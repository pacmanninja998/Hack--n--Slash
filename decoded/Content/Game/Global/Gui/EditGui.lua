-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\EditGui.lua 

local Class = require("Class")
local Class = require("Class")
local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local LabeledFieldGui = Gui.load("Content/Game/Global/Gui/LabeledFieldGui")
local EditGui = Class.create(HackFramedGui, "EditGui")
EditGui.HACK_COLOR = {0.44705882352941, 0.99607843137255, 0.9921568627451}
EditGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  HackFramedGui.init(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0.dismissEvent = Delegate.new()
  l_1_0.entity = l_1_3
  l_1_0.label = LabelGui.new(l_1_0, l_1_2, {color = l_1_0.HACK_COLOR, dropShadow = true})
  l_1_0.list = ListGui.new(l_1_0)
  l_1_0:setHackInnerGui(l_1_0.list)
end

EditGui.addField = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local fieldGui = LabeledFieldGui.new(l_2_0.list, l_2_1, l_2_2, l_2_3, l_2_0.entity)
  l_2_0.list:insert(fieldGui)
end

EditGui.handleMotive = function(l_3_0, l_3_1, l_3_2)
  if l_3_1 == "Dismiss" then
    l_3_0.dismissEvent:dispatch()
    return 
  end
  return HackFramedGui.handleMotive(l_3_0, l_3_1)
end

return EditGui

