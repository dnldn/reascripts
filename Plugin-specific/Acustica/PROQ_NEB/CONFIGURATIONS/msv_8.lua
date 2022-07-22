local msv_8 = {}


--x represents normalized parameter value
--y represents readout value from library; used for input into pro-q equation.

--UNIVERSALS:
local hardware = reaper.GetResourcePath() .. "\\Scripts\\DNLDN\\PROQ_NEB\\CONFIGURATIONS\\"

--LOCAL FUNCTIONS:
local function limit(val, min, max)
	if val < min then return min
	elseif val > max then return max
	else return val end
end

local function getFreqNormVal(freq)
	freq = limit(freq, 10, 30000)
    return -0.287594 + 0.124901 * math.log(freq)
end

local function getQNormVal(q)
	q = limit(q, 0.025, 40)
    return 0.4999+0.1356*math.log(q)
end

local function getGainNormVal(gain)
	gain = limit(gain, -30, 30)
    return 0.01667*gain+.5
end

local function modulateBoost(track, gainNormVal, fx)
   if gainNormVal >= .5 then reaper.TrackFX_SetParamNormalized(track, fx, msv.param.wet, 1)
   else reaper.TrackFX_SetParamNormalized(track, fx, msv.param.wet, 0) end
end

local function modulateCut(track, gainNormVal, fx)
   if gainNormVal < .5 then reaper.TrackFX_SetParamNormalized(track, fx, msv.param.wet, 1)
   else reaper.TrackFX_SetParamNormalized(track, fx, msv.param.wet, 0) end
end

--Set Pro-Q section limits.
function limitBand(value, lower, upper)
    if value <= lower then
        return lower
    elseif value >= upper then
        return upper
    else 
        return value
    end
end

function toggleSolo(solo)
    if solo == 1 then return true else return false end
end

function msv_8:updateBands(track, eq, controller_pos, hw)
    --Get values from pro-q.
    local freq = {b1, b2, b3, b4, b5, b6, b7, b8}
    local gain = {b1, b2, b3, b4, b5, b6, b7, b8}
    local q = {b1, b2, b3, b4, b5, b6, b7, b8}
    local solo = {b1, b2, b3, b4, b5, b6, b7, b8}
    
    
    freq.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.freq)
    freq.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.freq)
    freq.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.freq)
    freq.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.freq)
    freq.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.freq)
    freq.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.freq)
    freq.b7 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band7.freq)
    freq.b8 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band8.freq)

    gain.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.gain)
    gain.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.gain)
    gain.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.gain)
    gain.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.gain)
    gain.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.gain)
    gain.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.gain)
    gain.b7 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band7.gain)
    gain.b8 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band8.gain)

    q.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.q)
    q.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.q)
    q.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.q)
    q.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.q)
    q.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.q)
    q.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.q)
    q.b7 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band7.q)
    q.b8 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band8.q)
    
    solo.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.solo)
    solo.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.solo)
    solo.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.solo)
    solo.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.solo)
    solo.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.solo)
    solo.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.solo)
    solo.b7 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band7.solo)
    solo.b8 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band8.solo)
    
    --Setting nebula updates.
    reaper.TrackFX_SetParamNormalized(track, controller_pos+1, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b1)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+1, msv.param.freq, msv:getFreqLFNormVal(proq:getFreqVal(freq.b1)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+1, msv.param.gain, msv:getCutNormVal(0-(proq:getGainVal(gain.b1))))
    modulateCut(track, gain.b1, controller_pos+1)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+2, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b1)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+2, msv.param.freq, msv:getFreqLFNormVal(proq:getFreqVal(freq.b1)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+2, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b1)))
    modulateBoost(track, gain.b1, controller_pos+2)

    reaper.TrackFX_SetParamNormalized(track, controller_pos+3, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b2)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+3, msv.param.freq, msv:getFreqLFNormVal(proq:getFreqVal(freq.b2)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+3, msv.param.gain, msv:getCutNormVal(0-(proq:getGainVal(gain.b2))))
    modulateCut(track, gain.b2, controller_pos+3)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+4, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b2)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+4, msv.param.freq, msv:getFreqLFNormVal(proq:getFreqVal(freq.b2)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+4, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b2)))
    modulateBoost(track, gain.b2, controller_pos+4)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+5, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b3)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+5, msv.param.freq, msv:getFreqLMFNormVal(proq:getFreqVal(freq.b3)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+5, msv.param.gain, msv:getCutNormVal(0-(proq:getGainVal(gain.b3))))
    modulateCut(track, gain.b3, controller_pos+5)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+6, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b3)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+6, msv.param.freq, msv:getFreqLMFNormVal(proq:getFreqVal(freq.b3)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+6, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b3)))
    modulateBoost(track, gain.b3, controller_pos+6)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+7, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b4)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+7, msv.param.freq, msv:getFreqLMFNormVal(proq:getFreqVal(freq.b4)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+7, msv.param.gain, msv:getCutNormVal(0-(proq:getGainVal(gain.b4))))
    modulateCut(track, gain.b4, controller_pos+7)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+8, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b4)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+8, msv.param.freq, msv:getFreqLMFNormVal(proq:getFreqVal(freq.b4)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+8, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b4)))
    modulateBoost(track, gain.b4, controller_pos+8)

    reaper.TrackFX_SetParamNormalized(track, controller_pos+9, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b5)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+9, msv.param.freq, msv:getFreqHMFNormVal(proq:getFreqVal(freq.b5)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+9, msv.param.gain, msv:getCutNormVal(0-(proq:getGainVal(gain.b5))))
    modulateCut(track, gain.b5, controller_pos+9)

    reaper.TrackFX_SetParamNormalized(track, controller_pos+10, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b5)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+10, msv.param.freq, msv:getFreqHMFNormVal(proq:getFreqVal(freq.b5)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+10, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b5)))
    modulateBoost(track, gain.b5, controller_pos+10)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+11, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b6)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+11, msv.param.freq, msv:getFreqHMFNormVal(proq:getFreqVal(freq.b6)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+11, msv.param.gain, msv:getCutNormVal(0-(proq:getGainVal(gain.b6))))
    modulateCut(track, gain.b6, controller_pos+11)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+12, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b6)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+12, msv.param.freq, msv:getFreqHMFNormVal(proq:getFreqVal(freq.b6)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+12, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b6)))
    modulateBoost(track, gain.b6, controller_pos+12)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+13, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b7)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+13, msv.param.freq, msv:getFreqHFNormVal(proq:getFreqVal(freq.b7)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+13, msv.param.gain, msv:getCutNormVal(0-(proq:getGainVal(gain.b7))))
    modulateCut(track, gain.b7, controller_pos+13)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+14, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b7)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+14, msv.param.freq, msv:getFreqHFNormVal(proq:getFreqVal(freq.b7)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+14, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b7)))
    modulateBoost(track, gain.b7, controller_pos+14)
    
    --reaper.TrackFX_SetParamNormalized(track, controller_pos+15, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b8)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+15, msv.param.freq, msv:getFreqHFNormVal(proq:getFreqVal(freq.b8)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+15, msv.param.Q, msv:getCutNormVal(0-(proq:getGainVal(gain.b8)))) -- This band is missing a bandwidth control and cut is positioned where Q is. They're scaled differently too, so fix that at some point.
    modulateCut(track, gain.b8, controller_pos+15)
    
    reaper.TrackFX_SetParamNormalized(track, controller_pos+16, msv.param.Q, msv:getQNormVal(proq:getQVal(q.b8)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+16, msv.param.freq, msv:getFreqHFNormVal(proq:getFreqVal(freq.b8)))
    reaper.TrackFX_SetParamNormalized(track, controller_pos+16, msv.param.gain, msv:getBoostNormVal(proq:getGainVal(gain.b8)))
    modulateBoost(track, gain.b8, controller_pos+16)

    --Setting Pro-Q limits.
    
    --Frequency.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.freq, limitBand(freq.b1, hw.proqBand.lowerFreq[1], hw.proqBand.upperFreq[1]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.freq, limitBand(freq.b2, hw.proqBand.lowerFreq[2], hw.proqBand.upperFreq[2]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.freq, limitBand(freq.b3, hw.proqBand.lowerFreq[3], hw.proqBand.upperFreq[3]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.freq, limitBand(freq.b4, hw.proqBand.lowerFreq[4], hw.proqBand.upperFreq[4]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.freq, limitBand(freq.b5, hw.proqBand.lowerFreq[5], hw.proqBand.upperFreq[5]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.freq, limitBand(freq.b6, hw.proqBand.lowerFreq[6], hw.proqBand.upperFreq[6]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band7.freq, limitBand(freq.b7, hw.proqBand.lowerFreq[7], hw.proqBand.upperFreq[7]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band8.freq, limitBand(freq.b8, hw.proqBand.lowerFreq[8], hw.proqBand.upperFreq[8]))

   --Gain.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.gain, limitBand(gain.b1, hw.proqBand.lowerGain[1], hw.proqBand.upperGain[1]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.gain, limitBand(gain.b2, hw.proqBand.lowerGain[2], hw.proqBand.upperGain[2]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.gain, limitBand(gain.b3, hw.proqBand.lowerGain[3], hw.proqBand.upperGain[3]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.gain, limitBand(gain.b4, hw.proqBand.lowerGain[4], hw.proqBand.upperGain[4]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.gain, limitBand(gain.b5, hw.proqBand.lowerGain[5], hw.proqBand.upperGain[5]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.gain, limitBand(gain.b6, hw.proqBand.lowerGain[6], hw.proqBand.upperGain[6]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band7.gain, limitBand(gain.b7, hw.proqBand.lowerGain[7], hw.proqBand.upperGain[7]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band8.gain, limitBand(gain.b8, hw.proqBand.lowerGain[8], hw.proqBand.upperGain[8]))

   --Q.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.q, limitBand(q.b1, hw.proqBand.lowerQ[1], hw.proqBand.upperQ[1]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.q, limitBand(q.b2, hw.proqBand.lowerQ[2], hw.proqBand.upperQ[2]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.q, limitBand(q.b3, hw.proqBand.lowerQ[3], hw.proqBand.upperQ[3]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.q, limitBand(q.b4, hw.proqBand.lowerQ[4], hw.proqBand.upperQ[4]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.q, limitBand(q.b5, hw.proqBand.lowerQ[5], hw.proqBand.upperQ[5]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.q, limitBand(q.b6, hw.proqBand.lowerQ[6], hw.proqBand.upperQ[6]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band7.q, limitBand(q.b7, hw.proqBand.lowerQ[7], hw.proqBand.upperQ[7]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band8.q, limitBand(q.b8, hw.proqBand.lowerQ[8], hw.proqBand.upperQ[8]))
   
   --Shape.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.shape, hw.hwBand.shape[1])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.shape, hw.hwBand.shape[2])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.shape, hw.hwBand.shape[3])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.shape, hw.hwBand.shape[4])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.shape, hw.hwBand.shape[5])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.shape, hw.hwBand.shape[6])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band7.shape, hw.hwBand.shape[7])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band8.shape, hw.hwBand.shape[8])
   
   --Force bands used.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band7.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band8.used, 1)
    
    --Limit used bands.
    for i = hw.num_bands, hw.unused_bands do
        reaper.TrackFX_SetParamNormalized(track, controller_pos, proq.param.used + (i*proq.param.gap), 0)
    end
    
    --Enable solo modulation.
    if toggleSolo(solo.b1) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band1.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band1.solo, 0)
    end
    if toggleSolo(solo.b2) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band2.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band2.solo, 0)
    end
    if toggleSolo(solo.b3) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band3.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band3.solo, 0)
    end
    if toggleSolo(solo.b4) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band4.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band4.solo, 0)
    end
    if toggleSolo(solo.b5) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band5.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band5.solo, 0)
    end
    if toggleSolo(solo.b6) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band6.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band6.solo, 0)
    end
    if toggleSolo(solo.b7) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band7.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band7.solo, 0)
    end
    if toggleSolo(solo.b8) then
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band8.solo, 1.0)
    else
       reaper.TrackFX_SetParamNormalized(track, controller_pos+18, eq.band8.solo, 0)
    end
end

msv_8.num_bands = 8
msv_8.unused_bands = 16
msv_8.hwNum = 1
msv_8.flag = "msv 8200"

--These definitions should ultimately be set by information contained in surge.lua, s432.lua, massive.lua etc if I intend to make it customizable with GUI.
--Magic numbering it for now.

--Declaring norm value that lock shape into place in pro-q.
local bell = 0
local lowShelf = .125
local highShelf = .375
local hpf = .25
local lpf = .5
local shapeArray = {lowShelf, bell, bell, bell, bell, bell, bell, highShelf}
local gap = 13

--Position relative to the controller; not sure this will ever not be incremental, but here for completion's sake.
local posArray = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}

--These should be calculated upstream in the future in the GUI generation template.
local lowerArrayGain = {getGainNormVal(-6), getGainNormVal(-6), getGainNormVal(-6), getGainNormVal(-6), getGainNormVal(-6), getGainNormVal(-6), getGainNormVal(-6), getGainNormVal(-6)}
local upperArrayGain = {getGainNormVal(4), getGainNormVal(4), getGainNormVal(4), getGainNormVal(4), getGainNormVal(4), getGainNormVal(4), getGainNormVal(4), getGainNormVal(4)}

--These should be calculated upstream in the future in the GUI generation template.
local lowerArrayQ = {getQNormVal(.5), getQNormVal(.5), getQNormVal(.5), getQNormVal(.5), getQNormVal(.5), getQNormVal(.5), getQNormVal(.5), getQNormVal(.5)}
local upperArrayQ = {getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5)}

--These should be calculated upstream in the future in the GUI generation template.
local lowerArrayFreq = {getFreqNormVal(22), getFreqNormVal(22), getFreqNormVal(220), getFreqNormVal(220), getFreqNormVal(1000), getFreqNormVal(1000), getFreqNormVal(4700), getFreqNormVal(4700)}
local upperArrayFreq = {getFreqNormVal(150), getFreqNormVal(150), getFreqNormVal(820), getFreqNormVal(820), getFreqNormVal(3900), getFreqNormVal(3900), getFreqNormVal(27000), getFreqNormVal(27000)}

msv_8.hwBand = {shape = {}, pos = {}}
msv_8.proqBand = {lowerGain = {}, upperGain = {}, lowerQ = {}, upperQ = {}, lowerFreq = {}, upperFreq = {}}
msv_8.mirror = false


for i = 0, msv_8.num_bands do
	msv_8.hwBand.shape[i] = shapeArray[i]
	msv_8.hwBand.pos[i] = posArray[i]
	msv_8.proqBand.lowerGain[i] = lowerArrayGain[i]
	msv_8.proqBand.upperGain[i] = upperArrayGain[i]
	msv_8.proqBand.lowerQ[i] = lowerArrayQ[i]
	msv_8.proqBand.upperQ[i] = upperArrayQ[i]
	msv_8.proqBand.lowerFreq[i] = lowerArrayFreq[i]
	msv_8.proqBand.upperFreq[i] = upperArrayFreq[i]
end


return msv_8