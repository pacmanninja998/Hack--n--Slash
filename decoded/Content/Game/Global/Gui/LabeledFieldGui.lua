-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\LabeledFieldGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local FieldGui = Gui.load("Content/Game/Global/Gui/FieldGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local LabeledFieldGui = require("Class").create(Gui, "LabeledFieldGui")
local LabeledFieldGui = Class.create(Gui, "LabeledFieldGui")
LabeledFieldGui.VALUE_SPACER = 32
LabeledFieldGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Gui.init(l_1_0, l_1_1)
  l_1_0.fieldLabel = LabelGui.new(l_1_0, tostring(l_1_3), {color = l_1_0.HACK_COLOR})
  l_1_0.valueGui = FieldGui.create(l_1_0, l_1_2, l_1_3, l_1_4, l_1_5)
end

LabeledFieldGui.measure = function(l_2_0, l_2_1, l_2_2)
  local fieldX, fieldY = l_2_0.fieldLabel:measure(l_2_1, l_2_2)
  local valueX, valueY = l_2_0.valueGui:measure(l_2_1 - fieldX - l_2_0.VALUE_SPACER, l_2_2)
  return fieldX + l_2_0.VALUE_SPACER + valueX, math.max(fieldY, valueY)
end

LabeledFieldGui.resize = function(l_3_0, l_3_1, l_3_2)
  Gui.resize(l_3_0, l_3_1, l_3_2)
  l_3_0.fieldLabel:position(0, 0, l_3_1, l_3_2)
  local valueX, valueY = l_3_0.valueGui:measure(l_3_1, l_3_2)
  l_3_0.valueGui:position(l_3_1 - valueX, 0, l_3_1, l_3_2)
end

LabeledFieldGui.handleFocusGain = function(l_4_0)
  if l_4_0.root.focus == l_4_0 then
    l_4_0.root:setFocus(l_4_0.valueGui)
  end
end

return LabeledFieldGui

