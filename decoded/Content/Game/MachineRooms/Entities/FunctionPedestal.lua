-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\FunctionPedestal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Pedestal = Entity.cache:load("Content/Game/MachineRooms/Entities/Pedestal")
local FunctionPedestal = Class.create(Pedestal, "FunctionPedestal")
local Disassembly = require("Disassembly")
local FunctionComponent = require("Components.FunctionComponent")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local SpriteComponent = require("Components.SpriteComponent")
FunctionPedestal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(FunctionPedestal).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0:get(SpriteComponent):setSprite("Signpost")
  FunctionComponent.new(l_1_0)
  local interaction = InteractionComponent.new(l_1_0)
  interaction.interactEvent:register(l_1_0.onInteract, l_1_0)
end

FunctionPedestal.setIndex = function(l_2_0, l_2_1, l_2_2)
  l_2_0:setLabelText(l_2_1:formatFunction(l_2_2))
  l_2_0.crystal:setCrystalColor(l_2_1, l_2_1.functionColorMap[l_2_2], true)
  l_2_0.expression = Disassembly.Function.new(l_2_1.prototype, l_2_2)
  local fnComponent = l_2_0:get(FunctionComponent)
  fnComponent:setName("f" .. l_2_2)
  fnComponent:setPrototype(l_2_1.prototype.children[l_2_2 + 1])
end

FunctionPedestal.onInteract = function(l_3_0, l_3_1)
  l_3_1:get(SceneComponent):play(function(l_1_0)
    interactor:halt(true)
    self:get(FunctionComponent):examine(l_1_0, interactor)
    interactor:halt(false)
    self:get(InteractionComponent):stopInteract(interactor)
   end)
end

FunctionPedestal.isProtected = function(l_4_0)
  return false
end

return FunctionPedestal

