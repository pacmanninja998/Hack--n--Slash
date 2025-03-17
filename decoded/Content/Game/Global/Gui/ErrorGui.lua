-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ErrorGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ErrorGui = Class.create(Gui, "ErrorGui")
ErrorGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0, l_1_1)
  l_1_0.gui = HackFramedGui.new(l_1_0, l_1_2)
  local label = LabelGui.new(l_1_0.gui, l_1_3)
  l_1_0.gui:setHackInnerGui(label)
  l_1_0:setFocus(l_1_0)
  if l_1_4 then
    l_1_0.gui:setEntity(l_1_4)
  end
end

ErrorGui.setEntity = function(l_2_0, l_2_1)
  l_2_0.gui:setEntity(l_2_1)
end

ErrorGui.resize = function(l_3_0, l_3_1, l_3_2)
  Gui.resize(l_3_0, l_3_1, l_3_2)
  l_3_0.gui:position(0, 0, l_3_1, l_3_2)
end

ErrorGui.handleMotiveStart = function(l_4_0, l_4_1)
  if l_4_1 == "Select" or l_4_1 == "Dismiss" then
    l_4_0.dismissed = true
  end
end

return ErrorGui

