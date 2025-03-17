-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Signpost.lua 

local Class = require("Class")
local Entity = require("Entity")
local Signpost = Class.create(Entity, "Signpost")
local Shader = require("Shader")
local AnimatorComponent = require("Components.AnimatorComponent")
local FunctionComponent = require("Components.FunctionComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SceneComponent = require("Components.SceneComponent")
local SpriteComponent = require("Components.SpriteComponent")
Signpost.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Signpost).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/VariablePedestal/VariablePedestal")
  FunctionComponent.new(l_1_0, l_1_4)
  local animator = AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  animator:play("Signpost")
  local interaction = InteractionComponent.new(l_1_0, false, 0, -50)
  interaction.interactEvent:register(l_1_0.onInteract, l_1_0)
  local scl = 0.3
  l_1_0.prop:setScl(scl)
  local x0, y0, x1, y1 = sprite.sheet:getHitbox("body", "Signpost")
  x0, y0, x1, y1 = x0 * scl, y0 * scl, x1 * scl, y1 * scl
  PhysicsComponent.new(l_1_0, {rect = {x0, y0, x1, y1}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
end

Signpost.onInteract = function(l_2_0, l_2_1)
  l_2_1:get(SceneComponent):play(function(l_1_0)
    interactor:halt(true)
    self:get(FunctionComponent):examine(l_1_0, interactor)
    interactor:halt(false)
    self:get(InteractionComponent):stopInteract(interactor)
   end)
end

Signpost.isProtected = function(l_3_0)
  if l_3_0.name:find("PROTECTED") then
    return true
  end
end

Signpost.tick = function(l_4_0)
  Class.super(Signpost).tick(l_4_0)
  if l_4_0:isProtected() then
    l_4_0:setDefaultShader(Shader.load("Content/Game/Global/Shaders/BeingHacked"))
  else
    l_4_0:setDefaultShader()
  end
end

return Signpost

