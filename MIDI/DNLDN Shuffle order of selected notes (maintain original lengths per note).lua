--Shuffle order of selected MIDI notes (maintaining original lengths per position).
    --Randomizes order of selected notes in reaper, reassigning note values and velocity values but respecting the original length of the note at the given spot.
    --Demonstration:


--Declaring module names.
get = {}
array = {}
undo = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Undo functions.

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

--Array functions.

--Randomize the values of two arrays.
function array:shuffle(t1, t2)
    local tbl1 = {}
    local tbl2 = {}

    --Local check function: if values haven't changed, operation will be run again. A little expensive, but quickest way to do it in Lua. If check fails twice, operation will cancel to avoid stack overflow.
    local function tablesMatch(a,b)
        return table.concat(a) == table.concat(b)
    end
    
    for i = 0, #t1 do
        tbl1[i] = t1[i]
    end
    
    for i = 0, #t2 do
        tbl2[i] = t2[i]
    end
    
    for i = #tbl1, 2, -1 do
        local j = math.random(0, i)
        tbl1[i], tbl1[j] = tbl1[j], tbl1[i]
        tbl2[i], tbl2[j] = tbl2[j], tbl2[i]
    end
    
    --Rerun operation if values have not shifted.
    if tablesMatch(t1, tbl1) then
        tbl1, tbl2 = self:shuffle(t1, t2)
    end
    return tbl1, tbl2
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Main function.
function main()
    local note, _ = get:SelectedMidiEvents()

    --Operation only runs if more than two notes are selected.
    if note.count > 2 then
        local shuffledNoteStart, shuffledNoteEnd = array:shuffle(note.startPPQ, note.endPPQ)
        for i = 0, note.count-1 do
            local dist = note.endPPQ[i] - note.startPPQ[i]
            reaper.MIDI_SetNote(note.take, note.idx[i], note.sel[i], note.mute[i], shuffledNoteStart[i], shuffledNoteStart[i]+dist, note.chan[i], note.pitch[i], note.vel[i], true)
        end
    end
end

undo:Begin()
main()
undo:End("DNLDN Shuffle order of selected notes (maintain lengths per note)")