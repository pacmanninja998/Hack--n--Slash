-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\ExitPortal.lua 

local Class = require("Class")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local Shader = require("Shader")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local ExitPortal = Class.create(Entity, "ExitPortal")
ExitPortal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(ExitPortal).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  SpriteComponent.new(l_1_0, "Particles/Textures/SwirlCore/SwirlCore")
  SoundComponent.new(l_1_0)
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture = physics.body:addCircle(0, 0, 48)
  physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
  physics.fixture:setSensor(true)
  physics:setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY, l_1_0.onHitDynamic, l_1_0, MOAIBox2DArbiter.BEGIN)
  local sprite = l_1_0:get(SpriteComponent)
  sprite.prop:setPriority(-200)
  l_1_0.prop:setScl(0.5)
  l_1_0.portalShader = Shader.load("Content/Game/Global/Shaders/Portal")
  l_1_0:setDefaultShader(l_1_0.portalShader)
  l_1_0.userRef = EntityRef.new()
end

ExitPortal.setUser = function(l_2_0, l_2_1)
  l_2_0.userRef:setEntity(l_2_1)
end

ExitPortal.onHitDynamic = function(l_3_0, l_3_1)
  if l_3_0.action then
    return 
  end
  if not l_3_0.userRef:equals(l_3_1) then
    return 
  end
  l_3_1:exitPrototype(l_3_0)
end

return ExitPortal

