--DNLDN Add harmonic series to last touched band in Fabfilter Pro-Q.
    --NOTE: This is for VST 3 version of Fabfilter Pro-q 3 - unclear if the same scaling is used on previous or future versions of Pro-Q.
    --Adds additional bands to last-touched Pro-Q plugin, if the last-touched parameter is in Pro-Q and related to a frequency band.
    --Demonstration: 


--Declaring module names.
get = {}
set = {}
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

--Returns VST-normalized value from frequency value.
function get:ProqFreqNormVal(freq)
    return -0.287594 + 0.124901 * math.log(freq)
end

--Returns frequency value from VST-normalized value.
function get:ProqFreqVal(norm)
    return 9.99991 * math.exp(8.00634*norm)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Set functions.

--Set values for each harmonic band to mirror the global last touched band.
function set:Band(normalized_harmonic, band_multiplier)

    --Only instantiate band if the normalized value does not exceed 1.0.
    if normalized_harmonic <= 1 then

        --Instantiate band.
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)-2, 1) --Used
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)-1, 1) --Enabled

        --Set frequency, gain, and dynamics to default values. It's easier to adjust them to taste immediately after instantiation, unless I am specifically trying to do a reductive notch.
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier), normalized_harmonic) --Frequency
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)+1, .5) --Gain (set to zero)
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)+2, .5) --Dynamics range (set to zero)
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)+3, 0) --Dynamics enabled (set to disabled)

        --Mirroring Q-value and stereo position.
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)+8, .5) --Stereo position (match original parameter)
        reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)+5, qVal)
        
        --If I'm notching (Q-value above 4 and gain value negative on selected band): set to same Q as original band and set gain to match value as well.
        if qVal >= qSweepLimit and gainVal < .5 then
            reaper.TrackFX_SetParamNormalized(track, fxn, param+(gap*band_multiplier)+1, gainVal) --Gain (set to zero)
        end
    end    
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Global variables.

--13 is the gap between each successive band parameter in Fabfilter: IE Frequency band 1 Frequency band 2; Q-value band 1 to Q-value band 2.
gap = 13

--Equal to a Q-value of 4. Used to determine conditional logic in main function.
qSweepLimit = .68790185451508

--Get the last touched FX and associated track information.
bool, trn, fxn, param = reaper.GetLastTouchedFX()
track = reaper.GetTrack(0, trn-1)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Main function.

function main()
    --Determine that Fabfilter Pro-Q is the last touched FX accessed before proceeding.
    if bool then
        bool, fxname = reaper.TrackFX_GetFXName(track,fxn, "")
        if bool then
            bool, name = reaper.TrackFX_GetParamName(track, fxn, param, "")
            local a, b = string.find(fxname, "Pro%-Q")

            --Check if Pro-Q has been aliased to be titled "Pre-Emphasis" - I use a linked FX preset that ties all parameters in two bands of Pro-Q together as a pre-emphasis and de-emphasis EQ utility.
            if not a and not b then
                a, b = string.find(fxname, "Pre%-Emphasis")
                local _, nm = reaper.BR_TrackFX_GetFXModuleName(track, fxn)
                
                --Guard railing in case some other plugin has the words "Pre-emphasis" but is not Pro-Q.
                if not nm:match("FabFilter Pro%-Q 3%.vst3") then
                    a = nil
                    b = nil
                end
                
            end

            --Once the above conditions have been met, determine that the last parameter to be manipulated was specific to the selected band, and reassign the param variable to the frequency slot.
            if a and b then
              
                local a, b = string.find(name, "Frequency")
                local c, d = string.find(name, "Gain")
                local e, f = string.find(name, "Q")
                local g, h = string.find(name, "Used")
                local i, j = string.find(name, "Enabled")
                if not a and not b then
                    if c and d then
                        a = c
                        b = d
                        param = param-1
                    end
                    if e and f then
                        a = e
                        b = f
                        param = param-5
                    end
                    if g and h then
                        a = g
                        b = h
                        param = param+2
                    end
                    if i and j then
                        a = i
                        b = j
                        param = param+1
                    end
                end
                
                
                if a and b then

                    --Obtain parameter values relative to frequency to mirror in harmonic bands.
                    val = reaper.TrackFX_GetParamNormalized(track, fxn, param)
                    stereoPos = reaper.TrackFX_GetParamNormalized(track, fxn, param+8)
                    gainVal = reaper.TrackFX_GetParamNormalized(track, fxn, param+1)
                    qVal = reaper.TrackFX_GetParamNormalized(track, fxn, param+5) --Anything over Q of 4 is considered a notch.
                    freqVal = get:ProqFreqVal(val)

                    --Get the normalized value of the first seven harmonics; which will be a whole number multiplication of the original frequency, and set multiplier value.
                    harm2 = {value = get:ProqFreqNormVal(freqVal*2), multiplier = 1}
                    harm3 = {value = get:ProqFreqNormVal(freqVal*3), multiplier = 2}
                    harm4 = {value = get:ProqFreqNormVal(freqVal*4), multiplier = 3}
                    harm5 = {value = get:ProqFreqNormVal(freqVal*5), multiplier = 4}
                    harm6 = {value = get:ProqFreqNormVal(freqVal*6), multiplier = 5}
                    harm7 = {value = get:ProqFreqNormVal(freqVal*7), multiplier = 6}                

                    --Set values for harmonic bands.
                    set:Band(harm2.value, harm2.multiplier)
                    set:Band(harm3.value, harm3.multiplier)
                    set:Band(harm4.value, harm4.multiplier)
                    set:Band(harm5.value, harm5.multiplier)
                    set:Band(harm6.value, harm6.multiplier)
                    set:Band(harm7.value, harm7.multiplier)
                end
             end
        end
    end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Execute main function.
undo:Begin()
main()
undo:End("Add harmonic series to last touched band in Pro-Q")