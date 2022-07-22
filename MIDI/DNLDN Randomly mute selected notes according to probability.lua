--Gets only selected notes and cc events from active midi take in midi editor HWND. Doesn't run if MIDI editor window isn't active.
    --Useful to experiment with adding pauses to runs. Requires user input to set probability.
    --Demonstration: https://raw.githubusercontent.com/dnldn/reascripts/main/MIDI/Randomly%20mute%20notes%20by%20user%20probability.gif


--Declaring module names.
get = {}
set = {}
undo = {}

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

--Set functions.

--Set limit on value to scale between minimum and maximum inputs.

function set:Limit(val, min, max)
    if not min or not max then min, max = 0,1 end 
    return math.max(min,  math.min(val, max) ) 
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

function get:Input()

    --Prompt user for probability.
    local _, val = reaper.GetUserInputs("Set mute probability of selected notes", 1, "Probability %", "")

    --Convert from string to number.
    val = tonumber(val)

    --Catch non-numbers and return zero to avoid error.
    if type(val) == "nil" then val = 0 end

    --Limit value from 0 to 100.
    val = set:Limit(val, 0, 100)

    --Return value.
    return val
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Main function.
function main()
    local note, _ = get:SelectedMidiEvents()
    local probability = get:Input()
    for i = 0, note.count-1 do
        local mute = math.random()
        if mute <= probability/100 then mute = true else mute = false end 
        reaper.MIDI_SetNote(note.take, note.idx[i], note.sel[i], mute, note.startPPQ[i], note.endPPQ[i], note.chan[i], note.pitch[i], note.vel[i], true)
    end
end

undo:Begin()
main()
undo:End("Randomly mute selected notes according to probability")
