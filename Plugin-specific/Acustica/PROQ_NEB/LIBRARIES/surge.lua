local surge = {}


surge.param = {gain=2, freq = 3, Q = 4}

--x represents normalized parameter value
--y represents readout value from library; used for input into pro-q equation.

--LOCAL FUNCTIONS:
local function limit(val, min, max)
	if val < min then return min
	elseif val > max then return max
	else return val end
end

function surge:getQVal(x)--Returns Q value of GML 8200 to pass into pro-q.
	x = limit(x, 0, 1)
	if x <=.5 then
		return (2.2003*x)+.40
	else
		return (5.000*x)-1--0.9972
	end
end

function surge:getQNormVal(y)--Returns normalized value of Q for GML 8200.
	y = limit(y, .4, 4)
	if y <= 1.5 then
		return math.abs((y-.40)/2.2003)
	else
		return ((y+0.9972)/5.000)+0.00056
	end
end

function surge:getGainVal(x)--Returns gain value to pass into pro-q.
	x = limit(x, 0, 1)
	return (30*x)-15
end

function surge:getGainNormVal(y)--Returns normalized value of gain for GML 8200.
	y = limit(y, -15, 15)
	return (y+15)/30
end

function surge:getFreqLFShelfVal(x)--Returns frequency value of GML 8200 low frequency shelf to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.016890158876777 then
		return 15
	elseif x >= 0.016890158876777 and x < 0.050869181752205 then
		return 16
	elseif x >= 0.050869181752205 and x < 0.083655960857868 then
		return 17
	elseif x >= 0.083655960857868 and x < 0.11723756790161 then
		return 18
	elseif x >= 0.11723756790161 and x < 0.15002433955669 then
		return 19
	elseif x >= 0.15002433955669 and x < 0.16949769854546 then
		return 20
	elseif x >= 0.16949769854546 and x < 0.17545893788338 then
		return 21
	elseif x >= 0.17545893788338 and x < 0.18082404136658 then
		return 22
	elseif x >= 0.18082404136658 and x < 0.18638786673546 then
		return 23
	elseif x >= 0.18638786673546 and x < 0.19175297021866 then
		return 24
	elseif x >= 0.19175297021866 and x < 0.1979129165411 then
		return 25
	elseif x >= 0.1979129165411 and x < 0.2032780200243 then
		return 26
	elseif x >= 0.2032780200243 and x < 0.2086431235075 then
		return 27
	elseif x >= 0.2086431235075 and x < 0.21480306982994 then
		return 28
	elseif x >= 0.21480306982994 and x < 0.22016817331314 then
		return 29
	elseif x >= 0.22016817331314 and x < 0.22533458471298 then
		return 30
	elseif x >= 0.22533458471298 and x < 0.23069968819618 then
		return 31
	elseif x >= 0.23069968819618 and x < 0.23685963451862 then
		return 32
	elseif x >= 0.23685963451862 and x < 0.24222473800182 then
		return 33
	elseif x >= 0.24222473800182 and x < 0.24758984148502 then
		return 34
	elseif x >= 0.24758984148502 and x < 0.25374978780746 then
		return 35
	elseif x >= 0.25374978780746 and x < 0.25911489129066 then
		return 36
	elseif x >= 0.25911489129066 and x < 0.26447999477386 then
		return 37
	elseif x >= 0.26447999477386 and x < 0.26964640617371 then
		return 38
	elseif x >= 0.26964640617371 and x < 0.27501150965691 then
		return 39
	elseif x >= 0.27501150965691 and x < 0.28117144107819 then
		return 40
	elseif x >= 0.28117144107819 and x < 0.28653657436371 then
		return 41
	elseif x >= 0.28653657436371 and x < 0.29190167784691 then
		return 42
	elseif x >= 0.29190167784691 and x < 0.29806160926819 then
		return 43
	elseif x >= 0.29806160926819 and x < 0.30342671275139 then
		return 44
	elseif x >= 0.30342671275139 and x < 0.30859312415123 then
		return 45
	elseif x >= 0.30859312415123 and x < 0.31395822763443 then
		return 46
	elseif x >= 0.31395822763443 and x < 0.31991946697235 then
		return 47
	elseif x >= 0.31991946697235 and x < 0.32528457045555 then
		return 48
	elseif x >= 0.32528457045555 and x < 0.33084839582443 then
		return 49
	elseif x >= 0.33084839582443 and x < 0.33442512154579 then
		return 50
	elseif x >= 0.33442512154579 and x < 0.33621349930763 then
		return 51
	elseif x >= 0.33621349930763 and x < 0.33800187706947 then
		return 52
	elseif x >= 0.33800187706947 and x < 0.33979022502899 then
		return 53
	elseif x >= 0.33979022502899 and x < 0.34137991070747 then
		return 54
	elseif x >= 0.34137991070747 and x < 0.34277084469795 then
		return 55
	elseif x >= 0.34277084469795 and x < 0.34455922245979 then
		return 56
	elseif x >= 0.34455922245979 and x < 0.34674501419067 then
		return 57
	elseif x >= 0.34674501419067 and x < 0.34773853421211 then
		return 58
	elseif x >= 0.34773853421211 and x < 0.34952691197395 then
		return 59
	elseif x >= 0.34952691197395 and x < 0.35111656785011 then
		return 60
	elseif x >= 0.35111656785011 and x < 0.35270625352859 then
		return 61
	elseif x >= 0.35270625352859 and x < 0.35469332337379 then
		return 62
	elseif x >= 0.35469332337379 and x < 0.35648170113564 then
		return 63
	elseif x >= 0.35648170113564 and x < 0.35827004909515 then
		return 64
	elseif x >= 0.35827004909515 and x < 0.35946229100227 then
		return 65
	elseif x >= 0.35946229100227 and x < 0.36085325479507 then
		return 66
	elseif x >= 0.36085325479507 and x < 0.36264163255692 then
		return 67
	elseif x >= 0.36264163255692 and x < 0.36443001031876 then
		return 68
	elseif x >= 0.36443001031876 and x < 0.36621835827827 then
		return 69
	elseif x >= 0.36621835827827 and x < 0.36760932207108 then
		return 70
	elseif x >= 0.36760932207108 and x < 0.36979511380196 then
		return 71
	elseif x >= 0.36979511380196 and x < 0.3715834915638 then
		return 72
	elseif x >= 0.3715834915638 and x < 0.37337183952332 then
		return 73
	elseif x >= 0.37337183952332 and x < 0.37456408143044 then
		return 74
	elseif x >= 0.37456408143044 and x < 0.37595504522324 then
		return 75
	elseif x >= 0.37595504522324 and x < 0.37774342298508 then
		return 76
	elseif x >= 0.37774342298508 and x < 0.37953180074692 then
		return 77
	elseif x >= 0.37953180074692 and x < 0.38132014870644 then
		return 78
	elseif x >= 0.38132014870644 and x < 0.38271111249924 then
		return 79
	elseif x >= 0.38271111249924 and x < 0.38489690423012 then
		return 80
	elseif x >= 0.38489690423012 and x < 0.38668525218964 then
		return 81
	elseif x >= 0.38668525218964 and x < 0.38807621598244 then
		return 82
	elseif x >= 0.38807621598244 and x < 0.38926845788956 then
		return 83
	elseif x >= 0.38926845788956 and x < 0.3910568356514 then
		return 84
	elseif x >= 0.3910568356514 and x < 0.39284521341324 then
		return 85
	elseif x >= 0.39284521341324 and x < 0.39463356137276 then
		return 86
	elseif x >= 0.39463356137276 and x < 0.3964219391346 then
		return 87
	elseif x >= 0.3964219391346 and x < 0.39821031689644 then
		return 88
	elseif x >= 0.39821031689644 and x < 0.39999869465828 then
		return 89
	elseif x >= 0.39999869465828 and x < 0.4017870426178 then
		return 90
	elseif x >= 0.4017870426178 and x < 0.40258187055588 then
		return 91
	elseif x >= 0.40258187055588 and x < 0.40437024831772 then
		return 92
	elseif x >= 0.40437024831772 and x < 0.40615862607956 then
		return 93
	elseif x >= 0.40615862607956 and x < 0.4079470038414 then
		return 94
	elseif x >= 0.4079470038414 and x < 0.40973535180092 then
		return 95
	elseif x >= 0.40973535180092 and x < 0.41152372956276 then
		return 96
	elseif x >= 0.41152372956276 and x < 0.4133121073246 then
		return 97
	elseif x >= 0.4133121073246 and x < 0.41510048508644 then
		return 98
	elseif x >= 0.41510048508644 and x < 0.41589531302452 then
		return 99
	elseif x >= 0.41589531302452 and x < 0.42463845014572 then
		return 100
	elseif x >= 0.42463845014572 and x < 0.4327854514122 then
		return 105
	elseif x >= 0.4327854514122 and x < 0.4415285885334 then
		return 110
	elseif x >= 0.4415285885334 and x < 0.44947689771652 then
		return 115
	elseif x >= 0.44947689771652 and x < 0.4584187567234 then
		return 120
	elseif x >= 0.4584187567234 and x < 0.46636706590652 then
		return 125
	elseif x >= 0.46636706590652 and x < 0.47431537508965 then
		return 130
	elseif x >= 0.47431537508965 and x < 0.48325723409653 then
		return 135
	elseif x >= 0.48325723409653 and x < 0.49120554327965 then
		return 140
	elseif x >= 0.49120554327965 and x < 0.49994868040085 then
		return 145
	elseif x >= 0.49994868040085 and x < 0.50531381368637 then
		return 150
	elseif x >= 0.50531381368637 and x < 0.51067888736725 then
		return 155
	elseif x >= 0.51067888736725 and x < 0.51644140481949 then
		return 160
	elseif x >= 0.51644140481949 and x < 0.52220392227173 then
		return 165
	elseif x >= 0.52220392227173 and x < 0.52756905555725 then
		return 170
	elseif x >= 0.52756905555725 and x < 0.53353029489517 then
		return 175
	elseif x >= 0.53353029489517 and x < 0.53909409046173 then
		return 180
	elseif x >= 0.53909409046173 and x < 0.54426050186157 then
		return 185
	elseif x >= 0.54426050186157 and x < 0.54962563514709 then
		return 190
	elseif x >= 0.54962563514709 and x < 0.55578553676605 then
		return 195
	elseif x >= 0.55578553676605 and x < 0.56115067005157 then
		return 200
	elseif x >= 0.56115067005157 and x < 0.56651574373245 then
		return 205
	elseif x >= 0.56651574373245 and x < 0.57168215513229 then
		return 210
	elseif x >= 0.57168215513229 and x < 0.57804083824158 then
		return 215
	elseif x >= 0.57804083824158 and x < 0.58320724964142 then
		return 220
	elseif x >= 0.58320724964142 and x < 0.5885723233223 then
		return 225
	elseif x >= 0.5885723233223 and x < 0.59393745660782 then
		return 230
	elseif x >= 0.59393745660782 and x < 0.60009735822678 then
		return 235
	elseif x >= 0.60009735822678 and x < 0.6054624915123 then
		return 240
	elseif x >= 0.6054624915123 and x < 0.61082762479782 then
		return 245
	elseif x >= 0.61082762479782 and x < 0.61659014225006 then
		return 250
	elseif x >= 0.61659014225006 and x < 0.62195521593094 then
		return 255
	elseif x >= 0.62195521593094 and x < 0.62751907110214 then
		return 260
	elseif x >= 0.62751907110214 and x < 0.63288414478302 then
		return 265
	elseif x >= 0.63288414478302 and x < 0.63904410600662 then
		return 270
	elseif x >= 0.63904410600662 and x < 0.6444091796875 then
		return 275
	elseif x >= 0.6444091796875 and x < 0.64977431297302 then
		return 280
	elseif x >= 0.64977431297302 and x < 0.65593427419662 then
		return 285
	elseif x >= 0.65593427419662 and x < 0.6612993478775 then
		return 290
	elseif x >= 0.6612993478775 and x < 0.66666448116302 then
		return 295
	elseif x >= 0.66666448116302 and x < 0.66924768686295 then
		return 300
	elseif x >= 0.66924768686295 and x < 0.67799079418182 then
		return 305
	elseif x >= 0.67799079418182 and x < 0.68077272176743 then
		return 320
	elseif x >= 0.68077272176743 and x < 0.68335592746735 then
		return 325
	elseif x >= 0.68335592746735 and x < 0.68613785505295 then
		return 330
	elseif x >= 0.68613785505295 and x < 0.68872106075287 then
		return 335
	elseif x >= 0.68872106075287 and x < 0.69766288995743 then
		return 340
	elseif x >= 0.69766288995743 and x < 0.70024609565735 then
		return 355
	elseif x >= 0.70024609565735 and x < 0.70282930135727 then
		return 360
	elseif x >= 0.70282930135727 and x < 0.70561116933823 then
		return 365
	elseif x >= 0.70561116933823 and x < 0.70819437503815 then
		return 370
	elseif x >= 0.70819437503815 and x < 0.71713626384735 then
		return 375
	elseif x >= 0.71713626384735 and x < 0.71971946954727 then
		return 390
	elseif x >= 0.71971946954727 and x < 0.72230261564255 then
		return 395
	elseif x >= 0.72230261564255 and x < 0.72508454322815 then
		return 400
	elseif x >= 0.72508454322815 and x < 0.72766774892807 then
		return 405
	elseif x >= 0.72766774892807 and x < 0.74177598953247 then
		return 410
	elseif x >= 0.74177598953247 and x < 0.74455791711807 then
		return 435
	elseif x >= 0.74455791711807 and x < 0.74714112281799 then
		return 440
	elseif x >= 0.74714112281799 and x < 0.74992299079895 then
		return 445
	elseif x >= 0.74992299079895 and x < 0.75250619649887 then
		return 450
	elseif x >= 0.75250619649887 and x < 0.75568556785583 then
		return 455
	elseif x >= 0.75568556785583 and x < 0.75846743583679 then
		return 460
	elseif x >= 0.75846743583679 and x < 0.76105064153671 then
		return 465
	elseif x >= 0.76105064153671 and x < 0.76383256912231 then
		return 470
	elseif x >= 0.76383256912231 and x < 0.76661449670792 then
		return 475
	elseif x >= 0.76661449670792 and x < 0.76919764280319 then
		return 480
	elseif x >= 0.76919764280319 and x < 0.77197957038879 then
		return 485
	elseif x >= 0.77197957038879 and x < 0.78092139959335 then
		return 490
	elseif x >= 0.78092139959335 and x < 0.78350460529327 then
		return 505
	elseif x >= 0.78350460529327 and x < 0.78608781099319 then
		return 510
	elseif x >= 0.78608781099319 and x < 0.7888697385788 then
		return 515
	elseif x >= 0.7888697385788 and x < 0.79145294427872 then
		return 520
	elseif x >= 0.79145294427872 and x < 0.80039477348328 then
		return 525
	elseif x >= 0.80039477348328 and x < 0.8029779791832 then
		return 540
	elseif x >= 0.8029779791832 and x < 0.80556118488312 then
		return 545
	elseif x >= 0.80556118488312 and x < 0.80834311246872 then
		return 550
	elseif x >= 0.80834311246872 and x < 0.81092631816864 then
		return 555
	elseif x >= 0.81092631816864 and x < 0.82245135307312 then
		return 560
	elseif x >= 0.82245135307312 and x < 0.82523328065872 then
		return 580
	elseif x >= 0.82523328065872 and x < 0.827816426754 then
		return 585
	elseif x >= 0.827816426754 and x < 0.83039963245392 then
		return 590
	elseif x >= 0.83039963245392 and x < 0.83755314350128 then
		return 595
	elseif x >= 0.83755314350128 and x < 0.84192472696304 then
		return 605
	elseif x >= 0.84192472696304 and x < 0.84550142288208 then
		return 610
	elseif x >= 0.84550142288208 and x < 0.84987300634384 then
		return 615
	elseif x >= 0.84987300634384 and x < 0.85444331169128 then
		return 620
	elseif x >= 0.85444331169128 and x < 0.86239159107208 then
		return 625
	elseif x >= 0.86239159107208 and x < 0.86676317453384 then
		return 635
	elseif x >= 0.86676317453384 and x < 0.87113475799561 then
		return 640
	elseif x >= 0.87113475799561 and x < 0.87471145391464 then
		return 645
	elseif x >= 0.87471145391464 and x < 0.8790830373764 then
		return 650
	elseif x >= 0.8790830373764 and x < 0.88365334272385 then
		return 655
	elseif x >= 0.88365334272385 and x < 0.89160162210464 then
		return 660
	elseif x >= 0.89160162210464 and x < 0.89597320556641 then
		return 670
	elseif x >= 0.89597320556641 and x < 0.90034478902817 then
		return 675
	elseif x >= 0.90034478902817 and x < 0.90392154455185 then
		return 680
	elseif x >= 0.90392154455185 and x < 0.90849179029465 then
		return 685
	elseif x >= 0.90849179029465 and x < 0.91286337375641 then
		return 690
	elseif x >= 0.91286337375641 and x < 0.91663879156113 then
		return 695
	elseif x >= 0.91663879156113 and x < 0.92081165313721 then
		return 700
	elseif x >= 0.92081165313721 and x < 0.92498451471329 then
		return 705
	elseif x >= 0.92498451471329 and x < 0.92875999212265 then
		return 710
	elseif x >= 0.92875999212265 and x < 0.93313157558441 then
		return 715
	elseif x >= 0.93313157558441 and x < 0.93770182132721 then
		return 720
	elseif x >= 0.93770182132721 and x < 0.94187468290329 then
		return 725
	elseif x >= 0.94187468290329 and x < 0.94565016031265 then
		return 730
	elseif x >= 0.94565016031265 and x < 0.95002168416977 then
		return 735
	elseif x >= 0.95002168416977 and x < 0.95439326763153 then
		return 740
	elseif x >= 0.95439326763153 and x < 0.95797002315521 then
		return 745
	elseif x >= 0.95797002315521 and x < 0.96254032850266 then
		return 750
	elseif x >= 0.96254032850266 and x < 0.96671319007874 then
		return 755
	elseif x >= 0.96671319007874 and x < 0.97486019134521 then
		return 760
	elseif x >= 0.97486019134521 and x < 0.97923177480698 then
		return 770
	elseif x >= 0.97923177480698 and x < 0.98320591449738 then
		return 775
	elseif x >= 0.98320591449738 and x < 0.98718005418777 then
		return 780
	elseif x >= 0.98718005418777 and x < 0.99155163764954 then
		return 785
	elseif x >= 0.99155163764954 and x < 1.0 then
		return 790
	elseif x == 1.0 then
		return 800
	end
end

function surge:getFreqLFShelfNormVal(y)--Returns normalized value of low frequency shelf for GML 8200.
	y = limit(y, 15, 800)
	if y >= 15 and y < 16 then
		return 0.0
	elseif y >= 16 and y < 17 then
		return 0.016890158876777
	elseif y >= 17 and y < 18 then
		return 0.050869181752205
	elseif y >= 18 and y < 19 then
		return 0.083655960857868
	elseif y >= 19 and y < 20 then
		return 0.11723756790161
	elseif y >= 20 and y < 21 then
		return 0.15002433955669
	elseif y >= 21 and y < 22 then
		return 0.16949769854546
	elseif y >= 22 and y < 23 then
		return 0.17545893788338
	elseif y >= 23 and y < 24 then
		return 0.18082404136658
	elseif y >= 24 and y < 25 then
		return 0.18638786673546
	elseif y >= 25 and y < 26 then
		return 0.19175297021866
	elseif y >= 26 and y < 27 then
		return 0.1979129165411
	elseif y >= 27 and y < 28 then
		return 0.2032780200243
	elseif y >= 28 and y < 29 then
		return 0.2086431235075
	elseif y >= 29 and y < 30 then
		return 0.21480306982994
	elseif y >= 30 and y < 31 then
		return 0.22016817331314
	elseif y >= 31 and y < 32 then
		return 0.22533458471298
	elseif y >= 32 and y < 33 then
		return 0.23069968819618
	elseif y >= 33 and y < 34 then
		return 0.23685963451862
	elseif y >= 34 and y < 35 then
		return 0.24222473800182
	elseif y >= 35 and y < 36 then
		return 0.24758984148502
	elseif y >= 36 and y < 37 then
		return 0.25374978780746
	elseif y >= 37 and y < 38 then
		return 0.25911489129066
	elseif y >= 38 and y < 39 then
		return 0.26447999477386
	elseif y >= 39 and y < 40 then
		return 0.26964640617371
	elseif y >= 40 and y < 41 then
		return 0.27501150965691
	elseif y >= 41 and y < 42 then
		return 0.28117144107819
	elseif y >= 42 and y < 43 then
		return 0.28653657436371
	elseif y >= 43 and y < 44 then
		return 0.29190167784691
	elseif y >= 44 and y < 45 then
		return 0.29806160926819
	elseif y >= 45 and y < 46 then
		return 0.30342671275139
	elseif y >= 46 and y < 47 then
		return 0.30859312415123
	elseif y >= 47 and y < 48 then
		return 0.31395822763443
	elseif y >= 48 and y < 49 then
		return 0.31991946697235
	elseif y >= 49 and y < 50 then
		return 0.32528457045555
	elseif y >= 50 and y < 51 then
		return 0.33084839582443
	elseif y >= 51 and y < 52 then
		return 0.33442512154579
	elseif y >= 52 and y < 53 then
		return 0.33621349930763
	elseif y >= 53 and y < 54 then
		return 0.33800187706947
	elseif y >= 54 and y < 55 then
		return 0.33979022502899
	elseif y >= 55 and y < 56 then
		return 0.34137991070747
	elseif y >= 56 and y < 57 then
		return 0.34277084469795
	elseif y >= 57 and y < 58 then
		return 0.34455922245979
	elseif y >= 58 and y < 59 then
		return 0.34674501419067
	elseif y >= 59 and y < 60 then
		return 0.34773853421211
	elseif y >= 60 and y < 61 then
		return 0.34952691197395
	elseif y >= 61 and y < 62 then
		return 0.35111656785011
	elseif y >= 62 and y < 63 then
		return 0.35270625352859
	elseif y >= 63 and y < 64 then
		return 0.35469332337379
	elseif y >= 64 and y < 65 then
		return 0.35648170113564
	elseif y >= 65 and y < 66 then
		return 0.35827004909515
	elseif y >= 66 and y < 67 then
		return 0.35946229100227
	elseif y >= 67 and y < 68 then
		return 0.36085325479507
	elseif y >= 68 and y < 69 then
		return 0.36264163255692
	elseif y >= 69 and y < 70 then
		return 0.36443001031876
	elseif y >= 70 and y < 71 then
		return 0.36621835827827
	elseif y >= 71 and y < 72 then
		return 0.36760932207108
	elseif y >= 72 and y < 73 then
		return 0.36979511380196
	elseif y >= 73 and y < 74 then
		return 0.3715834915638
	elseif y >= 74 and y < 75 then
		return 0.37337183952332
	elseif y >= 75 and y < 76 then
		return 0.37456408143044
	elseif y >= 76 and y < 77 then
		return 0.37595504522324
	elseif y >= 77 and y < 78 then
		return 0.37774342298508
	elseif y >= 78 and y < 79 then
		return 0.37953180074692
	elseif y >= 79 and y < 80 then
		return 0.38132014870644
	elseif y >= 80 and y < 81 then
		return 0.38271111249924
	elseif y >= 81 and y < 82 then
		return 0.38489690423012
	elseif y >= 82 and y < 83 then
		return 0.38668525218964
	elseif y >= 83 and y < 84 then
		return 0.38807621598244
	elseif y >= 84 and y < 85 then
		return 0.38926845788956
	elseif y >= 85 and y < 86 then
		return 0.3910568356514
	elseif y >= 86 and y < 87 then
		return 0.39284521341324
	elseif y >= 87 and y < 88 then
		return 0.39463356137276
	elseif y >= 88 and y < 89 then
		return 0.3964219391346
	elseif y >= 89 and y < 90 then
		return 0.39821031689644
	elseif y >= 90 and y < 91 then
		return 0.39999869465828
	elseif y >= 91 and y < 92 then
		return 0.4017870426178
	elseif y >= 92 and y < 93 then
		return 0.40258187055588
	elseif y >= 93 and y < 94 then
		return 0.40437024831772
	elseif y >= 94 and y < 95 then
		return 0.40615862607956
	elseif y >= 95 and y < 96 then
		return 0.4079470038414
	elseif y >= 96 and y < 97 then
		return 0.40973535180092
	elseif y >= 97 and y < 98 then
		return 0.41152372956276
	elseif y >= 98 and y < 99 then
		return 0.4133121073246
	elseif y >= 99 and y < 100 then
		return 0.41510048508644
	elseif y >= 100 and y < 105 then
		return 0.41589531302452
	elseif y >= 105 and y < 110 then
		return 0.42463845014572
	elseif y >= 110 and y < 115 then
		return 0.4327854514122
	elseif y >= 115 and y < 120 then
		return 0.4415285885334
	elseif y >= 120 and y < 125 then
		return 0.44947689771652
	elseif y >= 125 and y < 130 then
		return 0.4584187567234
	elseif y >= 130 and y < 135 then
		return 0.46636706590652
	elseif y >= 135 and y < 140 then
		return 0.47431537508965
	elseif y >= 140 and y < 145 then
		return 0.48325723409653
	elseif y >= 145 and y < 150 then
		return 0.49120554327965
	elseif y >= 150 and y < 155 then
		return 0.49994868040085
	elseif y >= 155 and y < 160 then
		return 0.50531381368637
	elseif y >= 160 and y < 165 then
		return 0.51067888736725
	elseif y >= 165 and y < 170 then
		return 0.51644140481949
	elseif y >= 170 and y < 175 then
		return 0.52220392227173
	elseif y >= 175 and y < 180 then
		return 0.52756905555725
	elseif y >= 180 and y < 185 then
		return 0.53353029489517
	elseif y >= 185 and y < 190 then
		return 0.53909409046173
	elseif y >= 190 and y < 195 then
		return 0.54426050186157
	elseif y >= 195 and y < 200 then
		return 0.54962563514709
	elseif y >= 200 and y < 205 then
		return 0.55578553676605
	elseif y >= 205 and y < 210 then
		return 0.56115067005157
	elseif y >= 210 and y < 215 then
		return 0.56651574373245
	elseif y >= 215 and y < 220 then
		return 0.57168215513229
	elseif y >= 220 and y < 225 then
		return 0.57804083824158
	elseif y >= 225 and y < 230 then
		return 0.58320724964142
	elseif y >= 230 and y < 235 then
		return 0.5885723233223
	elseif y >= 235 and y < 240 then
		return 0.59393745660782
	elseif y >= 240 and y < 245 then
		return 0.60009735822678
	elseif y >= 245 and y < 250 then
		return 0.6054624915123
	elseif y >= 250 and y < 255 then
		return 0.61082762479782
	elseif y >= 255 and y < 260 then
		return 0.61659014225006
	elseif y >= 260 and y < 265 then
		return 0.62195521593094
	elseif y >= 265 and y < 270 then
		return 0.62751907110214
	elseif y >= 270 and y < 275 then
		return 0.63288414478302
	elseif y >= 275 and y < 280 then
		return 0.63904410600662
	elseif y >= 280 and y < 285 then
		return 0.6444091796875
	elseif y >= 285 and y < 290 then
		return 0.64977431297302
	elseif y >= 290 and y < 295 then
		return 0.65593427419662
	elseif y >= 295 and y < 300 then
		return 0.6612993478775
	elseif y >= 300 and y < 305 then
		return 0.66666448116302
	elseif y >= 305 and y < 320 then
		return 0.66924768686295
	elseif y >= 320 and y < 325 then
		return 0.67799079418182
	elseif y >= 325 and y < 330 then
		return 0.68077272176743
	elseif y >= 330 and y < 335 then
		return 0.68335592746735
	elseif y >= 335 and y < 340 then
		return 0.68613785505295
	elseif y >= 340 and y < 355 then
		return 0.68872106075287
	elseif y >= 355 and y < 360 then
		return 0.69766288995743
	elseif y >= 360 and y < 365 then
		return 0.70024609565735
	elseif y >= 365 and y < 370 then
		return 0.70282930135727
	elseif y >= 370 and y < 375 then
		return 0.70561116933823
	elseif y >= 375 and y < 390 then
		return 0.70819437503815
	elseif y >= 390 and y < 395 then
		return 0.71713626384735
	elseif y >= 395 and y < 400 then
		return 0.71971946954727
	elseif y >= 400 and y < 405 then
		return 0.72230261564255
	elseif y >= 405 and y < 410 then
		return 0.72508454322815
	elseif y >= 410 and y < 435 then
		return 0.72766774892807
	elseif y >= 435 and y < 440 then
		return 0.74177598953247
	elseif y >= 440 and y < 445 then
		return 0.74455791711807
	elseif y >= 445 and y < 450 then
		return 0.74714112281799
	elseif y >= 450 and y < 455 then
		return 0.74992299079895
	elseif y >= 455 and y < 460 then
		return 0.75250619649887
	elseif y >= 460 and y < 465 then
		return 0.75568556785583
	elseif y >= 465 and y < 470 then
		return 0.75846743583679
	elseif y >= 470 and y < 475 then
		return 0.76105064153671
	elseif y >= 475 and y < 480 then
		return 0.76383256912231
	elseif y >= 480 and y < 485 then
		return 0.76661449670792
	elseif y >= 485 and y < 490 then
		return 0.76919764280319
	elseif y >= 490 and y < 505 then
		return 0.77197957038879
	elseif y >= 505 and y < 510 then
		return 0.78092139959335
	elseif y >= 510 and y < 515 then
		return 0.78350460529327
	elseif y >= 515 and y < 520 then
		return 0.78608781099319
	elseif y >= 520 and y < 525 then
		return 0.7888697385788
	elseif y >= 525 and y < 540 then
		return 0.79145294427872
	elseif y >= 540 and y < 545 then
		return 0.80039477348328
	elseif y >= 545 and y < 550 then
		return 0.8029779791832
	elseif y >= 550 and y < 555 then
		return 0.80556118488312
	elseif y >= 555 and y < 560 then
		return 0.80834311246872
	elseif y >= 560 and y < 580 then
		return 0.81092631816864
	elseif y >= 580 and y < 585 then
		return 0.82245135307312
	elseif y >= 585 and y < 590 then
		return 0.82523328065872
	elseif y >= 590 and y < 595 then
		return 0.827816426754
	elseif y >= 595 and y < 605 then
		return 0.83039963245392
	elseif y >= 605 and y < 610 then
		return 0.83755314350128
	elseif y >= 610 and y < 615 then
		return 0.84192472696304
	elseif y >= 615 and y < 620 then
		return 0.84550142288208
	elseif y >= 620 and y < 625 then
		return 0.84987300634384
	elseif y >= 625 and y < 635 then
		return 0.85444331169128
	elseif y >= 635 and y < 640 then
		return 0.86239159107208
	elseif y >= 640 and y < 645 then
		return 0.86676317453384
	elseif y >= 645 and y < 650 then
		return 0.87113475799561
	elseif y >= 650 and y < 655 then
		return 0.87471145391464
	elseif y >= 655 and y < 660 then
		return 0.8790830373764
	elseif y >= 660 and y < 670 then
		return 0.88365334272385
	elseif y >= 670 and y < 675 then
		return 0.89160162210464
	elseif y >= 675 and y < 680 then
		return 0.89597320556641
	elseif y >= 680 and y < 685 then
		return 0.90034478902817
	elseif y >= 685 and y < 690 then
		return 0.90392154455185
	elseif y >= 690 and y < 695 then
		return 0.90849179029465
	elseif y >= 695 and y < 700 then
		return 0.91286337375641
	elseif y >= 700 and y < 705 then
		return 0.91663879156113
	elseif y >= 705 and y < 710 then
		return 0.92081165313721
	elseif y >= 710 and y < 715 then
		return 0.92498451471329
	elseif y >= 715 and y < 720 then
		return 0.92875999212265
	elseif y >= 720 and y < 725 then
		return 0.93313157558441
	elseif y >= 725 and y < 730 then
		return 0.93770182132721
	elseif y >= 730 and y < 735 then
		return 0.94187468290329
	elseif y >= 735 and y < 740 then
		return 0.94565016031265
	elseif y >= 740 and y < 745 then
		return 0.95002168416977
	elseif y >= 745 and y < 750 then
		return 0.95439326763153
	elseif y >= 750 and y < 755 then
		return 0.95797002315521
	elseif y >= 755 and y < 760 then
		return 0.96254032850266
	elseif y >= 760 and y < 770 then
		return 0.96671319007874
	elseif y >= 770 and y < 775 then
		return 0.97486019134521
	elseif y >= 775 and y < 780 then
		return 0.97923177480698
	elseif y >= 780 and y < 785 then
		return 0.98320591449738
	elseif y >= 785 and y < 790 then
		return 0.98718005418777
	elseif y >= 790 and y < 800 then
		return 0.99155163764954
	elseif y == 800 then
		return 800
	end
end

function surge:getFreqLFVal(x)--Returns frequency value of GML 8200 low frequency band to pass into pro-q. 
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.0047997599467635 then
		return 15.0
	elseif x >= 0.0047997599467635 and x < 0.013399329967797 then
		return 15.5
	elseif x >= 0.013399329967797 and x < 0.022598870098591 then
		return 16.0
	elseif x >= 0.022598870098591 and x < 0.031398430466652 then
		return 16.5
	elseif x >= 0.031398430466652 and x < 0.039798010140657 then
		return 17.2
	elseif x >= 0.039798010140657 and x < 0.048397582024336 then
		return 18.0
	elseif x >= 0.048397582024336 and x < 0.05739713087678 then
		return 19.0
	elseif x >= 0.05739713087678 and x < 0.06619668751955 then
		return 20.0
	elseif x >= 0.06619668751955 and x < 0.075196243822575 then
		return 21.0
	elseif x >= 0.075196243822575 and x < 0.084195792675018 then
		return 22.0
	elseif x >= 0.084195792675018 and x < 0.092595368623734 then
		return 23.0
	elseif x >= 0.092595368623734 and x < 0.10099495202303 then
		return 24.0
	elseif x >= 0.10099495202303 and x < 0.10999450087547 then
		return 25.0
	elseif x >= 0.10999450087547 and x < 0.11879406124353 then
		return 26.0
	elseif x >= 0.11879406124353 and x < 0.12779361009598 then
		return 27.0
	elseif x >= 0.12779361009598 and x < 0.13639317452908 then
		return 28.0
	elseif x >= 0.13639317452908 and x < 0.14479276537895 then
		return 29.0
	elseif x >= 0.14479276537895 and x < 0.15359231829643 then
		return 30.0
	elseif x >= 0.15359231829643 and x < 0.16259187459946 then
		return 33.0
	elseif x >= 0.16259187459946 and x < 0.17139142751694 then
		return 36.0
	elseif x >= 0.17139142751694 and x < 0.18019099533558 then
		return 39.0
	elseif x >= 0.18019099533558 and x < 0.18939052522182 then
		return 42.0
	elseif x >= 0.18939052522182 and x < 0.19739012420177 then
		return 45.0
	elseif x >= 0.19739012420177 and x < 0.20618969202042 then
		return 48.0
	elseif x >= 0.20618969202042 and x < 0.21518924832344 then
		return 51.0
	elseif x >= 0.21518924832344 and x < 0.22378881275654 then
		return 56.0
	elseif x >= 0.22378881275654 and x < 0.23298835754395 then
		return 61.0
	elseif x >= 0.23298835754395 and x < 0.24198789894581 then
		return 66.0
	elseif x >= 0.24198789894581 and x < 0.25058746337891 then
		return 71.0
	elseif x >= 0.25058746337891 and x < 0.2587870657444 then
		return 76.0
	elseif x >= 0.2587870657444 and x < 0.26778662204742 then
		return 81.0
	elseif x >= 0.26778662204742 and x < 0.27678614854813 then
		return 86.0
	elseif x >= 0.27678614854813 and x < 0.28558573126793 then
		return 91.0
	elseif x >= 0.28558573126793 and x < 0.29458525776863 then
		return 94.0
	elseif x >= 0.29458525776863 and x < 0.30318483710289 then
		return 97.0
	elseif x >= 0.30318483710289 and x < 0.31158441305161 then
		return 100.0
	elseif x >= 0.31158441305161 and x < 0.32038399577141 then
		return 110.0
	elseif x >= 0.32038399577141 and x < 0.32938352227211 then
		return 115.0
	elseif x >= 0.32938352227211 and x < 0.33798310160637 then
		return 120.0
	elseif x >= 0.33798310160637 and x < 0.34698265790939 then
		return 125.0
	elseif x >= 0.34698265790939 and x < 0.35578221082687 then
		return 130.0
	elseif x >= 0.35578221082687 and x < 0.3647817671299 then
		return 135.0
	elseif x >= 0.3647817671299 and x < 0.37358132004738 then
		return 140.0
	elseif x >= 0.37358132004738 and x < 0.38158091902733 then
		return 145.0
	elseif x >= 0.38158091902733 and x < 0.39058047533035 then
		return 150.0
	elseif x >= 0.39058047533035 and x < 0.39958003163338 then
		return 155.0
	elseif x >= 0.39958003163338 and x < 0.40837958455086 then
		return 160.0
	elseif x >= 0.40837958455086 and x < 0.41697916388512 then
		return 165.0
	elseif x >= 0.41697916388512 and x < 0.4257787168026 then
		return 170.0
	elseif x >= 0.4257787168026 and x < 0.43517825007439 then
		return 175.0
	elseif x >= 0.43517825007439 and x < 0.44317784905434 then
		return 180.0
	elseif x >= 0.44317784905434 and x < 0.45217740535736 then
		return 185.0
	elseif x >= 0.45217740535736 and x < 0.46097695827484 then
		return 190.0
	elseif x >= 0.46097695827484 and x < 0.4695765376091 then
		return 195.0
	elseif x >= 0.4695765376091 and x < 0.47877606749535 then
		return 200.0
	elseif x >= 0.47877606749535 and x < 0.48697564005852 then
		return 210.0
	elseif x >= 0.48697564005852 and x < 0.49577522277832 then
		return 220.0
	elseif x >= 0.49577522277832 and x < 0.50477474927902 then
		return 230.0
	elseif x >= 0.50477474927902 and x < 0.51337432861328 then
		return 240.0
	elseif x >= 0.51337432861328 and x < 0.52237385511398 then
		return 250.0
	elseif x >= 0.52237385511398 and x < 0.53157341480255 then
		return 260.0
	elseif x >= 0.53157341480255 and x < 0.5395730137825 then
		return 270.0
	elseif x >= 0.5395730137825 and x < 0.54837256669998 then
		return 280.0
	elseif x >= 0.54837256669998 and x < 0.55737215280533 then
		return 285.0
	elseif x >= 0.55737215280533 and x < 0.56617170572281 then
		return 290.0
	elseif x >= 0.56617170572281 and x < 0.57497125864029 then
		return 295.0
	elseif x >= 0.57497125864029 and x < 0.58417081832886 then
		return 300.0
	elseif x >= 0.58417081832886 and x < 0.59217041730881 then
		return 310.0
	elseif x >= 0.59217041730881 and x < 0.60096997022629 then
		return 320.0
	elseif x >= 0.60096997022629 and x < 0.60996949672699 then
		return 325.0
	elseif x >= 0.60996949672699 and x < 0.61896908283234 then
		return 330.0
	elseif x >= 0.61896908283234 and x < 0.62776863574982 then
		return 340.0
	elseif x >= 0.62776863574982 and x < 0.63596820831299 then
		return 350.0
	elseif x >= 0.63596820831299 and x < 0.64476776123047 then
		return 376.0
	elseif x >= 0.64476776123047 and x < 0.65356731414795 then
		return 370.0
	elseif x >= 0.65356731414795 and x < 0.6625669002533 then
		return 380.0
	elseif x >= 0.6625669002533 and x < 0.671566426754 then
		return 390.0
	elseif x >= 0.671566426754 and x < 0.67996603250504 then
		return 400.0
	elseif x >= 0.67996603250504 and x < 0.68876558542252 then
		return 405.0
	elseif x >= 0.68876558542252 and x < 0.69816511869431 then
		return 410.00
	elseif x >= 0.69816511869431 and x < 0.70616471767426 then
		return 415.00
	elseif x >= 0.70616471767426 and x < 0.71516424417496 then
		return 420.00
	elseif x >= 0.71516424417496 and x < 0.72416377067566 then
		return 425.00
	elseif x >= 0.72416377067566 and x < 0.73296338319778 then
		return 430.00
	elseif x >= 0.73296338319778 and x < 0.74136292934418 then
		return 440.00
	elseif x >= 0.74136292934418 and x < 0.75076246261597 then
		return 450.00
	elseif x >= 0.75076246261597 and x < 0.759162068367 then
		return 457.00
	elseif x >= 0.759162068367 and x < 0.76776158809662 then
		return 460.00
	elseif x >= 0.76776158809662 and x < 0.77676117420197 then
		return 470.00
	elseif x >= 0.77676117420197 and x < 0.78556072711945 then
		return 480.00
	elseif x >= 0.78556072711945 and x < 0.7941603064537 then
		return 490.00
	elseif x >= 0.7941603064537 and x < 0.80295985937119 then
		return 500.00
	elseif x >= 0.80295985937119 and x < 0.81235939264297 then
		return 510.00
	elseif x >= 0.81235939264297 and x < 0.82035899162292 then
		return 520.00
	elseif x >= 0.82035899162292 and x < 0.82935851812363 then
		return 530.00
	elseif x >= 0.82935851812363 and x < 0.83815807104111 then
		return 540.00
	elseif x >= 0.83815807104111 and x < 0.84655767679214 then
		return 550.00
	elseif x >= 0.84655767679214 and x < 0.85595721006393 then
		return 560.00
	elseif x >= 0.85595721006393 and x < 0.86495673656464 then
		return 570.00
	elseif x >= 0.86495673656464 and x < 0.87295633554459 then
		return 585.00
	elseif x >= 0.87295633554459 and x < 0.88195592164993 then
		return 600.00
	elseif x >= 0.88195592164993 and x < 0.89075547456741 then
		return 605.00
	elseif x >= 0.89075547456741 and x < 0.89955502748489 then
		return 610.00
	elseif x >= 0.89955502748489 and x < 0.9085545539856 then
		return 620.00
	elseif x >= 0.9085545539856 and x < 0.91755414009094 then
		return 630.00
	elseif x >= 0.91755414009094 and x < 0.92555373907089 then
		return 640.00
	elseif x >= 0.92555373907089 and x < 0.93455326557159 then
		return 650.00
	elseif x >= 0.93455326557159 and x < 0.94335281848907 then
		return 675.00
	elseif x >= 0.94335281848907 and x < 0.95215237140656 then
		return 700.00
	elseif x >= 0.95215237140656 and x < 0.96055197715759 then
		return 720.00
	elseif x >= 0.96055197715759 and x < 0.96955150365829 then
		return 730.00
	elseif x >= 0.96955150365829 and x < 0.97815108299255 then
		return 740.00
	elseif x >= 0.97815108299255 and x < 0.9871506690979 then
		return 750.00
	elseif x >= 0.9871506690979 and x < 0.99595022201538 then
		return 775.00
	elseif x >= 0.99595022201538 and x <= 1 then
		return 800.00
	end
end

function surge:getFreqLFNormVal(y)--Returns normalized value of low frequency band for GML 8200.
	y = limit(y, 15, 800)
	if y >= 15.0 and y < 15.5 then
		return 0.0
	elseif y >= 15.5 and y < 16.0 then
		return 0.0047997599467635
	elseif y >= 16.0 and y < 16.5 then
		return 0.013399329967797
	elseif y >= 16.5 and y < 17.2 then
		return 0.022598870098591
	elseif y >= 17.2 and y < 18.0 then
		return 0.031398430466652
	elseif y >= 18.0 and y < 19.0 then
		return 0.039798010140657
	elseif y >= 19.0 and y < 20.0 then
		return 0.048397582024336
	elseif y >= 20.0 and y < 21.0 then
		return 0.05739713087678
	elseif y >= 21.0 and y < 22.0 then
		return 0.06619668751955
	elseif y >= 22.0 and y < 23.0 then
		return 0.075196243822575
	elseif y >= 23.0 and y < 24.0 then
		return 0.084195792675018
	elseif y >= 24.0 and y < 25.0 then
		return 0.092595368623734
	elseif y >= 25.0 and y < 26.0 then
		return 0.10099495202303
	elseif y >= 26.0 and y < 27.0 then
		return 0.10999450087547
	elseif y >= 27.0 and y < 28.0 then
		return 0.11879406124353
	elseif y >= 28.0 and y < 29.0 then
		return 0.12779361009598
	elseif y >= 29.0 and y < 30.0 then
		return 0.13639317452908
	elseif y >= 30.0 and y < 33.0 then
		return 0.14479276537895
	elseif y >= 33.0 and y < 36.0 then
		return 0.15359231829643
	elseif y >= 36.0 and y < 39.0 then
		return 0.16259187459946
	elseif y >= 39.0 and y < 42.0 then
		return 0.17139142751694
	elseif y >= 42.0 and y < 45.0 then
		return 0.18019099533558
	elseif y >= 45.0 and y < 48.0 then
		return 0.18939052522182
	elseif y >= 48.0 and y < 51.0 then
		return 0.19739012420177
	elseif y >= 51.0 and y < 56.0 then
		return 0.20618969202042
	elseif y >= 56.0 and y < 61.0 then
		return 0.21518924832344
	elseif y >= 61.0 and y < 66.0 then
		return 0.22378881275654
	elseif y >= 66.0 and y < 71.0 then
		return 0.23298835754395
	elseif y >= 71.0 and y < 76.0 then
		return 0.24198789894581
	elseif y >= 76.0 and y < 81.0 then
		return 0.25058746337891
	elseif y >= 81.0 and y < 86.0 then
		return 0.2587870657444
	elseif y >= 86.0 and y < 91.0 then
		return 0.26778662204742
	elseif y >= 91.0 and y < 94.0 then
		return 0.27678614854813
	elseif y >= 94.0 and y < 97.0 then
		return 0.28558573126793
	elseif y >= 97.0 and y < 100.0 then
		return 0.29458525776863
	elseif y >= 100.0 and y < 110.0 then
		return 0.30318483710289
	elseif y >= 110.0 and y < 115.0 then
		return 0.31158441305161
	elseif y >= 115.0 and y < 120.0 then
		return 0.32038399577141
	elseif y >= 120.0 and y < 125.0 then
		return 0.32938352227211
	elseif y >= 125.0 and y < 130.0 then
		return 0.33798310160637
	elseif y >= 130.0 and y < 135.0 then
		return 0.34698265790939
	elseif y >= 135.0 and y < 140.0 then
		return 0.35578221082687
	elseif y >= 140.0 and y < 145.0 then
		return 0.3647817671299
	elseif y >= 145.0 and y < 150.0 then
		return 0.37358132004738
	elseif y >= 150.0 and y < 155.0 then
		return 0.38158091902733
	elseif y >= 155.0 and y < 160.0 then
		return 0.39058047533035
	elseif y >= 160.0 and y < 165.0 then
		return 0.39958003163338
	elseif y >= 165.0 and y < 170.0 then
		return 0.40837958455086
	elseif y >= 170.0 and y < 175.0 then
		return 0.41697916388512
	elseif y >= 175.0 and y < 180.0 then
		return 0.4257787168026
	elseif y >= 180.0 and y < 185.0 then
		return 0.43517825007439
	elseif y >= 185.0 and y < 190.0 then
		return 0.44317784905434
	elseif y >= 190.0 and y < 195.0 then
		return 0.45217740535736
	elseif y >= 195.0 and y < 200.0 then
		return 0.46097695827484
	elseif y >= 200.0 and y < 210.0 then
		return 0.4695765376091
	elseif y >= 210.0 and y < 220.0 then
		return 0.47877606749535
	elseif y >= 220.0 and y < 230.0 then
		return 0.48697564005852
	elseif y >= 230.0 and y < 240.0 then
		return 0.49577522277832
	elseif y >= 240.0 and y < 250.0 then
		return 0.50477474927902
	elseif y >= 250.0 and y < 260.0 then
		return 0.51337432861328
	elseif y >= 260.0 and y < 270.0 then
		return 0.52237385511398
	elseif y >= 270.0 and y < 280.0 then
		return 0.53157341480255
	elseif y >= 280.0 and y < 285.0 then
		return 0.5395730137825
	elseif y >= 285.0 and y < 290.0 then
		return 0.54837256669998
	elseif y >= 290.0 and y < 295.0 then
		return 0.55737215280533
	elseif y >= 295.0 and y < 300.0 then
		return 0.56617170572281
	elseif y >= 300.0 and y < 310.0 then
		return 0.57497125864029
	elseif y >= 310.0 and y < 320.0 then
		return 0.58417081832886
	elseif y >= 320.0 and y < 325.0 then
		return 0.59217041730881
	elseif y >= 325.0 and y < 330.0 then
		return 0.60096997022629
	elseif y >= 330.0 and y < 340.0 then
		return 0.60996949672699
	elseif y >= 340.0 and y < 350.0 then
		return 0.61896908283234
	elseif y >= 350.0 and y < 376.0 then
		return 0.62776863574982
	elseif y >= 376.0 and y < 370.0 then
		return 0.63596820831299
	elseif y >= 370.0 and y < 380.0 then
		return 0.64476776123047
	elseif y >= 380.0 and y < 390.0 then
		return 0.65356731414795
	elseif y >= 390.0 and y < 400.0 then
		return 0.6625669002533
	elseif y >= 400.0 and y < 405.0 then
		return 0.671566426754
	elseif y >= 405.0 and y < 410.00 then
		return 0.67996603250504
	elseif y >= 410.00 and y < 415.00 then
		return 0.68876558542252
	elseif y >= 415.00 and y < 420.00 then
		return 0.69816511869431
	elseif y >= 420.00 and y < 425.00 then
		return 0.70616471767426
	elseif y >= 425.00 and y < 430.00 then
		return 0.71516424417496
	elseif y >= 430.00 and y < 440.00 then
		return 0.72416377067566
	elseif y >= 440.00 and y < 450.00 then
		return 0.73296338319778
	elseif y >= 450.00 and y < 457.00 then
		return 0.74136292934418
	elseif y >= 457.00 and y < 460.00 then
		return 0.75076246261597
	elseif y >= 460.00 and y < 470.00 then
		return 0.759162068367
	elseif y >= 470.00 and y < 480.00 then
		return 0.76776158809662
	elseif y >= 480.00 and y < 490.00 then
		return 0.77676117420197
	elseif y >= 490.00 and y < 500.00 then
		return 0.78556072711945
	elseif y >= 500.00 and y < 510.00 then
		return 0.7941603064537
	elseif y >= 510.00 and y < 520.00 then
		return 0.80295985937119
	elseif y >= 520.00 and y < 530.00 then
		return 0.81235939264297
	elseif y >= 530.00 and y < 540.00 then
		return 0.82035899162292
	elseif y >= 540.00 and y < 550.00 then
		return 0.82935851812363
	elseif y >= 550.00 and y < 560.00 then
		return 0.83815807104111
	elseif y >= 560.00 and y < 570.00 then
		return 0.84655767679214
	elseif y >= 570.00 and y < 585.00 then
		return 0.85595721006393
	elseif y >= 585.00 and y < 600.00 then
		return 0.86495673656464
	elseif y >= 600.00 and y < 605.00 then
		return 0.87295633554459
	elseif y >= 605.00 and y < 610.00 then
		return 0.88195592164993
	elseif y >= 610.00 and y < 620.00 then
		return 0.89075547456741
	elseif y >= 620.00 and y < 630.00 then
		return 0.89955502748489
	elseif y >= 630.00 and y < 640.00 then
		return 0.9085545539856
	elseif y >= 640.00 and y < 650.00 then
		return 0.91755414009094
	elseif y >= 650.00 and y < 675.00 then
		return 0.92555373907089
	elseif y >= 675.00 and y < 700.00 then
		return 0.93455326557159
	elseif y >= 700.00 and y < 720.00 then
		return 0.94335281848907
	elseif y >= 720.00 and y < 730.00 then
		return 0.95215237140656
	elseif y >= 730.00 and y < 740.00 then
		return 0.96055197715759
	elseif y >= 740.00 and y < 750.00 then
		return 0.96955150365829
	elseif y >= 750.00 and y < 775.00 then
		return 0.97815108299255
	elseif y >= 775.00 and y < 800.00 then
		return 0.9871506690979
	elseif y >= 800.00 then
		return 1.0
	end
end

function surge:getFreqHFShelfVal(x)--Returns frequency value of GML 8200 low frequency shelf to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.0059612323530018 then
		return 400
	elseif x >= 0.0059612323530018 and x < 0.012319879606366 then
		return 405
	elseif x >= 0.012319879606366 and x < 0.018479820340872 then
		return 410
	elseif x >= 0.018479820340872 and x < 0.024639759212732 then
		return 415
	elseif x >= 0.024639759212732 and x < 0.030998406931758 then
		return 420
	elseif x >= 0.030998406931758 and x < 0.037357054650784 then
		return 425
	elseif x >= 0.037357054650784 and x < 0.043516997247934 then
		return 430
	elseif x >= 0.043516997247934 and x < 0.049676936119795 then
		return 435
	elseif x >= 0.049676936119795 and x < 0.055836874991655 then
		return 440
	elseif x >= 0.055836874991655 and x < 0.062195524573326 then
		return 445
	elseif x >= 0.062195524573326 and x < 0.068355463445187 then
		return 450
	elseif x >= 0.068355463445187 and x < 0.074515402317047 then
		return 455
	elseif x >= 0.074515402317047 and x < 0.080675341188908 then
		return 460
	elseif x >= 0.080675341188908 and x < 0.087828822433949 then
		return 465
	elseif x >= 0.087828822433949 and x < 0.093193933367729 then
		return 470
	elseif x >= 0.093193933367729 and x < 0.10014870017767 then
		return 475
	elseif x >= 0.10014870017767 and x < 0.10650734603405 then
		return 480
	elseif x >= 0.10650734603405 and x < 0.11246858537197 then
		return 485
	elseif x >= 0.11246858537197 and x < 0.11842981725931 then
		return 490
	elseif x >= 0.11842981725931 and x < 0.12498717010021 then
		return 495
	elseif x >= 0.12498717010021 and x < 0.13114711642265 then
		return 500
	elseif x >= 0.13114711642265 and x < 0.13690963387489 then
		return 505
	elseif x >= 0.13690963387489 and x < 0.14326828718185 then
		return 510
	elseif x >= 0.14326828718185 and x < 0.14982563257217 then
		return 515
	elseif x >= 0.14982563257217 and x < 0.15598557889462 then
		return 520
	elseif x >= 0.15598557889462 and x < 0.1621455103159 then
		return 525
	elseif x >= 0.1621455103159 and x < 0.16850416362286 then
		return 530
	elseif x >= 0.16850416362286 and x < 0.1746641099453 then
		return 535
	elseif x >= 0.1746641099453 and x < 0.18082404136658 then
		return 540
	elseif x >= 0.18082404136658 and x < 0.18698398768902 then
		return 545
	elseif x >= 0.18698398768902 and x < 0.1931439191103 then
		return 550
	elseif x >= 0.1931439191103 and x < 0.20029740035534 then
		return 555
	elseif x >= 0.20029740035534 and x < 0.2056625187397 then
		return 560
	elseif x >= 0.2056625187397 and x < 0.21261727809906 then
		return 565
	elseif x >= 0.21261727809906 and x < 0.21897593140602 then
		return 570
	elseif x >= 0.21897593140602 and x < 0.22513587772846 then
		return 575
	elseif x >= 0.22513587772846 and x < 0.23129580914974 then
		return 580
	elseif x >= 0.23129580914974 and x < 0.23745575547218 then
		return 585
	elseif x >= 0.23745575547218 and x < 0.24381439387798 then
		return 590
	elseif x >= 0.24381439387798 and x < 0.24997434020042 then
		return 595
	elseif x >= 0.24997434020042 and x < 0.25355106592178 then
		return 600
	elseif x >= 0.25355106592178 and x < 0.2561342716217 then
		return 605
	elseif x >= 0.2561342716217 and x < 0.2595123052597 then
		return 610
	elseif x >= 0.2595123052597 and x < 0.26229423284531 then
		return 615
	elseif x >= 0.26229423284531 and x < 0.26587095856667 then
		return 620
	elseif x >= 0.26587095856667 and x < 0.26845416426659 then
		return 625
	elseif x >= 0.26845416426659 and x < 0.27203088998795 then
		return 630
	elseif x >= 0.27203088998795 and x < 0.27819085121155 then
		return 635
	elseif x >= 0.27819085121155 and x < 0.28097274899483 then
		return 645
	elseif x >= 0.28097274899483 and x < 0.28435078263283 then
		return 650
	elseif x >= 0.28435078263283 and x < 0.29070943593979 then
		return 655
	elseif x >= 0.29070943593979 and x < 0.29686936736107 then
		return 665
	elseif x >= 0.29686936736107 and x < 0.30302929878235 then
		return 675
	elseif x >= 0.30302929878235 and x < 0.30938795208931 then
		return 685
	elseif x >= 0.30938795208931 and x < 0.31276598572731 then
		return 695
	elseif x >= 0.31276598572731 and x < 0.31554788351059 then
		return 700
	elseif x >= 0.31554788351059 and x < 0.31892591714859 then
		return 705
	elseif x >= 0.31892591714859 and x < 0.32170784473419 then
		return 710
	elseif x >= 0.32170784473419 and x < 0.32528457045555 then
		return 715
	elseif x >= 0.32528457045555 and x < 0.32786777615547 then
		return 720
	elseif x >= 0.32786777615547 and x < 0.33144450187683 then
		return 725
	elseif x >= 0.33144450187683 and x < 0.33760446310043 then
		return 730
	elseif x >= 0.33760446310043 and x < 0.34078377485275 then
		return 740
	elseif x >= 0.34078377485275 and x < 0.34376439452171 then
		return 745
	elseif x >= 0.34376439452171 and x < 0.35012304782867 then
		return 750
	elseif x >= 0.35012304782867 and x < 0.35628297924995 then
		return 760
	elseif x >= 0.35628297924995 and x < 0.35906487703323 then
		return 770
	elseif x >= 0.35906487703323 and x < 0.36244291067123 then
		return 775
	elseif x >= 0.36244291067123 and x < 0.36860287189484 then
		return 780
	elseif x >= 0.36860287189484 and x < 0.3721795976162 then
		return 790
	elseif x >= 0.3721795976162 and x < 0.37476280331612 then
		return 795
	elseif x >= 0.37476280331612 and x < 0.37833952903748 then
		return 800
	elseif x >= 0.37833952903748 and x < 0.38112145662308 then
		return 805
	elseif x >= 0.38112145662308 and x < 0.3843007683754 then
		return 810
	elseif x >= 0.3843007683754 and x < 0.38728138804436 then
		return 815
	elseif x >= 0.38728138804436 and x < 0.39085811376572 then
		return 820
	elseif x >= 0.39085811376572 and x < 0.39344131946564 then
		return 825
	elseif x >= 0.39344131946564 and x < 0.39701807498932 then
		return 830
	elseif x >= 0.39701807498932 and x < 0.4031780064106 then
		return 835
	elseif x >= 0.4031780064106 and x < 0.40615862607956 then
		return 845
	elseif x >= 0.40615862607956 and x < 0.40933793783188 then
		return 850
	elseif x >= 0.40933793783188 and x < 0.41569659113884 then
		return 855
	elseif x >= 0.41569659113884 and x < 0.42185652256012 then
		return 865
	elseif x >= 0.42185652256012 and x < 0.42503586411476 then
		return 875
	elseif x >= 0.42503586411476 and x < 0.42801648378372 then
		return 880
	elseif x >= 0.42801648378372 and x < 0.43099710345268 then
		return 885
	elseif x >= 0.43099710345268 and x < 0.434176415205 then
		return 890
	elseif x >= 0.434176415205 and x < 0.43775314092636 then
		return 895
	elseif x >= 0.43775314092636 and x < 0.44033634662628 then
		return 900
	elseif x >= 0.44033634662628 and x < 0.44391310214996 then
		return 905
	elseif x >= 0.44391310214996 and x < 0.45007303357124 then
		return 910
	elseif x >= 0.45007303357124 and x < 0.45285493135452 then
		return 920
	elseif x >= 0.45285493135452 and x < 0.4564316868782 then
		return 925
	elseif x >= 0.4564316868782 and x < 0.46259161829948 then
		return 930
	elseif x >= 0.46259161829948 and x < 0.46577095985413 then
		return 940
	elseif x >= 0.46577095985413 and x < 0.46875154972076 then
		return 945
	elseif x >= 0.46875154972076 and x < 0.47491151094437 then
		return 950
	elseif x >= 0.47491151094437 and x < 0.47789213061333 then
		return 960
	elseif x >= 0.47789213061333 and x < 0.48107144236565 then
		return 965
	elseif x >= 0.48107144236565 and x < 0.48464816808701 then
		return 970
	elseif x >= 0.48464816808701 and x < 0.48743009567261 then
		return 975
	elseif x >= 0.48743009567261 and x < 0.49080812931061 then
		return 980
	elseif x >= 0.49080812931061 and x < 0.49359002709389 then
		return 985
	elseif x >= 0.49359002709389 and x < 0.49716678261757 then
		return 990
	elseif x >= 0.49716678261757 and x < 0.49974995851517 then
		return 995
	elseif x >= 0.49974995851517 and x < 0.51127499341965 then
		return 1000
	elseif x >= 0.51127499341965 and x < 0.52001816034317 then
		return 1225
	elseif x >= 0.52001816034317 and x < 0.57625246047974 then
		return 1400
	elseif x >= 0.57625246047974 and x < 0.60248190164566 then
		return 2525
	elseif x >= 0.60248190164566 and x < 0.61142373085022 then
		return 3050
	elseif x >= 0.61142373085022 and x < 0.62374359369278 then
		return 3225
	elseif x >= 0.62374359369278 and x < 0.63268542289734 then
		return 3475
	elseif x >= 0.63268542289734 and x < 0.64500534534454 then
		return 3650
	elseif x >= 0.64500534534454 and x < 0.65295362472534 then
		return 3900
	elseif x >= 0.65295362472534 and x < 0.65772265195847 then
		return 4059
	elseif x >= 0.65772265195847 and x < 0.66010713577271 then
		return 4154
	elseif x >= 0.66010713577271 and x < 0.66050451993942 then
		return 4202
	elseif x >= 0.66050451993942 and x < 0.66269034147263 then
		return 4206
	elseif x >= 0.66269034147263 and x < 0.66308772563934 then
		return 4254
	elseif x >= 0.66308772563934 and x < 0.66547220945358 then
		return 4258
	elseif x >= 0.66547220945358 and x < 0.66626703739166 then
		return 4305
	elseif x >= 0.66626703739166 and x < 0.66785669326782 then
		return 4325
	elseif x >= 0.66785669326782 and x < 0.67123472690582 then
		return 4353
	elseif x >= 0.67123472690582 and x < 0.67520892620087 then
		return 4425
	elseif x >= 0.67520892620087 and x < 0.67779213190079 then
		return 4500
	elseif x >= 0.67779213190079 and x < 0.68037527799606 then
		return 4556
	elseif x >= 0.68037527799606 and x < 0.68752878904343 then
		return 4608
	elseif x >= 0.68752878904343 and x < 0.69011199474335 then
		return 4751
	elseif x >= 0.69011199474335 and x < 0.69269520044327 then
		return 4802
	elseif x >= 0.69269520044327 and x < 0.69289392232895 then
		return 4854
	elseif x >= 0.69289392232895 and x < 0.69647061824799 then
		return 4858
	elseif x >= 0.69647061824799 and x < 0.70263057947159 then
		return 4925
	elseif x >= 0.70263057947159 and x < 0.70521378517151 then
		return 5053
	elseif x >= 0.70521378517151 and x < 0.70779699087143 then
		return 5104
	elseif x >= 0.70779699087143 and x < 0.71753364801407 then
		return 5156
	elseif x >= 0.71753364801407 and x < 0.72011685371399 then
		return 5351
	elseif x >= 0.72011685371399 and x < 0.72031557559967 then
		return 5402
	elseif x >= 0.72031557559967 and x < 0.72289878129959 then
		return 5406
	elseif x >= 0.72289878129959 and x < 0.73005223274231 then
		return 5458
	elseif x >= 0.73005223274231 and x < 0.73144322633743 then
		return 5601
	elseif x >= 0.73144322633743 and x < 0.73263543844223 then
		return 5625
	elseif x >= 0.73263543844223 and x < 0.73541736602783 then
		return 5653
	elseif x >= 0.73541736602783 and x < 0.74515402317047 then
		return 5708
	elseif x >= 0.74515402317047 and x < 0.74773722887039 then
		return 5903
	elseif x >= 0.74773722887039 and x < 0.74813467264175 then
		return 5955
	elseif x >= 0.74813467264175 and x < 0.75071781873703 then
		return 5959
	elseif x >= 0.75071781873703 and x < 0.75131398439407 then
		return 6057
	elseif x >= 0.75131398439407 and x < 0.75270491838455 then
		return 6105
	elseif x >= 0.75270491838455 and x < 0.75568556785583 then
		return 6200
	elseif x >= 0.75568556785583 and x < 0.75906360149384 then
		return 6455
	elseif x >= 0.75906360149384 and x < 0.76025581359863 then
		return 6709
	elseif x >= 0.76025581359863 and x < 0.77257567644119 then
		return 6805
	elseif x >= 0.77257567644119 and x < 0.7815175652504 then
		return 7806
	elseif x >= 0.7815175652504 and x < 0.78270977735519 then
		return 8506
	elseif x >= 0.78270977735519 and x < 0.79085683822632 then
		return 8601
	elseif x >= 0.79085683822632 and x < 0.79383742809296 then
		return 9253
	elseif x >= 0.79383742809296 and x < 0.7950296998024 then
		return 9507
	elseif x >= 0.7950296998024 and x < 0.7956258058548 then
		return 9602
	elseif x >= 0.7956258058548 and x < 0.79781156778336 then
		return 9650
	elseif x >= 0.79781156778336 and x < 0.79820901155472 then
		return 9825
	elseif x >= 0.79820901155472 and x < 0.7990038394928 then
		return 9857
	elseif x >= 0.7990038394928 and x < 0.79999738931656 then
		return 9904
	elseif x >= 0.79999738931656 and x < 0.80337542295456 then
		return 10000
	elseif x >= 0.80337542295456 and x < 0.80436891317368 then
		return 10254
	elseif x >= 0.80436891317368 and x < 0.82582938671112 then
		return 10350
	elseif x >= 0.82582938671112 and x < 0.8407324552536 then
		return 12050
	elseif x >= 0.8407324552536 and x < 0.8468924164772 then
		return 13259
	elseif x >= 0.8468924164772 and x < 0.85941100120544 then
		return 13751
	elseif x >= 0.85941100120544 and x < 0.87093603610992 then
		return 14753
	elseif x >= 0.87093603610992 and x < 0.90113961696625 then
		return 15675
	elseif x >= 0.90113961696625 and x < 0.90630602836609 then
		return 18075
	elseif x >= 0.90630602836609 and x < 0.90769696235657 then
		return 18504
	elseif x >= 0.90769696235657 and x < 0.93750309944153 then
		return 18600
	elseif x >= 0.93750309944153 and x < 0.94624626636505 then
		return 21000
	elseif x >= 0.94624626636505 and x < 0.95320105552673 then
		return 21700
	elseif x >= 0.95320105552673 and x < 0.96571964025497 then
		return 22256
	elseif x >= 0.96571964025497 and x < 0.97187954187393 then
		return 23258
	elseif x >= 0.97187954187393 and x < 0.97625112533569 then
		return 23750
	elseif x >= 0.97625112533569 and x < 0.97823822498322 then
		return 24100
	elseif x >= 0.97823822498322 and x <= 1 then
		return 26000
	end
end

function surge:getFreqHFShelfNormVal(y)--Returns normalized value of low frequency shelf for GML 8200.
	y = limit(y, 400, 26000)
	if y >= 400 and y < 405 then
		return 0.0
	elseif y >= 405 and y < 410 then
		return 0.0059612323530018
	elseif y >= 410 and y < 415 then
		return 0.012319879606366
	elseif y >= 415 and y < 420 then
		return 0.018479820340872
	elseif y >= 420 and y < 425 then
		return 0.024639759212732
	elseif y >= 425 and y < 430 then
		return 0.030998406931758
	elseif y >= 430 and y < 435 then
		return 0.037357054650784
	elseif y >= 435 and y < 440 then
		return 0.043516997247934
	elseif y >= 440 and y < 445 then
		return 0.049676936119795
	elseif y >= 445 and y < 450 then
		return 0.055836874991655
	elseif y >= 450 and y < 455 then
		return 0.062195524573326
	elseif y >= 455 and y < 460 then
		return 0.068355463445187
	elseif y >= 460 and y < 465 then
		return 0.074515402317047
	elseif y >= 465 and y < 470 then
		return 0.080675341188908
	elseif y >= 470 and y < 475 then
		return 0.087828822433949
	elseif y >= 475 and y < 480 then
		return 0.093193933367729
	elseif y >= 480 and y < 485 then
		return 0.10014870017767
	elseif y >= 485 and y < 490 then
		return 0.10650734603405
	elseif y >= 490 and y < 495 then
		return 0.11246858537197
	elseif y >= 495 and y < 500 then
		return 0.11842981725931
	elseif y >= 500 and y < 505 then
		return 0.12498717010021
	elseif y >= 505 and y < 510 then
		return 0.13114711642265
	elseif y >= 510 and y < 515 then
		return 0.13690963387489
	elseif y >= 515 and y < 520 then
		return 0.14326828718185
	elseif y >= 520 and y < 525 then
		return 0.14982563257217
	elseif y >= 525 and y < 530 then
		return 0.15598557889462
	elseif y >= 530 and y < 535 then
		return 0.1621455103159
	elseif y >= 535 and y < 540 then
		return 0.16850416362286
	elseif y >= 540 and y < 545 then
		return 0.1746641099453
	elseif y >= 545 and y < 550 then
		return 0.18082404136658
	elseif y >= 550 and y < 555 then
		return 0.18698398768902
	elseif y >= 555 and y < 560 then
		return 0.1931439191103
	elseif y >= 560 and y < 565 then
		return 0.20029740035534
	elseif y >= 565 and y < 570 then
		return 0.2056625187397
	elseif y >= 570 and y < 575 then
		return 0.21261727809906
	elseif y >= 575 and y < 580 then
		return 0.21897593140602
	elseif y >= 580 and y < 585 then
		return 0.22513587772846
	elseif y >= 585 and y < 590 then
		return 0.23129580914974
	elseif y >= 590 and y < 595 then
		return 0.23745575547218
	elseif y >= 595 and y < 600 then
		return 0.24381439387798
	elseif y >= 600 and y < 605 then
		return 0.24997434020042
	elseif y >= 605 and y < 610 then
		return 0.25355106592178
	elseif y >= 610 and y < 615 then
		return 0.2561342716217
	elseif y >= 615 and y < 620 then
		return 0.2595123052597
	elseif y >= 620 and y < 625 then
		return 0.26229423284531
	elseif y >= 625 and y < 630 then
		return 0.26587095856667
	elseif y >= 630 and y < 635 then
		return 0.26845416426659
	elseif y >= 635 and y < 645 then
		return 0.27203088998795
	elseif y >= 645 and y < 650 then
		return 0.27819085121155
	elseif y >= 650 and y < 655 then
		return 0.28097274899483
	elseif y >= 655 and y < 665 then
		return 0.28435078263283
	elseif y >= 665 and y < 675 then
		return 0.29070943593979
	elseif y >= 675 and y < 685 then
		return 0.29686936736107
	elseif y >= 685 and y < 695 then
		return 0.30302929878235
	elseif y >= 695 and y < 700 then
		return 0.30938795208931
	elseif y >= 700 and y < 705 then
		return 0.31276598572731
	elseif y >= 705 and y < 710 then
		return 0.31554788351059
	elseif y >= 710 and y < 715 then
		return 0.31892591714859
	elseif y >= 715 and y < 720 then
		return 0.32170784473419
	elseif y >= 720 and y < 725 then
		return 0.32528457045555
	elseif y >= 725 and y < 730 then
		return 0.32786777615547
	elseif y >= 730 and y < 740 then
		return 0.33144450187683
	elseif y >= 740 and y < 745 then
		return 0.33760446310043
	elseif y >= 745 and y < 750 then
		return 0.34078377485275
	elseif y >= 750 and y < 760 then
		return 0.34376439452171
	elseif y >= 760 and y < 770 then
		return 0.35012304782867
	elseif y >= 770 and y < 775 then
		return 0.35628297924995
	elseif y >= 775 and y < 780 then
		return 0.35906487703323
	elseif y >= 780 and y < 790 then
		return 0.36244291067123
	elseif y >= 790 and y < 795 then
		return 0.36860287189484
	elseif y >= 795 and y < 800 then
		return 0.3721795976162
	elseif y >= 800 and y < 805 then
		return 0.37476280331612
	elseif y >= 805 and y < 810 then
		return 0.37833952903748
	elseif y >= 810 and y < 815 then
		return 0.38112145662308
	elseif y >= 815 and y < 820 then
		return 0.3843007683754
	elseif y >= 820 and y < 825 then
		return 0.38728138804436
	elseif y >= 825 and y < 830 then
		return 0.39085811376572
	elseif y >= 830 and y < 835 then
		return 0.39344131946564
	elseif y >= 835 and y < 845 then
		return 0.39701807498932
	elseif y >= 845 and y < 850 then
		return 0.4031780064106
	elseif y >= 850 and y < 855 then
		return 0.40615862607956
	elseif y >= 855 and y < 865 then
		return 0.40933793783188
	elseif y >= 865 and y < 875 then
		return 0.41569659113884
	elseif y >= 875 and y < 880 then
		return 0.42185652256012
	elseif y >= 880 and y < 885 then
		return 0.42503586411476
	elseif y >= 885 and y < 890 then
		return 0.42801648378372
	elseif y >= 890 and y < 895 then
		return 0.43099710345268
	elseif y >= 895 and y < 900 then
		return 0.434176415205
	elseif y >= 900 and y < 905 then
		return 0.43775314092636
	elseif y >= 905 and y < 910 then
		return 0.44033634662628
	elseif y >= 910 and y < 920 then
		return 0.44391310214996
	elseif y >= 920 and y < 925 then
		return 0.45007303357124
	elseif y >= 925 and y < 930 then
		return 0.45285493135452
	elseif y >= 930 and y < 940 then
		return 0.4564316868782
	elseif y >= 940 and y < 945 then
		return 0.46259161829948
	elseif y >= 945 and y < 950 then
		return 0.46577095985413
	elseif y >= 950 and y < 960 then
		return 0.46875154972076
	elseif y >= 960 and y < 965 then
		return 0.47491151094437
	elseif y >= 965 and y < 970 then
		return 0.47789213061333
	elseif y >= 970 and y < 975 then
		return 0.48107144236565
	elseif y >= 975 and y < 980 then
		return 0.48464816808701
	elseif y >= 980 and y < 985 then
		return 0.48743009567261
	elseif y >= 985 and y < 990 then
		return 0.49080812931061
	elseif y >= 990 and y < 995 then
		return 0.49359002709389
	elseif y >= 995 and y < 1000 then
		return 0.49716678261757
	elseif y >= 1000 and y < 1225 then
		return 0.49974995851517
	elseif y >= 1225 and y < 1400 then
		return 0.51127499341965
	elseif y >= 1400 and y < 2525 then
		return 0.52001816034317
	elseif y >= 2525 and y < 3050 then
		return 0.57625246047974
	elseif y >= 3050 and y < 3225 then
		return 0.60248190164566
	elseif y >= 3225 and y < 3475 then
		return 0.61142373085022
	elseif y >= 3475 and y < 3650 then
		return 0.62374359369278
	elseif y >= 3650 and y < 3900 then
		return 0.63268542289734
	elseif y >= 3900 and y < 4059 then
		return 0.64500534534454
	elseif y >= 4059 and y < 4154 then
		return 0.65295362472534
	elseif y >= 4154 and y < 4202 then
		return 0.65772265195847
	elseif y >= 4202 and y < 4206 then
		return 0.66010713577271
	elseif y >= 4206 and y < 4254 then
		return 0.66050451993942
	elseif y >= 4254 and y < 4258 then
		return 0.66269034147263
	elseif y >= 4258 and y < 4305 then
		return 0.66308772563934
	elseif y >= 4305 and y < 4325 then
		return 0.66547220945358
	elseif y >= 4325 and y < 4353 then
		return 0.66626703739166
	elseif y >= 4353 and y < 4425 then
		return 0.66785669326782
	elseif y >= 4425 and y < 4500 then
		return 0.67123472690582
	elseif y >= 4500 and y < 4556 then
		return 0.67520892620087
	elseif y >= 4556 and y < 4608 then
		return 0.67779213190079
	elseif y >= 4608 and y < 4751 then
		return 0.68037527799606
	elseif y >= 4751 and y < 4802 then
		return 0.68752878904343
	elseif y >= 4802 and y < 4854 then
		return 0.69011199474335
	elseif y >= 4854 and y < 4858 then
		return 0.69269520044327
	elseif y >= 4858 and y < 4925 then
		return 0.69289392232895
	elseif y >= 4925 and y < 5053 then
		return 0.69647061824799
	elseif y >= 5053 and y < 5104 then
		return 0.70263057947159
	elseif y >= 5104 and y < 5156 then
		return 0.70521378517151
	elseif y >= 5156 and y < 5351 then
		return 0.70779699087143
	elseif y >= 5351 and y < 5402 then
		return 0.71753364801407
	elseif y >= 5402 and y < 5406 then
		return 0.72011685371399
	elseif y >= 5406 and y < 5458 then
		return 0.72031557559967
	elseif y >= 5458 and y < 5601 then
		return 0.72289878129959
	elseif y >= 5601 and y < 5625 then
		return 0.73005223274231
	elseif y >= 5625 and y < 5653 then
		return 0.73144322633743
	elseif y >= 5653 and y < 5708 then
		return 0.73263543844223
	elseif y >= 5708 and y < 5903 then
		return 0.73541736602783
	elseif y >= 5903 and y < 5955 then
		return 0.74515402317047
	elseif y >= 5955 and y < 5959 then
		return 0.74773722887039
	elseif y >= 5959 and y < 6057 then
		return 0.74813467264175
	elseif y >= 6057 and y < 6105 then
		return 0.75071781873703
	elseif y >= 6105 and y < 6200 then
		return 0.75131398439407
	elseif y >= 6200 and y < 6455 then
		return 0.75270491838455
	elseif y >= 6455 and y < 6709 then
		return 0.75568556785583
	elseif y >= 6709 and y < 6805 then
		return 0.75906360149384
	elseif y >= 6805 and y < 7806 then
		return 0.76025581359863
	elseif y >= 7806 and y < 8506 then
		return 0.77257567644119
	elseif y >= 8506 and y < 8601 then
		return 0.7815175652504
	elseif y >= 8601 and y < 9253 then
		return 0.78270977735519
	elseif y >= 9253 and y < 9507 then
		return 0.79085683822632
	elseif y >= 9507 and y < 9602 then
		return 0.79383742809296
	elseif y >= 9602 and y < 9650 then
		return 0.7950296998024
	elseif y >= 9650 and y < 9825 then
		return 0.7956258058548
	elseif y >= 9825 and y < 9857 then
		return 0.79781156778336
	elseif y >= 9857 and y < 9904 then
		return 0.79820901155472
	elseif y >= 9904 and y < 10000 then
		return 0.7990038394928
	elseif y >= 10000 and y < 10254 then
		return 0.79999738931656
	elseif y >= 10254 and y < 10350 then
		return 0.80337542295456
	elseif y >= 10350 and y < 12050 then
		return 0.80436891317368
	elseif y >= 12050 and y < 13259 then
		return 0.82582938671112
	elseif y >= 13259 and y < 13751 then
		return 0.8407324552536
	elseif y >= 13751 and y < 14753 then
		return 0.8468924164772
	elseif y >= 14753 and y < 15675 then
		return 0.85941100120544
	elseif y >= 15675 and y < 18075 then
		return 0.87093603610992
	elseif y >= 18075 and y < 18504 then
		return 0.90113961696625
	elseif y >= 18504 and y < 18600 then
		return 0.90630602836609
	elseif y >= 18600 and y < 21000 then
		return 0.90769696235657
	elseif y >= 21000 and y < 21700 then
		return 0.93750309944153
	elseif y >= 21700 and y < 22256 then
		return 0.94624626636505
	elseif y >= 22256 and y < 23258 then
		return 0.95320105552673
	elseif y >= 23258 and y < 23750 then
		return 0.96571964025497
	elseif y >= 23750 and y < 24100 then
		return 0.97187954187393
	elseif y >= 24100 and y < 26000 then
		return 0.97625112533569
	elseif y == 26000 then
		return 1.0
	end
end

function surge:getFreqHFVal(x)--Returns frequency value of  GML 8200 high frequency band to pass into pro-q.
	x = limit(x, 0, 1)
	if x >= 0.0 and x < 0.050397481769323 then
		return 400
	elseif x >= 0.050397481769323 and x < 0.058597069233656 then
		return 410
	elseif x >= 0.058597069233656 and x < 0.067996598780155 then
		return 420
	elseif x >= 0.067996598780155 and x < 0.076996147632599 then
		return 425
	elseif x >= 0.076996147632599 and x < 0.08579570800066  then
		return 430
	elseif x >= 0.08579570800066 and x < 0.095195241272449 then
		return 435
	elseif x >= 0.095195241272449 and x < 0.10419479012489  then
		return 440
	elseif x >= 0.10419479012489 and x < 0.11319433897734  then
		return 450
	elseif x >= 0.11319433897734 and x < 0.1219938993454  then
		return 455
	elseif x >= 0.1219938993454 and x < 0.13099345564842  then
		return 460
	elseif x >= 0.13099345564842 and x < 0.1397930085659  then
		return 470
	elseif x >= 0.1397930085659 and x < 0.14879256486893  then
		return 475
	elseif x >= 0.14879256486893 and x < 0.15799209475517  then
		return 480
	elseif x >= 0.15799209475517 and x < 0.16739162802696  then
		return 500
	elseif x >= 0.16739162802696 and x < 0.17639118432999  then
		return 510
	elseif x >= 0.17639118432999 and x < 0.18539072573185  then
		return 520
	elseif x >= 0.18539072573185 and x < 0.19399030506611  then
		return 530
	elseif x >= 0.19399030506611 and x < 0.20318983495235  then
		return 540
	elseif x >= 0.20318983495235 and x < 0.211989402771  then
		return 550
	elseif x >= 0.211989402771 and x < 0.22098894417286  then
		return 560
	elseif x >= 0.22098894417286 and x < 0.22998850047588  then
		return 570
	elseif x >= 0.22998850047588 and x < 0.23878806829453  then
		return 580
	elseif x >= 0.23878806829453 and x < 0.24778760969639  then
		return 590
	elseif x >= 0.24778760969639 and x < 0.2575871348381  then
		return 600
	elseif x >= 0.2575871348381 and x < 0.26618668437004  then
		return 615
	elseif x >= 0.26618668437004 and x < 0.27538624405861  then
		return 625
	elseif x >= 0.27538624405861 and x < 0.28398579359055  then
		return 640
	elseif x >= 0.28398579359055 and x < 0.29318535327911  then
		return 650
	elseif x >= 0.29318535327911 and x < 0.30218487977982  then
		return 670
	elseif x >= 0.30218487977982 and x < 0.31098446249962  then
		return 680
	elseif x >= 0.31098446249962 and x < 0.31998398900032  then
		return 690
	elseif x >= 0.31998398900032 and x < 0.32978349924088  then
		return 710
	elseif x >= 0.32978349924088 and x < 0.33838307857513  then
		return 730
	elseif x >= 0.33838307857513 and x < 0.34758260846138  then
		return 750
	elseif x >= 0.34758260846138 and x < 0.3565821647644  then
		return 775
	elseif x >= 0.3565821647644 and x < 0.36538171768188  then
		return 790
	elseif x >= 0.36538171768188 and x < 0.37418130040169  then
		return 800
	elseif x >= 0.37418130040169 and x < 0.38318085670471  then
		return 830
	elseif x >= 0.38318085670471 and x < 0.39218038320541  then
		return 870
	elseif x >= 0.39218038320541 and x < 0.40117993950844  then
		return 900
	elseif x >= 0.40117993950844 and x < 0.40997949242592  then
		return 925
	elseif x >= 0.40997949242592 and x < 0.41897904872894  then
		return 950
	elseif x >= 0.41897904872894 and x < 0.4287785589695  then
		return 980
	elseif x >= 0.4287785589695 and x < 0.43717813491821  then
		return 1000
	elseif x >= 0.43717813491821 and x < 0.44657766819  then
		return 1050
	elseif x >= 0.44657766819 and x < 0.45537722110748  then
		return 1100
	elseif x >= 0.45537722110748 and x < 0.46437677741051  then
		return 1200
	elseif x >= 0.46437677741051 and x < 0.47337633371353  then
		return 1300
	elseif x >= 0.47337633371353 and x < 0.48217588663101  then
		return 1350
	elseif x >= 0.48217588663101 and x < 0.49117544293404  then
		return 1400
	elseif x >= 0.49117544293404 and x < 0.50097495317459  then
		return 1450
	elseif x >= 0.50097495317459 and x < 0.50977450609207  then
		return 1500
	elseif x >= 0.50977450609207 and x < 0.51877409219742  then
		return 1550
	elseif x >= 0.51877409219742 and x < 0.5275736451149  then
		return 1650
	elseif x >= 0.5275736451149 and x < 0.5365731716156  then
		return 1700
	elseif x >= 0.5365731716156 and x < 0.5455726981163  then
		return 1750
	elseif x >= 0.5455726981163 and x < 0.55437231063843  then
		return 1800
	elseif x >= 0.55437231063843 and x < 0.56317186355591  then
		return 1900
	elseif x >= 0.56317186355591 and x < 0.57217139005661  then
		return 2100
	elseif x >= 0.57217139005661 and x < 0.58117091655731  then
		return 2250
	elseif x >= 0.58117091655731 and x < 0.59037047624588  then
		return 2400
	elseif x >= 0.59037047624588 and x < 0.59937006235123  then
		return 2600
	elseif x >= 0.59937006235123 and x < 0.60876953601837  then
		return 2800
	elseif x >= 0.60876953601837 and x < 0.61776912212372  then
		return 2900
	elseif x >= 0.61776912212372 and x < 0.62676864862442  then
		return 3100
	elseif x >= 0.62676864862442 and x < 0.63536822795868  then
		return 3300
	elseif x >= 0.63536822795868 and x < 0.64456778764725  then
		return 3500
	elseif x >= 0.64456778764725 and x < 0.65336734056473  then
		return 3700
	elseif x >= 0.65336734056473 and x < 0.66236686706543  then
		return 3800
	elseif x >= 0.66236686706543 and x < 0.671566426754  then
		return 3900
	elseif x >= 0.671566426754 and x < 0.68076598644257  then
		return 4000
	elseif x >= 0.68076598644257 and x < 0.68996548652649  then
		return 4300
	elseif x >= 0.68996548652649 and x < 0.69896507263184  then
		return 4600
	elseif x >= 0.69896507263184 and x < 0.70756465196609  then
		return 4800
	elseif x >= 0.70756465196609 and x < 0.71676415205002  then
		return 5000
	elseif x >= 0.71676415205002 and x < 0.7255637049675  then
		return 5300
	elseif x >= 0.7255637049675 and x < 0.73456329107285  then
		return 5600
	elseif x >= 0.73456329107285 and x < 0.74356281757355  then
		return 5800
	elseif x >= 0.74356281757355 and x < 0.75236237049103  then
		return 6000
	elseif x >= 0.75236237049103 and x < 0.76136195659637  then
		return 6300
	elseif x >= 0.76136195659637 and x < 0.77096146345139  then
		return 6600
	elseif x >= 0.77096146345139 and x < 0.77976101636887  then
		return 6800
	elseif x >= 0.77976101636887 and x < 0.78896057605743  then
		return 7000
	elseif x >= 0.78896057605743 and x < 0.79796010255814  then
		return 7300
	elseif x >= 0.79796010255814 and x < 0.8065596818924  then
		return 7600
	elseif x >= 0.8065596818924 and x < 0.81575924158096  then
		return 7800
	elseif x >= 0.81575924158096 and x < 0.82455879449844  then
		return 8000
	elseif x >= 0.82455879449844 and x < 0.83355832099915  then
		return 8500
	elseif x >= 0.83355832099915 and x < 0.84235787391663  then
		return 8900
	elseif x >= 0.84235787391663 and x < 0.85135746002197  then
		return 9300
	elseif x >= 0.85135746002197 and x < 0.86115694046021  then
		return 9600
	elseif x >= 0.86115694046021 and x < 0.87015646696091  then
		return 10000
	elseif x >= 0.87015646696091 and x < 0.87895607948303  then
		return 10500
	elseif x >= 0.87895607948303 and x < 0.88795560598373  then
		return 11000
	elseif x >= 0.88795560598373 and x < 0.89675515890121  then
		return 11500
	elseif x >= 0.89675515890121 and x < 0.90575474500656  then
		return 12000
	elseif x >= 0.90575474500656 and x < 0.91475427150726  then
		return 13000
	elseif x >= 0.91475427150726 and x < 0.92355382442474  then
		return 14000
	elseif x >= 0.92355382442474 and x < 0.93335336446762  then
		return 15000
	elseif x >= 0.93335336446762 and x < 0.94235289096832  then
		return 16000
	elseif x >= 0.94235289096832 and x < 0.9511524438858  then
		return 17000
	elseif x >= 0.9511524438858 and x < 0.95995199680328  then
		return 18000
	elseif x >= 0.95995199680328 and x < 0.96855157613754  then
		return 19000
	elseif x >= 0.96855157613754 and x < 0.97835105657578  then
		return 19500
	elseif x >= 0.97835105657578 and x < 0.98675066232681  then
		return 20000
	elseif x >= 0.98675066232681 and x < 0.99575018882751  then
		return 23000
	elseif x > 0.99575018882751 and x <= 1.0 then
		return 26000
	end
end

function surge:getFreqHFNormVal(y)--Returns normalized value of high frequency band for GML 8200.
	y = limit(y, 400, 26000)
	if y >= 400 and y < 410 then
		return 0.0
	elseif y >= 410 and y < 420 then
		return 0.050397481769323
	elseif y >= 420 and y < 425 then
		return 0.058597069233656
	elseif y >= 425 and y < 430 then
		return 0.067996598780155
	elseif y >= 430 and y < 435  then
		return 0.076996147632599
	elseif y >= 435 and y < 440 then
		return 0.08579570800066
	elseif y >= 440 and y < 450  then
		return 0.095195241272449
	elseif y >= 450 and y < 455  then
		return 0.10419479012489
	elseif y >= 455 and y < 460  then
		return 0.11319433897734
	elseif y >= 460 and y < 470  then
		return 0.1219938993454
	elseif y >= 470 and y < 475  then
		return 0.13099345564842
	elseif y >= 475 and y < 480  then
		return 0.1397930085659
	elseif y >= 480 and y < 500  then
		return 0.14879256486893
	elseif y >= 500 and y < 510  then
		return 0.15799209475517
	elseif y >= 510 and y < 520  then
		return 0.16739162802696
	elseif y >= 520 and y < 530  then
		return 0.17639118432999
	elseif y >= 530 and y < 540  then
		return 0.18539072573185
	elseif y >= 540 and y < 550  then
		return 0.19399030506611
	elseif y >= 550 and y < 560  then
		return 0.20318983495235
	elseif y >= 560 and y < 570  then
		return 0.211989402771
	elseif y >= 570 and y < 580  then
		return 0.22098894417286
	elseif y >= 580 and y < 590  then
		return 0.22998850047588
	elseif y >= 590 and y < 600  then
		return 0.23878806829453
	elseif y >= 600 and y < 615  then
		return 0.24778760969639
	elseif y >= 615 and y < 625  then
		return 0.2575871348381
	elseif y >= 625 and y < 640  then
		return 0.26618668437004
	elseif y >= 640 and y < 650  then
		return 0.27538624405861
	elseif y >= 650 and y < 670  then
		return 0.28398579359055
	elseif y >= 670 and y < 680  then
		return 0.29318535327911
	elseif y >= 680 and y < 690  then
		return 0.30218487977982
	elseif y >= 690 and y < 710  then
		return 0.31098446249962
	elseif y >= 710 and y < 730  then
		return 0.31998398900032
	elseif y >= 730 and y < 750  then
		return 0.32978349924088
	elseif y >= 750 and y < 775  then
		return 0.33838307857513
	elseif y >= 775 and y < 790  then
		return 0.34758260846138
	elseif y >= 790 and y < 800  then
		return 0.3565821647644
	elseif y >= 800 and y < 830  then
		return 0.36538171768188
	elseif y >= 830 and y < 870  then
		return 0.37418130040169
	elseif y >= 870 and y < 900  then
		return 0.38318085670471
	elseif y >= 900 and y < 925  then
		return 0.39218038320541
	elseif y >= 925 and y < 950  then
		return 0.40117993950844
	elseif y >= 950 and y < 980  then
		return 0.40997949242592
	elseif y >= 980 and y < 1000  then
		return 0.41897904872894
	elseif y >= 1000 and y < 1050  then
		return 0.4287785589695
	elseif y >= 1050 and y < 1100  then
		return 0.43717813491821
	elseif y >= 1100 and y < 1200  then
		return 0.44657766819
	elseif y >= 1200 and y < 1300  then
		return 0.45537722110748
	elseif y >= 1300 and y < 1350  then
		return 0.46437677741051
	elseif y >= 1350 and y < 1400  then
		return 0.47337633371353
	elseif y >= 1400 and y < 1450  then
		return 0.48217588663101
	elseif y >= 1450 and y < 1500  then
		return 0.49117544293404
	elseif y >= 1500 and y < 1550  then
		return 0.50097495317459
	elseif y >= 1550 and y < 1650  then
		return 0.50977450609207
	elseif y >= 1650 and y < 1700  then
		return 0.51877409219742
	elseif y >= 1700 and y < 1750  then
		return 0.5275736451149
	elseif y >= 1750 and y < 1800  then
		return 0.5365731716156
	elseif y >= 1800 and y < 1900  then
		return 0.5455726981163
	elseif y >= 1900 and y < 2100  then
		return 0.55437231063843
	elseif y >= 2100 and y < 2250  then
		return 0.56317186355591
	elseif y >= 2250 and y < 2400  then
		return 0.57217139005661
	elseif y >= 2400 and y < 2600  then
		return 0.58117091655731
	elseif y >= 2600 and y < 2800  then
		return 0.59037047624588
	elseif y >= 2800 and y < 2900  then
		return 0.59937006235123
	elseif y >= 2900 and y < 3100  then
		return 0.60876953601837
	elseif y >= 3100 and y < 3300  then
		return 0.61776912212372
	elseif y >= 3300 and y < 3500  then
		return 0.62676864862442
	elseif y >= 3500 and y < 3700  then
		return 0.63536822795868
	elseif y >= 3700 and y < 3800  then
		return 0.64456778764725
	elseif y >= 3800 and y < 3900  then
		return 0.65336734056473
	elseif y >= 3900 and y < 4000  then
		return 0.66236686706543
	elseif y >= 4000 and y < 4300  then
		return 0.671566426754
	elseif y >= 4300 and y < 4600  then
		return 0.68076598644257
	elseif y >= 4600 and y < 4800  then
		return 0.68996548652649
	elseif y >= 4800 and y < 5000  then
		return 0.69896507263184
	elseif y >= 5000 and y < 5300  then
		return 0.70756465196609
	elseif y >= 5300 and y < 5600  then
		return 0.71676415205002
	elseif y >= 5600 and y < 5800  then
		return 0.7255637049675
	elseif y >= 5800 and y < 6000  then
		return 0.73456329107285
	elseif y >= 6000 and y < 6300  then
		return 0.74356281757355
	elseif y >= 6300 and y < 6600  then
		return 0.75236237049103
	elseif y >= 6600 and y < 6800  then
		return 0.76136195659637
	elseif y >= 6800 and y < 7000  then
		return 0.77096146345139
	elseif y >= 7000 and y < 7300  then
		return 0.77976101636887
	elseif y >= 7300 and y < 7600  then
		return 0.78896057605743
	elseif y >= 7600 and y < 7800  then
		return 0.79796010255814
	elseif y >= 7800 and y < 8000  then
		return 0.8065596818924
	elseif y >= 8000 and y < 8500  then
		return 0.81575924158096
	elseif y >= 8500 and y < 8900  then
		return 0.82455879449844
	elseif y >= 8900 and y < 9300  then
		return 0.83355832099915
	elseif y >= 9300 and y < 9600  then
		return 0.84235787391663
	elseif y >= 9600 and y < 10000  then
		return 0.85135746002197
	elseif y >= 10000 and y < 10500  then
		return 0.86115694046021
	elseif y >= 10500 and y < 11000  then
		return 0.87015646696091
	elseif y >= 11000 and y < 11500  then
		return 0.87895607948303
	elseif y >= 11500 and y < 12000  then
		return 0.88795560598373
	elseif y >= 12000 and y < 13000  then
		return 0.89675515890121
	elseif y >= 13000 and y < 14000  then
		return 0.90575474500656
	elseif y >= 14000 and y < 15000  then
		return 0.91475427150726
	elseif y >= 15000 and y < 16000  then
		return 0.92355382442474
	elseif y >= 16000 and y < 17000  then
		return 0.93335336446762
	elseif y >= 17000 and y < 18000  then
		return 0.94235289096832
	elseif y >= 18000 and y < 19000  then
		return 0.9511524438858
	elseif y >= 19000 and y < 19500  then
		return 0.95995199680328
	elseif y >= 19500 and y < 20000  then
		return 0.96855157613754
	elseif y >= 20000 and y < 23000  then
		return 0.97835105657578
	elseif y >= 23000 and y < 26000  then
		return 0.98675066232681
	elseif y == 26000 then
		return 1.0
	end
end

return surge