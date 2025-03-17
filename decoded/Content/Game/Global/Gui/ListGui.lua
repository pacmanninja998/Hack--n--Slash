-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ListGui.lua 

local Gui = require("Gui")
local ListGui = require("Class").create(Gui, "ListGui")
local Delegate = require("DFMoai.Delegate")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local SpriteSheet = require("SpriteSheet")
ListGui.CURSOR_SPACE = 24
ListGui.DEFAULT_ITEM_HEIGHT = 48
ListGui.CURSOR_BLINK_DURATION = 0.5
ListGui.init = function(l_1_0, l_1_1, l_1_2)
  Gui.init(l_1_0, l_1_1)
  l_1_0.guis = {}
  l_1_0.selectionChangeEvent = Delegate.new()
  if not l_1_2 then
    l_1_0.itemHeight = l_1_0.DEFAULT_ITEM_HEIGHT
  end
  local cursors = SpriteSheet.load("UI/Cursors/Cursors")
  l_1_0.up = SpriteGui.new(l_1_0, cursors, "UpArrow", {blinkDuration = l_1_0.CURSOR_BLINK_DURATION})
  l_1_0.down = SpriteGui.new(l_1_0, cursors, "DownArrow", {blinkDuration = l_1_0.CURSOR_BLINK_DURATION})
  l_1_0.cursor = SpriteGui.new(l_1_0, cursors, "RightArrow", {blinkDuration = l_1_0.CURSOR_BLINK_DURATION})
  l_1_0:clear()
end

ListGui.insert = function(l_2_0, l_2_1, l_2_2)
  if not l_2_2 then
    l_2_2 = l_2_1
    l_2_1 = #l_2_0.guis + 1
  end
  assert(l_2_2.parent == l_2_0)
  local currentIndex = l_2_0.selectionIndex
  local newIndex = currentIndex or l_2_1
  if currentIndex and l_2_1 <= currentIndex then
    l_2_0:setSelection(nil)
    newIndex = currentIndex + 1
  end
  table.insert(l_2_0.guis, l_2_1, l_2_2)
  l_2_0:requestResize()
  l_2_0:setSelection(newIndex)
end

ListGui.remove = function(l_3_0, l_3_1)
  if not l_3_1 then
    l_3_1 = #l_3_0.guis
  end
  local currentIndex = l_3_0.selectionIndex
  if currentIndex and l_3_1 <= currentIndex then
    l_3_0:setSelection(nil)
  end
  local gui = l_3_0.guis[l_3_1]
  gui:destroy()
  table.remove(l_3_0.guis, l_3_1)
  l_3_0:requestResize()
  if currentIndex and l_3_1 <= currentIndex and #l_3_0.guis ~= 0 then
    if l_3_1 < currentIndex then
      currentIndex = currentIndex - 1
    end
    l_3_0:setSelection(math.min(currentIndex, #l_3_0.guis))
  end
end

ListGui.clear = function(l_4_0)
  l_4_0:setSelection()
  l_4_0.visibleIndex = 1
  for index,gui in ipairs(l_4_0.guis) do
    gui:destroy()
  end
  l_4_0.guis = {}
  l_4_0:requestResize()
end

ListGui.handleFocusGain = function(l_5_0)
  if l_5_0.root.focus == l_5_0 then
    if l_5_0.selectionIndex then
      local gui = l_5_0.guis[l_5_0.selectionIndex]
    end
    if gui then
      l_5_0.root:setFocus(gui)
    end
  end
end

ListGui.handleMotive = function(l_6_0, l_6_1, l_6_2)
  local delta = 0
  if l_6_1 == "Up" then
    delta = -1
  elseif l_6_1 == "Down" then
    delta = 1
  end
  if l_6_0.selectionIndex and delta ~= 0 then
    local newIndex = 1 + (l_6_0.selectionIndex + delta - 1) % #l_6_0.guis
    l_6_0:playCue("UI/Hacking_UI/HackingUI_ToggleParameter")
    l_6_0:setSelection(newIndex)
    return 
  end
  Gui.handleMotive(l_6_0, l_6_1, l_6_2)
end

ListGui.measure = function(l_7_0, l_7_1, l_7_2)
  l_7_1 = l_7_1 - l_7_0.CURSOR_SPACE
  l_7_2 = l_7_2 - l_7_0.CURSOR_SPACE * 2
  local sizeX, sizeY = 0, 0
  do
    local i = l_7_0.visibleIndex
    repeat
      if i <= #l_7_0.guis then
        local item = l_7_0.guis[i]
        local itemX, itemY = item:measure(l_7_1, l_7_2)
        if itemY < l_7_0.itemHeight then
          itemY = l_7_0.itemHeight
        end
        if sizeX < itemX then
          sizeX = itemX
        end
        if l_7_2 < sizeY + itemY then
          do return end
        end
        sizeY = sizeY + itemY
        i = i + 1
      else
        return sizeX, sizeY + l_7_0.CURSOR_SPACE * 2
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ListGui.resize = function(l_8_0, l_8_1, l_8_2)
  Gui.resize(l_8_0, l_8_1, l_8_2)
  l_8_0.up:position(0, l_8_2 - l_8_0.CURSOR_SPACE, l_8_1, l_8_2)
  l_8_0.down:position(0, 0, l_8_1, l_8_0.CURSOR_SPACE)
  local itemHeights = {}
  for i,item in ipairs(l_8_0.guis) do
    local itemX, itemY = item:measure(l_8_1 - l_8_0.CURSOR_SPACE, l_8_2)
    if itemY < l_8_0.itemHeight then
      itemY = l_8_0.itemHeight
    end
    itemHeights[i] = itemY
  end
  if l_8_0.selectionIndex and l_8_0.selectionIndex < l_8_0.visibleIndex then
    l_8_0.visibleIndex = l_8_0.selectionIndex
  end
  local selectionDelta = 0
  for i = l_8_0.visibleIndex, math.min(l_8_0.selectionIndex or 1, #l_8_0.guis) do
    selectionDelta = selectionDelta + itemHeights[i]
  end
  if l_8_0.selectionIndex and l_8_0.visibleIndex < l_8_0.selectionIndex and l_8_2 - 2 * l_8_0.CURSOR_SPACE < selectionDelta then
    selectionDelta = selectionDelta - itemHeights[l_8_0.visibleIndex]
    l_8_0.visibleIndex = l_8_0.visibleIndex + 1
  else
    l_8_0.cursor:show(false)
    for i = 1, l_8_0.visibleIndex - 1 do
      local item = l_8_0.guis[i]
      item:show(false)
    end
    local itemTop = l_8_2 - l_8_0.CURSOR_SPACE
    local i = l_8_0.visibleIndex
    repeat
      if i <= #l_8_0.guis then
        local item = l_8_0.guis[i]
        local itemHeight = itemHeights[i]
        if itemTop - itemHeight < l_8_0.CURSOR_SPACE then
          do return end
        end
        item:show(true)
        item:position(l_8_0.CURSOR_SPACE, itemTop - itemHeight, l_8_1, itemTop)
        if i == l_8_0.selectionIndex then
          l_8_0.cursor:show(true)
          l_8_0.cursor:position(0, itemTop - itemHeight, l_8_0.CURSOR_SPACE, itemTop)
        end
        itemTop = itemTop - itemHeight
        l_8_2 = l_8_2 - (itemTop)
        i = i + 1
      else
        l_8_0.up:show(l_8_0.visibleIndex > 1)
        l_8_0.down:show(i <= #l_8_0.guis)
        repeat
          if i <= #l_8_0.guis then
            local item = l_8_0.guis[i]
            item:show(false)
            i = i + 1
          else
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ListGui.setSelection = function(l_9_0, l_9_1)
  if l_9_1 == l_9_0.selectionIndex then
    return 
  end
  local oldIndex = l_9_0.selectionIndex
  l_9_0.selectionIndex = l_9_1
  l_9_0.selectionChangeEvent:dispatch(l_9_1, oldIndex)
  l_9_0.root:setFocus(not l_9_0:hasFocus() or l_9_0.guis[l_9_0.selectionIndex] or l_9_0)
  l_9_0.cursor:reset()
  l_9_0:redoLayout()
end

return ListGui

