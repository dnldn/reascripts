--DNLDN Adjust fade curve under cursor
--2-1-21

--#########################################
--#########################################
--#########################################
--ADD VOLUME SLIDER2DB FUNCTION LATER
--#########################################
--#########################################
--#########################################

------------------------------------------------------------------------------------------------------------------------------

--Check that item under cursor exists.
function itemExists(item)
    if item then return true
    else return false end
end

------------------------------------------------------------------------------------------------------------------------------

reaper.Undo_BeginBlock() -- Beginning of undo block.
reaper.PreventUIRefresh(1)-- Prevent UI refreshing. Uncomment it only if the script works.

storedPos = reaper.GetCursorPosition()
item, cursorPos = reaper.BR_ItemAtMouseCursor()
reaper.SetEditCurPos(cursorPos, true, true)
 _,_,_,_,_,_,mouse_scroll  = reaper.get_action_context() 

if itemExists(item) then

    --Get item positional information.
    position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    endPos = length + position
    middle = position + (endPos - position)/2
    fadeInEnd = position + reaper.GetMediaItemInfo_Value(item, "D_FADEINLEN")
    fadeOutStart = endPos - reaper.GetMediaItemInfo_Value(item, "D_FADEOUTLEN")
    curFadeInShape = reaper.GetMediaItemInfo_Value(item, "D_FADEINDIR")
    curFadeOutShape = reaper.GetMediaItemInfo_Value(item, "D_FADEOUTDIR")
    
    
    if cursorPos < fadeInEnd and curFadeInShape > -.9 and mouse_scroll > 0 then 
          reaper.SetMediaItemInfo_Value(item, "D_FADEINDIR", curFadeInShape-.1)
    end
    
    if cursorPos > fadeOutStart and curFadeOutShape < .9 and mouse_scroll > 0 then 
            reaper.SetMediaItemInfo_Value(item, "D_FADEOUTDIR", curFadeOutShape+.1)
    end
    
    if cursorPos < fadeInEnd and curFadeInShape < .9 and mouse_scroll < 0 then 
            reaper.SetMediaItemInfo_Value(item, "D_FADEINDIR", curFadeInShape+.1)
    end 
    
    if cursorPos > fadeOutStart and curFadeOutShape > -.9 and mouse_scroll < 0 then 
            reaper.SetMediaItemInfo_Value(item, "D_FADEOUTDIR", curFadeOutShape-.1)
    end
    
    
end

reaper.SetEditCurPos(storedPos, true, true)
reaper.PreventUIRefresh(-1) -- Restore UI refresh. Uncomment it only if the script works.
reaper.UpdateArrange()
reaper.Undo_EndBlock("DNLDN: Adjust Fade curve under cursor", -1) -- End of the undo block.
