-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\PortBlock.lua 

local Entity = require("Entity")
local PortBlock = require("Class").create(Entity, "PortBlock")
local Direction = require("Direction")
local Delegate = require("DFMoai.Delegate")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local ReflectionComponent = require("Components.ReflectionComponent")
local BoomerangProjectile = Entity.cache:load("Content/Game/Global/Entities/BoomerangProjectile")
PortBlock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/PortBlock/PortBlock")
  AnimatorComponent.new(l_1_0, false, l_1_5)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:get(AnimatorComponent):play("PortBlock")
  l_1_0.fieldSetEvent = Delegate.new()
end

PortBlock.isHackable = function(l_2_0, l_2_1)
  local blockDir = l_2_0:get(AnimatorComponent):getDirection()
  return not l_2_1 or Direction.rotate(l_2_1, 4) == blockDir
end

PortBlock.onFieldSet = function(l_3_0, l_3_1, l_3_2)
  l_3_0.fieldSetEvent:dispatch(l_3_1, l_3_2, l_3_0)
end

return PortBlock

