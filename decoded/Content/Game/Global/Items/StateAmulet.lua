-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\StateAmulet.lua 

local Item = require("Item")
local Action = require("Action")
local CommonActions = require("CommonActions")
local Gui = require("Gui")
local UniverseStateGui = Gui.load("Content/Game/Global/Gui/UniverseStateGui")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local StateAmulet = require("Class").create(Item, "StateAmulet")
StateAmulet.RestoreStateAction = require("Class").create(CommonActions.Pose, "StateAmulet.RestoreStateAction")
StateAmulet.RestoreStateAction.start = function(l_1_0, l_1_1)
  CommonActions.Pose.start(l_1_0, l_1_1)
  local interface = l_1_0.entity:get(InterfaceComponent)
  l_1_0.gui = UniverseStateGui.new(nil, l_1_1:universe(), l_1_1)
  interface:pushInterface(l_1_0.gui)
end

StateAmulet.RestoreStateAction.tick = function(l_2_0)
  if l_2_0.gui.dismissed then
    l_2_0.active = false
  end
  return CommonActions.Pose.tick(l_2_0)
end

StateAmulet.RestoreStateAction.stop = function(l_3_0)
  l_3_0.entity:get(InterfaceComponent):removeInterface(l_3_0.gui)
  l_3_0.gui = nil
end

StateAmulet.getAction = function(l_4_0, l_4_1)
  return StateAmulet.RestoreStateAction.new()
end

StateAmulet.getDescription = function(l_5_0)
  return "Universe tuning amulet"
end

StateAmulet.getSprite = function(l_6_0)
  return "UI/Placeholder/ItemIcons/StateAmulet/StateAmulet", "StateAmulet"
end

return StateAmulet

