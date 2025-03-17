-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Actions\HackAction.lua 

local Action = require("Action")
local HackAction = require("Class").create(Action, "HackAction")
local AnimatorComponent = require("Components.AnimatorComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HackGui = require("Gui").load("Content/Game/Global/Gui/HackGui")
local Delegate = require("DFMoai.Delegate")
HackAction.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0.target = l_1_1
end

HackAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  local physics = l_2_0.entity:get(PhysicsComponent)
  physics:setLinearVelocity(0, 0)
  if not l_2_0.entity:get(InterfaceComponent) then
    l_2_0.interface = l_2_0.target:get(InterfaceComponent)
  end
  l_2_0.hackInterface = HackGui.new(nil, l_2_0.target, l_2_0.entity)
  l_2_0.interface:pushInterface(l_2_0.hackInterface, l_2_0.entity)
end

HackAction.tick = function(l_3_0)
  if not l_3_0.hackInterface.dismissed then
    l_3_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
    return true
  end
  return false
end

HackAction.stop = function(l_4_0)
  l_4_0.interface:removeInterface(l_4_0.hackInterface)
end

return HackAction

