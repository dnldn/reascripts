local proq = {}


proq.param = {
used = 0,
enabled = 1,
freq = 2,
gain = 3,
Q = 7,
shape = 8,
solo = 12,
gap = 13
}

--x represents normalized parameter value
--y represents readout value from library; used for input into pro-q equation.

--LOCAL FUNCTIONS:
local function limit(val, min, max)
	if val < min then return min
	elseif val > max then return max
	else return val end
end

function proq:getFreqNormVal(freq)
	freq = limit(freq, 10, 30000)
    return -0.287594 + 0.124901 * math.log(freq)
end

function proq:getFreqVal(norm)
	norm = limit(norm, 0, 1)
    return 9.99991 * math.exp(8.00634*norm)
end

function proq:getQNormVal(q)
	q = limit(q, 0.025, 40)
    return 0.4999+0.1356*math.log(q)
end

function proq:getQVal(norm)
	norm = limit(norm, 0, 1)
    return math.exp(-3.6870+7.3753*norm)
end

function proq:getGainNormVal(gain)
	gain = limit(gain, -30, 30)
    return 0.01667*gain+.5
end

function proq:getGainVal(norm)
	norm = limit(norm, 0, 1)
    return 60*norm-30
end

return proq