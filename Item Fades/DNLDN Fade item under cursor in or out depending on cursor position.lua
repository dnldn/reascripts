--Apply linear fade in or out to item under cursor depending on cursor position relative to middle of item.
--DNLDN 2-1-21

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
    
    --If multiple items are selected, apply fadein/fadeout to all items to cursor.
    if multiSel then 
  
        if cursorPos > middle then
              reaper.Main_OnCommand(40510,0) --Fade selected items out to cursor.
        elseif cursorPos <= middle then
              reaper.Main_OnCommand(40509,0) -- Fade selected items into cursor.
        end
    
    --If one or no items are selected, apply fadein/fadeout to the one item.
    else
    
        if cursorPos > middle then
              reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", endPos-cursorPos)
              reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", 0)
        elseif cursorPos <= middle then
              reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", cursorPos-position)
              reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", 0)    
        end
    end
end

reaper.UpdateArrange()
