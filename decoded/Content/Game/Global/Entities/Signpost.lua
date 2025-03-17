-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Signpost.lua 

local Class = require("Class")
local Delegate = require("DFMoai.Delegate")
local Disassembly = require("Disassembly")
local Entity = require("Entity")
local Signpost = Class.create(Entity, "Signpost")
local Shader = require("Shader")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local FunctionComponent = require("Components.FunctionComponent")
Signpost.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Signpost/Signpost")
  AnimatorComponent.new(l_1_0, true)
  local animator = l_1_0:get(AnimatorComponent)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0.interactEndEvent = Delegate.new()
  local sprite = l_1_0:get(SpriteComponent)
  l_1_0:get(PhysicsComponent).fixture:destroy()
  animator:enableHitboxBody(true, 0.325)
  animator:play("Stone", 0)
  FunctionComponent.new(l_1_0, l_1_4)
  InteractionComponent.new(l_1_0)
  l_1_0:get(InteractionComponent).interactEvent:register(l_1_0.onInteract, l_1_0)
end

Signpost.setFunction = function(l_2_0, l_2_1, l_2_2)
  l_2_0:get(FunctionComponent):setFunction(l_2_1, l_2_2)
end

Signpost.isProtected = function(l_3_0)
  if l_3_0.name:find("PROTECTED") then
    return true
  end
end

Signpost.onInteract = function(l_4_0, l_4_1)
  l_4_1:get(SceneComponent):play(function(l_1_0)
    interactor:halt(true)
    local interacted = self:get(FunctionComponent):examine(l_1_0, interactor)
    interactor:halt(false)
    if not interacted then
      self.interactEndEvent:dispatch(l_1_0)
    end
    self:get(InteractionComponent):stopInteract(interactor)
   end)
end

Signpost.tick = function(l_5_0)
  Class.super(Signpost).tick(l_5_0)
  if l_5_0:isProtected() then
    l_5_0:setDefaultShader(Shader.load("Content/Game/Global/Shaders/BeingHacked"))
  else
    l_5_0:setDefaultShader()
  end
end

return Signpost

