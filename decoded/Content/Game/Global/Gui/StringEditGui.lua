-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\StringEditGui.lua 

local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local SpriteSheet = require("SpriteSheet")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local PromptGui = Gui.load("Content/Game/Global/Gui/PromptGui")
local StringEditGui = require("Class").create(HackFramedGui, "StringEditGui")
StringEditGui.InnerGui = require("Class").create(Gui, "StringEditGui.InnerGui")
StringEditGui.InnerGui.BLINK_DURATION = 0.5
StringEditGui.InnerGui.CURSOR_SIZE = 23
StringEditGui.InnerGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Gui.init(l_1_0, l_1_1)
  l_1_0.container, l_1_0.field, l_1_0.schema, l_1_0.characterFilter = l_1_2, l_1_3, l_1_4, l_1_6
  l_1_0.gotTextInput = false
  l_1_0.label = LabelGui.new(l_1_0, nil, {justifyVertical = MOAITextBox.CENTER_JUSTIFY})
  local cursors = SpriteSheet.load("UI/Cursors/Cursors")
  l_1_0.up = SpriteGui.new(l_1_0, cursors, "UpArrow", {blinkDuration = l_1_0.BLINK_DURATION})
  l_1_0.down = SpriteGui.new(l_1_0, cursors, "DownArrow", {blinkDuration = l_1_0.BLINK_DURATION})
  l_1_0.left = SpriteGui.new(l_1_0, cursors, "LeftArrow", {blinkDuration = l_1_0.BLINK_DURATION})
  l_1_0.right = SpriteGui.new(l_1_0, cursors, "RightArrow", {blinkDuration = l_1_0.BLINK_DURATION})
  l_1_0.schema:registerValueSetHandler(l_1_2, l_1_0.onValueSet, l_1_0)
  local initial = l_1_2[l_1_3]
  l_1_0:setCursor(#initial + 1)
  l_1_0:onValueSet(initial)
  if l_1_5 then
    l_1_0.prompt = PromptGui.new(l_1_0, l_1_5, "Select")
  end
end

StringEditGui.InnerGui.setCursor = function(l_2_0, l_2_1)
  l_2_0.cursor = l_2_1
  l_2_0:updateCursorArrows()
  l_2_0:redoLayout()
end

StringEditGui.InnerGui.shiftCharacter = function(l_3_0, l_3_1)
  local value = l_3_0.container[l_3_0.field]
  do
    local charCode = nil
    if l_3_0.cursor <= #value then
      charCode = value:byte(l_3_0.cursor)
    else
      charCode = string.byte("A") - l_3_1
    end
    repeat
      charCode = charCode + l_3_1
      repeat
        if charCode < 32 then
          charCode = 127 - (32 - (charCode))
        elseif charCode > 126 then
          charCode = 32 + (charCode - 126)
      until not l_3_0.characterFilter or not string.char(charCode):gmatch(l_3_0.characterFilter)()
      else
        l_3_0.container[l_3_0.field] = value:sub(1, l_3_0.cursor - 1) .. string.char(charCode) .. value:sub(l_3_0.cursor + 1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StringEditGui.InnerGui.tick = function(l_4_0)
  Gui.tick(l_4_0)
  l_4_0.gotTextInput = false
end

StringEditGui.InnerGui.handleKeys = function(l_5_0, l_5_1)
  for _,keyCode in ipairs(l_5_1) do
    if l_5_0:handleKey(keyCode) then
      l_5_0:playCue("UI/Hacking_UI/HackingUI_ValueToggle")
    end
  end
end

StringEditGui.InnerGui.handleTextInput = function(l_6_0, l_6_1)
  l_6_0.gotTextInput = true
  if l_6_0.characterFilter then
    local filtered = ""
    for i = 1, #l_6_1 do
      local char = l_6_1:sub(i, i)
      if char:gmatch(l_6_0.characterFilter)() then
        filtered = filtered .. char
      end
    end
    l_6_1 = filtered
  end
  if l_6_1 ~= "" then
    local value = l_6_0.container[l_6_0.field]
    l_6_0.container[l_6_0.field] = value:sub(1, l_6_0.cursor - 1) .. l_6_1 .. value:sub(l_6_0.cursor)
    l_6_0:setCursor(l_6_0.cursor + #l_6_1)
    l_6_0:playCue("UI/Hacking_UI/HackingUI_ValueToggle")
  end
end

StringEditGui.InnerGui.handleKey = function(l_7_0, l_7_1)
  local value = l_7_0.container[l_7_0.field]
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_7_1 == 8 and l_7_0.cursor > 1 then
    l_7_0:setCursor(l_7_0.cursor - 1)
    l_7_0.container[l_7_0.field] = value:sub(1, l_7_0.cursor - 1) .. value:sub(l_7_0.cursor + 1)
    return true
    do return end
    if l_7_1 == 127 and l_7_0.cursor <= #value then
      l_7_0.container[l_7_0.field] = value:sub(1, l_7_0.cursor - 1) .. value:sub(l_7_0.cursor + 1)
      return true
    end
  end
end

StringEditGui.InnerGui.handleMotive = function(l_8_0, l_8_1, l_8_2)
  if not l_8_0.gotTextInput then
    if l_8_1 == "Left" then
      if l_8_0.cursor > 1 then
        l_8_0:setCursor(l_8_0.cursor - 1)
      end
      l_8_0:playCue("UI/Hacking_UI/HackingUI_ValueToggle")
      return 
    elseif l_8_1 == "Right" then
      if l_8_0.cursor < #l_8_0.container[l_8_0.field] + 1 then
        l_8_0:setCursor(l_8_0.cursor + 1)
      end
      l_8_0:playCue("UI/Hacking_UI/HackingUI_ValueToggle")
      return 
    elseif l_8_1 == "Up" then
      l_8_0:shiftCharacter(1)
      l_8_0:playCue("UI/Hacking_UI/HackingUI_ValueToggle")
      return 
    elseif l_8_1 == "Down" then
      l_8_0:shiftCharacter(-1)
      l_8_0:playCue("UI/Hacking_UI/HackingUI_ValueToggle")
      return 
    end
  end
  Gui.handleMotive(l_8_0, l_8_1, l_8_2)
end

StringEditGui.InnerGui.onValueSet = function(l_9_0, l_9_1)
  l_9_0.label:setText(l_9_1)
  if #l_9_1 + 1 < l_9_0.cursor then
    l_9_0:setCursor(#l_9_1 + 1)
  end
  l_9_0:updateCursorArrows()
  l_9_0:requestResize()
end

StringEditGui.InnerGui.updateCursorArrows = function(l_10_0)
  l_10_0.left:show(l_10_0.cursor > 1)
  l_10_0.left:reset()
  l_10_0.right:show(l_10_0.cursor < #l_10_0.container[l_10_0.field] + 1)
  l_10_0.right:reset()
  l_10_0.up:reset()
  l_10_0.down:reset()
end

StringEditGui.InnerGui.measure = function(l_11_0, l_11_1, l_11_2)
  local labelX, labelY = l_11_0.label:measure(l_11_1, l_11_2)
  local totalX, totalY = labelX + 2 * l_11_0.CURSOR_SIZE, labelY + l_11_0.CURSOR_SIZE * 2
  if l_11_0.prompt then
    local promptX, promptY = l_11_0.prompt:measure(l_11_1, l_11_2)
    promptX, promptY = promptX * 0.5, promptY * 0.5
    if totalX < promptX then
      totalX = promptX
    end
    totalY = math.max(totalY + promptY, 180)
  end
  return totalX, totalY
end

StringEditGui.InnerGui.resize = function(l_12_0, l_12_1, l_12_2)
  Gui.resize(l_12_0, l_12_1, l_12_2)
  local y0 = 0
  if l_12_0.prompt then
    local promptX, promptY = l_12_0.prompt:measure(l_12_1, l_12_2)
    promptX, promptY = promptX * 0.5, promptY * 0.5
    l_12_0.prompt:position(l_12_1 - promptX, 0, l_12_1, promptY)
    y0 = promptY
    l_12_2 = l_12_2 - promptY
  end
  local centerY = (l_12_2) * 0.5
  local labelX, labelY = l_12_0.label:measure(l_12_1, l_12_2)
  l_12_0.left:position(0, y0 + centerY - l_12_0.CURSOR_SIZE * 0.5, l_12_0.CURSOR_SIZE, y0 + centerY + l_12_0.CURSOR_SIZE * 0.5)
  l_12_0.label:position(l_12_0.CURSOR_SIZE, y0 + l_12_0.CURSOR_SIZE, l_12_0.CURSOR_SIZE + labelX, y0 + (l_12_2) - l_12_0.CURSOR_SIZE)
  l_12_0.right:position(l_12_0.CURSOR_SIZE + labelX, y0 + centerY - l_12_0.CURSOR_SIZE * 0.5, l_12_0.CURSOR_SIZE * 2 + labelX, y0 + centerY + l_12_0.CURSOR_SIZE * 0.5)
  local cursorX = l_12_0.CURSOR_SIZE + l_12_0.CURSOR_SIZE * (l_12_0.cursor - 0.5)
  l_12_0.down:position(cursorX - l_12_0.CURSOR_SIZE * 0.5, y0, cursorX + l_12_0.CURSOR_SIZE * 0.5, y0 + l_12_0.CURSOR_SIZE)
  l_12_0.up:position(cursorX - l_12_0.CURSOR_SIZE * 0.5, y0 + (l_12_2) - l_12_0.CURSOR_SIZE, cursorX + l_12_0.CURSOR_SIZE * 0.5, y0 + (l_12_2))
end

StringEditGui.init = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4, l_13_5, l_13_6)
  HackFramedGui.init(l_13_0, l_13_1, tostring(l_13_3), l_13_5)
  l_13_0.dismissEvent = Delegate.new()
  l_13_0.selectEvent = Delegate.new()
  l_13_0:setHackInnerGui(StringEditGui.InnerGui.new(l_13_0, l_13_2, l_13_3, l_13_4, l_13_5, l_13_6))
end

StringEditGui.dismiss = function(l_14_0)
  l_14_0.dismissed = true
  l_14_0.dismissEvent:dispatch()
end

StringEditGui.handleMotiveStart = function(l_15_0, l_15_1)
  if not l_15_0.inner.gotTextInput then
    if l_15_1 == "Dismiss" then
      l_15_0:dismiss()
    elseif l_15_1 == "Select" then
      l_15_0.selectEvent:dispatch()
      l_15_0:dismiss()
    else
      HackFramedGui.handleMotiveStart(l_15_0, l_15_1)
    end
  end
end

return StringEditGui

