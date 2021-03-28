--DNLDN: Aubio Onset Transient Slicer
--12-30-20

--Globals:
--Store original cursor position to restore at end of function.
cursorPos = reaper.GetCursorPosition()

---------------------------------------------------------------------------------------------------------------------------

--Checking for existence of file.
function file_exists(fileName)
    local f = io.open(fileName, "r")
    if f ~=nil then
        io.close(f) 
        return true
    else
        return false
    end
end

---------------------------------------------------------------------------------------------------------------------------

--Converts string to boolean.
function toBoolean(s)
    if s == "true" then return true
    else return false end
end

---------------------------------------------------------------------------------------------------------------------------

--Gets exterior state arguments.
function fromExtState(key, nilallowed)
    local state = "AUBIO_ONSET"
    if nilallowed == nil then nilallowed = false end
    local val = reaper.GetExtState(state,key)
    if nilallowed then
      if val == '' then
        val = nil
      end
    end
    return val
end

---------------------------------------------------------------------------------------------------------------------------

--Limit cuts when exceeding the length of a pooled copy based on cursor position.
function sliceLimit()
    local a =  reaper.GetCursorPosition()
    if a <= item.length+item.pos then return true
    else return false end
end

---------------------------------------------------------------------------------------------------------------------------

--Populates errors when script can't run aubio due to bitrate.
function populateErrors()
    
    local x = 0
    
    return function()
        x = x+1
        return x
    end
    
end

errorNum = populateErrors()

---------------------------------------------------------------------------------------------------------------------------

--Runs command line aubioonset.exe script on selected items.
function onset()

    --Declaring array.
    local valueTable = {}
    local idx = 0
    
    --Gets plugin path for aubio.
    path =  reaper.GetResourcePath() .. "\\UserPlugins\\aubio\\0.4.9\\win64\\"
    exe = path.."aubioonset.exe"
 
    --Shows process is running; otherwise it may appear that reaper is frozen on long files. Clean up later to show arguments.
    reaper.ClearConsole()
    reaper.ShowConsoleMsg("Scanning " .. item.fileName .. "...")
    
    --Deprecated: basing transient detection on volume analysis proved unreliable; there's too small of a gap between item
    --peak values or even RMS/LUFS. Computationally very slow too. Leaving the conditionals in place in case I revisit the idea.
    --Sets bottom threshold for transient detection on command line function; based on volume analysis or simple floor value.
    if setByPeak == false and setByRMS == false and setByLUFS == false then 
        threshold = lowerLim
    else 
        threshold = currentVol + lowerLim
    end
    
    --Checking bitrate of file. Should implement this before item is scanned but too lazy.
    if item.bitrate == 32 then errorNum() end
    
    --Executes aubio onset, prints results to string file. Clean up variable later to be transient.item or something.  -s -50 -O complex
    local transient = reaper.ExecProcess(exe .. " -i " .. "\"" .. item.fileName .. "\"" .. " -O " ..method.. " -H " ..hop.. " -s " ..threshold.. " -M " .. interval, 0)
    
    --Clears "Scanning item..." dialog, outputs debug dialog.
    reaper.ClearConsole()


    --Sort string values into array. Regular expression is separating values by line break.
    for line in string.gmatch(transient,'[^\n]+') do 
        valueTable[idx] = tonumber(line)
        idx = idx+1
    end
    
    --Moves edit cursor to top of file; otherwise the   Main_OnCommand doesn't work.
    reaper.SetEditCurPos2(0, item.pos, false, false)
    
    --Apply item playback rate to adjust calculation.
    applyRate()
    
    --Re-organize values in table.
    sortTable(valueTable)
    
    --Slice items in table.
    slice(valueTable)
    
    --Console message when finished.
    reaper.ShowConsoleMsg("Done!")

end

---------------------------------------------------------------------------------------------------------------------------

--Not used in its current state: process is too slow and implementation too unreliable.
--Calculate dB value of item; returns RMS, peak or LUFS value depending on toggled option.
function dbCalc(item)

    --Declaring take and volume variable.
    local take = reaper.GetActiveTake(item)
    local itemVol
    
    --Setting function according to external dialog.
    if setByRMS == true then
        itemVol = reaper.NF_GetMediaItemAverageRMS(item)
    elseif setByPeak == true then
        itemVol = reaper.NF_GetMediaItemMaxPeak(item)
    elseif setByLUFS == true then
        retval, itemVol = reaper.NF_AnalyzeTakeLoudness_IntegratedOnly(take)
    end
    
    --Return whichever calculation was used.
    return itemVol
    
end

---------------------------------------------------------------------------------------------------------------------------

--Returns arguments to pass into aubioonset.exe script.
function getArgs()

    --Method. Defaults to hfc, other options are explained at bottom of script.
    method = fromExtState('method', true)
    if method == "1" then method = "hfc"
    elseif method == "2" then method = "energy"
    elseif method == "3" then method = "phase"
    elseif method == "4" then method = "complex"
    elseif method == "5" then method = "specdiff"
    elseif method == "6" then method = "specflux"
    elseif method == "7" then method = "kl"
    elseif method == "8" then method = "mkl"
    end

    --Threshold actually corresponds to -s silence threshold in aubioonset- sets a lower dB limit under which no transients are detected.
    --(The -t threshold argument isn't that useful because it doesn't correspond to specific dB values.)
    --threshold = 0-math.abs(threshold)
    
    --Gives a little extra space under the the threshold detection for quiet sections. Defaults to -70 dB.
    lowerLim = fromExtState('lowerLim', true)
    
    --Set minimum interval between detections in ms. Defaults to 12.
    interval = fromExtState('interval', true)
    interval = interval/1000
    
    --Set hop size for calculation in samples. Defaults to 256. No real reason to change it in most cases.
    hop = fromExtState('hop size', true)
    
    --Get booleans from external state.
    setByPeak = toBoolean(fromExtState('peak', true))
    setByRMS = toBoolean(fromExtState('rms', true))
    setByLUFS = toBoolean(fromExtState('lufs', true))
    

    
end

---------------------------------------------------------------------------------------------------------------------------

--Gets item values.
function getItem()
        local item = {current, pos, length, sourceLength, fileName, offset, rate, bitrate, guid}
        --Get selected item's attributes.
        item.current = reaper.GetSelectedMediaItem(0, 0)
        local take = reaper.GetActiveTake(item.current)
        local source = reaper.GetMediaItemTake_Source(take)
        item.rate =  reaper.GetMediaItemTakeInfo_Value( take, "D_PLAYRATE")
        item.sourceLength, _ = reaper.GetMediaSourceLength(source)
        item.fileName = reaper.GetMediaSourceFileName(source, "")
        item.pos = reaper.GetMediaItemInfo_Value(item.current, "D_POSITION")
        item.length = reaper.GetMediaItemInfo_Value(item.current, "D_LENGTH")
        item.guid = reaper.BR_GetMediaItemGUID(item.current)
        item.offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")
        item.bitrate =  reaper.CF_GetMediaSourceBitDepth(source)
    return item
end

---------------------------------------------------------------------------------------------------------------------------

--Applies playback rate adjustment.
function applyRate()
    local rate = item.rate
    item.sourceLength = item.sourceLength/rate
    item.offset = item.offset/rate
end

---------------------------------------------------------------------------------------------------------------------------

--Sort table according to offset information.
function sortTable(array)
    for k, v in pairs(array) do
    
        --Defining split point as length of item minus the amount it's offset by.
        local position = array[k]
        splitPoint = item.sourceLength - item.offset
        
        --This part is skipped if there is no offset.
        if item.offset ~= 0 then
        
            --Sets first index to itself. Function doesn't work once it's sorted if first value isn't the first place it makes a cut.
            if k == 0 then 
                position = position
                
            --Else, if position comes after offset, position is position minus offset.
            elseif position > item.offset then
                position = position - item.offset
                
            --Else, position is split point plus position.
            else
                position = splitPoint + position
            end

        end
        
        --Array value updated.
        array[k] = position
    end
    
    --Organizes values in table from small to large.
    table.sort(array)
end

---------------------------------------------------------------------------------------------------------------------------

--Slice items in array.
function slice(array)
    --Declares number of times selected item is copied.
    cutidx = math.ceil(item.length/item.sourceLength)

    --Repeat for as many pooled copies as exist in item.
    for j = 0, cutidx-1 do
    
        --Index needs to start at 1, else it'll try to make a splice at position zero and not trigger the script properly.
        for i = 0, #array-1 do
        
            --Set slice position and track the selected item is on.
            local position = array[i+1]
            --reaper.ShowConsoleMsg("Position: " ..position .. " Index: " .. i .. "\n") --debugging 
            
            --Select first item.
            newSel = reaper.GetSelectedMediaItem(0,0)
            
            --Split item, with offset set by track position in session. Mult is for copied (pooled?) items.
            local mult = item.sourceLength*j
            
            --Establish boolean to determine if cuts exceed length of total file.
            local splitIsValid = sliceLimit()
            
            if splitIsValid then
                reaper.SplitMediaItem(newSel, mult+(position/item.rate)+item.pos)
            else end
            
             --Select and move to next item. If index is at zero, it doesn't move to next item, because that causes splits to skip.
            if i == 0 then local dummy = 0
            else reaper.Main_OnCommand(40417, 0) end
        end      
    end
end

---------------------------------------------------------------------------------------------------------------------------

--Main function.
function main()

    --Checks for existence of ultraschall api. Not important if it isn't installed; just gives the ability to close out console.
    local ultraCheck = file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
    if ultraCheck == true then
        dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
    end
    
    --Gets arguments from external state. May pass error if transient settings script hasn't been run yet.
    getArgs()
    
    --Declare currently selected items, current track selection, and number of items selected total.
    currentSel = {}
    tr = {}
    vol = {}
    local count =  reaper.CountSelectedMediaItems(0)
    
    --Enumerate selections; run dB analysis on each if option is toggled.
    for i = 0, count-1 do
        currentSel[i] =  reaper.GetSelectedMediaItem(0, i)
        tr[i] =  reaper.GetMediaItem_Track(currentSel[i])
        if setByRMS == true or setByPeak == true or setByLUFS == true then
            vol[i] = dbCalc(currentSel[i])-lowerLim
        else
            vol[i] = lowerLim
        end
        
    end
    
    
    --Run command on all selections.
    for i = 0, count-1 do

        local sel = currentSel[i]
        currentVol = vol[i]
        
        --Unselect all tracks, then select track current item is on.
        reaper.Main_OnCommand(40297, 0)
        reaper.SetTrackSelected(tr[i], true)
        
        --Unselect all items, then select current index item.
        reaper.Main_OnCommand(40289, 0)
        reaper.SetMediaItemSelected(sel, true)
        
        --Get item attributes.
        item = getItem()
        
        --Run operation.
        onset()
        
        --If ultraschall api exists, then close out console. Else it stays open.
        if ultraCheck == true then
            ultraschall.CloseReaScriptConsole()
        end
    end
    
    --Set cursor position back to its original spot. 
    reaper.SetEditCurPos(cursorPos, true, false)
end

---------------------------------------------------------------------------------------------------------------------------

--Script execution area.
reaper.Undo_BeginBlock() -- Beginning of undo block.
reaper.PreventUIRefresh(1)-- Prevent UI refreshing. Uncomment it only if the script works.

main()
dumnum = errorNum()-1
if dumnum > 0 then reaper.ShowConsoleMsg("Couldn't run operation on all files; aubio does not work on 32-bit files.") end
reaper.PreventUIRefresh(-1) -- Restore UI refresh. Uncomment it only if the script works.
reaper.UpdateArrange() -- Update the arrangement.
reaper.Undo_EndBlock("Split item by transients (Aubio Onset)", -1) -- End of the undo block.
