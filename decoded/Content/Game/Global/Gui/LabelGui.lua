-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\LabelGui.lua 

local Gui = require("Gui")
local LabelGui = require("Class").create(Gui, "LabelGui")
local Font = require("Font")
LabelGui.DEFAULT_HEIGHT = 48
LabelGui.SIZE_PADDING = 32
LabelGui.SPOOL_SPEED = 100
LabelGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Gui.init(l_1_0, l_1_1)
  if not l_1_3 then
    l_1_3 = {}
  end
  if not l_1_3.height then
    l_1_0.height = l_1_0.DEFAULT_HEIGHT
  end
  l_1_0.textBox = MOAITextBox.new()
  l_1_0.textBox:setSpeed(l_1_0.SPOOL_SPEED)
  l_1_0.textBox:setYFlip(true)
  if l_1_3.justifyHorizontal or not l_1_3.justifyVertical then
    l_1_0.textBox:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  end
  l_1_0:addProp(l_1_0.textBox)
  local defaultFont = Font.load(Font.STANDARD_PATH)
  local defaultStyle = defaultFont:makeStyle(l_1_0.height)
  l_1_0.textBox:setStyle(defaultStyle)
  local shiftedFont = Font.load(Font.SHIFTED_PATH)
  local shiftedStyle = shiftedFont:makeStyle(l_1_0.height)
  l_1_0.textBox:setStyle("shifted", shiftedStyle)
  local symbolicFont = Font.load(Font.GLYPH_PATH)
  local symbolicStyle = symbolicFont:makeStyle(l_1_0.height)
  l_1_0.textBox:setStyle("symbolic", symbolicStyle)
  local titleFont = Font.load(Font.TITLE_PATH)
  local titleStyle = titleFont:makeStyle(l_1_0.height)
  l_1_0.textBox:setStyle("title", titleStyle)
  if l_1_2 then
    l_1_0:setText(l_1_2)
  end
  if not l_1_3.color then
    l_1_0:setColor(unpack({1, 1, 1, 1}))
  end
end

LabelGui.setText = function(l_2_0, l_2_1)
  l_2_0.text = l_2_1
  l_2_0.textBox:setString(l_2_0.text)
  l_2_0:requestResize()
end

LabelGui.setColor = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  l_3_0.textBox:setColor(l_3_1, l_3_2, l_3_3, l_3_4)
end

LabelGui.spool = function(l_4_0)
  l_4_0.textBox:spool()
end

LabelGui.more = function(l_5_0)
  return l_5_0.textBox:more()
end

LabelGui.nextPage = function(l_6_0, l_6_1)
  l_6_0.textBox:spool()
end

LabelGui.revealAll = function(l_7_0)
  l_7_0.textBox:setReveal(#l_7_0.text)
end

LabelGui.isDone = function(l_8_0)
  return l_8_0.textBox:isDone()
end

LabelGui.getSubstringBounds = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4)
  l_9_0.textBox:setRect(0, 0, l_9_3 or 10000, l_9_4 or 10000)
  local xMin, yMin, xMax, yMax = l_9_0.textBox:getStringBounds(l_9_1, l_9_2)
  if not xMin then
    return 0, 0
  end
  if l_9_0.sizeX and l_9_0.sizeY then
    l_9_0.textBox:setRect(0, 0, l_9_0.sizeX, l_9_0.sizeY)
  end
  return xMax - xMin, yMax - yMin
end

LabelGui.measure = function(l_10_0, l_10_1, l_10_2)
  local width, height = l_10_0:getSubstringBounds(1, #l_10_0.text, l_10_1, l_10_2)
  return width + l_10_0.SIZE_PADDING, height
end

LabelGui.resize = function(l_11_0, l_11_1, l_11_2)
  Gui.resize(l_11_0, l_11_1, l_11_2)
  l_11_0.textBox:setRect(0, 0, l_11_1, l_11_2)
end

return LabelGui

