-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\MenuGui.lua 

local Class = require("Class")
local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local TextButtonGui = Gui.load("Content/Game/Global/Gui/TextButtonGui")
local MenuGui = Class.create(HackFramedGui, "MenuGui")
MenuGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Class.super(MenuGui).init(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0.dismissEvent = Delegate.new()
  l_1_0.list = ListGui.new(l_1_0)
  l_1_0:setHackInnerGui(l_1_0.list)
end

MenuGui.reset = function(l_2_0)
  l_2_0.list:clear()
end

MenuGui.dismiss = function(l_3_0)
  l_3_0.dismissed = true
  l_3_0.dismissEvent:dispatch()
end

MenuGui.addMenuButton = function(l_4_0, l_4_1, l_4_2, l_4_3)
  local button = TextButtonGui.new(l_4_0.list, l_4_1)
  button.selectedEvent:register(l_4_2, l_4_3)
  l_4_0.list:insert(button)
end

MenuGui.handleMotiveStart = function(l_5_0, l_5_1)
  if l_5_1 == "Dismiss" then
    l_5_0:dismiss()
  end
end

return MenuGui

