local CCB = {}


--x represents normalized parameter value
--y represents readout value from library; used for input into pro-q equation.

--UNIVERSALS:
local hardware = reaper.GetResourcePath() .. "\\Scripts\\DNLDN\\PROQ_NEB\\CONFIGURATIONS\\"
CCB.bandShapeFlag = {lf, lmf, hmf, hf}

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


--Probably can be blown.
local function setGainLimit(band, negative)
   if band == 2 and negative then
      if CCB.bandShapeFlag.lf == 1 then return -15 else return -10 end
   elseif band == 2 and not negative then
      if CCB.bandShapeFlag.lf == 1 then return 15 else return 10 end
   end

   if band == 3 and negative then
      if CCB.bandShapeFlag.lmf == 1 then return -15 else return -10 end
   elseif band == 3 and not negative then
      if CCB.bandShapeFlag.lmf == 1 then return 15 else return 10 end
   end

   if band == 4 and negative then
      if CCB.bandShapeFlag.hmf == 1 then return -15 else return -10 end
   elseif band == 4 and not negative then
      if CCB.bandShapeFlag.hmf == 1 then return 15 else return 10 end
   end

   if band == 5 and negative then
      if CCB.bandShapeFlag.hf == 1 then return -15 else return -10 end
   elseif band == 5 and not negative then
      if CCB.bandShapeFlag.hf == 1 then return 15 else return 10 end
   end

end


local bell = 0
local lowShelf = .125
local highShelf = .375
local hpf = .25
local lpf = .5
local shapeArray = {hpf, bell, bell, bell, bell, lpf}
local gap = 13

--local function getQValLF(q, shape)
--   if shape == lowShelf and q <= 1.25 then
--      CCB.bandShapeFlag.lf = 0
--      return 0
--   elseif shape == bell and q <= 1.25 then
--      CCB.bandShapeFlag.lf = 0
--      return .25
--   elseif shape == lowShelf and q > 1.25 then
--      CCB.bandShapeFlag.lf = 1
--      return .5
--   elseif shape == bell and q > 1.25 then
--      CCB.bandShapeFlag.lf = 1
--      return .75
--   end
--end
--
--local function getQValLMF(q, shape)
--   if q <= 1.25 then
--      CCB.bandShapeFlag.lmf = 0
--      return 0
--   elseif q > 1.25 then
--      CCB.bandShapeFlag.lmf = 1
--      return .333
--   end
--end
--
--local function getQValHMF(q, shape)
--   if q <= 1.25 then
--      CCB.bandShapeFlag.hmf = 0
--      return 0
--   elseif q > 1.25 then
--      CCB.bandShapeFlag.hmf = 1
--      return .5
--   end
--end
--
--local function getQValHF(q, shape)
--   if shape == highShelf and q <= 1.25 then
--      CCB.bandShapeFlag.hf = 0
--      return 0
--   elseif shape == bell and q <= 1.25 then
--      CCB.bandShapeFlag.hf = 0
--      return .2
--   elseif shape == highShelf and q > 1.25 then
--      CCB.bandShapeFlag.hf = 1
--      return .4
--   elseif shape == bell and q > 1.25 then
--      CCB.bandShapeFlag.hf = 1
--      return .6
--   end
--end

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

function CCB:updateBands(track, eq, controller_pos, hw)
	--Get values from pro-q.
	local freq = {b1, b2, b3, b4, b5, b6}
	local gain = {b1, b2, b3, b4, b5, b6}
	local q = {b1, b2, b3, b4, b5, b6}
	local solo = {b1, b2, b3, b4, b5, b6}
   local shape = {b1, b2, b3, b4, b5, b6}
	
	
   freq.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.freq)
   freq.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.freq)
   freq.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.freq)
   freq.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.freq)
   freq.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.freq)
   freq.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.freq)

   gain.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.gain)
   gain.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.gain)
   gain.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.gain)
   gain.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.gain)
   gain.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.gain)
   gain.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.gain)

   q.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.q)
   q.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.q)
   q.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.q)
   q.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.q)
   q.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.q)
   q.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.q)
	
   solo.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.solo)
   solo.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.solo)
   solo.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.solo)
   solo.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.solo)
   solo.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.solo)
   solo.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.solo)

   shape.b1 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band1.shape)
   shape.b2 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band2.shape)
   shape.b3 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band3.shape)
   shape.b4 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band4.shape)
   shape.b5 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band5.shape)
   shape.b6 = reaper.TrackFX_GetParamNormalized(track, controller_pos, eq.band6.shape)
	
   --Setting nebula updates.
	
   --Q.
   local isShape = {bell = 0, lowShelf = .125, highShelf = .375, hpf = .25, lpf = .5}
   local isMult = {lf = false, lmf = false, hmf = false, hf = false}

   local function getLFQ(q, shape)
      local band_is = {shelf = 0, bell = .25, shelfMult = .5, bellMult = .75}
      if shape == isShape.bell and proq:getQVal(q) <= 1.25 then isMult.lf = false return band_is.bell
      elseif shape == isShape.lowShelf and proq:getQVal(q) <= 1.25 then isMult.lf = false return band_is.shelf
      elseif shape == isShape.bell and proq:getQVal(q) > 1.25 then isMult.lf = true return band_is.bellMult
      elseif shape == isShape.lowShelf and proq:getQVal(q) > 1.25 then isMult.lf = true return band_is.shelfMult
      elseif shape ~= isShape.bell and shape ~= isShape.lowShelf then isMult.lf = false return band_is.shelf end
   end

   local function getLMFQ(q)
      local band_is = {bell = 0, bellMult = .333}
      if proq:getQVal(q) <= 1.25 then isMult.lmf = false return band_is.bell
      elseif proq:getQVal(q) > 1.25 then isMult.lmf = true return band_is.bellMult end
   end

   local function getHMFQ(q)
      local band_is = {bell = 0, bellMult = .5}
      if proq:getQVal(q) <= 1.25 then isMult.hmf = false return band_is.bell
      elseif proq:getQVal(q) > 1.25 then isMult.hmf = true return band_is.bellMult end
   end

   local function getHFQ(q, shape)
      local band_is = {shelf = 0, bell = .2, shelfMult = .4, bellMult = .6}
      if shape == isShape.bell and proq:getQVal(q) <= 1.25 then isMult.hf = false return band_is.bell
      elseif shape == isShape.highShelf and proq:getQVal(q) <= 1.25 then isMult.hf = false return band_is.shelf
      elseif shape == isShape.bell and proq:getQVal(q) > 1.25 then isMult.hf = true return band_is.bellMult
      elseif shape == isShape.highShelf and proq:getQVal(q) > 1.25 then isMult.hf = true return band_is.shelfMult
      elseif shape ~= isShape.bell and shape ~= isShape.highShelf then isMult.hf = false return band_is.bell end
   end

   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lfQ, getLFQ(q.b2, shape.b2))
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lmfQ, getLMFQ(q.b3))
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hmfQ, getHMFQ(q.b4))
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hfQ, getHFQ(q.b5, shape.b5))

   --Gain.
   

   local function getLFGain()
      if isMult.lf then return ccb:getGainNormValMult(proq:getGainVal(gain.b2))
      else return ccb:getGainNormVal(proq:getGainVal(gain.b2)) end
   end

   local function getLMFGain()
      if isMult.lmf then return ccb:getGainNormValMult(proq:getGainVal(gain.b3))
      else return ccb:getGainNormVal(proq:getGainVal(gain.b3)) end
   end

   local function getHMFGain()
      if isMult.hmf then return ccb:getGainNormValMult(proq:getGainVal(gain.b4))
      else return ccb:getGainNormVal(proq:getGainVal(gain.b4)) end
   end

   local function getHFGain()
      if isMult.hf then return ccb:getGainNormValMult(proq:getGainVal(gain.b5))
      else return ccb:getGainNormVal(proq:getGainVal(gain.b5)) end
   end

   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lfGain, getLFGain())
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lmfGain, getLMFGain())
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hmfGain, getHMFGain())
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hfGain, getHFGain())

   --reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lfGain, ccb:getGainNormVal(proq:getGainVal(gain.b2)))
   --reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lmfGain, ccb:getGainNormVal(proq:getGainVal(gain.b3)))
   --reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hmfGain, ccb:getGainNormVal(proq:getGainVal(gain.b4)))
   --reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hfGain, ccb:getGainNormVal(proq:getGainVal(gain.b5)))


   --Frequency.
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.HPF, ccb:getHPFNormVal(proq:getFreqVal(freq.b1)))   
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lfFreq, ccb:getFreqLFNormVal(proq:getFreqVal(freq.b2)))
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.lmfFreq, ccb:getFreqLMFNormVal(proq:getFreqVal(freq.b3)))
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hmfFreq, ccb:getFreqHMFNormVal(proq:getFreqVal(freq.b4)))
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.hfFreq, ccb:getFreqHFNormVal(proq:getFreqVal(freq.b5)))
   reaper.TrackFX_SetParamNormalized(track, controller_pos+1, ccb.param.LPF, ccb:getLPFNormVal(proq:getFreqVal(freq.b6)))
	
	--Setting Pro-Q limits.
	
	--Frequency.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.freq, limitBand(freq.b1, hw.proqBand.lowerFreq[1], hw.proqBand.upperFreq[1]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.freq, limitBand(freq.b2, hw.proqBand.lowerFreq[2], hw.proqBand.upperFreq[2]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.freq, limitBand(freq.b3, hw.proqBand.lowerFreq[3], hw.proqBand.upperFreq[3]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.freq, limitBand(freq.b4, hw.proqBand.lowerFreq[4], hw.proqBand.upperFreq[4]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.freq, limitBand(freq.b5, hw.proqBand.lowerFreq[5], hw.proqBand.upperFreq[5]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.freq, limitBand(freq.b6, hw.proqBand.lowerFreq[6], hw.proqBand.upperFreq[6]))

	--Gain.
   local function rescaleGain(scaled, negative)
      if scaled and negative then return -15
      elseif scaled and not negative then return 15
      elseif not scaled and negative then return -10
      elseif not scaled and not negative then return 10
      end
   end
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.gain, limitBand(gain.b1, hw.proqBand.lowerGain[1], hw.proqBand.upperGain[1]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.gain, limitBand(gain.b2, proq:getGainNormVal(rescaleGain(isMult.lf, true)), proq:getGainNormVal(rescaleGain(isMult.lf, false))))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.gain, limitBand(gain.b3, proq:getGainNormVal(rescaleGain(isMult.lmf, true)), proq:getGainNormVal(rescaleGain(isMult.lmf, false))))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.gain, limitBand(gain.b4, proq:getGainNormVal(rescaleGain(isMult.hmf, true)), proq:getGainNormVal(rescaleGain(isMult.hmf, false))))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.gain, limitBand(gain.b5, proq:getGainNormVal(rescaleGain(isMult.hf, true)), proq:getGainNormVal(rescaleGain(isMult.hf, false))))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.gain, limitBand(gain.b6, hw.proqBand.lowerGain[6], hw.proqBand.upperGain[6]))


   --reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.gain, limitBand(gain.b2, hw.proqBand.lowerGain[2], hw.proqBand.upperGain[2]))
   --reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.gain, limitBand(gain.b3, hw.proqBand.lowerGain[3], hw.proqBand.upperGain[3]))
   --reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.gain, limitBand(gain.b4, hw.proqBand.lowerGain[4], hw.proqBand.upperGain[4]))
   --reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.gain, limitBand(gain.b5, hw.proqBand.lowerGain[5], hw.proqBand.upperGain[5]))

	--Q.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.q, limitBand(q.b1, hw.proqBand.lowerQ[1], hw.proqBand.upperQ[1]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.q, limitBand(q.b2, hw.proqBand.lowerQ[2], hw.proqBand.upperQ[2]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.q, limitBand(q.b3, hw.proqBand.lowerQ[3], hw.proqBand.upperQ[3]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.q, limitBand(q.b4, hw.proqBand.lowerQ[4], hw.proqBand.upperQ[4]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.q, limitBand(q.b5, hw.proqBand.lowerQ[5], hw.proqBand.upperQ[5]))
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.q, limitBand(q.b6, hw.proqBand.lowerQ[6], hw.proqBand.upperQ[6]))
	
	--Shape.
   local function reshapeLF(shape)
      if shape == isShape.bell then return isShape.bell
      elseif shape == isShape.lowShelf then return isShape.lowShelf
      elseif shape > isShape.lowShelf then return isShape.bell end
   end

   local function reshapeHF(shape)
      if shape == isShape.bell then return isShape.bell
      elseif shape == isShape.highShelf then return isShape.highShelf
      elseif shape == isShape.lowShelf then return isShape.highShelf
      elseif shape > isShape.lowShelf and shape < isShape.highShelf then return isShape.highShelf
      elseif shape > isShape.highShelf then return isShape.bell end
   end

   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.shape, hw.hwBand.shape[1])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.shape, reshapeLF(shape.b2))--hw.hwBand.shape[2])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.shape, hw.hwBand.shape[3])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.shape, hw.hwBand.shape[4])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.shape, reshapeHF(shape.b5))--hw.hwBand.shape[5])
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.shape, hw.hwBand.shape[6])
	
	--Force bands used.
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band1.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band2.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band3.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band4.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band5.used, 1)
   reaper.TrackFX_SetParamNormalized(track, controller_pos, eq.band6.used, 1)
	
   --Limit used bands.
   for i = hw.num_bands, hw.unused_bands do
      reaper.TrackFX_SetParamNormalized(track, controller_pos, proq.param.used + (i*proq.param.gap), 0)
   end	

   --Enable solo modulation.
   if toggleSolo(solo.b1) then
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band1.solo, 1.0)
   else
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band1.solo, 0)
   end
   if toggleSolo(solo.b2) then
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band2.solo, 1.0)
   else
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band2.solo, 0)
   end
   if toggleSolo(solo.b3) then
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band3.solo, 1.0)
   else
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band3.solo, 0)
   end
   if toggleSolo(solo.b4) then
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band4.solo, 1.0)
   else
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band4.solo, 0)
   end
   if toggleSolo(solo.b5) then
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band5.solo, 1.0)
   else
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band5.solo, 0)
   end
   if toggleSolo(solo.b6) then
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band6.solo, 1.0)
   else
      reaper.TrackFX_SetParamNormalized(track, controller_pos+2, eq.band6.solo, 0)
   end
end

CCB.num_bands = 6
CCB.unused_bands = 18
CCB.hwNum = 1
CCB.flag = "Chandler Curve Bender"

--These definitions should ultimately be set by information contained in surge.lua, s432.lua, massive.lua etc if I intend to make it customizable with GUI.
--Magic numbering it for now.


--Position relative to the controller; not sure this will ever not be incremental, but here for completion's sake.
local posArray = {1, 2, 3, 4, 5, 6, 7, 8}

--These should be calculated upstream in the future in the GUI generation template.
local lowerArrayGain = {getGainNormVal(0), getGainNormVal(setGainLimit(2, true)), getGainNormVal(setGainLimit(3, true)), getGainNormVal(setGainLimit(4, true)), getGainNormVal(setGainLimit(5, true)), getGainNormVal(0)}
local upperArrayGain = {getGainNormVal(0), getGainNormVal(setGainLimit(2, false)), getGainNormVal(setGainLimit(3, false)), getGainNormVal(setGainLimit(4, false)), getGainNormVal(setGainLimit(5, false)), getGainNormVal(0)}

--These should be calculated upstream in the future in the GUI generation template.
local lowerArrayQ = {.5, getQNormVal(1.0), getQNormVal(1.0), getQNormVal(1.0), getQNormVal(1.0), .5}
local upperArrayQ = {.5, getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5), getQNormVal(1.5), .5}

--These should be calculated upstream in the future in the GUI generation template.
local lowerArrayFreq = {getFreqNormVal(20), getFreqNormVal(35), getFreqNormVal(300), getFreqNormVal(800), getFreqNormVal(3600), getFreqNormVal(2000)}
local upperArrayFreq = {getFreqNormVal(320), getFreqNormVal(300), getFreqNormVal(3600), getFreqNormVal(8100), getFreqNormVal(20000), getFreqNormVal(30000)}

CCB.hwBand = {shape = {}, pos = {}}
CCB.proqBand = {lowerGain = {}, upperGain = {}, lowerQ = {}, upperQ = {}, lowerFreq = {}, upperFreq = {}}
CCB.mirror = false


for i = 0, CCB.num_bands do
	CCB.hwBand.shape[i] = shapeArray[i]
	CCB.hwBand.pos[i] = posArray[i]
	CCB.proqBand.lowerGain[i] = lowerArrayGain[i]
	CCB.proqBand.upperGain[i] = upperArrayGain[i]
	CCB.proqBand.lowerQ[i] = lowerArrayQ[i]
	CCB.proqBand.upperQ[i] = upperArrayQ[i]
	CCB.proqBand.lowerFreq[i] = lowerArrayFreq[i]
	CCB.proqBand.upperFreq[i] = upperArrayFreq[i]
end

return CCB