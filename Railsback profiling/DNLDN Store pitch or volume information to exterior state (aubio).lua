--Detect and write pitch and volume information to item notes (using Aubio)
    --Requires the Aubio package to be installed.
    --Designed around successive take names corresponding to and being labeled according to following MIDI convention: C1 C#1 D1 D#1 E1 F1 F#1 G1 G#1 A1 A#1 B1 C2
    --The cent adjustment necessary to bring the sample to 440 equal temperament is assessed according to 6 different pitch algorithms, and another script creates tone generators to assess pitch accuracy by ear.
    --Volume analysis is also performed.
    --The idea is to roughly assess railsback curves on controlled sample sets where the notes are known; true inharmonicity will not be accounted for completely, neither will pitch analysis include partial harmonics- we are only assessing for the average centered pitch of a wave file.
    --For assessing harmonically-predictable material that sits in a medium to higher register (all pitch detection systems lose accuracy in lower registers); this is quite useful to create temperament profiles or physically model pitch-related behavior.


--Declaring module names.
undo = {}
value = {}
array = {}
get = {}
set = {}
midi = {}
take = {}
run = {}

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

--Math functions:


--Returns nth root of number. (eg. semi = value:nroot(12,2) would be the number by which you multiply/divide a frequency to get the next semitone in 12-tone equal temperament.)
function value:nroot(root, num)
    return num^(1/root)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Array functions.

--Table comparison. Should probably do a metatable thing here but it's just for two tables. Returns boolean.
function array:Match(a, b)
    return table.concat(a) == table.concat(b)
end

--Returns median average of table or error message.
function array:Median(t)

    temp={}
    for k,v in pairs(t) do
        if type(v) == 'number' then
           table.insert(temp, v)
        end
    end
    table.sort(temp)
    
    -- If we have an even number of table elements or odd.
    if #temp > 0 then
        if math.fmod(#temp,2) == 0 then
            -- return mean value of middle two elements
            return ( temp[#temp/2] + temp[(#temp/2)+1] ) / 2
        else
            -- return middle element
            return temp[math.ceil(#temp/2)]
        end
    else
        return "nan"
    end
    
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Get functions.

--Save time/item/track selection. Use with reaper.PreventUIRefresh(1) /function/ reaper.PreventUIRefresh(-1) to prevent visual choppiness.
function set:Selection()

    --Store all items and tracks by GUID, store loop to table.
    local sel = {trackGUID = {}, itemGUID={}, loop={0,0}}
    local trackCount = reaper.CountSelectedTracks(0)
    local itemCount = reaper.CountSelectedMediaItems(0)
    sel.loop[0], sel.loop[1] = reaper.GetSet_LoopTimeRange(false, false, 0, 0, 0)
    
    --Store item selections.
    for i = 0, itemCount-1 do
        local it = reaper.GetSelectedMediaItem(0,i)
        sel.itemGUID[i] = reaper.BR_GetMediaItemGUID(it)
    end
    
    --Store track selections.
    for i = 0, trackCount-1 do
        local tr = reaper.GetSelectedTrack(0,i)
        sel.trackGUID[i] = reaper.GetTrackGUID(tr)
    end
    
    --Return object.
    return sel
end

--Restore time/item/track selection. Use with reaper.PreventUIRefresh(1) /function/ reaper.PreventUIRefresh(-1) to prevent visual choppiness.
function get:Selection(sel)

        --Restore track selections by GUID.
        for i = 0, #sel.trackGUID do
            local tr = reaper.BR_GetMediaTrackByGUID(0, sel.trackGUID[i])
            if tr then reaper.SetTrackSelected(tr, true) end
        end
        
        for i = 0, #sel.itemGUID do
            local it = reaper.BR_GetMediaItemByGUID(0,sel.itemGUID[i])
            if it then reaper.SetMediaItemSelected(it, true) end
        end        
        --Restore loop.
        reaper.GetSet_LoopTimeRange(true, true, sel.loop[0], sel.loop[1], true)
end


--Get first selected item attributes.
function get:ItemAttributes(it)
        local item = {current, trim, pos, length, fin, source, sourceLength,
                     fileName, takeName, offset, rate, bitrate, guid, take, pitchAdj,
                     track, trackidx, pan, playrate, color, mute, selected, vol,
                     fadeInLength, fadeOutLength, group, inGroup, reverse}
                     
        --Get selected item's attributes.
        item.current = it
        item.take = reaper.GetActiveTake(item.current)
        item.source = reaper.GetMediaItemTake_Source(item.take)
        
        --Item attributes:
        item.sourceLength, _ = reaper.GetMediaSourceLength(item.source)
        item.fileName = reaper.GetMediaSourceFileName(item.source, "")
        item.pos = reaper.GetMediaItemInfo_Value(item.current, "D_POSITION")
        item.length = reaper.GetMediaItemInfo_Value(item.current, "D_LENGTH")
        item.fin = item.pos + item.length
        item.track = reaper.GetMediaItemTrack(item.current)
        item.trackidx = reaper.CSurf_TrackToID(item.track, false)-1 -- minus one because it's zero index
        item.guid = reaper.BR_GetMediaItemGUID(item.current)
        item.bitrate =  reaper.CF_GetMediaSourceBitDepth(item.source)
        item.selected = reaper.GetMediaItemInfo_Value(item.current, "B_UISEL")
        item.trim = reaper.GetMediaItemInfo_Value(item.current, "D_VOL") --this isn't scaled in useful way, need ultraschall api thing to make sense of it
        item.fadeInLength = reaper.GetMediaItemInfo_Value(item.current, "D_FADEINLEN")
        item.fadeOutLength = reaper.GetMediaItemInfo_Value(item.current, "D_FADEOUTLEN")
        
        item.mute = reaper.GetMediaItemInfo_Value(item.current, "B_MUTE")
        if item.mute == 0 then item.mute = false
        elseif item.mute == 1 then item.mute = true end
        
        item.group = reaper.GetMediaItemInfo_Value(item.current, "I_GROUPID")
        if item.group == 0 then item.inGroup = false
        elseif item.group ~= 0 then item.inGroup = true end
        
        
        --Take attributes:
        _, item.takeName = reaper.GetSetMediaItemTakeInfo_String(item.take, "P_NAME", "", false)
        item.rate =  reaper.GetMediaItemTakeInfo_Value(item.take, "D_PLAYRATE")
        item.offset = reaper.GetMediaItemTakeInfo_Value(item.take, "D_STARTOFFS")
        item.vol = reaper.GetMediaItemTakeInfo_Value(item.take, "D_VOL") --this isn't scaled in useful way, need ultraschall api thing to make sense of it
        item.pitchAdj = reaper.GetMediaItemTakeInfo_Value(item.take, "D_PITCH")
        item.pan = reaper.GetMediaItemTakeInfo_Value(item.take, "D_PAN")
        item.playrate = reaper.GetMediaItemTakeInfo_Value(item.take, "D_PLAYRATE")
        item.color = reaper.GetMediaItemTakeInfo_Value(item.take, "I_CUSTOMCOLOR")|0x100000
        item.reverse = reaper.GetMediaItemTakeInfo_Value(item.take, "I_CHANMODE") -- 0 normal 1 reverse
        
        if item.reverse == 0 then item.reverse = false
        elseif item.reverse == 1 then item.reverse = true end
        
    return item
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--MIDI functions

--Return equal temperament hz value based on midi number.
function midi:NumberToHz(num)

    --Establish lowest midi note (c -0) based on pitch standard. Probably should be stored as variable but I don't care, computationally light enough.
    local low = pitchStandard
    for i = 69, 1, -1 do
        low = low/semi
    end
    
    --Multiplying value until equal to inputted note.
    local val = low
    for i = 0, num-1 do
        val = val * semi
    end
    return val
end


--Translate numbers to midi note name. Called recursively.
function midi:NumberToMidiNote(num)--: Return midi note name based on numerical input. Using only sharps for simplicity.

    if num == 0 then val = "C-1"
    elseif num == 1 then val = "C#-1"
    elseif num == 2 then val = "D-1"
    elseif num == 3 then val = "D#-1"
    elseif num == 4 then val = "E-1"
    elseif num == 5 then val = "F-1"
    elseif num == 6 then val = "F#-1"
    elseif num == 7 then val = "G-1"
    elseif num == 8 then val = "G#-1"
    elseif num == 9 then val = "A-1"
    elseif num == 10 then val = "A#-1"
    elseif num == 11 then val = "B-1"
    elseif num == 12 then val = "C0"
    elseif num == 13 then val = "C#0"
    elseif num == 14 then val = "D0"
    elseif num == 15 then val = "D#0"
    elseif num == 16 then val = "E0"
    elseif num == 17 then val = "F0"
    elseif num == 18 then val = "F#0"
    elseif num == 19 then val = "G0"
    elseif num == 20 then val = "G#0"
    elseif num == 21 then val = "A0"
    elseif num == 22 then val = "A#0"
    elseif num == 23 then val = "B0"
    elseif num == 24 then val = "C1"
    elseif num == 25 then val = "C#1"
    elseif num == 26 then val = "D1"
    elseif num == 27 then val = "D#1"
    elseif num == 28 then val = "E1"
    elseif num == 29 then val = "F1"
    elseif num == 30 then val = "F#1"
    elseif num == 31 then val = "G1"
    elseif num == 32 then val = "G#1"
    elseif num == 33 then val = "A1"
    elseif num == 34 then val = "A#1"
    elseif num == 35 then val = "B1"
    elseif num == 36 then val = "C2"
    elseif num == 37 then val = "C#2"
    elseif num == 38 then val = "D2"
    elseif num == 39 then val = "D#2"
    elseif num == 40 then val = "E2"
    elseif num == 41 then val = "F2"
    elseif num == 42 then val = "F#2"
    elseif num == 43 then val = "G2"
    elseif num == 44 then val = "G#2"
    elseif num == 45 then val = "A2"
    elseif num == 46 then val = "A#2"
    elseif num == 47 then val = "B2"
    elseif num == 48 then val = "C3"
    elseif num == 49 then val = "C#3"
    elseif num == 50 then val = "D3"
    elseif num == 51 then val = "D#3"
    elseif num == 52 then val = "E3"
    elseif num == 53 then val = "F3"
    elseif num == 54 then val = "F#3"
    elseif num == 55 then val = "G3"
    elseif num == 56 then val = "G#3"
    elseif num == 57 then val = "A3"
    elseif num == 58 then val = "A#3"
    elseif num == 59 then val = "B3"
    elseif num == 60 then val = "C4"
    elseif num == 61 then val = "C#4"
    elseif num == 62 then val = "D4"
    elseif num == 63 then val = "D#4"
    elseif num == 64 then val = "E4"
    elseif num == 65 then val = "F4"
    elseif num == 66 then val = "F#4"
    elseif num == 67 then val = "G4"
    elseif num == 68 then val = "G#4"
    elseif num == 69 then val = "A4"
    elseif num == 70 then val = "A#4"
    elseif num == 71 then val = "B4"
    elseif num == 72 then val = "C5"
    elseif num == 73 then val = "C#5"
    elseif num == 74 then val = "D5"
    elseif num == 75 then val = "D#5"
    elseif num == 76 then val = "E5"
    elseif num == 77 then val = "F5"
    elseif num == 78 then val = "F#5"
    elseif num == 79 then val = "G5"
    elseif num == 80 then val = "G#5"
    elseif num == 81 then val = "A5"
    elseif num == 82 then val = "A#5"
    elseif num == 83 then val = "B5"
    elseif num == 84 then val = "C6"
    elseif num == 85 then val = "C#6"
    elseif num == 86 then val = "D6"
    elseif num == 87 then val = "D#6"
    elseif num == 88 then val = "E6"
    elseif num == 89 then val = "F6"
    elseif num == 90 then val = "F#6"
    elseif num == 91 then val = "G6"
    elseif num == 92 then val = "G#6"
    elseif num == 93 then val = "A6"
    elseif num == 94 then val = "A#6"
    elseif num == 95 then val = "B6"
    elseif num == 96 then val = "C7"
    elseif num == 97 then val = "C#7"
    elseif num == 98 then val = "D7"
    elseif num == 99 then val = "D#7"
    elseif num == 100 then val = "E7"
    elseif num == 101 then val = "F7"
    elseif num == 102 then val = "F#7"
    elseif num == 103 then val = "G7"
    elseif num == 104 then val = "G#7"
    elseif num == 105 then val = "A7"
    elseif num == 106 then val = "A#7"
    elseif num == 107 then val = "B7"
    elseif num == 108 then val = "C8"
    elseif num == 109 then val = "C#8"
    elseif num == 110 then val = "D8"
    elseif num == 111 then val = "D#8"
    elseif num == 112 then val = "E8"
    elseif num == 113 then val = "F8"
    elseif num == 114 then val = "F#8"
    elseif num == 115 then val = "G8"
    elseif num == 116 then val = "G#8"
    elseif num == 117 then val = "A8"
    elseif num == 118 then val = "A#8"
    elseif num == 119 then val = "B8"
    elseif num == 120 then val = "C9"
    elseif num == 121 then val = "C#9"
    elseif num == 122 then val = "D9"
    elseif num == 123 then val = "D#9"
    elseif num == 124 then val = "E9"
    elseif num == 125 then val = "F9"
    elseif num == 126 then val = "F#9"
    elseif num == 127 then val = "G9"
    end
    
    return val
end

--Translate midi note names to numbers. Called recursively.
function midi:NoteToNumber(val)--: Return number based on midi note name.
    if val == "C-1" then num = 0
    elseif val == "C#-1" then num = 1
    elseif val == "D-1" then num = 2
    elseif val == "D#-1" then num = 3
    elseif val == "E-1" then num = 4
    elseif val == "F-1" then num = 5
    elseif val == "F#-1" then num = 6
    elseif val == "G-1" then num = 7
    elseif val == "G#-1" then num = 8
    elseif val == "A-1" then num = 9
    elseif val == "A#-1" then num = 10
    elseif val == "B-1" then num = 11
    elseif val == "C0" then num = 12
    elseif val == "C#0" then num = 13
    elseif val == "D0" then num = 14
    elseif val == "D#0" then num = 15
    elseif val == "E0" then num = 16
    elseif val == "F0" then num = 17
    elseif val == "F#0" then num = 18
    elseif val == "G0" then num = 19
    elseif val == "G#0" then num = 20
    elseif val == "A0" then num = 21
    elseif val == "A#0" then num = 22
    elseif val == "B0" then num = 23
    elseif val == "C1" then num = 24
    elseif val == "C#1" then num = 25
    elseif val == "D1" then num = 26
    elseif val == "D#1" then num = 27
    elseif val == "E1" then num = 28
    elseif val == "F1" then num = 29
    elseif val == "F#1" then num = 30
    elseif val == "G1" then num = 31
    elseif val == "G#1" then num = 32
    elseif val == "A1" then num = 33
    elseif val == "A#1" then num = 34
    elseif val == "B1" then num = 35
    elseif val == "C2" then num = 36
    elseif val == "C#2" then num = 37
    elseif val == "D2" then num = 38
    elseif val == "D#2" then num = 39
    elseif val == "E2" then num = 40
    elseif val == "F2" then num = 41
    elseif val == "F#2" then num = 42
    elseif val == "G2" then num = 43
    elseif val == "G#2" then num = 44
    elseif val == "A2" then num = 45
    elseif val == "A#2" then num = 46
    elseif val == "B2" then num = 47
    elseif val == "C3" then num = 48
    elseif val == "C#3" then num = 49
    elseif val == "D3" then num = 50
    elseif val == "D#3" then num = 51
    elseif val == "E3" then num = 52
    elseif val == "F3" then num = 53
    elseif val == "F#3" then num = 54
    elseif val == "G3" then num = 55
    elseif val == "G#3" then num = 56
    elseif val == "A3" then num = 57
    elseif val == "A#3" then num = 58
    elseif val == "B3" then num = 59
    elseif val == "C4" then num = 60
    elseif val == "C#4" then num = 61
    elseif val == "D4" then num = 62
    elseif val == "D#4" then num = 63
    elseif val == "E4" then num = 64
    elseif val == "F4" then num = 65
    elseif val == "F#4" then num = 66
    elseif val == "G4" then num = 67
    elseif val == "G#4" then num = 68
    elseif val == "A4" then num = 69
    elseif val == "A#4" then num = 70
    elseif val == "B4" then num = 71
    elseif val == "C5" then num = 72
    elseif val == "C#5" then num = 73
    elseif val == "D5" then num = 74
    elseif val == "D#5" then num = 75
    elseif val == "E5" then num = 76
    elseif val == "F5" then num = 77
    elseif val == "F#5" then num = 78
    elseif val == "G5" then num = 79
    elseif val == "G#5" then num = 80
    elseif val == "A5" then num = 81
    elseif val == "A#5" then num = 82
    elseif val == "B5" then num = 83
    elseif val == "C6" then num = 84
    elseif val == "C#6" then num = 85
    elseif val == "D6" then num = 86
    elseif val == "D#6" then num = 87
    elseif val == "E6" then num = 88
    elseif val == "F6" then num = 89
    elseif val == "F#6" then num = 90
    elseif val == "G6" then num = 91
    elseif val == "G#6" then num = 92
    elseif val == "A6" then num = 93
    elseif val == "A#6" then num = 94
    elseif val == "B6" then num = 95
    elseif val == "C7" then num = 96
    elseif val == "C#7" then num = 97
    elseif val == "D7" then num = 98
    elseif val == "D#7" then num = 99
    elseif val == "E7" then num = 100
    elseif val == "F7" then num = 101
    elseif val == "F#7" then num = 102
    elseif val == "G7" then num = 103
    elseif val == "G#7" then num = 104
    elseif val == "A7" then num = 105
    elseif val == "A#7" then num = 106
    elseif val == "B7" then num = 107
    elseif val == "C8" then num = 108
    elseif val == "C#8" then num = 109
    elseif val == "D8" then num = 110
    elseif val == "D#8" then num = 111
    elseif val == "E8" then num = 112
    elseif val == "F8" then num = 113
    elseif val == "F#8" then num = 114
    elseif val == "G8" then num = 115
    elseif val == "G#8" then num = 116
    elseif val == "A8" then num = 117
    elseif val == "A#8" then num = 118
    elseif val == "B8" then num = 119
    elseif val == "C9" then num = 120
    elseif val == "C#9" then num = 121
    elseif val == "D9" then num = 122
    elseif val == "D#9" then num = 123
    elseif val == "E9" then num = 124
    elseif val == "F9" then num = 125
    elseif val == "F#9" then num = 126
    elseif val == "G9" then num = 127
    end
    
    return num
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Get intended pitch from take name. Note that letter must be upper case (may change later but don't think I need to.)
function get:PitchFromTakeName(take)

    --Get name of the take.
    local name = reaper.GetTakeName(take)
    
    --Search for letter, then sharp sign, then number.
    local note = name:match("%a#%d")
    
    --If there is no sharp, then just match letter and number.
    if not note then
        note = name:match("%a%d")
    end
    
    --Return note name.
    return note
end

--This is totally gross but it works. Results not beauty, right?
--Get intended hertz value of take according to take name.
function get:HzFromTakeName(item)
    return  midi:NumberToHz(midi:NoteToNumber(get:PitchFromTakeName(reaper.GetActiveTake(item))))
end

-------------------------------------------------------------------------------------------------------------------------------------------------------


--Analyze rms.
function get:RMS(item)
    local rms = reaper.NF_GetMediaItemAverageRMS(item)
    return rms
end


--Analyze peak.
function get:Peak(item)
    local peak = reaper.NF_GetMediaItemMaxPeak(item)
    return peak
end

--Analyze LUFS.
function get:LUFS(item)
    local take = reaper.GetActiveTake(item)
    local _, lufs = reaper.NF_AnalyzeTakeLoudness_IntegratedOnly(take)
    return lufs
end



-------------------------------------------------------------------------------------------------------------------------------------------------------


--Create track of empty items with normalization numbers on them.
function set:NormalizationTrack(vol, unit)
    
    --Slightly sloppy: I'm basing where track gets inserted on first selected item. I don't think I'll ever have items selected across multiple tracks for this though.
    local it = get:ItemAttributes(reaper.GetSelectedMediaItem(0,0))
    
    --Insert track above track with selected items.
    reaper.InsertTrackAtIndex(it.trackidx, false)
    local tr = reaper.GetTrack(0, it.trackidx)
    
    --Set track to yellow, short height, locked. (keeping it consistent with drum session colors).
    --Doesn't appear to be a way to programatically lock the track controls, so that's different (not super important).
    --Also, may take a moment to actually shrink the track.
    reaper.SetTrackColor(tr, 16842751)
    reaper.SetMediaTrackInfo_Value(tr, "I_HEIGHTOVERRIDE", 30)
    reaper.SetMediaTrackInfo_Value(tr, "B_HEIGHTLOCK", 1)
    
    --Unselect all items so I can apply random colors within loop.
    reaper.Main_OnCommand(40289, 0) --Item: Unselect all items
    
    --Rename track based on option name, then generate parallel blank items with volume information from analysis.
    if unit == "Peak" then
    reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "NORMALIZE (PEAK)", true)

        for i = 0, #vol.val do
            local item = reaper.AddMediaItemToTrack(tr)
            local str = tostring(vol.val[i])
            reaper.SetMediaItemInfo_Value(item, "D_POSITION", vol.pos[i])
            reaper.SetMediaItemInfo_Value(item, "D_LENGTH", vol.length[i])
            reaper.GetSetMediaItemInfo_String(item, "P_NOTES", str, true)
            reaper.SetMediaItemSelected(item, true)
        end
    
    elseif unit == "RMS" then
    reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "NORMALIZE (RMS)", true)

        for i = 0, #vol.val do
            local item = reaper.AddMediaItemToTrack(tr)
            local str = tostring(vol.val[i])
            reaper.SetMediaItemInfo_Value(item, "D_POSITION", vol.pos[i])
            reaper.SetMediaItemInfo_Value(item, "D_LENGTH", vol.length[i])
            reaper.GetSetMediaItemInfo_String(item, "P_NOTES", str, true)
            reaper.SetMediaItemSelected(item, true)
        end
    
    elseif unit == "LUFS" then
    reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "NORMALIZE (LUFS)", true)
    
        for i = 0, #vol.val do
            local item = reaper.AddMediaItemToTrack(tr)
            local str = tostring(vol.val[i])
            reaper.SetMediaItemInfo_Value(item, "D_POSITION", vol.pos[i])
            reaper.SetMediaItemInfo_Value(item, "D_LENGTH", vol.length[i])
            reaper.GetSetMediaItemInfo_String(item, "P_NOTES", str, true)
            reaper.SetMediaItemSelected(item, true)
        end
    end
    
    --Apply random colors, unselect, restore selection.
    reaper.Main_OnCommand(40705, 0) --Item: Set to random colors
    reaper.Main_OnCommand(40289, 0) --Item: Unselect all items
    set:ItemsSelectedByExtStateGUIDS()
    
    
    
    
end

-------------------------------------------------------------------------------------------------------------------------------------------------------


--Run aubio pitch analysis, return averaged out amount and cent offset. Automatically sends values to ext state.
function run:AubioPitch(item, note, index, args)

    --Declaring array
    local pitchTable = {}
    local idx = 0
    
    --Declaring upper and lower limit for frequency detection filter. Sets bounds to within semitone of known intended frequency.
    local upperVal = note * semi
    local lowerVal = note / semi
    
    --Get item attributes.
    local it = get:ItemAttributes(item)
    
    --Change one confidence value or the other to determine filter aggression. May need to use a lot less on stuff that's really out.
    method = args
    confidence = " -l 0.9"
--    confidence = ""
    
    --Executes aubio pitch on item, print results to string file. @@@@@@@@@@@@@MAY WANT TO RETHINK THE -l 0.9 BIT, THIS MAY BE EXCLUDING A LOT OF RESULTS.
    aubioOutput = reaper.ExecProcess(aubioPath .. " -i " .. "\"" .. it.fileName .. "\"" .. " -p " .. method .. confidence, 0)-- .. "  -p " .. args, 0)

    --Sort string values into array. Regular expression is separating values by line break.
    for line in string.gmatch(aubioOutput,'[^\n]+') do
    
        --Capture sequence is space, followed by any number of digits, period, any number of digits.
        local stringVal = tonumber(line:match('(%s%d+[.]%d+)'))
        if stringVal then
        
        --Filtering values that are more than a semitone out
            if stringVal > lowerVal and stringVal < upperVal then 
                pitchTable[idx] = stringVal
                idx = idx + 1
            end
        end
    end
    
    
    --Calculate average. Will return nan value if no valid detections exist (happens a lot at super low frequencies regardless of algorithm used).
    local avg = array:Median(pitchTable)
    if avg == "nan" then
        set:ExteriorState(method, "none", "none", index)
    return "none", "none"
    else
        
        --Calculate cent offset.
        local adj = 0
        local calc = avg
        a = 0
        b = 0
        
        --If average is greater than note (sharp), then divide by 100th of a cent until it's not.
        if avg > note then
            while calc > note do
                calc = calc / centcent
                adj = adj - 1
                a = a - 1
            end
            
        --If average is less than note (flat), then multiply by 100th of a cent until it's not.
        elseif avg < note then
            while calc < note do
                calc = calc * centcent
                adj = adj + 1
                b = b + 1
            end
            
        --If average is bang on, don't do anything.
        elseif avg == note then
            adj = 0
        end
        
        --Divide adj to get actual cent value.
        adj = adj/100
        
        --Send hz, cent adjustment, and current index to exterior state (labeled by method).
        set:ExteriorState(method, avg, adj, index)
        
        --Return hz and cent adjustment.
        return avg, adj
    end
    
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Check exterior state for methods that have already been used.
function get:ExteriorStateMethods()

      --Set indexes for individual checks. Need to be strings to be passed into exterior state.
      local a, b, c, d, e, f
      a = "0" 
      b = "0" 
      c = "0" 
      d = "0" 
      e = "0"
      f = "0" 
      
      --This string will be stripped back depending on what checks are passed.
      local str = "yinfast yinfft fcomb mcomb schmitt specacf"
  
      --Each of the following iterate through their exterior state twice. If it iterates more than once, it's detecting valid entries the code has already been executed.
      --Yinfast
      local ret = true
      while ret do
          if tonumber(a) > 1 then break end
          ret, _, key = reaper.EnumProjExtState(0, "yinfast_HZ", a)
          a = a + 1
      end
      
      
      
      --Yinfft
      ret = true
      while ret do
          if tonumber(b) > 1 then break end
          ret = reaper.EnumProjExtState(0, "yinfft_HZ", b)
          b = b + 1
      end
      
      
      --Fcomb
      ret = true
      while ret do
          if tonumber(c) > 1 then break end
          ret = reaper.EnumProjExtState(0, "fcomb_HZ", c)
          c = c + 1
      end
      
      
      --Mcomb
      ret = true
      while ret do
          if tonumber(d) > 1 then break end
          ret = reaper.EnumProjExtState(0, "mcomb_HZ", d)
          d = d + 1
      end
      
      
      --Schmitt
      ret = true
      while ret do
          if tonumber(e) > 1 then break end
          ret = reaper.EnumProjExtState(0, "schmitt_HZ", e)
          e = e + 1
      end
      
      
      --Specacf
      ret = true
      while ret do
          if tonumber(f) > 1 then break end
          ret = reaper.EnumProjExtState(0, "specacf_HZ", f)
          f = f + 1
      end
      
      
      --If value goes through loop more than once, remove method from list of methods that have to be performed.
      if tonumber(a) > 1 then str = str:gsub("yinfast ", "") end
      if tonumber(b) > 1 then str = str:gsub("yinfft ", "") end
      if tonumber(c) > 1 then str = str:gsub("fcomb ", "") end
      if tonumber(d) > 1 then str = str:gsub("mcomb ", "") end
      if tonumber(e) > 1 then str = str:gsub("schmitt ", "") end
      if tonumber(f) > 1 then str = str:gsub("specacf", "") end -- no space on this last bad benjamin
      
      --Return string with remaining operations.
      return str
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Clear all exterior states.
--Going to implement it to an exterior script; keeping it here for debugging.
function set:ExteriorStateClear()

    --Yinfast
    reaper.SetProjExtState(0, "yinfast_HZ", "", "")
    reaper.SetProjExtState(0, "yinfast_cent", "", "")
    
    --Yinfft
    reaper.SetProjExtState(0, "yinfft_HZ", "", "")
    reaper.SetProjExtState(0, "yinfft_cent", "", "")
    
    
    --Fcomb
    reaper.SetProjExtState(0, "fcomb_HZ", "", "")
    reaper.SetProjExtState(0, "fcomb_cent", "", "")
    
    
    --Mcomb
    reaper.SetProjExtState(0, "mcomb_HZ", "", "")
    reaper.SetProjExtState(0, "mcomb_cent", "", "")
    
    
    --Schmitt
    reaper.SetProjExtState(0, "schmitt_HZ", "", "")
    reaper.SetProjExtState(0, "schmitt_cent", "", "")
    
    --Specacf
    reaper.SetProjExtState(0, "specacf_HZ", "", "")
    reaper.SetProjExtState(0, "specacf_cent", "", "")
    
    --Selected GUIDS
    reaper.SetProjExtState(0, "GUID_AUBIO", "", "")
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Set exterior state with pitch specific information. Called recursively in aubio pitch function.
function set:ExteriorState(method, hz, cent, index)
    
    --Need spaces after first 5 arguments due to some sloppiness on my part. I could probably set it to partial match instead of absolute but eh.

    --Yinfast
    if method == "yinfast " then
        reaper.SetProjExtState(0, "yinfast_HZ", tostring(index), hz)
        reaper.SetProjExtState(0, "yinfast_cent", tostring(index), cent)
    end
    
    --Yinfft
    if method == "yinfft " then
        reaper.SetProjExtState(0, "yinfft_HZ", tostring(index), hz)
        reaper.SetProjExtState(0, "yinfft_cent", tostring(index), cent)    
    end
    --Fcomb
    if method == "fcomb " then
        reaper.SetProjExtState(0, "fcomb_HZ", tostring(index), hz)
        reaper.SetProjExtState(0, "fcomb_cent", tostring(index), cent)
    end
    
    --Mcomb
    if method == "mcomb " then
        reaper.SetProjExtState(0, "mcomb_HZ", tostring(index), hz)
        reaper.SetProjExtState(0, "mcomb_cent", tostring(index), cent)
    end
    
    --Schmitt
    if method == "schmitt " then
        reaper.SetProjExtState(0, "schmitt_HZ", tostring(index), hz)
        reaper.SetProjExtState(0, "schmitt_cent", tostring(index), cent)    
    end
    
    --Specacf
    if method == "specacf" then
        reaper.SetProjExtState(0, "specacf_HZ", tostring(index), hz)
        reaper.SetProjExtState(0, "specacf_cent", tostring(index), cent)    
    end
    
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Enumerate all selected items GUIDs to string table.
function get:ItemGUIDS()
    local guid = {} 
    local count = reaper.CountSelectedMediaItems(0)
    for i = 0, count-1 do
        local item = reaper.GetSelectedMediaItem(0,i)
        guid[i] = reaper.BR_GetMediaItemGUID(item)
    end
    return guid
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Send string table to exterior state.
function set:GUIDStoExteriorState(guid)
    for i = 0, #guid do
        reaper.SetProjExtState(0, "GUID_AUBIO", i, guid[i])
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Check existence of pitch exterior state.
function get:PitchExteriorStateExists()

    --Checking for exterior state of any pitch operation that's been performed.
    local a, b, c, d, e, f, g, h, i, j, k, l
    
    a, _, _ = reaper.EnumProjExtState(0, "yinfast_HZ", 0)
    b, _, _ = reaper.EnumProjExtState(0, "yinfast_cent", 0)
    
    c, _, _ = reaper.EnumProjExtState(0, "yinfft_HZ", 0)
    d, _, _ = reaper.EnumProjExtState(0, "yinfft_cent", 0)    
    
    e, _, _ = reaper.EnumProjExtState(0, "fcomb_HZ", 0)
    f, _, _ = reaper.EnumProjExtState(0, "fcomb_cent", 0)    
    
    g, _, _ = reaper.EnumProjExtState(0, "mcomb_HZ", 0)
    h, _, _ = reaper.EnumProjExtState(0, "mcomb_cent", 0)

    i, _, _ = reaper.EnumProjExtState(0, "schmitt_HZ", 0)
    j, _, _ = reaper.EnumProjExtState(0, "schmitt_cent", 0)
    
    k, _, _ = reaper.EnumProjExtState(0, "specacf_HZ", 0)
    l, _, _ = reaper.EnumProjExtState(0, "specacf_cent", 0)    

    --This was fun to type!
    if a or b or c or d or e or f or g or h or i or j or k or l then return true
    else return false end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Compare current string table against exterior state string table. 
function get:GUIDSChanged(guid)
    
    local curguid = {}
    local ret = true
    local i = 0
    while ret do
        ret =  reaper.EnumProjExtState(0, "GUID_AUBIO", i)
        _, curguid[i] = reaper.GetProjExtState(0, "GUID_AUBIO", i)
        i = i + 1
    end
    local changed = array:Match(guid,curguid)
    
    --If tables are equal, GUID has not changed and false should be returned.
    if changed then return false
    
    --Else if they are not equal, then GUID has changed and true should be returned.
    else return true end
    
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Removes item selection, restores selection from GUIDs in exterior state.
function set:ItemsSelectedByExtStateGUIDS()

    --Unselect all items, then establish local variables.
    reaper.Main_OnCommand(40289, 0) -- Unselect all items.
    local guid = {}
    local ret = true
    local i = 0
    
    
    --Loop through exterior state to populate table.
    while ret do
        ret =  reaper.EnumProjExtState(0, "GUID_AUBIO", i)
        _, guid[i] = reaper.GetProjExtState(0, "GUID_AUBIO", i)
        i = i + 1
    end
    
    --Loop through table and set items to selected by GUID.
    for i = 0, #guid do
    
        --This is super annoying: BR_GetMediaItemByGUID doesn't like tables for some reason. Have to convert to local variable first (new bug?? MPL scripts seem to not have this problem with exact same implementation.)
        local id = guid[i]
        
        --Get item by GUID.
        local item = reaper.BR_GetMediaItemByGUID(0, id)
        
        --If item exists, set it to selected.
        if item then
             reaper.SetMediaItemSelected(item, true)
        end
    end
    
    --Need to run this or items don't appear to be selected without first moving arrange view.
    reaper.UpdateArrange()
    
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--Determine whether to clear exterior states, run pitch analysis (and if so what type), or run volume analysis (and if so what type).
function init()
    
    
    --Clear console.
    reaper.ClearConsole()
    
    --Enumerate GUIDS to string table.
    local guids = get:ItemGUIDS()
    
    --Check exterior state for pitch analyses that have already been done.
    local pitchCheck = get:ExteriorStateMethods()
    
    --Set default input option.
    local initInput = "1,0,0"

    --Check if pitch exterior state exists. If it does, check for pitch analyses done.
    if get:PitchExteriorStateExists() then

        --Check for pitch analyses that have already been done. If they've all been done, set input to volume analysis.
        if pitchCheck == "" then initInput = "0,1,0" end
        
        --Get item GUIDS of selected items. If this differs from exterior state, option will default to nuke.
        if get:GUIDSChanged(guids) then initInput = "0,0,1" end
    
    --If pitch exterior state does not exist, set to pitch.
    else 
        initInput = "1,0,0"
    end
    

    
    
    
    
    --Initial user input, figure out whether to nuke exterior states, run pitch analysis, or run volume analysis.
    ::again::
    local selOption
    local process = {}
    local processIDX = 0
    local _, init = reaper.GetUserInputs("Store pitch or volume information to exterior state (1 to choose option)", 3, "Pitch (1 for yes),Volume (1 for yes),Restore/del ext state (1 for yes)", initInput)
    
    for option in init:gmatch('([^,]+)') do
        process[processIDX] = tonumber(option)
        processIDX = processIDX + 1
    end
    
    --Ensure only one option is enabled.
    if process[0] == 1 and process[1] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto again
    elseif process[0] == 1 and process[1] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto again
    elseif process[0] == 1 and process[2] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto again
    elseif process[1] == 1 and process[2] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto again
    elseif process[0] == 1 and process[1] == 1 and process[2] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto again
    elseif process[0] ~= 1 and process[1] ~= 1 and process[2] ~= 1 then reaper.ShowConsoleMsg("Invalid input.\n") goto again end
    
    
    --Pitch.
    if process[0] == 1 then
    
        local pitchProcess = {}
        local pitchIDX = 0
        local a, b, c, d, e, f
        local pitchCSV = "0,0,0,0,0,0"
        
        
        --Tabs through methods sequentially.
        a = pitchCheck:match("yinfast")
        if a then pitchCSV = "1,0,0,0,0,0" goto pitch end
        
        b = pitchCheck:match("yinfft")
        if b then pitchCSV = "0,1,0,0,0,0" goto pitch end
        
        c = pitchCheck:match("fcomb")
        if c then pitchCSV = "0,0,1,0,0,0" goto pitch end
        
        d = pitchCheck:match("mcomb")
        if d then pitchCSV = "0,0,0,1,0,0" goto pitch end
        
        e = pitchCheck:match("schmitt")
        if e then pitchCSV = "0,0,0,0,1,0" goto pitch end
        
        f = pitchCheck:match("specacf")
        if f then pitchCSV = "0,0,0,0,0,1" goto pitch end

        
        ::pitch::
        reaper.ShowConsoleMsg("\nStill have to run pitch analysis with following methods: " .. pitchCheck .. "\n")
        local _, pitchMethod = reaper.GetUserInputs("Select pitch detection method (1 to choose option)", 6, "yinfast (1 for yes),yinfft (1 for yes),fcomb (1 for yes),mcomb (1 for yes),schmitt (1 for yes),specacf (1 for yes)", pitchCSV)
        
        for option in pitchMethod:gmatch('([^,]+)') do
            pitchProcess[pitchIDX] = tonumber(option)
            pitchIDX = pitchIDX + 1
        end
        
        --Little dirty using the global here; no dirtier than the spaghetti code above. I maintain it's actually easier to read in this case than nested conditionals.
        if pitchProcess[0] == 1 then args = "yinfast "
        elseif pitchProcess[1] == 1 then args = "yinfft "
        elseif pitchProcess[2] == 1 then args = "fcomb "
        elseif pitchProcess[3] == 1 then args = "mcomb "
        elseif pitchProcess[4] == 1 then args = "schmitt "
        elseif pitchProcess[5] == 1 then args = "specacf" end
        
        selOption = "Pitch"
        
    end
    
    --Volume.
    if process[1] == 1 then
        
        ::volAgain::
        local volProcess = {}
        local volIDX = 0
        local _, volMethod = reaper.GetUserInputs("Select volume analysis method (1 to choose option)", 3, "Peak (1 for yes),RMS (1 for yes),LUFS (1 for yes)", "1,0,0")
        
        for option in volMethod:gmatch('([^,]+)') do
            volProcess[volIDX] = tonumber(option)
            volIDX = volIDX + 1
        end
        
        --Ensure only one option is enabled.
        if volProcess[0] == 1 and volProcess[1] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto volAgain
        elseif volProcess[0] == 1 and volProcess[1] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto volAgain
        elseif volProcess[0] == 1 and volProcess[2] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto volAgain
        elseif volProcess[1] == 1 and volProcess[2] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto volAgain
        elseif volProcess[0] == 1 and volProcess[1] == 1 and volProcess[2] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto volAgain
        elseif volProcess[0] ~= 1 and volProcess[1] ~= 1 and volProcess[2] ~= 1 then reaper.ShowConsoleMsg("Invalid input.\n") goto volAgain end
        
        if volProcess[0] == 1 then selOption = "Peak" end
        if volProcess[1] == 1 then selOption = "RMS" end
        if volProcess[2] == 1 then selOption = "LUFS" end
        
    end
    
    --Nuke.
    if process[2] == 1 then
        
        ::nukeAgain::
        local nukeProcess = {}
        local nukeIDX = 0
        local _, nukeMethod = reaper.GetUserInputs("Remove exterior state? (1 to choose option)", 2, "Restore selection (1 for yes),Delete ext state (1 for yes)", "1,0")
        
        for option in nukeMethod:gmatch('([^,]+)') do
            nukeProcess[nukeIDX] = tonumber(option)
            nukeIDX = nukeIDX + 1
        end
        
        --Ensure only one option is enabled.
        if nukeProcess[0] == 1 and nukeProcess[1] == 1 then reaper.ShowConsoleMsg("Pick only one process.\n") goto nukeAgain
        elseif nukeProcess[0] ~= 1 and nukeProcess[1] ~= 1 then reaper.ShowConsoleMsg("Invalid input.\n") goto nukeAgain end
        
        if nukeProcess[0] == 1 then selOption = "Select" end
        if nukeProcess[1] == 1 then selOption = "Nuke" end
        
    end
    
    
    return selOption, guids
end

--Runs main function (option determines which function it runs).
function main(option, guids)

------------------------------------------------------------------------------------
    if option == "Pitch" then
        local count = reaper.CountSelectedMediaItems(0)
        
        --If more than zero items are selected, run operation.
        if count > 0 then 
            set:GUIDStoExteriorState(guids)
            for i = 0, count-1 do
                local it = reaper.GetSelectedMediaItem(0,i)
                local tk = reaper.GetActiveTake(it)
                local nm = reaper.GetTakeName(tk)
                local hz = get:HzFromTakeName(it)
                local avg, adj = run:AubioPitch(it, hz, i, args)
                reaper.ShowConsoleMsg("Using ".. args.. ": The estimated pitch of ".. nm.. " should be " .. hz .. ". The averaged pitch is " .. avg .. ". Adjustment should be " .. adj .. " cents. \n")
            end
            
            checkStr = get:ExteriorStateMethods()
            if checkStr == "" then 
                reaper.ShowConsoleMsg("\n-----------------------------------------\n")
                reaper.ShowConsoleMsg("All pitch analyses complete!")
                reaper.ShowConsoleMsg("\n-----------------------------------------\n")
            else
                reaper.ShowConsoleMsg("\n-----------------------------------------\n")
                reaper.ShowConsoleMsg("Still have to run pitch analysis with following methods: " .. get:ExteriorStateMethods())
                reaper.ShowConsoleMsg("\n-----------------------------------------\n")
            end
        
        --Else if no items are selected, abort operation.
        else
            reaper.ClearConsole()
  --          reaper.ShowConsoleMsg("No items selected!")
        end
------------------------------------------------------------------------------------
    elseif option == "Peak" then
        local count = reaper.CountSelectedMediaItems(0)
        peak = {val={}, pos={}, length={}}
        for i = 0, count-1 do
            local it = reaper.GetSelectedMediaItem(0,i)
            peak.val[i] = get:Peak(it)
            peak.pos[i] = reaper.GetMediaItemInfo_Value(it, "D_POSITION")
            peak.length[i] = reaper.GetMediaItemInfo_Value(it, "D_LENGTH")
        end
    set:NormalizationTrack(peak, option)
------------------------------------------------------------------------------------    
    elseif option == "RMS" then
        rms = {val={}, pos={}, length={}}
        local count = reaper.CountSelectedMediaItems(0)
        for i = 0, count-1 do
            local it = reaper.GetSelectedMediaItem(0,i)
            rms.val[i] = get:RMS(it)
            rms.pos[i] = reaper.GetMediaItemInfo_Value(it, "D_POSITION")
            rms.length[i] = reaper.GetMediaItemInfo_Value(it, "D_LENGTH")
        end
    set:NormalizationTrack(rms, option)
------------------------------------------------------------------------------------    
    elseif option == "LUFS" then 
        lufs = {val={}, pos={}, length={}}
        local count = reaper.CountSelectedMediaItems(0)
        for i = 0, count-1 do
            local it = reaper.GetSelectedMediaItem(0,i)
            lufs.val[i] = get:LUFS(it)
            lufs.pos[i] = reaper.GetMediaItemInfo_Value(it, "D_POSITION")
            lufs.length[i] = reaper.GetMediaItemInfo_Value(it, "D_LENGTH")
        end
    set:NormalizationTrack(lufs, option)
------------------------------------------------------------------------------------
    elseif option == "Nuke" then
        set:ExteriorStateClear()
------------------------------------------------------------------------------------        
    elseif option == "Select" then
        set:ItemsSelectedByExtStateGUIDS()
    end
------------------------------------------------------------------------------------    
    
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--GLOBALS:
cent = value:nroot(1200,2) -- I can probably get more precise than this but it'd be pretty silly. Maybe for a future implementation with crepe instead of aubio.
centcent = value:nroot(120000,2) -- I did get silly on this; just because reatune gives hundredth of a cent precision and piano tuning contains a lot of 2 cent adjustments.
semi = value:nroot(12,2)
aubioPath = reaper.GetResourcePath().."\\UserPlugins\\aubio\\0.4.9\\win64\\aubiopitch.exe" 

--This is declared here, but it's redeclared down below. Keeping it just in case for now.
--Do plan to split the script into the different methods anyway on a toolbar.
args = "" --yinfft, yinfast , yin, schmitt, mcomb, fcomb, specacf are the options. yinfft is default
pitchStandard = 440


undo:Begin()
option, guids = init()
main(option, guids)
undo:End("Store pitch or volume information to exterior state (aubio)")



--[[
--RESET BUTTON: Use for debugging.
set:ExteriorStateClear()
]]
