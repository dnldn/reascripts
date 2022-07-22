local coffee = {}


coffee.param = {lfGain = 0, lmfGain = 1, hmfGain = 2, hfGain = 3, HPF = 6, LPF = 7, lfQ = 11, lfFreq = 12, lmfQ = 13, lmfFreq = 14, hmfQ = 15, hmfFreq = 16, hfQ = 17, hfFreq = 18}


--x represents normalized parameter value
--y represents readout value from library; used for input into pro-q equation.

--LOCAL FUNCTIONS:
local function limit(val, min, max)
	if val < min then return min
	elseif val > max then return max
	else return val end
end


local function scaleRange(value, oldMax, oldMin, newMax, newMin)
	return ((value-oldMin)/(oldMax-oldMin))*(newMax-newMin) + newMin
end

function coffee:getGainVal(x)--Returns gain value to pass into pro-q.
	x = limit(x, 0, 1)
	return scaleRange(x, 0, 1, -10, 10)
end

function coffee:getGainValMult(x)--Returns gain value to pass into pro-q.
	x = limit(x, 0, 1)
	return scaleRange(x, 0, 1, -15, 15)
end

function coffee:getGainNormVal(y)--Returns normalized value of gain for Chandler Curve Bender.
	y = limit(y, -10, 10)
	return scaleRange(y, -10, 10, 0, 1)
end

function coffee:getGainNormValMult(y)--Returns normalized value of gain for Chandler Curve Bender.
	y = limit(y, -15, 15)
	return scaleRange(y, -15, 15, 0, 1)
end

function coffee:getQVal(x)--Returns Q value of Chandler Curve Bender to pass into pro-q.
	x = limit(x, 0, 1)
	if x <= 0.53024542331696 then return 1
	elseif x > 0.53024542331696 then return 1.5 end
end


function coffee:getHPFVal(x)
	x = limit(x, 0, 1)
	return math.exp(2.9927+2.6401*x)
end

function coffee:getHPFNormVal(y)
	y = limit(y, 20, 320)
	return -1.1167+0.3749*math.log(y)
end

function coffee:getLPFVal(x)
	x = limit(x, 0, 1)
	return math.exp(7.8855+2.5007*x)
end

function coffee:getLPFNormVal(y)
	y = limit(y, 2000, 30000)
	return -2.9951+0.3824*math.log(y)
end

function coffee:getFreqLFVal(x)
	x = limit(x, 0.14285714924335, 1)
	if x >= 0.14285714924335 and x < 0.28571429848671 then 
		return 35 
	elseif x >= 0.28571429848671 and x < 0.4285714328289 then 
		return 50 
	elseif x >= 0.4285714328289 and x < 0.57142859697342 then 
		return 70 
	elseif x >= 0.57142859697342 and x < 0.71428573131561 then 
		return 91 
	elseif x >= 0.71428573131561 and x < 0.85714286565781 then 
		return 150 
	elseif x >= 0.85714286565781 and x < 1.0 then 
		return 200 
	elseif x == 1.0 then 
		return 300 
	end
end

function coffee:getFreqLFNormVal(y)
	limit(y, 35, 300)
	if y >= 0 and y < 50 then
		return 0.14285714924335
	elseif y >= 50 and y < 70 then
		return 0.28571429848671
	elseif y >= 70 and y < 91 then
		return 0.4285714328289
	elseif y >= 91 and y < 150 then
		return 0.57142859697342
	elseif y >= 150 and y < 200 then
		return 0.71428573131561
	elseif y >= 200 and y < 300 then
		return 0.85714286565781
	elseif y >= 300 then 
		return 1.0
	end
end

function coffee:getFreqLMFVal(x)
	limit(x, 0.125, 1)
	if x >= 0.125 and x < 0.25 then
		return 300
	elseif x >= 0.25 and x < 0.375 then
		return 400
	elseif x >= 0.375 and x < 0.5 then
		return 500
	elseif x >= 0.5 and x < 0.625 then
		return 800
	elseif x >= 0.625 and x < 0.75 then
		return 1200
	elseif x >= 0.75 and x < 0.875 then
		return 1800
	elseif x >= 0.875 and x < 1.0 then
		return 2800
	elseif x == 1.0 then
		return 3600
	end
end

function coffee:getFreqLMFNormVal(y)
	limit(y, 300, 3600)
	if y >= 0 and y < 400 then
		return 0.125
	elseif y >= 400 and y < 500 then
		return 0.25
	elseif y >= 500 and y < 800 then
		return 0.375
	elseif y >= 800 and y < 1200 then
		return 0.5
	elseif y >= 1200 and y < 1800 then
		return 0.625
	elseif y >= 1800 and y < 2800 then
		return 0.75
	elseif y >= 2800 and y < 3600 then
		return 0.875
	elseif y >= 3600 then
		return 1.0
	end
end

function coffee:getFreqHMFVal(x)
	limit(x, 0.125, 1)
	if x >= 0.125 and x < 0.25 then
		return 800
	elseif x >= 0.25 and x < 0.375 then
		return 1200
	elseif x >= 0.375 and x < 0.5 then
		return 1800
	elseif x >= 0.5 and x < 0.625 then
		return 2800
	elseif x >= 0.625 and x < 0.75 then
		return 3600
	elseif x >= 0.75 and x < 0.875 then
		return 4200
	elseif x >= 0.875 and x < 1.0 then
		return 6500
	elseif x == 1.0 then
		return 8100
	end
end

function coffee:getFreqHMFNormVal(y)
	limit(y, 800, 8100)
	if y >= 0 and y < 1200 then
		return 0.125
	elseif y >= 1200 and y < 1800 then
		return 0.25
	elseif y >= 1800 and y < 2800 then
		return 0.375
	elseif y >= 2800 and y < 3600 then
		return 0.5
	elseif y >= 3600 and y < 4200 then
		return 0.625
	elseif y >= 4200 and y < 6500 then
		return 0.75
	elseif y >= 6500 and y < 8100 then
		return 0.875
	elseif y >= 8100 then
		return 1.0
	end
end

function coffee:getFreqHFVal(x)
	limit(x, 0.125, 1)
	if x >= 0.125 and x < 0.25 then
		return 3600
	elseif x >= 0.25 and x < 0.375 then
		return 4200
	elseif x >= 0.375 and x < 0.5 then
		return 6500
	elseif x >= 0.5 and x < 0.625 then
		return 8100
	elseif x >= 0.625 and x < 0.75 then
		return 10000
	elseif x >= 0.75 and x < 0.875 then
		return 12000
	elseif x >= 0.875 and x < 1.0 then
		return 16000
	elseif x == 1.0 then
		return 20000
	end
end

function coffee:getFreqHFNormVal(y)
	limit(y, 3600, 20000)
	if y >= 0 and y < 4200 then
		return 0.125
	elseif y >= 4200 and y < 6500 then
		return 0.25
	elseif y >= 6500 and y < 8100 then
		return 0.375
	elseif y >= 8100 and y < 10000 then
		return 0.5
	elseif y >= 10000 and y < 12000 then
		return 0.625
	elseif y >= 12000 and y < 16000 then
		return 0.75
	elseif y >= 16000 and y < 20000 then
		return 0.875
	elseif y >= 20000 then
		return 1.0
	end
end

return coffee