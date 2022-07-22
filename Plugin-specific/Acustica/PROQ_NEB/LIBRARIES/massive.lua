local massive = {}

massive.param = {freq = 0, Q = 1, gain=2, wet=11}

--x represents normalized parameter value
--y represents readout value from library; used for input into pro-q equation.

--QUIRKS:
--Gain on unit is scaled to +4; cut is scaled to -6. Actual cut/boost can far exceed what that does in pro-q due to nature of bells.
--Will need to test for the 8k(?) boost that was on the original unit when stacking many instances. I can probably compensate for that on the control, or have a compensation channel.
--Look this up, but I think this one also works on the principle that the last plugin should be dirty, the rest should be run clean.

--LOCAL FUNCTIONS:
local function limit(val, min, max)
	if val < min then return min
	elseif val > max then return max
	else return val end
end

function massive:getBoostVal(x)--Returns boost value to pass into pro-q.
	x = limit(x, 0, 1)
	return x*4
end

function massive:getBoostNormVal(y)--Returns normalized value of Manley Massive Passive boost.
	y = limit(y, 0, 4)
	return y/4
end

function massive:getCutVal(x)--Returns cut value to pass into pro-q.
	x = limit(x, 0, 1)
	return x * -6
end

function massive:getCutNormVal(y)--Returns normalized value of Manley Massive Passive cut.
	y = limit(y, 0, 6)
	return y/6
end

function massive:getQVal(x)--Returns Q value to pass into pro-q.
	x = limit(x, 0, 1)
	return x+.5
end

function massive:getQNormVal(y)--Returns normalized value of Manley Massive Passive boost/cut.
	y = limit(y, .5, 1.5)
	return y-.5
end

function massive:getFreqLFVal(x)--Returns frequency value of Manley Massive Passive low band to pass into pro-q.	
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.072925738990307 then
		return 22.0
	elseif x >= 0.072925738990307 and x < 0.21460436284542 then
		return 33.0
	elseif x >= 0.21460436284542 and x < 0.35727652907372 then
		return 47.0
	elseif x >= 0.35727652907372 and x < 0.50173705816269 then
		return 68.0
	elseif x >= 0.50173705816269 and x < 0.64341568946838 then
		return 82.0
	elseif x >= 0.64341568946838 and x < 0.78708136081696 then
		return 100.0
	elseif x >= 0.78708136081696 and x < 0.92995220422745 then
		return 120.0
	elseif x > 0.92995220422745 then
		return 150.0
	end
end

function massive:getFreqLFNormVal(y)--Returns normalized frequency value of Manley Massive Passive low band.
	y = limit(y, 22, 150)
	if y >= 22.0 and y < 33.0 then
		return 0.0
	elseif y >= 33.0 and y < 47.0 then
		return  0.072925738990307
	elseif y >= 47.0 and y < 68.0 then
		return  0.21460436284542
	elseif y >= 68.0 and y < 82.0 then
		return  0.35727652907372
	elseif y >= 82.0 and y < 100.0 then
		return  0.50173705816269
	elseif y >= 100.0 and y < 120.0 then
		return  0.64341568946838
	elseif y >= 120.0 and y < 150.0 then
		return  0.78708136081696
	elseif y >= 150.0 then
		return 1.0
	end
end

function massive:getFreqLMFVal(x)--Returns frequency value of S432 Manley Massive Passive mid to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.063983894884586 then
		return 180.0
	elseif x >= 0.063983894884586 and x < 0.18797752261162 then
		return 220.0
	elseif x >= 0.18797752261162 and x < 0.31336212158203 then
		return 270.0
	elseif x >= 0.31336212158203 and x < 0.437554448843 then
		return 330.0
	elseif x >= 0.437554448843 and x < 0.56254160404205 then
		return 390.0
	elseif x >= 0.56254160404205 and x < 0.68852233886719 then
		return 470.0
	elseif x >= 0.68852233886719 and x < 0.8125159740448 then
		return 560.0
	elseif x >= 0.8125159740448 and x < 0.93770182132721 then
		return 680.0
	elseif x >= 0.93770182132721 then
		return 820.0
	end
end

function massive:getFreqLMFNormVal(y)--Returns normalized frequency value of S432 Manley Massive Passive mid band.
	y = limit(y, 180, 820)
	if y >= 180.0 and y < 220.0 then
		return 0.0
	elseif y >= 220.0 and y < 270.0 then
		return 0.063983894884586
	elseif y >= 270.0 and y < 330.0 then
		return 0.18797752261162
	elseif y >= 330.0 and y < 390.0 then
		return 0.31336212158203
	elseif y >= 390.0 and y < 470.0 then
		return 0.437554448843
	elseif y >= 470.0 and y < 560.0 then
		return 0.56254160404205
	elseif y >= 560.0 and y < 680.0 then
		return 0.68852233886719
	elseif y >= 680.0 and y < 820.0 then
		return 0.8125159740448
	elseif y >= 820.0 then
		return 1.0
	end
end

function massive:getFreqHMFVal(x)--Returns frequency value of S432 Manley Massive Passive mid to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.071932204067707 then
		return 1000.0
	elseif x >= 0.071932204067707 and x < 0.21500177681446 then
		return 1200.0
	elseif x >= 0.21500177681446 and x < 0.35767394304276 then
		return 1500.0
	elseif x >= 0.35767394304276 and x < 0.50014740228653 then
		return 1800.0
	elseif x >= 0.50014740228653 and x < 0.64341568946838 then
		return 2200.0
	elseif x >= 0.64341568946838 and x < 0.78668397665024 then
		return 2700.0
	elseif x >= 0.78668397665024 and x < 0.92935609817505 then
		return 3300.0
	elseif x >= 0.92935609817505 then
		return 3900.0
	end
end

function massive:getFreqHMFNormVal(y)--Returns normalized frequency value of S432 Manley Massive Passive mid band.
	y = limit(y, 1000, 3900)
	if y >= 1000.0 and y < 1200.0 then
		return 0.0
	elseif y >= 1200.0 and y < 1500.0 then
		return 0.071932204067707
	elseif y >= 1500.0 and y < 1800.0 then
		return 0.21500177681446
	elseif y >= 1800.0 and y < 2200.0 then
		return 0.35767394304276
	elseif y >= 2200.0 and y < 2700.0 then
		return 0.50014740228653
	elseif y >= 2700.0 and y < 3300.0 then
		return 0.64341568946838
	elseif y >= 3300.0 and y < 3900.0 then
		return 0.78668397665024
	elseif y >= 3900.0 then
		return 1.0
	end
end

function massive:getFreqHFVal(x)--Returns frequency value of Manley Massive Passive high band to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.071534790098667 then
		return 4700
	elseif x >= 0.071534790098667 and x < 0.21480306982994 then
		return 5600
	elseif x >= 0.21480306982994 and x < 0.35727652907372 then
		return 6800
	elseif x >= 0.35727652907372 and x < 0.50074350833893 then
		return 8200
	elseif x >= 0.50074350833893 and x < 0.6438130736351 then
		return 10000
	elseif x >= 0.6438130736351 and x < 0.78608781099319 then
		return 12000
	elseif x >= 0.78608781099319 and x < 0.92895871400833 then
		return 16000
	elseif x >= 0.92895871400833 then
		return 27000
	end
end

function massive:getFreqHFNormVal(y)--Returns normalized frequency value of Manley Massive Passive high band.
	y = limit(y, 4700, 27000)
	if y >= 4700 and y < 5600 then
		return 0.0
	elseif y >= 5600 and y < 6800 then
		return 0.071534790098667
	elseif y >= 6800 and y < 8200 then
		return 0.21480306982994
	elseif y >= 8200 and y < 10000 then
		return 0.35727652907372
	elseif y >= 10000 and y < 12000 then
		return 0.50074350833893
	elseif y >= 12000 and y < 16000 then
		return 0.6438130736351
	elseif y >= 16000 and y < 22000 then
		return 0.78608781099319
	elseif y >= 22000 then --fudged because 27k is hard to reach in pro-q
		return 1.0
	end
end

return massive