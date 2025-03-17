-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\TextButtonGui.lua 

local Delegate = require("DFMoai.Delegate")
local Class = require("Class")
local Gui = require("Gui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local TextButtonGui = Class.create(Gui, "TextButtonGui")
TextButtonGui.LABEL_COLOR = {0.44705882352941, 0.99607843137255, 0.9921568627451}
TextButtonGui.DISABLED_COLOR = {0.49803921568627, 0.49803921568627, 0.49803921568627}
TextButtonGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Class.super(TextButtonGui).init(l_1_0, l_1_1)
  if not l_1_3 then
    l_1_3 = {}
  end
  l_1_0.left = LabelGui.new(l_1_0, "[", {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, justifyVertical = l_1_3.justifyVertical, color = l_1_0.LABEL_COLOR, height = l_1_3.height})
  l_1_0.right = LabelGui.new(l_1_0, "]", {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, justifyVertical = l_1_3.justifyVertical, color = l_1_0.LABEL_COLOR, height = l_1_3.height})
  l_1_0.label = LabelGui.new(l_1_0, l_1_2, {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, justifyVertical = l_1_3.justifyVertical, color = l_1_0.LABEL_COLOR, height = l_1_3.height})
  l_1_0.enabled = true
  l_1_0.selectedEvent = Delegate.new()
  l_1_0:showBrackets(false)
end

TextButtonGui.setEnabled = function(l_2_0, l_2_1)
  local color = l_2_0.LABEL_COLOR
  if not l_2_1 then
    color = l_2_0.DISABLED_COLOR
  end
  local r, g, b = unpack(color)
  l_2_0.enabled = l_2_1
  l_2_0.left:setColor(r, g, b)
  l_2_0.right:setColor(r, g, b)
  l_2_0.label:setColor(r, g, b)
end

TextButtonGui.handleFocusGain = function(l_3_0)
  l_3_0:showBrackets(true)
end

TextButtonGui.handleFocusLoss = function(l_4_0)
  l_4_0:showBrackets(false)
end

TextButtonGui.showBrackets = function(l_5_0, l_5_1)
  l_5_0.left:show(l_5_1)
  l_5_0.right:show(l_5_1)
end

TextButtonGui.handleMotiveStart = function(l_6_0, l_6_1)
  if l_6_0.enabled and l_6_1 == "Select" then
    l_6_0.selectedEvent:dispatch()
  else
    Class.super(TextButtonGui).handleMotiveStart(l_6_0, l_6_1)
  end
end

TextButtonGui.measure = function(l_7_0, l_7_1, l_7_2)
  local leftX, leftY = l_7_0.left:measure(l_7_1, l_7_2)
  local rightX, rightY = l_7_0.right:measure(l_7_1 - leftX, l_7_2)
  local labelX, labelY = l_7_0.label:measure(l_7_1 - leftX - rightX, l_7_2)
  return leftX + rightX + labelX, math.max(leftY, rightY, labelY, LabelGui.DEFAULT_HEIGHT)
end

TextButtonGui.resize = function(l_8_0, l_8_1, l_8_2)
  Class.super(TextButtonGui).resize(l_8_0, l_8_1, l_8_2)
  local leftX, leftY = l_8_0.left:measure(l_8_1, l_8_2)
  local rightX, rightY = l_8_0.right:measure(l_8_1, l_8_2)
  l_8_0.left:position(0, 0, leftX, l_8_2)
  l_8_0.right:position(l_8_1 - rightX, 0, l_8_1, l_8_2)
  l_8_0.label:position(0, 0, l_8_1, l_8_2)
end

return TextButtonGui

