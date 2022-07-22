--UNIVERSALS:
library = reaper.GetResourcePath() .. "\\Scripts\\DNLDN\\PROQ_NEB\\LIBRARIES\\"
hw_dir = reaper.GetResourcePath() .. "\\Scripts\\DNLDN\\PROQ_NEB\\CONFIGURATIONS\\"
dictionary = reaper.GetResourcePath() .. "\\Scripts\\DNLDN\\PROQ_NEB\\CONFIGURATIONS\\dictionary.lua"

--Libraries: contain the module information needed to get/set values to and from Pro-Q and nebula.
proq = library.."proq.lua"
GML8200 = library.."surge.lua"
S432 = library.."s432.lua"
MASSIVEPASSIVE = library.."massive.lua"
CURVEBENDER = library .. "coffee.lua"

proq = dofile(proq)
gml = dofile(GML8200)
s432 = dofile(S432)
msv = dofile(MASSIVEPASSIVE)
ccb = dofile(CURVEBENDER)

--Configurations: contain the resources and information needed by primary script to ID the hardware being used in the FX chain.
GML_8 = hw_dir .. "gml_8.lua"
MSV_8 = hw_dir .. "msv_8.lua"
CCB = hw_dir .. "coffee.lua"

--Refactor to become an exterior definition file, which allows additional libraries to be added without clouding things up here.
--This should be changed to return the object, as long as there aren't performance drawbacks to doing that.
function checkForFX()
    local exists, tracknumber, _, fxnumber = reaper.GetFocusedFX2()
    if exists then
        local current_track = reaper.GetTrack(0, tracknumber-1)
        if current_track then
            local _, alias = reaper.TrackFX_GetFXName(current_track, fxnumber)
            if alias == "GML_CONTROLLER" then
                local name = {}
                for i = 1, 9 do
                    _, name[i] = reaper.TrackFX_GetFXName(current_track, fxnumber+i)
                end
                
                --GML 8200 SANDBAG CHECK. FUNCTIONALIZE LATER.
                if name[1] == "GML_LOW_SHELF" and name[2] == "GML_LOW_MID" and name[3] == "GML_LOW_MID" and name[4] == "GML_LOW_MID"
                and name[5] == "GML_HIGH_MID" and name[6] == "GML_HIGH_MID" and name[7] == "GML_HIGH_MID" and name[8] == "GML_HIGH_SHELF"
                and name[9] == "GML_MIRROR" then return true, dofile(GML_8) end
            elseif alias == "MMP_CONTROLLER" then
                local name = {}
                for i = 1, 18 do
                    _, name[i] = reaper.TrackFX_GetFXName(current_track, fxnumber+i)
                end
                
                --MASSIVE SANDBAG CHECK. FUNCTIONALIZE LATER.
                if name[1] == "MMP_LF_SHELF_CUT" and name[2] == "MMP_LF_SHELF_BOOST" and name[3] == "MMP_LF_BELL_CUT" and name[4] == "MMP_LF_BELL_BOOST"
                and name[5] == "MMP_LM_BELL_CUT_1" and name[6] == "MMP_LM_BELL_BOOST_1" and name[7] == "MMP_LM_BELL_CUT_2" and name[8] == "MMP_LM_BELL_BOOST_2"
                and name[9] == "MMP_HM_BELL_CUT_1" and name[10] == "MMP_HM_BELL_BOOST_1" and name[11] == "MMP_HM_BELL_CUT_2" and name[12] == "MMP_HM_BELL_BOOST_2"
                and name[13] == "MMP_HF_BELL_CUT" and name[14] == "MMP_HF_BELL_BOOST" and name[15] == "MMP_HF_SHELF_CUT" and name[16] == "MMP_HF_SHELF_BOOST"
                and name[17] == "MMP_SHELF_COMPENSATION" and name[18] == "MMP_MIRROR" then return true, dofile(MSV_8) end
                
            elseif alias == "CBB_CONTROLLER" then
                local name = {}
                for i = 1, 2 do
                    _, name[i] = reaper.TrackFX_GetFXName(current_track, fxnumber+i)
                end
                
                --CURVE BENDER SANDBAG CHECK. FUNCTIONALIZE LATER (or never at this rate...)
                if name[1] == "CHANDLER CURVE BENDER" and name[2] == "CBB_MIRROR" then return true, dofile(CCB) end
            else
                return false
            end
        end
    else
        return false
    end
end

--Refactor to allow options beside GML_8, and those functions should probably run to an exterior xml file or something.
function updateNebulaFX()
    local exists, tracknumber, _, fxnumber = reaper.GetFocusedFX2()
    local current_track = reaper.GetTrack(0, tracknumber-1)
    if exists then
        local isValid, hardware = checkForFX()
        if isValid then
            eq = {
                band1={freq = proq.param.freq, gain = proq.param.gain, q = proq.param.Q, shape = proq.param.shape, solo = proq.param.solo, used = proq.param.used},
                band2={freq = proq.param.freq + (proq.param.gap*1), gain = proq.param.gain + (proq.param.gap*1), q = proq.param.Q + (proq.param.gap*1), shape = proq.param.shape + (proq.param.gap*1), solo = proq.param.solo + (proq.param.gap*1), used = proq.param.used + (proq.param.gap*1)},
                band3={freq = proq.param.freq + (proq.param.gap*2), gain = proq.param.gain + (proq.param.gap*2), q = proq.param.Q + (proq.param.gap*2), shape = proq.param.shape + (proq.param.gap*2), solo = proq.param.solo + (proq.param.gap*2), used = proq.param.used + (proq.param.gap*2)},
                band4={freq = proq.param.freq + (proq.param.gap*3), gain = proq.param.gain + (proq.param.gap*3), q = proq.param.Q + (proq.param.gap*3), shape = proq.param.shape + (proq.param.gap*3), solo = proq.param.solo + (proq.param.gap*3), used = proq.param.used + (proq.param.gap*3)},
                band5={freq = proq.param.freq + (proq.param.gap*4), gain = proq.param.gain + (proq.param.gap*4), q = proq.param.Q + (proq.param.gap*4), shape = proq.param.shape + (proq.param.gap*4), solo = proq.param.solo + (proq.param.gap*4), used = proq.param.used + (proq.param.gap*4)},
                band6={freq = proq.param.freq + (proq.param.gap*5), gain = proq.param.gain + (proq.param.gap*5), q = proq.param.Q + (proq.param.gap*5), shape = proq.param.shape + (proq.param.gap*5), solo = proq.param.solo + (proq.param.gap*5), used = proq.param.used + (proq.param.gap*5)},
                band7={freq = proq.param.freq + (proq.param.gap*6), gain = proq.param.gain + (proq.param.gap*6), q = proq.param.Q + (proq.param.gap*6), shape = proq.param.shape + (proq.param.gap*6), solo = proq.param.solo + (proq.param.gap*6), used = proq.param.used + (proq.param.gap*6)},
                band8={freq = proq.param.freq + (proq.param.gap*7), gain = proq.param.gain + (proq.param.gap*7), q = proq.param.Q + (proq.param.gap*7), shape = proq.param.shape + (proq.param.gap*7), solo = proq.param.solo + (proq.param.gap*7), used = proq.param.used + (proq.param.gap*7)}
            }
            hardware:updateBands(current_track, eq, fxnumber, hardware)
        end
    end
end

function startDefer(SCRIPTNAME)
    gfx.init(SCRIPTNAME, 200, 10, 0, 0, 0)
end

function main()

    updateNebulaFX()
    if gfx.getchar() >= 0 then
        reaper.defer(main)
        bool = false
    else
        bool = true
    end
    
    --Atexit logic (maybe save to ext state or something in the future?)
    if bool then
        reaper.atexit()
    end
end
startDefer("NEBULA/ACQUA Deferred Script")
main()


--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DEBUG AREA FOR FUNCTION TESTING ONLY - NO IMPLEMENTATION.
--USE CROSS THREAD APPROACH HERE TO CHECK FOR TRANSLATION.
--x = norm
--y = val
--x = .21481
--y = 6800



--a1_v = gml:getQVal(x)
--a2_v = gml:getGainVal(x)
--a3_v = gml:getFreqLFVal(x)
--a4_v = gml:getFreqHFVal(x)

--a5_n = gml:getQNormVal(y)
--a6_n = gml:getGainNormVal(y)
--a7_n = gml:getFreqLFNormVal(y)
--a8_n = gml:getFreqHFNormVal(y)


--b1 = s432:getQVal(x)
--b2 = s432:getGainVal(x)
--b3 = s432:getFreqLFShelfVal(x)
--b4 = s432:getFreqLFVal(x)
--b6 = s432:getFreqLMFVal(x)
--b7 = s432:getFreqHMFVal(x)
--b8 = s432:getFreqHFVal(x)

--b9 = s432:getQNormVal(y)
--b10 = s432:getGainNormVal(y)
--b11 = s432:getFreqLFShelfNormVal(y)
--b12 = s432:getFreqLFNormVal(y)
--b13 = s432:getFreqLMFNormVal(y)
--b14 = s432:getFreqHMFNormVal(y)
--b15 = s432:getFreqHFNormVal(y)


--c1 = msv:getQVal(x)
--c2 = msv:getBoostVal(x)
--c3 = msv:getCutVal(x)
--c4 = msv:getFreqLFVal(x)
--c5 = msv:getFreqLMFVal(x)
--c6 = msv:getFreqHMFVal(x)
--c7 = msv:getFreqHFVal(x)

--c8 = msv:getQNormVal(y)
--c9 = msv:getBoostNormVal(y)
--c10 = msv:getCutNormVal(y)
--c11 = msv:getFreqLFNormVal(y)
--c12 = msv:getFreqLMFNormVal(y)
--c13 = msv:getFreqHMFNormVal(y)
--c14 = msv:getFreqHFNormVal(y)

--[[
FUNCTION TOOLTIPS FROM MODULES:
function gml:getQVal(norm)--Returns Q value of GML 8200 to pass into pro-q.
function gml:getQNormVal(val)--Returns normalized value of Q for GML 8200.
function gml:getGainVal(norm)--Returns gain value to pass into pro-q.
function gml:getGainNormVal(val)--Returns normalized value of gain for GML 8200.
function gml:getFreqLFVal(norm)--Returns frequency value of GML 8200 low frequency band to pass into pro-q.
function gml:getFreqLFNormVal(val)--Returns normalized value of low frequency band for GML 8200.
function gml:getFreqHFVal(norm)--Returns frequency value of  GML 8200 high frequency band to pass into pro-q.
function gml:getFreqHFNormVal(val)--Returns normalized value of high frequency band for GML 8200.
function gml:getFreqLFShelfVal(x)--Returns frequency value of GML 8200 low frequency shelf to pass into pro-q.
function gml:getFreqLFShelfNormVal(y)--Returns normalized value of low frequency shelf for GML 8200
function gml:getFreqHFShelfVal(x)--Returns frequency value of GML 8200 low frequency shelf to pass into pro-q.
function gml:getFreqHFShelfNormVal(y)--Returns normalized value of low frequency shelf for GML 8200.

function s432:getQVal(norm)--Returns scaled Q value of S432 to pass into pro-q.
function s432:getQNormVal(Q)--Returns normalized value of Q for S432.
function s432:getGainVal(norm)--Returns gain value to pass into pro-q.
function s432:getGainNormVal(gain)--Returns normalized value of gain for S432.
function s432:getFreqLFShelfVal(norm)--Returns low shelf value to pass into pro-q.
function s432:getFreqLFShelfNormVal(freq)--Returns normalized value of low shelf switch for S432.
function s432:getFreqLFVal(norm)--Returns frequency value of S432 low band to pass into pro-q.  
function s432:getFreqLFNormVal(freq)--Returns normalized frequency value of S432 low band.
function s432:getFreqLMFVal(norm)--Returns frequency value of S432 low mid band to pass into pro-q.
function s432:getFreqLMFNormVal(freq)--Returns normalized frequency value of S432 low mid band.
function s432:getFreqHMFVal(norm)--Returns frequency value of S432 high mid band to pass into pro-q.
function s432:getFreqHMFNormVal(freq)--Returns normalized frequency value of S432 high mid band.
function s432:getFreqHFVal(norm)--Returns frequency value of S432 high band to pass into pro-q.
function s432:getFreqHFNormVal(freq)--Returns normalized frequency value of S432 high band.

function msv:getBoostVal(x)--Returns boost value to pass into pro-q.
function msv:getBoostNormVal(y)--Returns normalized value of Manley Massive Passive boost.
function msv:getCutVal(x)--Returns cut value to pass into pro-q.
function msv:getCutNormVal(y)--Returns normalized value of Manley Massive Passive cut.
function msv:getQVal(x)--Returns Q value to pass into pro-q.
function msv:getQNormVal(y)--Returns normalized value of Manley Massive Passive boost/cut.
function msv:getFreqLFVal(x)--Returns frequency value of Manley Massive Passive low band to pass into pro-q.
function msv:getFreqLFNormVal(y)--Returns normalized frequency value of Manley Massive Passive low band.
function msv:getFreqLMFVal(x)--Returns frequency value of S432 Manley Massive Passive mid to pass into pro-q.
function msv:getFreqLMFNormVal(y)--Returns normalized frequency value of S432 Manley Massive Passive mid band.
function msv:getFreqHMFVal(x)--Returns frequency value of S432 Manley Massive Passive mid to pass into pro-q.
function msv:getFreqHMFNormVal(y)--Returns normalized frequency value of S432 Manley Massive Passive mid band.
function msv:getFreqHFVal(x)--Returns frequency value of Manley Massive Passive high band to pass into pro-q.
function msv:getFreqHFNormVal(y)--Returns normalized frequency value of Manley Massive Passive high band.

function proq:getFreqNormval(freq)--Returns normalized value of frequency for Pro-Q.
function proq:getFreqVal(norm)--Returns frequency of normalized value from Pro-Q.
function proq:getQNormVal(Q)--Returns normalized value of Q from Pro-Q.
function proq:getQVal(norm)--Returns Q value of normalized value from Pro-Q.
function proq:getGainNormVal(gain)--Returns normalized value of gain from Pro-Q.
function proq:getGainVal(norm)--Returns gain value of normalized value from Pro-Q.
function hardware:updatebands(track, eq, controller_pos, hw)--Update all Pro-Q bands and nebula bands on defer cycle.
]]
