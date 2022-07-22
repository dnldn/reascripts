local s432 = {}


s432.param = {gain=1, Q = 2, freq = 0, hiShelf = 2}

--x represents normalized parameter value
--y represents readout value from library; used for input into pro-q equation.

--QUIRKS:
--Gain value on high/low shelf band is tied to the fx parameter for Q on the other bands.
--Make sure to put 5k hi/low shelf at end for hardware color, and use 1k for the rest!

--LOCAL FUNCTIONS:
local function limit(val, min, max)
	if val < min then return min
	elseif val > max then return max
	else return val end
end

local function scaleQValue(v)
	return ((v-5)/(15-5))*(2.5-.5)+.5
end


function s432:getQVal(x)--Returns scaled Q value of S432 to pass into pro-q.
	x = limit(x, 0, 1)
	if x <= 0.5 then
		return scaleQValue((8.000*x)+5.00)
	else
		return scaleQValue((12*x)+3)
	end
end

function s432:getQNormVal(y)--Returns normalized value of Q for S432.
	y = limit(y, 5, 15)
	if y <= 9 then
		return (y*.125)-.625
	else
		return (y*.0833)-.25+.0005
	end
end

function s432:getGainVal(x)--Returns gain value to pass into pro-q.
	x = limit(x, 0, 1)
	return (12*x)-6
end

function s432:getGainNormVal(y)--Returns normalized value of gain for S432.
	y = limit(y, -6, 6)
	return (y+6)/12
end

function s432:getFreqLFShelfVal(x)--Returns low shelf value to pass into pro-q.
	x = limit(x, 0, 1)
	if x <=.5 then
		return 50
	else
		return 100
	end
end

function s432:getFreqLFShelfNormVal(y)--Returns normalized value of low shelf switch for S432.
	y = limit(y, 50, 100)
	if y <= 50 then
		return 0
	elseif y > 50 then
		return 1
	end
end

function s432:getFreqLFVal(x)--Returns frequency value of S432 low band to pass into pro-q.	
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.0063586477190256 then
		return 11.0
	elseif x >= 0.0063586477190256 and x < 0.018877236172557 then
		return 12.0
	elseif x >= 0.018877236172557 and x < 0.031395822763443 then
		return 13.0
	elseif x >= 0.031395822763443 and x < 0.043914411216974 then
		return 14.0
	elseif x >= 0.043914411216974 and x < 0.054247211664915 then
		return 15.0
	elseif x >= 0.054247211664915 and x < 0.062592938542366 then
		return 16.0
	elseif x >= 0.062592938542366 and x < 0.070938661694527 then
		return 17.0
	elseif x >= 0.070938661694527 and x < 0.079284392297268 then
		return 18.0
	elseif x >= 0.079284392297268 and x < 0.087630115449429 then
		return 19.0
	elseif x >= 0.087630115449429 and x < 0.095975838601589 then
		return 20.0
	elseif x >= 0.095975838601589 and x < 0.10571251809597 then
		return 21.0
	elseif x >= 0.10571251809597 and x < 0.11684015393257 then
		return 22.0
	elseif x >= 0.11684015393257 and x < 0.12796778976917 then
		return 23.0
	elseif x >= 0.12796778976917 and x < 0.13889671862125 then
		return 24.0
	elseif x >= 0.13889671862125 and x < 0.15002433955669 then
		return 25.0
	elseif x >= 0.15002433955669 and x < 0.1611519753933 then
		return 26.0
	elseif x >= 0.1611519753933 and x < 0.1722796112299 then
		return 27.0
	elseif x >= 0.1722796112299 and x < 0.1834072470665 then
		return 28.0
	elseif x >= 0.1834072470665 and x < 0.1945348829031 then
		return 29.0
	elseif x >= 0.1945348829031 and x < 0.2042715549469 then
		return 30.0
	elseif x >= 0.2042715549469 and x < 0.21261727809906 then
		return 31.0
	elseif x >= 0.21261727809906 and x < 0.22096301615238 then
		return 32.0
	elseif x >= 0.22096301615238 and x < 0.22930873930454 then
		return 33.0
	elseif x >= 0.22930873930454 and x < 0.2376544624567 then
		return 34.0
	elseif x >= 0.2376544624567 and x < 0.24600018560886 then
		return 35.0
	elseif x >= 0.24600018560886 and x < 0.25434592366219 then
		return 36.0
	elseif x >= 0.25434592366219 and x < 0.26269164681435 then
		return 37.0
	elseif x >= 0.26269164681435 and x < 0.27083864808083 then
		return 38.0
	elseif x >= 0.27083864808083 and x < 0.27918437123299 then
		return 39.0
	elseif x >= 0.27918437123299 and x < 0.28753009438515 then
		return 40.0
	elseif x >= 0.28753009438515 and x < 0.29587581753731 then
		return 41.0
	elseif x >= 0.29587581753731 and x < 0.30640733242035 then
		return 42.0
	elseif x >= 0.30640733242035 and x < 0.31892591714859 then
		return 43.0
	elseif x >= 0.31892591714859 and x < 0.33144450187683 then
		return 44.0
	elseif x >= 0.33144450187683 and x < 0.34376439452171 then
		return 45.0
	elseif x >= 0.34376439452171 and x < 0.35628297924995 then
		return 46.0
	elseif x >= 0.35628297924995 and x < 0.3688015639782 then
		return 47.0
	elseif x >= 0.3688015639782 and x < 0.38132014870644 then
		return 48.0
	elseif x >= 0.38132014870644 and x < 0.39383873343468 then
		return 49.0
	elseif x >= 0.39383873343468 and x < 0.4051650762558 then
		return 50.0
	elseif x >= 0.4051650762558 and x < 0.41510048508644 then
		return 51.0
	elseif x >= 0.41510048508644 and x < 0.42503586411476 then
		return 52.0
	elseif x >= 0.42503586411476 and x < 0.43516996502876 then
		return 53.0
	elseif x >= 0.43516996502876 and x < 0.44510534405708 then
		return 54.0
	elseif x >= 0.44510534405708 and x < 0.4550407230854 then
		return 55.0
	elseif x >= 0.4550407230854 and x < 0.4651748239994 then
		return 56.0
	elseif x >= 0.4651748239994 and x < 0.47511020302773 then
		return 57.0
	elseif x >= 0.47511020302773 and x < 0.48504561185837 then
		return 58.0
	elseif x >= 0.48504561185837 and x < 0.49517968297005 then
		return 59.0
	elseif x >= 0.49517968297005 and x < 0.50471764802933 then
		return 60.0
	elseif x >= 0.50471764802933 and x < 0.51365953683853 then
		return 61.0
	elseif x >= 0.51365953683853 and x < 0.52280008792877 then
		return 62.0
	elseif x >= 0.52280008792877 and x < 0.53194063901901 then
		return 63.0
	elseif x >= 0.53194063901901 and x < 0.54108119010925 then
		return 64.0
	elseif x >= 0.54108119010925 and x < 0.55002301931381 then
		return 65.0
	elseif x >= 0.55002301931381 and x < 0.55916357040405 then
		return 66.0
	elseif x >= 0.55916357040405 and x < 0.56830412149429 then
		return 67.0
	elseif x >= 0.56830412149429 and x < 0.57744467258453 then
		return 68.0
	elseif x >= 0.57744467258453 and x < 0.58638656139374 then
		return 69.0
	elseif x >= 0.58638656139374 and x < 0.59552711248398 then
		return 70.0
	elseif x >= 0.59552711248398 and x < 0.60367411375046 then
		return 71.0
	elseif x >= 0.60367411375046 and x < 0.61082762479782 then
		return 72.0
	elseif x >= 0.61082762479782 and x < 0.61798107624054 then
		return 73.0
	elseif x >= 0.61798107624054 and x < 0.62513452768326 then
		return 74.0
	elseif x >= 0.62513452768326 and x < 0.63228803873062 then
		return 75.0
	elseif x >= 0.63228803873062 and x < 0.63944149017334 then
		return 76.0
	elseif x >= 0.63944149017334 and x < 0.6465950012207 then
		return 77.0
	elseif x >= 0.6465950012207 and x < 0.65374845266342 then
		return 78.0
	elseif x >= 0.65374845266342 and x < 0.66090196371078 then
		return 79.0
	elseif x >= 0.66090196371078 and x < 0.6680554151535 then
		return 80.0
	elseif x >= 0.6680554151535 and x < 0.67501020431519 then
		return 81.0
	elseif x >= 0.67501020431519 and x < 0.6821636557579 then
		return 82.0
	elseif x >= 0.6821636557579 and x < 0.68931716680527 then
		return 83.0
	elseif x >= 0.68931716680527 and x < 0.69647061824799 then
		return 84.0
	elseif x >= 0.69647061824799 and x < 0.70342540740967 then
		return 85.0
	elseif x >= 0.70342540740967 and x < 0.71018147468567 then
		return 86.0
	elseif x >= 0.71018147468567 and x < 0.71673882007599 then
		return 87.0
	elseif x >= 0.71673882007599 and x < 0.72349488735199 then
		return 88.0
	elseif x >= 0.72349488735199 and x < 0.73005223274231 then
		return 89.0
	elseif x >= 0.73005223274231 and x < 0.73680830001831 then
		return 90.0
	elseif x >= 0.73680830001831 and x < 0.74336564540863 then
		return 91.0
	elseif x >= 0.74336564540863 and x < 0.75012171268463 then
		return 92.0
	elseif x >= 0.75012171268463 and x < 0.75667905807495 then
		return 93.0
	elseif x >= 0.75667905807495 and x < 0.76343512535095 then
		return 94.0
	elseif x >= 0.76343512535095 and x < 0.77019119262695 then
		return 95.0
	elseif x >= 0.77019119262695 and x < 0.77674853801727 then
		return 96.0
	elseif x >= 0.77674853801727 and x < 0.78350460529327 then
		return 97.0
	elseif x >= 0.78350460529327 and x < 0.79006201028824 then
		return 98.0
	elseif x >= 0.79006201028824 and x < 0.79681801795959 then
		return 99.0
	elseif x >= 0.79681801795959 and x < 0.80258059501648 then
		return 100.0
	elseif x >= 0.80258059501648 and x < 0.80754828453064 then
		return 101.0
	elseif x >= 0.80754828453064 and x < 0.8125159740448 then
		return 102.0
	elseif x >= 0.8125159740448 and x < 0.81768238544464 then
		return 103.0
	elseif x >= 0.81768238544464 and x < 0.8226500749588 then
		return 104.0
	elseif x >= 0.8226500749588 and x < 0.82761776447296 then
		return 105.0
	elseif x >= 0.82761776447296 and x < 0.83258545398712 then
		return 106.0
	elseif x >= 0.83258545398712 and x < 0.83755314350128 then
		return 107.0
	elseif x >= 0.83755314350128 and x < 0.84252083301544 then
		return 108.0
	elseif x >= 0.84252083301544 and x < 0.84768724441528 then
		return 109.0
	elseif x >= 0.84768724441528 and x < 0.85265493392944 then
		return 110.0
	elseif x >= 0.85265493392944 and x < 0.8576226234436 then
		return 111.0
	elseif x >= 0.8576226234436 and x < 0.86259031295776 then
		return 112.0
	elseif x >= 0.86259031295776 and x < 0.86755800247192 then
		return 113.0
	elseif x >= 0.86755800247192 and x < 0.87252569198608 then
		return 114.0
	elseif x >= 0.87252569198608 and x < 0.87769210338593 then
		return 115.0
	elseif x >= 0.87769210338593 and x < 0.88265979290009 then
		return 116.0
	elseif x >= 0.88265979290009 and x < 0.88762748241425 then
		return 117.0
	elseif x >= 0.88762748241425 and x < 0.89259517192841 then
		return 118.0
	elseif x >= 0.89259517192841 and x < 0.89756286144257 then
		return 119.0
	elseif x >= 0.89756286144257 and x < 0.90173572301865 then
		return 120.0
	elseif x >= 0.90173572301865 and x < 0.90511375665665 then
		return 121.0
	elseif x >= 0.90511375665665 and x < 0.90849179029465 then
		return 122.0
	elseif x >= 0.90849179029465 and x < 0.91167110204697 then
		return 123.0
	elseif x >= 0.91167110204697 and x < 0.91504913568497 then
		return 124.0
	elseif x >= 0.91504913568497 and x < 0.91842716932297 then
		return 125.0
	elseif x >= 0.91842716932297 and x < 0.92180520296097 then
		return 126.0
	elseif x >= 0.92180520296097 and x < 0.92518323659897 then
		return 127.0
	elseif x >= 0.92518323659897 and x < 0.92836254835129 then
		return 128.0
	elseif x >= 0.92836254835129 and x < 0.93174058198929 then
		return 129.0
	elseif x >= 0.93174058198929 and x < 0.93511861562729 then
		return 130.0
	elseif x >= 0.93511861562729 and x < 0.93849664926529 then
		return 131.0
	elseif x >= 0.93849664926529 and x < 0.94167596101761 then
		return 132.0
	elseif x >= 0.94167596101761 and x < 0.94505399465561 then
		return 133.0
	elseif x >= 0.94505399465561 and x < 0.94843202829361 then
		return 134.0
	elseif x >= 0.94843202829361 and x < 0.95181006193161 then
		return 135.0
	elseif x >= 0.95181006193161 and x < 0.95518809556961 then
		return 136.0
	elseif x >= 0.95518809556961 and x < 0.95836746692657 then
		return 137.0
	elseif x >= 0.95836746692657 and x < 0.96174544095993 then
		return 138.0
	elseif x >= 0.96174544095993 and x < 0.96512347459793 then
		return 139.0
	elseif x >= 0.96512347459793 and x < 0.96850150823593 then
		return 140.0
	elseif x >= 0.96850150823593 and x < 0.9716808795929 then
		return 141.0
	elseif x >= 0.9716808795929 and x < 0.9750589132309 then
		return 142.0
	elseif x >= 0.9750589132309 and x < 0.9784369468689 then
		return 143.0
	elseif x >= 0.9784369468689 and x < 0.9818149805069 then
		return 144.0
	elseif x >= 0.9818149805069 and x < 0.98519295454025 then
		return 145.0
	elseif x >= 0.98519295454025 and x < 0.98837232589722 then
		return 146.0
	elseif x >= 0.98837232589722 and x < 0.99175035953522 then
		return 147.0
	elseif x >= 0.99175035953522 and x < 1.0 then
		return 148.0
	elseif x == 1.0 then
		return 150.0
	end
end

function s432:getFreqLFNormVal(y)--Returns normalized frequency value of S432 low band.
	y = limit(y, 11, 150)
	if y >= 11.0 and y < 12.0 then
		return 0.0
	elseif y >= 12.0 and y < 13.0 then
		return 0.0063586477190256
	elseif y >= 13.0 and y < 14.0 then
		return 0.018877236172557
	elseif y >= 14.0 and y < 15.0 then
		return 0.031395822763443
	elseif y >= 15.0 and y < 16.0 then
		return 0.043914411216974
	elseif y >= 16.0 and y < 17.0 then
		return 0.054247211664915
	elseif y >= 17.0 and y < 18.0 then
		return 0.062592938542366
	elseif y >= 18.0 and y < 19.0 then
		return 0.070938661694527
	elseif y >= 19.0 and y < 20.0 then
		return 0.079284392297268
	elseif y >= 20.0 and y < 21.0 then
		return 0.087630115449429
	elseif y >= 21.0 and y < 22.0 then
		return 0.095975838601589
	elseif y >= 22.0 and y < 23.0 then
		return 0.10571251809597
	elseif y >= 23.0 and y < 24.0 then
		return 0.11684015393257
	elseif y >= 24.0 and y < 25.0 then
		return 0.12796778976917
	elseif y >= 25.0 and y < 26.0 then
		return 0.13889671862125
	elseif y >= 26.0 and y < 27.0 then
		return 0.15002433955669
	elseif y >= 27.0 and y < 28.0 then
		return 0.1611519753933
	elseif y >= 28.0 and y < 29.0 then
		return 0.1722796112299
	elseif y >= 29.0 and y < 30.0 then
		return 0.1834072470665
	elseif y >= 30.0 and y < 31.0 then
		return 0.1945348829031
	elseif y >= 31.0 and y < 32.0 then
		return 0.2042715549469
	elseif y >= 32.0 and y < 33.0 then
		return 0.21261727809906
	elseif y >= 33.0 and y < 34.0 then
		return 0.22096301615238
	elseif y >= 34.0 and y < 35.0 then
		return 0.22930873930454
	elseif y >= 35.0 and y < 36.0 then
		return 0.2376544624567
	elseif y >= 36.0 and y < 37.0 then
		return 0.24600018560886
	elseif y >= 37.0 and y < 38.0 then
		return 0.25434592366219
	elseif y >= 38.0 and y < 39.0 then
		return 0.26269164681435
	elseif y >= 39.0 and y < 40.0 then
		return 0.27083864808083
	elseif y >= 40.0 and y < 41.0 then
		return 0.27918437123299
	elseif y >= 41.0 and y < 42.0 then
		return 0.28753009438515
	elseif y >= 42.0 and y < 43.0 then
		return 0.29587581753731
	elseif y >= 43.0 and y < 44.0 then
		return 0.30640733242035
	elseif y >= 44.0 and y < 45.0 then
		return 0.31892591714859
	elseif y >= 45.0 and y < 46.0 then
		return 0.33144450187683
	elseif y >= 46.0 and y < 47.0 then
		return 0.34376439452171
	elseif y >= 47.0 and y < 48.0 then
		return 0.35628297924995
	elseif y >= 48.0 and y < 49.0 then
		return 0.3688015639782
	elseif y >= 49.0 and y < 50.0 then
		return 0.38132014870644
	elseif y >= 50.0 and y < 51.0 then
		return 0.39383873343468
	elseif y >= 51.0 and y < 52.0 then
		return 0.4051650762558
	elseif y >= 52.0 and y < 53.0 then
		return 0.41510048508644
	elseif y >= 53.0 and y < 54.0 then
		return 0.42503586411476
	elseif y >= 54.0 and y < 55.0 then
		return 0.43516996502876
	elseif y >= 55.0 and y < 56.0 then
		return 0.44510534405708
	elseif y >= 56.0 and y < 57.0 then
		return 0.4550407230854
	elseif y >= 57.0 and y < 58.0 then
		return 0.4651748239994
	elseif y >= 58.0 and y < 59.0 then
		return 0.47511020302773
	elseif y >= 59.0 and y < 60.0 then
		return 0.48504561185837
	elseif y >= 60.0 and y < 61.0 then
		return 0.49517968297005
	elseif y >= 61.0 and y < 62.0 then
		return 0.50471764802933
	elseif y >= 62.0 and y < 63.0 then
		return 0.51365953683853
	elseif y >= 63.0 and y < 64.0 then
		return 0.52280008792877
	elseif y >= 64.0 and y < 65.0 then
		return 0.53194063901901
	elseif y >= 65.0 and y < 66.0 then
		return 0.54108119010925
	elseif y >= 66.0 and y < 67.0 then
		return 0.55002301931381
	elseif y >= 67.0 and y < 68.0 then
		return 0.55916357040405
	elseif y >= 68.0 and y < 69.0 then
		return 0.56830412149429
	elseif y >= 69.0 and y < 70.0 then
		return 0.57744467258453
	elseif y >= 70.0 and y < 71.0 then
		return 0.58638656139374
	elseif y >= 71.0 and y < 72.0 then
		return 0.59552711248398
	elseif y >= 72.0 and y < 73.0 then
		return 0.60367411375046
	elseif y >= 73.0 and y < 74.0 then
		return 0.61082762479782
	elseif y >= 74.0 and y < 75.0 then
		return 0.61798107624054
	elseif y >= 75.0 and y < 76.0 then
		return 0.62513452768326
	elseif y >= 76.0 and y < 77.0 then
		return 0.63228803873062
	elseif y >= 77.0 and y < 78.0 then
		return 0.63944149017334
	elseif y >= 78.0 and y < 79.0 then
		return 0.6465950012207
	elseif y >= 79.0 and y < 80.0 then
		return 0.65374845266342
	elseif y >= 80.0 and y < 81.0 then
		return 0.66090196371078
	elseif y >= 81.0 and y < 82.0 then
		return 0.6680554151535
	elseif y >= 82.0 and y < 83.0 then
		return 0.67501020431519
	elseif y >= 83.0 and y < 84.0 then
		return 0.6821636557579
	elseif y >= 84.0 and y < 85.0 then
		return 0.68931716680527
	elseif y >= 85.0 and y < 86.0 then
		return 0.69647061824799
	elseif y >= 86.0 and y < 87.0 then
		return 0.70342540740967
	elseif y >= 87.0 and y < 88.0 then
		return 0.71018147468567
	elseif y >= 88.0 and y < 89.0 then
		return 0.71673882007599
	elseif y >= 89.0 and y < 90.0 then
		return 0.72349488735199
	elseif y >= 90.0 and y < 91.0 then
		return 0.73005223274231
	elseif y >= 91.0 and y < 92.0 then
		return 0.73680830001831
	elseif y >= 92.0 and y < 93.0 then
		return 0.74336564540863
	elseif y >= 93.0 and y < 94.0 then
		return 0.75012171268463
	elseif y >= 94.0 and y < 95.0 then
		return 0.75667905807495
	elseif y >= 95.0 and y < 96.0 then
		return 0.76343512535095
	elseif y >= 96.0 and y < 97.0 then
		return 0.77019119262695
	elseif y >= 97.0 and y < 98.0 then
		return 0.77674853801727
	elseif y >= 98.0 and y < 99.0 then
		return 0.78350460529327
	elseif y >= 99.0 and y < 100.0 then
		return 0.79006201028824
	elseif y >= 100.0 and y < 101.0 then
		return 0.79681801795959
	elseif y >= 101.0 and y < 102.0 then
		return 0.80258059501648
	elseif y >= 102.0 and y < 103.0 then
		return 0.80754828453064
	elseif y >= 103.0 and y < 104.0 then
		return 0.8125159740448
	elseif y >= 104.0 and y < 105.0 then
		return 0.81768238544464
	elseif y >= 105.0 and y < 106.0 then
		return 0.8226500749588
	elseif y >= 106.0 and y < 107.0 then
		return 0.82761776447296
	elseif y >= 107.0 and y < 108.0 then
		return 0.83258545398712
	elseif y >= 108.0 and y < 109.0 then
		return 0.83755314350128
	elseif y >= 109.0 and y < 110.0 then
		return 0.84252083301544
	elseif y >= 110.0 and y < 111.0 then
		return 0.84768724441528
	elseif y >= 111.0 and y < 112.0 then
		return 0.85265493392944
	elseif y >= 112.0 and y < 113.0 then
		return 0.8576226234436
	elseif y >= 113.0 and y < 114.0 then
		return 0.86259031295776
	elseif y >= 114.0 and y < 115.0 then
		return 0.86755800247192
	elseif y >= 115.0 and y < 116.0 then
		return 0.87252569198608
	elseif y >= 116.0 and y < 117.0 then
		return 0.87769210338593
	elseif y >= 117.0 and y < 118.0 then
		return 0.88265979290009
	elseif y >= 118.0 and y < 119.0 then
		return 0.88762748241425
	elseif y >= 119.0 and y < 120.0 then
		return 0.89259517192841
	elseif y >= 120.0 and y < 121.0 then
		return 0.89756286144257
	elseif y >= 121.0 and y < 122.0 then
		return 0.90173572301865
	elseif y >= 122.0 and y < 123.0 then
		return 0.90511375665665
	elseif y >= 123.0 and y < 124.0 then
		return 0.90849179029465
	elseif y >= 124.0 and y < 125.0 then
		return 0.91167110204697
	elseif y >= 125.0 and y < 126.0 then
		return 0.91504913568497
	elseif y >= 126.0 and y < 127.0 then
		return 0.91842716932297
	elseif y >= 127.0 and y < 128.0 then
		return 0.92180520296097
	elseif y >= 128.0 and y < 129.0 then
		return 0.92518323659897
	elseif y >= 129.0 and y < 130.0 then
		return 0.92836254835129
	elseif y >= 130.0 and y < 131.0 then
		return 0.93174058198929
	elseif y >= 131.0 and y < 132.0 then
		return 0.93511861562729
	elseif y >= 132.0 and y < 133.0 then
		return 0.93849664926529
	elseif y >= 133.0 and y < 134.0 then
		return 0.94167596101761
	elseif y >= 134.0 and y < 135.0 then
		return 0.94505399465561
	elseif y >= 135.0 and y < 136.0 then
		return 0.94843202829361
	elseif y >= 136.0 and y < 137.0 then
		return 0.95181006193161
	elseif y >= 137.0 and y < 138.0 then
		return 0.95518809556961
	elseif y >= 138.0 and y < 139.0 then
		return 0.95836746692657
	elseif y >= 139.0 and y < 140.0 then
		return 0.96174544095993
	elseif y >= 140.0 and y < 141.0 then
		return 0.96512347459793
	elseif y >= 141.0 and y < 142.0 then
		return 0.96850150823593
	elseif y >= 142.0 and y < 143.0 then
		return 0.9716808795929
	elseif y >= 143.0 and y < 144.0 then
		return 0.9750589132309
	elseif y >= 144.0 and y < 145.0 then
		return 0.9784369468689
	elseif y >= 145.0 and y < 146.0 then
		return 0.9818149805069
	elseif y >= 146.0 and y < 147.0 then
		return 0.98519295454025
	elseif y >= 147.0 and y < 148.0 then
		return 0.98837232589722
	elseif y >= 148.0 and y < 1.0 then
		return 0.99175035953522
	elseif y == 150.0 then
		return 1.0
	end
end

function s432:getFreqLMFVal(x)--Returns frequency value of S432 low mid band to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.0075508942827582 then
		return 150
	elseif x >= 0.0075508942827582 and x < 0.015896620228887 then
		return 155
	elseif x >= 0.015896620228887 and x < 0.024242345243692 then
		return 160
	elseif x >= 0.024242345243692 and x < 0.032588068395853 then
		return 165
	elseif x >= 0.032588068395853 and x < 0.040933795273304 then
		return 170
	elseif x >= 0.040933795273304 and x < 0.049279518425465 then
		return 175
	elseif x >= 0.049279518425465 and x < 0.057625245302916 then
		return 180
	elseif x >= 0.057625245302916 and x < 0.065970972180367 then
		return 185
	elseif x >= 0.065970972180367 and x < 0.074316695332527 then
		return 190
	elseif x >= 0.074316695332527 and x < 0.082662418484688 then
		return 195
	elseif x >= 0.082662418484688 and x < 0.091008149087429 then
		return 200
	elseif x >= 0.091008149087429 and x < 0.09935387223959 then
		return 205
	elseif x >= 0.09935387223959 and x < 0.11127633601427 then
		return 210
	elseif x >= 0.11127633601427 and x < 0.12379492074251 then
		return 215
	elseif x >= 0.12379492074251 and x < 0.13631351292133 then
		return 220
	elseif x >= 0.13631351292133 and x < 0.14883209764957 then
		return 225
	elseif x >= 0.14883209764957 and x < 0.16135068237782 then
		return 230
	elseif x >= 0.16135068237782 and x < 0.17386926710606 then
		return 235
	elseif x >= 0.17386926710606 and x < 0.18638786673546 then
		return 240
	elseif x >= 0.18638786673546 and x < 0.1989064514637 then
		return 245
	elseif x >= 0.1989064514637 and x < 0.21520048379898 then
		return 250
	elseif x >= 0.21520048379898 and x < 0.23169322311878 then
		return 255
	elseif x >= 0.23169322311878 and x < 0.24838468432426 then
		return 260
	elseif x >= 0.24838468432426 and x < 0.26507613062859 then
		return 265
	elseif x >= 0.26507613062859 and x < 0.28176757693291 then
		return 270
	elseif x >= 0.28176757693291 and x < 0.29845902323723 then
		return 275
	elseif x >= 0.29845902323723 and x < 0.30759957432747 then
		return 280
	elseif x >= 0.30759957432747 and x < 0.31614401936531 then
		return 285
	elseif x >= 0.31614401936531 and x < 0.32429102063179 then
		return 290
	elseif x >= 0.32429102063179 and x < 0.33283546566963 then
		return 295
	elseif x >= 0.33283546566963 and x < 0.34098249673843 then
		return 300
	elseif x >= 0.34098249673843 and x < 0.34932821989059 then
		return 305
	elseif x >= 0.34932821989059 and x < 0.35767394304276 then
		return 310
	elseif x >= 0.35767394304276 and x < 0.36621835827827 then
		return 315
	elseif x >= 0.36621835827827 and x < 0.37436538934708 then
		return 320
	elseif x >= 0.37436538934708 and x < 0.38251239061356 then
		return 325
	elseif x >= 0.38251239061356 and x < 0.39085811376572 then
		return 330
	elseif x >= 0.39085811376572 and x < 0.3992038667202 then
		return 335
	elseif x >= 0.3992038667202 and x < 0.40754958987236 then
		return 340
	elseif x >= 0.40754958987236 and x < 0.41589531302452 then
		return 345
	elseif x >= 0.41589531302452 and x < 0.42424103617668 then
		return 350
	elseif x >= 0.42424103617668 and x < 0.43258675932884 then
		return 355
	elseif x >= 0.43258675932884 and x < 0.440932482481 then
		return 360
	elseif x >= 0.440932482481 and x < 0.44927820563316 then
		return 365
	elseif x >= 0.44927820563316 and x < 0.45762392878532 then
		return 370
	elseif x >= 0.45762392878532 and x < 0.46596965193748 then
		return 375
	elseif x >= 0.46596965193748 and x < 0.47431537508965 then
		return 380
	elseif x >= 0.47431537508965 and x < 0.48266109824181 then
		return 385
	elseif x >= 0.48266109824181 and x < 0.49100682139397 then
		return 390
	elseif x >= 0.49100682139397 and x < 0.49935254454613 then
		return 395
	elseif x >= 0.49935254454613 and x < 0.50571119785309 then
		return 400
	elseif x >= 0.50571119785309 and x < 0.51206982135773 then
		return 405
	elseif x >= 0.51206982135773 and x < 0.51822978258133 then
		return 410
	elseif x >= 0.51822978258133 and x < 0.52438974380493 then
		return 415
	elseif x >= 0.52438974380493 and x < 0.53074836730957 then
		return 420
	elseif x >= 0.53074836730957 and x < 0.53690832853317 then
		return 425
	elseif x >= 0.53690832853317 and x < 0.54326695203781 then
		return 430
	elseif x >= 0.54326695203781 and x < 0.54942691326141 then
		return 435
	elseif x >= 0.54942691326141 and x < 0.55578553676605 then
		return 440
	elseif x >= 0.55578553676605 and x < 0.56194549798965 then
		return 445
	elseif x >= 0.56194549798965 and x < 0.56830412149429 then
		return 450
	elseif x >= 0.56830412149429 and x < 0.5744640827179 then
		return 455
	elseif x >= 0.5744640827179 and x < 0.58082270622253 then
		return 460
	elseif x >= 0.58082270622253 and x < 0.58698266744614 then
		return 465
	elseif x >= 0.58698266744614 and x < 0.59314262866974 then
		return 470
	elseif x >= 0.59314262866974 and x < 0.59950125217438 then
		return 475
	elseif x >= 0.59950125217438 and x < 0.60506504774094 then
		return 480
	elseif x >= 0.60506504774094 and x < 0.61062890291214 then
		return 485
	elseif x >= 0.61062890291214 and x < 0.6161926984787 then
		return 490
	elseif x >= 0.6161926984787 and x < 0.62175649404526 then
		return 495
	elseif x >= 0.62175649404526 and x < 0.62732034921646 then
		return 500
	elseif x >= 0.62732034921646 and x < 0.63288414478302 then
		return 505
	elseif x >= 0.63288414478302 and x < 0.63844799995422 then
		return 510
	elseif x >= 0.63844799995422 and x < 0.64401179552078 then
		return 515
	elseif x >= 0.64401179552078 and x < 0.64957559108734 then
		return 520
	elseif x >= 0.64957559108734 and x < 0.65513944625854 then
		return 525
	elseif x >= 0.65513944625854 and x < 0.6607032418251 then
		return 530
	elseif x >= 0.6607032418251 and x < 0.66626703739166 then
		return 535
	elseif x >= 0.66626703739166 and x < 0.67183089256287 then
		return 540
	elseif x >= 0.67183089256287 and x < 0.67739468812943 then
		return 545
	elseif x >= 0.67739468812943 and x < 0.68295848369598 then
		return 550
	elseif x >= 0.68295848369598 and x < 0.68852233886719 then
		return 555
	elseif x >= 0.68852233886719 and x < 0.69408613443375 then
		return 560
	elseif x >= 0.69408613443375 and x < 0.69945126771927 then
		return 565
	elseif x >= 0.69945126771927 and x < 0.70362412929535 then
		return 570
	elseif x >= 0.70362412929535 and x < 0.70739954710007 then
		return 575
	elseif x >= 0.70739954710007 and x < 0.71117502450943 then
		return 580
	elseif x >= 0.71117502450943 and x < 0.71514916419983 then
		return 585
	elseif x >= 0.71514916419983 and x < 0.71892458200455 then
		return 590
	elseif x >= 0.71892458200455 and x < 0.72270005941391 then
		return 595
	elseif x >= 0.72270005941391 and x < 0.72667419910431 then
		return 600
	elseif x >= 0.72667419910431 and x < 0.73044967651367 then
		return 605
	elseif x >= 0.73044967651367 and x < 0.73442381620407 then
		return 610
	elseif x >= 0.73442381620407 and x < 0.73819923400879 then
		return 615
	elseif x >= 0.73819923400879 and x < 0.74197471141815 then
		return 620
	elseif x >= 0.74197471141815 and x < 0.74594885110855 then
		return 625
	elseif x >= 0.74594885110855 and x < 0.74972432851791 then
		return 630
	elseif x >= 0.74972432851791 and x < 0.75349974632263 then
		return 635
	elseif x >= 0.75349974632263 and x < 0.75747388601303 then
		return 640
	elseif x >= 0.75747388601303 and x < 0.76124936342239 then
		return 645
	elseif x >= 0.76124936342239 and x < 0.76502478122711 then
		return 650
	elseif x >= 0.76502478122711 and x < 0.76899898052216 then
		return 655
	elseif x >= 0.76899898052216 and x < 0.77277439832687 then
		return 660
	elseif x >= 0.77277439832687 and x < 0.77654987573624 then
		return 665
	elseif x >= 0.77654987573624 and x < 0.78052401542664 then
		return 670
	elseif x >= 0.78052401542664 and x < 0.78429943323135 then
		return 675
	elseif x >= 0.78429943323135 and x < 0.7882736325264 then
		return 680
	elseif x >= 0.7882736325264 and x < 0.79204905033112 then
		return 685
	elseif x >= 0.79204905033112 and x < 0.79582452774048 then
		return 690
	elseif x >= 0.79582452774048 and x < 0.79979866743088 then
		return 695
	elseif x >= 0.79979866743088 and x < 0.80337542295456 then
		return 700
	elseif x >= 0.80337542295456 and x < 0.8069521188736 then
		return 705
	elseif x >= 0.8069521188736 and x < 0.81052887439728 then
		return 710
	elseif x >= 0.81052887439728 and x < 0.81410562992096 then
		return 715
	elseif x >= 0.81410562992096 and x < 0.81768238544464 then
		return 720
	elseif x >= 0.81768238544464 and x < 0.82125908136368 then
		return 725
	elseif x >= 0.82125908136368 and x < 0.82483583688736 then
		return 730
	elseif x >= 0.82483583688736 and x < 0.82841259241104 then
		return 735
	elseif x >= 0.82841259241104 and x < 0.83179062604904 then
		return 740
	elseif x >= 0.83179062604904 and x < 0.83536732196808 then
		return 745
	elseif x >= 0.83536732196808 and x < 0.83894407749176 then
		return 750
	elseif x >= 0.83894407749176 and x < 0.84252083301544 then
		return 755
	elseif x >= 0.84252083301544 and x < 0.84609758853912 then
		return 760
	elseif x >= 0.84609758853912 and x < 0.84967428445816 then
		return 765
	elseif x >= 0.84967428445816 and x < 0.85325103998184 then
		return 770
	elseif x >= 0.85325103998184 and x < 0.85682779550552 then
		return 775
	elseif x >= 0.85682779550552 and x < 0.86040455102921 then
		return 780
	elseif x >= 0.86040455102921 and x < 0.86398124694824 then
		return 785
	elseif x >= 0.86398124694824 and x < 0.86755800247192 then
		return 790
	elseif x >= 0.86755800247192 and x < 0.87113475799561 then
		return 795
	elseif x >= 0.87113475799561 and x < 0.87471145391464 then
		return 800
	elseif x >= 0.87471145391464 and x < 0.87828820943832 then
		return 805
	elseif x >= 0.87828820943832 and x < 0.88186496496201 then
		return 810
	elseif x >= 0.88186496496201 and x < 0.88544172048569 then
		return 815
	elseif x >= 0.88544172048569 and x < 0.88901841640472 then
		return 820
	elseif x >= 0.88901841640472 and x < 0.89259517192841 then
		return 825
	elseif x >= 0.89259517192841 and x < 0.89617192745209 then
		return 830
	elseif x >= 0.89617192745209 and x < 0.89974868297577 then
		return 835
	elseif x >= 0.89974868297577 and x < 0.90292799472809 then
		return 840
	elseif x >= 0.90292799472809 and x < 0.90610730648041 then
		return 845
	elseif x >= 0.90610730648041 and x < 0.90908789634705 then
		return 850
	elseif x >= 0.90908789634705 and x < 0.91226726770401 then
		return 855
	elseif x >= 0.91226726770401 and x < 0.91544657945633 then
		return 860
	elseif x >= 0.91544657945633 and x < 0.91862589120865 then
		return 865
	elseif x >= 0.91862589120865 and x < 0.92180520296097 then
		return 870
	elseif x >= 0.92180520296097 and x < 0.92478585243225 then
		return 875
	elseif x >= 0.92478585243225 and x < 0.92796516418457 then
		return 880
	elseif x >= 0.92796516418457 and x < 0.93094575405121 then
		return 885
	elseif x >= 0.93094575405121 and x < 0.93412506580353 then
		return 890
	elseif x >= 0.93412506580353 and x < 0.93730443716049 then
		return 895
	elseif x >= 0.93730443716049 and x < 0.94048374891281 then
		return 900
	elseif x >= 0.94048374891281 and x < 0.94346433877945 then
		return 905
	elseif x >= 0.94346433877945 and x < 0.94664371013641 then
		return 910
	elseif x >= 0.94664371013641 and x < 0.94982302188873 then
		return 915
	elseif x >= 0.94982302188873 and x < 0.95300233364105 then
		return 920
	elseif x >= 0.95300233364105 and x < 0.95598292350769 then
		return 925
	elseif x >= 0.95598292350769 and x < 0.95916229486465 then
		return 930
	elseif x >= 0.95916229486465 and x < 0.96234160661697 then
		return 935
	elseif x >= 0.96234160661697 and x < 0.96532219648361 then
		return 940
	elseif x >= 0.96532219648361 and x < 0.96850150823593 then
		return 945
	elseif x >= 0.96850150823593 and x < 0.9716808795929 then
		return 950
	elseif x >= 0.9716808795929 and x < 0.97486019134521 then
		return 955
	elseif x >= 0.97486019134521 and x < 0.97784078121185 then
		return 960
	elseif x >= 0.97784078121185 and x < 0.98102009296417 then
		return 965
	elseif x >= 0.98102009296417 and x < 0.98419946432114 then
		return 970
	elseif x >= 0.98419946432114 and x < 0.98737877607346 then
		return 975
	elseif x >= 0.98737877607346 and x < 0.99035936594009 then
		return 980
	elseif x >= 0.99035936594009 and x < 0.99353873729706 then
		return 985
	elseif x >= 0.99353873729706 and x < 1.0 then
		return 990
	elseif x == 1.0 then
		return 1000
	end
end

function s432:getFreqLMFNormVal(y)--Returns normalized frequency value of S432 low mid band.
	y = limit(y, 150, 1000)
	if y >= 150 and y < 155 then
		return 0.0
	elseif y >= 155 and y < 160 then
		return 0.0075508942827582
	elseif y >= 160 and y < 165 then
		return 0.015896620228887
	elseif y >= 165 and y < 170 then
		return 0.024242345243692
	elseif y >= 170 and y < 175 then
		return 0.032588068395853
	elseif y >= 175 and y < 180 then
		return 0.040933795273304
	elseif y >= 180 and y < 185 then
		return 0.049279518425465
	elseif y >= 185 and y < 190 then
		return 0.057625245302916
	elseif y >= 190 and y < 195 then
		return 0.065970972180367
	elseif y >= 195 and y < 200 then
		return 0.074316695332527
	elseif y >= 200 and y < 205 then
		return 0.082662418484688
	elseif y >= 205 and y < 210 then
		return 0.091008149087429
	elseif y >= 210 and y < 215 then
		return 0.09935387223959
	elseif y >= 215 and y < 220 then
		return 0.11127633601427
	elseif y >= 220 and y < 225 then
		return 0.12379492074251
	elseif y >= 225 and y < 230 then
		return 0.13631351292133
	elseif y >= 230 and y < 235 then
		return 0.14883209764957
	elseif y >= 235 and y < 240 then
		return 0.16135068237782
	elseif y >= 240 and y < 245 then
		return 0.17386926710606
	elseif y >= 245 and y < 250 then
		return 0.18638786673546
	elseif y >= 250 and y < 255 then
		return 0.1989064514637
	elseif y >= 255 and y < 260 then
		return 0.21520048379898
	elseif y >= 260 and y < 265 then
		return 0.23169322311878
	elseif y >= 265 and y < 270 then
		return 0.24838468432426
	elseif y >= 270 and y < 275 then
		return 0.26507613062859
	elseif y >= 275 and y < 280 then
		return 0.28176757693291
	elseif y >= 280 and y < 285 then
		return 0.29845902323723
	elseif y >= 285 and y < 290 then
		return 0.30759957432747
	elseif y >= 290 and y < 295 then
		return 0.31614401936531
	elseif y >= 295 and y < 300 then
		return 0.32429102063179
	elseif y >= 300 and y < 305 then
		return 0.33283546566963
	elseif y >= 305 and y < 310 then
		return 0.34098249673843
	elseif y >= 310 and y < 315 then
		return 0.34932821989059
	elseif y >= 315 and y < 320 then
		return 0.35767394304276
	elseif y >= 320 and y < 325 then
		return 0.36621835827827
	elseif y >= 325 and y < 330 then
		return 0.37436538934708
	elseif y >= 330 and y < 335 then
		return 0.38251239061356
	elseif y >= 335 and y < 340 then
		return 0.39085811376572
	elseif y >= 340 and y < 345 then
		return 0.3992038667202
	elseif y >= 345 and y < 350 then
		return 0.40754958987236
	elseif y >= 350 and y < 355 then
		return 0.41589531302452
	elseif y >= 355 and y < 360 then
		return 0.42424103617668
	elseif y >= 360 and y < 365 then
		return 0.43258675932884
	elseif y >= 365 and y < 370 then
		return 0.440932482481
	elseif y >= 370 and y < 375 then
		return 0.44927820563316
	elseif y >= 375 and y < 380 then
		return 0.45762392878532
	elseif y >= 380 and y < 385 then
		return 0.46596965193748
	elseif y >= 385 and y < 390 then
		return 0.47431537508965
	elseif y >= 390 and y < 395 then
		return 0.48266109824181
	elseif y >= 395 and y < 400 then
		return 0.49100682139397
	elseif y >= 400 and y < 405 then
		return 0.49935254454613
	elseif y >= 405 and y < 410 then
		return 0.50571119785309
	elseif y >= 410 and y < 415 then
		return 0.51206982135773
	elseif y >= 415 and y < 420 then
		return 0.51822978258133
	elseif y >= 420 and y < 425 then
		return 0.52438974380493
	elseif y >= 425 and y < 430 then
		return 0.53074836730957
	elseif y >= 430 and y < 435 then
		return 0.53690832853317
	elseif y >= 435 and y < 440 then
		return 0.54326695203781
	elseif y >= 440 and y < 445 then
		return 0.54942691326141
	elseif y >= 445 and y < 450 then
		return 0.55578553676605
	elseif y >= 450 and y < 455 then
		return 0.56194549798965
	elseif y >= 455 and y < 460 then
		return 0.56830412149429
	elseif y >= 460 and y < 465 then
		return 0.5744640827179
	elseif y >= 465 and y < 470 then
		return 0.58082270622253
	elseif y >= 470 and y < 475 then
		return 0.58698266744614
	elseif y >= 475 and y < 480 then
		return 0.59314262866974
	elseif y >= 480 and y < 485 then
		return 0.59950125217438
	elseif y >= 485 and y < 490 then
		return 0.60506504774094
	elseif y >= 490 and y < 495 then
		return 0.61062890291214
	elseif y >= 495 and y < 500 then
		return 0.6161926984787
	elseif y >= 500 and y < 505 then
		return 0.62175649404526
	elseif y >= 505 and y < 510 then
		return 0.62732034921646
	elseif y >= 510 and y < 515 then
		return 0.63288414478302
	elseif y >= 515 and y < 520 then
		return 0.63844799995422
	elseif y >= 520 and y < 525 then
		return 0.64401179552078
	elseif y >= 525 and y < 530 then
		return 0.64957559108734
	elseif y >= 530 and y < 535 then
		return 0.65513944625854
	elseif y >= 535 and y < 540 then
		return 0.6607032418251
	elseif y >= 540 and y < 545 then
		return 0.66626703739166
	elseif y >= 545 and y < 550 then
		return 0.67183089256287
	elseif y >= 550 and y < 555 then
		return 0.67739468812943
	elseif y >= 555 and y < 560 then
		return 0.68295848369598
	elseif y >= 560 and y < 565 then
		return 0.68852233886719
	elseif y >= 565 and y < 570 then
		return 0.69408613443375
	elseif y >= 570 and y < 575 then
		return 0.69945126771927
	elseif y >= 575 and y < 580 then
		return 0.70362412929535
	elseif y >= 580 and y < 585 then
		return 0.70739954710007
	elseif y >= 585 and y < 590 then
		return 0.71117502450943
	elseif y >= 590 and y < 595 then
		return 0.71514916419983
	elseif y >= 595 and y < 600 then
		return 0.71892458200455
	elseif y >= 600 and y < 605 then
		return 0.72270005941391
	elseif y >= 605 and y < 610 then
		return 0.72667419910431
	elseif y >= 610 and y < 615 then
		return 0.73044967651367
	elseif y >= 615 and y < 620 then
		return 0.73442381620407
	elseif y >= 620 and y < 625 then
		return 0.73819923400879
	elseif y >= 625 and y < 630 then
		return 0.74197471141815
	elseif y >= 630 and y < 635 then
		return 0.74594885110855
	elseif y >= 635 and y < 640 then
		return 0.74972432851791
	elseif y >= 640 and y < 645 then
		return 0.75349974632263
	elseif y >= 645 and y < 650 then
		return 0.75747388601303
	elseif y >= 650 and y < 655 then
		return 0.76124936342239
	elseif y >= 655 and y < 660 then
		return 0.76502478122711
	elseif y >= 660 and y < 665 then
		return 0.76899898052216
	elseif y >= 665 and y < 670 then
		return 0.77277439832687
	elseif y >= 670 and y < 675 then
		return 0.77654987573624
	elseif y >= 675 and y < 680 then
		return 0.78052401542664
	elseif y >= 680 and y < 685 then
		return 0.78429943323135
	elseif y >= 685 and y < 690 then
		return 0.7882736325264
	elseif y >= 690 and y < 695 then
		return 0.79204905033112
	elseif y >= 695 and y < 700 then
		return 0.79582452774048
	elseif y >= 700 and y < 705 then
		return 0.79979866743088
	elseif y >= 705 and y < 710 then
		return 0.80337542295456
	elseif y >= 710 and y < 715 then
		return 0.8069521188736
	elseif y >= 715 and y < 720 then
		return 0.81052887439728
	elseif y >= 720 and y < 725 then
		return 0.81410562992096
	elseif y >= 725 and y < 730 then
		return 0.81768238544464
	elseif y >= 730 and y < 735 then
		return 0.82125908136368
	elseif y >= 735 and y < 740 then
		return 0.82483583688736
	elseif y >= 740 and y < 745 then
		return 0.82841259241104
	elseif y >= 745 and y < 750 then
		return 0.83179062604904
	elseif y >= 750 and y < 755 then
		return 0.83536732196808
	elseif y >= 755 and y < 760 then
		return 0.83894407749176
	elseif y >= 760 and y < 765 then
		return 0.84252083301544
	elseif y >= 765 and y < 770 then
		return 0.84609758853912
	elseif y >= 770 and y < 775 then
		return 0.84967428445816
	elseif y >= 775 and y < 780 then
		return 0.85325103998184
	elseif y >= 780 and y < 785 then
		return 0.85682779550552
	elseif y >= 785 and y < 790 then
		return 0.86040455102921
	elseif y >= 790 and y < 795 then
		return 0.86398124694824
	elseif y >= 795 and y < 800 then
		return 0.86755800247192
	elseif y >= 800 and y < 805 then
		return 0.87113475799561
	elseif y >= 805 and y < 810 then
		return 0.87471145391464
	elseif y >= 810 and y < 815 then
		return 0.87828820943832
	elseif y >= 815 and y < 820 then
		return 0.88186496496201
	elseif y >= 820 and y < 825 then
		return 0.88544172048569
	elseif y >= 825 and y < 830 then
		return 0.88901841640472
	elseif y >= 830 and y < 835 then
		return 0.89259517192841
	elseif y >= 835 and y < 840 then
		return 0.89617192745209
	elseif y >= 840 and y < 845 then
		return 0.89974868297577
	elseif y >= 845 and y < 850 then
		return 0.90292799472809
	elseif y >= 850 and y < 855 then
		return 0.90610730648041
	elseif y >= 855 and y < 860 then
		return 0.90908789634705
	elseif y >= 860 and y < 865 then
		return 0.91226726770401
	elseif y >= 865 and y < 870 then
		return 0.91544657945633
	elseif y >= 870 and y < 875 then
		return 0.91862589120865
	elseif y >= 875 and y < 880 then
		return 0.92180520296097
	elseif y >= 880 and y < 885 then
		return 0.92478585243225
	elseif y >= 885 and y < 890 then
		return 0.92796516418457
	elseif y >= 890 and y < 895 then
		return 0.93094575405121
	elseif y >= 895 and y < 900 then
		return 0.93412506580353
	elseif y >= 900 and y < 905 then
		return 0.93730443716049
	elseif y >= 905 and y < 910 then
		return 0.94048374891281
	elseif y >= 910 and y < 915 then
		return 0.94346433877945
	elseif y >= 915 and y < 920 then
		return 0.94664371013641
	elseif y >= 920 and y < 925 then
		return 0.94982302188873
	elseif y >= 925 and y < 930 then
		return 0.95300233364105
	elseif y >= 930 and y < 935 then
		return 0.95598292350769
	elseif y >= 935 and y < 940 then
		return 0.95916229486465
	elseif y >= 940 and y < 945 then
		return 0.96234160661697
	elseif y >= 945 and y < 950 then
		return 0.96532219648361
	elseif y >= 950 and y < 955 then
		return 0.96850150823593
	elseif y >= 955 and y < 960 then
		return 0.9716808795929
	elseif y >= 960 and y < 965 then
		return 0.97486019134521
	elseif y >= 965 and y < 970 then
		return 0.97784078121185
	elseif y >= 970 and y < 975 then
		return 0.98102009296417
	elseif y >= 975 and y < 980 then
		return 0.98419946432114
	elseif y >= 980 and y < 985 then
		return 0.98737877607346
	elseif y >= 985 and y < 990 then
		return 0.99035936594009
	elseif y >= 990 and y < 1000 then
		return 0.99353873729706
	elseif y == 1000 then
		return 1.0
	end
end

function s432:getFreqHMFVal(x)--Returns frequency value of S432 high mid band to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.024838468059897 then
		return 1000
	elseif x >= 0.024838468059897 and x < 0.049875643104315 then
		return 1050
	elseif x >= 0.049875643104315 and x < 0.074912816286087 then
		return 1100
	elseif x >= 0.074912816286087 and x < 0.09975128620863 then
		return 1150
	elseif x >= 0.09975128620863 and x < 0.12478846311569 then
		return 1200
	elseif x >= 0.12478846311569 and x < 0.15002433955669 then
		return 1250
	elseif x >= 0.15002433955669 and x < 0.17486281692982 then
		return 1300
	elseif x >= 0.17486281692982 and x < 0.1998999863863 then
		return 1350
	elseif x >= 0.1998999863863 and x < 0.21659143269062 then
		return 1400
	elseif x >= 0.21659143269062 and x < 0.2332828938961 then
		return 1450
	elseif x >= 0.2332828938961 and x < 0.24997434020042 then
		return 1500
	elseif x >= 0.24997434020042 and x < 0.26666578650475 then
		return 1550
	elseif x >= 0.26666578650475 and x < 0.28335723280907 then
		return 1600
	elseif x >= 0.28335723280907 and x < 0.29984998703003 then
		return 1650
	elseif x >= 0.29984998703003 and x < 0.31654143333435 then
		return 1700
	elseif x >= 0.31654143333435 and x < 0.33323287963867 then
		return 1750
	elseif x >= 0.33323287963867 and x < 0.34992432594299 then
		return 1800
	elseif x >= 0.34992432594299 and x < 0.36661577224731 then
		return 1850
	elseif x >= 0.36661577224731 and x < 0.38330724835396 then
		return 1900
	elseif x >= 0.38330724835396 and x < 0.39999869465828 then
		return 1950
	elseif x >= 0.39999869465828 and x < 0.41251727938652 then
		return 2000
	elseif x >= 0.41251727938652 and x < 0.42503586411476 then
		return 2050
	elseif x >= 0.42503586411476 and x < 0.437554448843 then
		return 2100
	elseif x >= 0.437554448843 and x < 0.45007303357124 then
		return 2150
	elseif x >= 0.45007303357124 and x < 0.46239292621613 then
		return 2200
	elseif x >= 0.46239292621613 and x < 0.47491151094437 then
		return 2250
	elseif x >= 0.47491151094437 and x < 0.48743009567261 then
		return 2300
	elseif x >= 0.48743009567261 and x < 0.49994868040085 then
		return 2350
	elseif x >= 0.49994868040085 and x < 0.51246726512909 then
		return 2400
	elseif x >= 0.51246726512909 and x < 0.52498584985733 then
		return 2450
	elseif x >= 0.52498584985733 and x < 0.53750443458557 then
		return 2500
	elseif x >= 0.53750443458557 and x < 0.55002301931381 then
		return 2550
	elseif x >= 0.55002301931381 and x < 0.56254160404205 then
		return 2600
	elseif x >= 0.56254160404205 and x < 0.57506018877029 then
		return 2650
	elseif x >= 0.57506018877029 and x < 0.5873801112175 then
		return 2700
	elseif x >= 0.5873801112175 and x < 0.59989869594574 then
		return 2750
	elseif x >= 0.59989869594574 and x < 0.61659014225006 then
		return 2800
	elseif x >= 0.61659014225006 and x < 0.62493586540222 then
		return 2900
	elseif x >= 0.62493586540222 and x < 0.63328158855438 then
		return 2950
	elseif x >= 0.63328158855438 and x < 0.64162731170654 then
		return 3000
	elseif x >= 0.64162731170654 and x < 0.6499730348587 then
		return 3050
	elseif x >= 0.6499730348587 and x < 0.65831875801086 then
		return 3100
	elseif x >= 0.65831875801086 and x < 0.66666448116302 then
		return 3150
	elseif x >= 0.66666448116302 and x < 0.67501020431519 then
		return 3200
	elseif x >= 0.67501020431519 and x < 0.68335592746735 then
		return 3250
	elseif x >= 0.68335592746735 and x < 0.69170165061951 then
		return 3300
	elseif x >= 0.69170165061951 and x < 0.70004737377167 then
		return 3350
	elseif x >= 0.70004737377167 and x < 0.70839309692383 then
		return 3400
	elseif x >= 0.70839309692383 and x < 0.71673882007599 then
		return 3450
	elseif x >= 0.71673882007599 and x < 0.74992299079895 then
		return 3500
	elseif x >= 0.74992299079895 and x < 0.75826871395111 then
		return 3700
	elseif x >= 0.75826871395111 and x < 0.76661449670792 then
		return 3750
	elseif x >= 0.76661449670792 and x < 0.77496021986008 then
		return 3800
	elseif x >= 0.77496021986008 and x < 0.78330594301224 then
		return 3850
	elseif x >= 0.78330594301224 and x < 0.7916516661644 then
		return 3900
	elseif x >= 0.7916516661644 and x < 0.79999738931656 then
		return 3950
	elseif x >= 0.79999738931656 and x < 0.8125159740448 then
		return 4000
	elseif x >= 0.8125159740448 and x < 0.82503455877304 then
		return 4100
	elseif x >= 0.82503455877304 and x < 0.831194460392 then
		return 4200
	elseif x >= 0.831194460392 and x < 0.83755314350128 then
		return 4250
	elseif x >= 0.83755314350128 and x < 0.84371304512024 then
		return 4300
	elseif x >= 0.84371304512024 and x < 0.85623162984848 then
		return 4350
	elseif x >= 0.85623162984848 and x < 0.86875027418137 then
		return 4450
	elseif x >= 0.86875027418137 and x < 0.88126885890961 then
		return 4550
	elseif x >= 0.88126885890961 and x < 0.89378744363785 then
		return 4650
	elseif x >= 0.89378744363785 and x < 0.89994734525681 then
		return 4750
	elseif x >= 0.89994734525681 and x < 0.90551120042801 then
		return 4800
	elseif x >= 0.90551120042801 and x < 0.91107499599457 then
		return 4850
	elseif x >= 0.91107499599457 and x < 0.91663879156113 then
		return 4900
	elseif x >= 0.91663879156113 and x < 0.92220264673233 then
		return 4950
	elseif x >= 0.92220264673233 and x < 0.92776644229889 then
		return 5000
	elseif x >= 0.92776644229889 and x < 0.93333023786545 then
		return 5050
	elseif x >= 0.93333023786545 and x < 0.93889409303665 then
		return 5100
	elseif x >= 0.93889409303665 and x < 0.94445788860321 then
		return 5150
	elseif x >= 0.94445788860321 and x < 0.95002168416977 then
		return 5200
	elseif x >= 0.95002168416977 and x < 0.95558553934097 then
		return 5250
	elseif x >= 0.95558553934097 and x < 0.96114933490753 then
		return 5300
	elseif x >= 0.96114933490753 and x < 0.96671319007874 then
		return 5350
	elseif x >= 0.96671319007874 and x < 0.97227698564529 then
		return 5400
	elseif x >= 0.97227698564529 and x < 0.97784078121185 then
		return 5450
	elseif x >= 0.97784078121185 and x < 0.98340463638306 then
		return 5501
	elseif x >= 0.98340463638306 and x < 0.98896843194962 then
		return 5551
	elseif x >= 0.98896843194962 and x < 1.0 then
		return 5601
	elseif x == 1.0 then
		return 5700
	end
end

function s432:getFreqHMFNormVal(y)--Returns normalized frequency value of S432 high mid band.
	y = limit(y, 1000, 5700)
	if y >= 1000 and y < 1050 then
		return 0.0
	elseif y >= 1050 and y < 1100 then
		return 0.024838468059897
	elseif y >= 1100 and y < 1150 then
		return 0.049875643104315
	elseif y >= 1150 and y < 1200 then
		return 0.074912816286087
	elseif y >= 1200 and y < 1250 then
		return 0.09975128620863
	elseif y >= 1250 and y < 1300 then
		return 0.12478846311569
	elseif y >= 1300 and y < 1350 then
		return 0.15002433955669
	elseif y >= 1350 and y < 1400 then
		return 0.17486281692982
	elseif y >= 1400 and y < 1450 then
		return 0.1998999863863
	elseif y >= 1450 and y < 1500 then
		return 0.21659143269062
	elseif y >= 1500 and y < 1550 then
		return 0.2332828938961
	elseif y >= 1550 and y < 1600 then
		return 0.24997434020042
	elseif y >= 1600 and y < 1650 then
		return 0.26666578650475
	elseif y >= 1650 and y < 1700 then
		return 0.28335723280907
	elseif y >= 1700 and y < 1750 then
		return 0.29984998703003
	elseif y >= 1750 and y < 1800 then
		return 0.31654143333435
	elseif y >= 1800 and y < 1850 then
		return 0.33323287963867
	elseif y >= 1850 and y < 1900 then
		return 0.34992432594299
	elseif y >= 1900 and y < 1950 then
		return 0.36661577224731
	elseif y >= 1950 and y < 2000 then
		return 0.38330724835396
	elseif y >= 2000 and y < 2050 then
		return 0.39999869465828
	elseif y >= 2050 and y < 2100 then
		return 0.41251727938652
	elseif y >= 2100 and y < 2150 then
		return 0.42503586411476
	elseif y >= 2150 and y < 2200 then
		return 0.437554448843
	elseif y >= 2200 and y < 2250 then
		return 0.45007303357124
	elseif y >= 2250 and y < 2300 then
		return 0.46239292621613
	elseif y >= 2300 and y < 2350 then
		return 0.47491151094437
	elseif y >= 2350 and y < 2400 then
		return 0.48743009567261
	elseif y >= 2400 and y < 2450 then
		return 0.49994868040085
	elseif y >= 2450 and y < 2500 then
		return 0.51246726512909
	elseif y >= 2500 and y < 2550 then
		return 0.52498584985733
	elseif y >= 2550 and y < 2600 then
		return 0.53750443458557
	elseif y >= 2600 and y < 2650 then
		return 0.55002301931381
	elseif y >= 2650 and y < 2700 then
		return 0.56254160404205
	elseif y >= 2700 and y < 2750 then
		return 0.57506018877029
	elseif y >= 2750 and y < 2800 then
		return 0.5873801112175
	elseif y >= 2800 and y < 2900 then
		return 0.59989869594574
	elseif y >= 2900 and y < 2950 then
		return 0.61659014225006
	elseif y >= 2950 and y < 3000 then
		return 0.62493586540222
	elseif y >= 3000 and y < 3050 then
		return 0.63328158855438
	elseif y >= 3050 and y < 3100 then
		return 0.64162731170654
	elseif y >= 3100 and y < 3150 then
		return 0.6499730348587
	elseif y >= 3150 and y < 3200 then
		return 0.65831875801086
	elseif y >= 3200 and y < 3250 then
		return 0.66666448116302
	elseif y >= 3250 and y < 3300 then
		return 0.67501020431519
	elseif y >= 3300 and y < 3350 then
		return 0.68335592746735
	elseif y >= 3350 and y < 3400 then
		return 0.69170165061951
	elseif y >= 3400 and y < 3450 then
		return 0.70004737377167
	elseif y >= 3450 and y < 3500 then
		return 0.70839309692383
	elseif y >= 3500 and y < 3700 then
		return 0.71673882007599
	elseif y >= 3700 and y < 3750 then
		return 0.74992299079895
	elseif y >= 3750 and y < 3800 then
		return 0.75826871395111
	elseif y >= 3800 and y < 3850 then
		return 0.76661449670792
	elseif y >= 3850 and y < 3900 then
		return 0.77496021986008
	elseif y >= 3900 and y < 3950 then
		return 0.78330594301224
	elseif y >= 3950 and y < 4000 then
		return 0.7916516661644
	elseif y >= 4000 and y < 4100 then
		return 0.79999738931656
	elseif y >= 4100 and y < 4200 then
		return 0.8125159740448
	elseif y >= 4200 and y < 4250 then
		return 0.82503455877304
	elseif y >= 4250 and y < 4300 then
		return 0.831194460392
	elseif y >= 4300 and y < 4350 then
		return 0.83755314350128
	elseif y >= 4350 and y < 4450 then
		return 0.84371304512024
	elseif y >= 4450 and y < 4550 then
		return 0.85623162984848
	elseif y >= 4550 and y < 4650 then
		return 0.86875027418137
	elseif y >= 4650 and y < 4750 then
		return 0.88126885890961
	elseif y >= 4750 and y < 4800 then
		return 0.89378744363785
	elseif y >= 4800 and y < 4850 then
		return 0.89994734525681
	elseif y >= 4850 and y < 4900 then
		return 0.90551120042801
	elseif y >= 4900 and y < 4950 then
		return 0.91107499599457
	elseif y >= 4950 and y < 5000 then
		return 0.91663879156113
	elseif y >= 5000 and y < 5050 then
		return 0.92220264673233
	elseif y >= 5050 and y < 5100 then
		return 0.92776644229889
	elseif y >= 5100 and y < 5150 then
		return 0.93333023786545
	elseif y >= 5150 and y < 5200 then
		return 0.93889409303665
	elseif y >= 5200 and y < 5250 then
		return 0.94445788860321
	elseif y >= 5250 and y < 5300 then
		return 0.95002168416977
	elseif y >= 5300 and y < 5350 then
		return 0.95558553934097
	elseif y >= 5350 and y < 5400 then
		return 0.96114933490753
	elseif y >= 5400 and y < 5450 then
		return 0.96671319007874
	elseif y >= 5450 and y < 5501 then
		return 0.97227698564529
	elseif y >= 5501 and y < 5551 then
		return 0.97784078121185
	elseif y >= 5551 and y < 5601 then
		return 0.98340463638306
	elseif y >= 5601 and y < 5700 then
		return 0.98896843194962
	elseif y == 5700 then
		return 1.0
	end
end

function s432:getFreqHFVal(x)--Returns frequency value of S432 high band to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.0045702778734267 then
		return 5700
	elseif x >= 0.0045702778734267 and x < 0.031793240457773 then
		return 5750
	elseif x >= 0.031793240457773 and x < 0.036363516002893 then
		return 6050
	elseif x >= 0.036363516002893 and x < 0.040933795273304 then
		return 6100
	elseif x >= 0.040933795273304 and x < 0.068156756460667 then
		return 6150
	elseif x >= 0.068156756460667 and x < 0.072727032005787 then
		return 6450
	elseif x >= 0.072727032005787 and x < 0.077297315001488 then
		return 6500
	elseif x >= 0.077297315001488 and x < 0.10769959539175 then
		return 6550
	elseif x >= 0.10769959539175 and x < 0.11922464519739 then
		return 6900
	elseif x >= 0.11922464519739 and x < 0.13074968755245 then
		return 7050
	elseif x >= 0.13074968755245 and x < 0.13849928975105 then
		return 7200
	elseif x >= 0.13849928975105 and x < 0.14227473735809 then
		return 7300
	elseif x >= 0.14227473735809 and x < 0.15002433955669 then
		return 7350
	elseif x >= 0.15002433955669 and x < 0.16154938936234 then
		return 7450
	elseif x >= 0.16154938936234 and x < 0.17307443916798 then
		return 7600
	elseif x >= 0.17307443916798 and x < 0.18459948897362 then
		return 7750
	elseif x >= 0.18459948897362 and x < 0.19612453877926 then
		return 7900
	elseif x >= 0.19612453877926 and x < 0.2066560536623 then
		return 8050
	elseif x >= 0.2066560536623 and x < 0.21996946632862 then
		return 8200
	elseif x >= 0.21996946632862 and x < 0.22334749996662 then
		return 8400
	elseif x >= 0.22334749996662 and x < 0.2366609275341 then
		return 8450
	elseif x >= 0.2366609275341 and x < 0.24997434020042 then
		return 8650
	elseif x >= 0.24997434020042 and x < 0.25335237383842 then
		return 8850
	elseif x >= 0.25335237383842 and x < 0.26666578650475 then
		return 8900
	elseif x >= 0.26666578650475 and x < 0.27997919917107 then
		return 9100
	elseif x >= 0.27997919917107 and x < 0.28335723280907 then
		return 9300
	elseif x >= 0.28335723280907 and x < 0.29667064547539 then
		return 9350
	elseif x >= 0.29667064547539 and x < 0.30004867911339 then
		return 9550
	elseif x >= 0.30004867911339 and x < 0.31256726384163 then
		return 9600
	elseif x >= 0.31256726384163 and x < 0.32488715648651 then
		return 9650
	elseif x >= 0.32488715648651 and x < 0.33740574121475 then
		return 9700
	elseif x >= 0.33740574121475 and x < 0.34992432594299 then
		return 9750
	elseif x >= 0.34992432594299 and x < 0.36244291067123 then
		return 9800
	elseif x >= 0.36244291067123 and x < 0.37496149539948 then
		return 9850
	elseif x >= 0.37496149539948 and x < 0.38748010993004 then
		return 9900
	elseif x >= 0.38748010993004 and x < 0.39999869465828 then
		return 9950
	elseif x >= 0.39999869465828 and x < 0.41251727938652 then
		return 10000
	elseif x >= 0.41251727938652 and x < 0.41748496890068 then
		return 10250
	elseif x >= 0.41748496890068 and x < 0.43000355362892 then
		return 10350
	elseif x >= 0.43000355362892 and x < 0.44252213835716 then
		return 10600
	elseif x >= 0.44252213835716 and x < 0.44748982787132 then
		return 10850
	elseif x >= 0.44748982787132 and x < 0.46000841259956 then
		return 10950
	elseif x >= 0.46000841259956 and x < 0.46497610211372 then
		return 11200
	elseif x >= 0.46497610211372 and x < 0.47749471664429 then
		return 11300
	elseif x >= 0.47749471664429 and x < 0.49001330137253 then
		return 11550
	elseif x >= 0.49001330137253 and x < 0.49498099088669 then
		return 11800
	elseif x >= 0.49498099088669 and x < 0.50749957561493 then
		return 11900
	elseif x >= 0.50749957561493 and x < 0.52001816034317 then
		return 12150
	elseif x >= 0.52001816034317 and x < 0.52498584985733 then
		return 12400
	elseif x >= 0.52498584985733 and x < 0.53750443458557 then
		return 12500
	elseif x >= 0.53750443458557 and x < 0.55002301931381 then
		return 12750
	elseif x >= 0.55002301931381 and x < 0.55499070882797 then
		return 13000
	elseif x >= 0.55499070882797 and x < 0.56750929355621 then
		return 13100
	elseif x >= 0.56750929355621 and x < 0.57247698307037 then
		return 13350
	elseif x >= 0.57247698307037 and x < 0.58499556779861 then
		return 13450
	elseif x >= 0.58499556779861 and x < 0.59751415252686 then
		return 13700
	elseif x >= 0.59751415252686 and x < 0.60248190164566 then
		return 13950
	elseif x >= 0.60248190164566 and x < 0.6150004863739 then
		return 14050
	elseif x >= 0.6150004863739 and x < 0.62751907110214 then
		return 14300
	elseif x >= 0.62751907110214 and x < 0.6324867606163 then
		return 14550
	elseif x >= 0.6324867606163 and x < 0.64500534534454 then
		return 14650
	elseif x >= 0.64500534534454 and x < 0.65752393007278 then
		return 14900
	elseif x >= 0.65752393007278 and x < 0.66249161958694 then
		return 15150
	elseif x >= 0.66249161958694 and x < 0.67501020431519 then
		return 15250
	elseif x >= 0.67501020431519 and x < 0.67997789382935 then
		return 15500
	elseif x >= 0.67997789382935 and x < 0.69249647855759 then
		return 15600
	elseif x >= 0.69249647855759 and x < 0.70501506328583 then
		return 15850
	elseif x >= 0.70501506328583 and x < 0.71832847595215 then
		return 16150
	elseif x >= 0.71832847595215 and x < 0.72667419910431 then
		return 16550
	elseif x >= 0.72667419910431 and x < 0.73998761177063 then
		return 16800
	elseif x >= 0.73998761177063 and x < 0.74833333492279 then
		return 17200
	elseif x >= 0.74833333492279 and x < 0.75667905807495 then
		return 17450
	elseif x >= 0.75667905807495 and x < 0.76999247074127 then
		return 17700
	elseif x >= 0.76999247074127 and x < 0.77833825349808 then
		return 18100
	elseif x >= 0.77833825349808 and x < 0.7916516661644 then
		return 18350
	elseif x >= 0.7916516661644 and x < 0.79999738931656 then
		return 18750
	elseif x >= 0.79999738931656 and x < 0.80874049663544 then
		return 19000
	elseif x >= 0.80874049663544 and x < 0.82125908136368 then
		return 19350
	elseif x >= 0.82125908136368 and x < 0.8300022482872 then
		return 19850
	elseif x >= 0.8300022482872 and x < 0.83874535560608 then
		return 20200
	elseif x >= 0.83874535560608 and x < 0.8474885225296 then
		return 20550
	elseif x >= 0.8474885225296 and x < 0.86000710725784 then
		return 20900
	elseif x >= 0.86000710725784 and x < 0.86875027418137 then
		return 21400
	elseif x >= 0.86875027418137 and x < 0.87749338150024 then
		return 21750
	elseif x >= 0.87749338150024 and x < 0.89001196622849 then
		return 22100
	elseif x >= 0.89001196622849 and x < 0.89875513315201 then
		return 22600
	elseif x >= 0.89875513315201 and x < 0.90749824047089 then
		return 22950
	elseif x >= 0.90749824047089 and x < 0.92001682519913 then
		return 23150
	elseif x >= 0.92001682519913 and x < 0.92498451471329 then
		return 23400
	elseif x >= 0.92498451471329 and x < 0.93750309944153 then
		return 23500
	elseif x >= 0.93750309944153 and x < 0.95002168416977 then
		return 23750
	elseif x >= 0.95002168416977 and x < 0.95498943328857 then
		return 24000
	elseif x >= 0.95498943328857 and x < 0.96750801801682 then
		return 24100
	elseif x >= 0.96750801801682 and x < 0.97247570753098 then
		return 24350
	elseif x >= 0.97247570753098 and x < 0.98499429225922 then
		return 24450
	elseif x >= 0.98499429225922 and x < 1.0 then
		return 24700
	elseif x == 1.0 then
		return 25000
	end
end

function s432:getFreqHFNormVal(y)--Returns normalized frequency value of S432 high band.
	y = limit(y, 5700, 25000)
	if y >= 5700 and y < 5750 then
		return 0.0
	elseif y >= 5750 and y < 6050 then
		return 0.0045702778734267
	elseif y >= 6050 and y < 6100 then
		return 0.031793240457773
	elseif y >= 6100 and y < 6150 then
		return 0.036363516002893
	elseif y >= 6150 and y < 6450 then
		return 0.040933795273304
	elseif y >= 6450 and y < 6500 then
		return 0.068156756460667
	elseif y >= 6500 and y < 6550 then
		return 0.072727032005787
	elseif y >= 6550 and y < 6900 then
		return 0.077297315001488
	elseif y >= 6900 and y < 7050 then
		return 0.10769959539175
	elseif y >= 7050 and y < 7200 then
		return 0.11922464519739
	elseif y >= 7200 and y < 7300 then
		return 0.13074968755245
	elseif y >= 7300 and y < 7350 then
		return 0.13849928975105
	elseif y >= 7350 and y < 7450 then
		return 0.14227473735809
	elseif y >= 7450 and y < 7600 then
		return 0.15002433955669
	elseif y >= 7600 and y < 7750 then
		return 0.16154938936234
	elseif y >= 7750 and y < 7900 then
		return 0.17307443916798
	elseif y >= 7900 and y < 8050 then
		return 0.18459948897362
	elseif y >= 8050 and y < 8200 then
		return 0.19612453877926
	elseif y >= 8200 and y < 8400 then
		return 0.2066560536623
	elseif y >= 8400 and y < 8450 then
		return 0.21996946632862
	elseif y >= 8450 and y < 8650 then
		return 0.22334749996662
	elseif y >= 8650 and y < 8850 then
		return 0.2366609275341
	elseif y >= 8850 and y < 8900 then
		return 0.24997434020042
	elseif y >= 8900 and y < 9100 then
		return 0.25335237383842
	elseif y >= 9100 and y < 9300 then
		return 0.26666578650475
	elseif y >= 9300 and y < 9350 then
		return 0.27997919917107
	elseif y >= 9350 and y < 9550 then
		return 0.28335723280907
	elseif y >= 9550 and y < 9600 then
		return 0.29667064547539
	elseif y >= 9600 and y < 9650 then
		return 0.30004867911339
	elseif y >= 9650 and y < 9700 then
		return 0.31256726384163
	elseif y >= 9700 and y < 9750 then
		return 0.32488715648651
	elseif y >= 9750 and y < 9800 then
		return 0.33740574121475
	elseif y >= 9800 and y < 9850 then
		return 0.34992432594299
	elseif y >= 9850 and y < 9900 then
		return 0.36244291067123
	elseif y >= 9900 and y < 9950 then
		return 0.37496149539948
	elseif y >= 9950 and y < 10000 then
		return 0.38748010993004
	elseif y >= 10000 and y < 10250 then
		return 0.39999869465828
	elseif y >= 10250 and y < 10350 then
		return 0.41251727938652
	elseif y >= 10350 and y < 10600 then
		return 0.41748496890068
	elseif y >= 10600 and y < 10850 then
		return 0.43000355362892
	elseif y >= 10850 and y < 10950 then
		return 0.44252213835716
	elseif y >= 10950 and y < 11200 then
		return 0.44748982787132
	elseif y >= 11200 and y < 11300 then
		return 0.46000841259956
	elseif y >= 11300 and y < 11550 then
		return 0.46497610211372
	elseif y >= 11550 and y < 11800 then
		return 0.47749471664429
	elseif y >= 11800 and y < 11900 then
		return 0.49001330137253
	elseif y >= 11900 and y < 12150 then
		return 0.49498099088669
	elseif y >= 12150 and y < 12400 then
		return 0.50749957561493
	elseif y >= 12400 and y < 12500 then
		return 0.52001816034317
	elseif y >= 12500 and y < 12750 then
		return 0.52498584985733
	elseif y >= 12750 and y < 13000 then
		return 0.53750443458557
	elseif y >= 13000 and y < 13100 then
		return 0.55002301931381
	elseif y >= 13100 and y < 13350 then
		return 0.55499070882797
	elseif y >= 13350 and y < 13450 then
		return 0.56750929355621
	elseif y >= 13450 and y < 13700 then
		return 0.57247698307037
	elseif y >= 13700 and y < 13950 then
		return 0.58499556779861
	elseif y >= 13950 and y < 14050 then
		return 0.59751415252686
	elseif y >= 14050 and y < 14300 then
		return 0.60248190164566
	elseif y >= 14300 and y < 14550 then
		return 0.6150004863739
	elseif y >= 14550 and y < 14650 then
		return 0.62751907110214
	elseif y >= 14650 and y < 14900 then
		return 0.6324867606163
	elseif y >= 14900 and y < 15150 then
		return 0.64500534534454
	elseif y >= 15150 and y < 15250 then
		return 0.65752393007278
	elseif y >= 15250 and y < 15500 then
		return 0.66249161958694
	elseif y >= 15500 and y < 15600 then
		return 0.67501020431519
	elseif y >= 15600 and y < 15850 then
		return 0.67997789382935
	elseif y >= 15850 and y < 16150 then
		return 0.69249647855759
	elseif y >= 16150 and y < 16550 then
		return 0.70501506328583
	elseif y >= 16550 and y < 16800 then
		return 0.71832847595215
	elseif y >= 16800 and y < 17200 then
		return 0.72667419910431
	elseif y >= 17200 and y < 17450 then
		return 0.73998761177063
	elseif y >= 17450 and y < 17700 then
		return 0.74833333492279
	elseif y >= 17700 and y < 18100 then
		return 0.75667905807495
	elseif y >= 18100 and y < 18350 then
		return 0.76999247074127
	elseif y >= 18350 and y < 18750 then
		return 0.77833825349808
	elseif y >= 18750 and y < 19000 then
		return 0.7916516661644
	elseif y >= 19000 and y < 19350 then
		return 0.79999738931656
	elseif y >= 19350 and y < 19850 then
		return 0.80874049663544
	elseif y >= 19850 and y < 20200 then
		return 0.82125908136368
	elseif y >= 20200 and y < 20550 then
		return 0.8300022482872
	elseif y >= 20550 and y < 20900 then
		return 0.83874535560608
	elseif y >= 20900 and y < 21400 then
		return 0.8474885225296
	elseif y >= 21400 and y < 21750 then
		return 0.86000710725784
	elseif y >= 21750 and y < 22100 then
		return 0.86875027418137
	elseif y >= 22100 and y < 22600 then
		return 0.87749338150024
	elseif y >= 22600 and y < 22950 then
		return 0.89001196622849
	elseif y >= 22950 and y < 23150 then
		return 0.89875513315201
	elseif y >= 23150 and y < 23400 then
		return 0.90749824047089
	elseif y >= 23400 and y < 23500 then
		return 0.92001682519913
	elseif y >= 23500 and y < 23750 then
		return 0.92498451471329
	elseif y >= 23750 and y < 24000 then
		return 0.93750309944153
	elseif y >= 24000 and y < 24100 then
		return 0.95002168416977
	elseif y >= 24100 and y < 24350 then
		return 0.95498943328857
	elseif y >= 24350 and y < 24450 then
		return 0.96750801801682
	elseif y >= 24450 and y < 24700 then
		return 0.97247570753098
	elseif y >= 24700 and y < 25000 then
		return 0.98499429225922
	elseif y == 25000 then
		return 1.0
	end
end

return s432