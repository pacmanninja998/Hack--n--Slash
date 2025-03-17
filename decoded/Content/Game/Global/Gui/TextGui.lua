-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\TextGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local Delegate = require("DFMoai.Delegate")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local TextGui = Class.create(HackFramedGui, "TextGui")
TextGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  HackFramedGui.init(l_1_0, l_1_1, l_1_2)
  l_1_0.dismissEvent = Delegate.new()
  l_1_0.listGui = ListGui.new(l_1_0, LabelGui.DEFAULT_HEIGHT)
  for line in l_1_3:gmatch("[^\n]*\n") do
    l_1_0.listGui:insert(LabelGui.new(l_1_0.listGui, line))
  end
  l_1_0:setHackInnerGui(l_1_0.listGui)
  l_1_0:setFocus(l_1_0.listGui)
end

TextGui.handleMotiveStart = function(l_2_0, l_2_1)
  if l_2_1 == "Dismiss" or l_2_1 == "Select" then
    l_2_0.dismissEvent:dispatch()
    l_2_0.dismissed = true
    return 
  end
  HackFramedGui.handleMotiveStart(l_2_0, l_2_1)
end

return TextGui

