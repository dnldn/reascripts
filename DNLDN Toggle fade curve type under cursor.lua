--Toggle fade curve type under cursor
--DNLDN 2-2-21

------------------------------------------------------------------------------------------------------------------------------

--Check that item under cursor exists.
function itemExists(item)
    if item then return true
    else return false end
end

------------------------------------------------------------------------------------------------------------------------------

--Check if multiple items are selected.
function multipleAreSelected()
    local count = reaper.CountMediaItems(0)
    local retval = 0
    for i = 0, count-1 do
        local curItem = reaper.GetMediaItem(0, i)
        selected = reaper.GetMediaItemInfo_Value(curItem, "B_UISEL")
        if selected == 1 then
            retval = retval + 1
        end
    end
    if retval > 1 then return true
    else return false end
end

------------------------------------------------------------------------------------------------------------------------------

--Populate values.
multiSel = multipleAreSelected()
storedPos = reaper.GetCursorPosition()
item, cursorPos = reaper.BR_ItemAtMouseCursor()
reaper.SetEditCurPos(cursorPos, true, true)

--Checks existence of item.
if itemExists(item) then

    --Get item positional information.
    position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    endPos = length + position
    middle = position + (endPos - position)/2
    fadeInEnd = position + reaper.GetMediaItemInfo_Value(item, "D_FADEINLEN")
    fadeInType = reaper.GetMediaItemInfo_Value(item, "C_FADEINSHAPE")
    fadeOutStart = endPos - reaper.GetMediaItemInfo_Value(item, "D_FADEOUTLEN")
    fadeOutType = reaper.GetMediaItemInfo_Value(item, "C_FADEOUTSHAPE")
    
    if cursorPos < fadeInEnd then
        if fadeInType == 0 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 1)
        elseif fadeInType == 1 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 2)
        elseif fadeInType == 2 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 3)
        elseif fadeInType == 3 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 4)
        elseif fadeInType == 4 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 5)
        elseif fadeInType == 5 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 6)
        elseif fadeInType == 6 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 0)
        end
    end
    
    if cursorPos > fadeOutStart then
        if fadeOutType == 0 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 1)
        elseif fadeOutType == 1 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 2)
        elseif fadeOutType == 2 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 3)
        elseif fadeOutType == 3 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 4)
        elseif fadeOutType == 4 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 5)
        elseif fadeOutType == 5 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 6)
        elseif fadeOutType == 6 then
            reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 0)
        end
    end
    
    
    --If multiple items are selected, apply fadein/fadeout to all items to cursor.
    --[[if multiSel then 
    
    end]]
  
    
    
    

end

reaper.UpdateArrange()
