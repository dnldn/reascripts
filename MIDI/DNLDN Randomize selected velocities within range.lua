--Randomize selected velocities of note within range.
    --Randomizes velocity of selected notes in reaper, reassigning velocity randomly based on mean average of the selected notes.
    --Useful to add slight variations on runs, although note that running command repeatedly will eventually quantize the entire range toward a single value.
    --Demonstration: https://raw.githubusercontent.com/dnldn/reascripts/main/MIDI/Randomize%20velocities%20within%20range.gif


--Declaring module names.
get = {}
undo = {}
array = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Undo functions.
undo = {}

--Call at beginning of operation.
function undo:Begin()
    reaper.Undo_BeginBlock()
    reaper.PreventUIRefresh(1)
end

--Call at end: string argument to give description to action.
function undo:End(str)
    reaper.Undo_EndBlock(str, -1)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get minimum value from array.
function array:Min(a)
    local values = {}
    for k,v in pairs(a) do
      values[#values+1] = v
    end
    table.sort(values) -- automatically sorts lowest to highest
    return values[1]
end

--Get maximum value from array.
function array:Max(a)
    local values = {}
    for k,v in pairs(a) do
      values[#values+1] = v
    end
    table.sort(values) -- automatically sorts lowest to highest
    return values[#values]
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get functions.

--Gets only selected notes and cc events from active midi take in midi editor HWND. Doesn't run if MIDI editor window isn't active.
function get:SelectedMidiEvents()

    --Get the active window handle of MIDI editor. NOTE: this should be implemented by Reaper as cross-platform for macOS.
    local midiHWND = reaper.MIDIEditor_GetActive()

    --Establish objects for note, cc, selected note, selected cc, and sysex information.
    local note = {count, sel = {}, mute = {}, startPPQ = {}, endPPQ = {}, chan = {}, pitch = {}, vel = {}}
    local cc = {count, sel = {}, mute = {}, ppqpos = {}, chanmsg = {}, chan = {}, msg2 = {}, msg3 = {}, shape={}, bez = {}}
    local selNote = {count, take, idx = {}, sel = {}, mute = {}, startPPQ = {}, endPPQ = {}, chan = {}, pitch = {}, vel = {}}
    local selCC = {count, take, idx={}, sel = {}, mute = {}, ppqpos = {}, chanmsg = {}, chan = {}, msg2 = {}, msg3 = {}, shape={}, bez = {}}
    local sysex = {}

    --If the MIDI editor is active:
    if midiHWND then

        --Determine take from active MIDI window.
        local take = reaper.MIDIEditor_GetTake(midiHWND)
        selNote.take = take
        selCC.take = take
        
        --Determine number of events from active MIDI window.
        local retval, noteNum, ccNum, sysexNum = reaper.MIDI_CountEvts(take)
        note.count = noteNum
        cc.count = ccNum
        
        --Enumerate all notes and declare to object.
        if retval and noteNum > 0 then
            local j = 0
            for i = 0, noteNum-1 do
                _, note.sel[i], note.mute[i], note.startPPQ[i], note.endPPQ[i], note.chan[i], note.pitch[i], note.vel[i] =  reaper.MIDI_GetNote(take, i)

                --Enumerate selected notes.
                if note.sel[i] then                    
                    selNote.idx[j] = i
                    _, selNote.sel[j], selNote.mute[j], selNote.startPPQ[j], selNote.endPPQ[j], selNote.chan[j], selNote.pitch[j], selNote.vel[j] =  reaper.MIDI_GetNote(take, i)
                    j = j + 1                
                end
            end
            selNote.count = j
        end
        
        --Enumerate all CC's and declare to object.
        if retval and ccNum > 0 then
            local j = 0
            for i = 0, ccNum-1 do            
                  _, cc.sel[i], cc.mute[i], cc.ppqpos[i], cc.chanmsg[i], cc.chan[i], cc.msg2[i], cc.msg3[i] =  reaper.MIDI_GetCC(take, i)
                  _, cc.shape[i], cc.bez[i] = reaper.MIDI_GetCCShape(take, i)

                  --Enumerate selected CC's.
                  if cc.sel[i] then                  
                      selCC.idx[j] = i
                      _, selCC.sel[j], selCC.mute[j], selCC.ppqpos[j], selCC.chanmsg[j], selCC.chan[j], selCC.msg2[j], selCC.msg3[j] =  reaper.MIDI_GetCC(take, i)
                      _, selCC.shape[j], selCC.bez[j] = reaper.MIDI_GetCCShape(take, i)
                      j = j + 1                  
                  end
            end
            selCC.count = j
        end
        
        
        --Reserved for future implementation with sysex/bitwise operations.
        --[[
        if retval and sysexNum > 0 then
            for i = 0, sysexNum-1 do        
                reaper.MIDI_GetTextSysexEvt(take, i)            
            end
        end
        ]]        
    end
    return selNote, selCC
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Main function.
function main()
    local note, _ = get:SelectedMidiEvents()
    local minval = array:Min(note.vel)
    local maxval = array:Max(note.vel)
    local diff = maxval-minval    
    for i = 0, note.count-1 do
        local retval, selected, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(note.take, i)
        if selected then
            local v = math.random(0, diff)+minval
            reaper.MIDI_SetNote(note.take, i, -1, false, -1, -1, -1, -1, v, -1)
        end 
    end     
    reaper.MIDI_Sort(note.take)
end


undo:Begin()
main()
undo:End("Randomize velocities of selected notes within range")
