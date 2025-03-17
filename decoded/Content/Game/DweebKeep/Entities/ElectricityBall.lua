-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\ElectricityBall.lua 

local Entity = require("Entity")
local ElectricityBall = require("Class").create(Entity, "ElectricityBall")
local Direction = require("Direction")
local EntitySet = require("EntitySet")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
local LogoComponent = require("Components.LogoComponent")
ElectricityBall.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/ElectricityBall/ElectricityBall")
  AnimatorComponent.new(l_1_0, true, l_1_5, Direction.DIR_E)
  LogoComponent.new(l_1_0)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.DYNAMIC, true)
  local physics = l_1_0:get(PhysicsComponent)
  physics:setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY, l_1_0.onHitDynamic, l_1_0, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  physics:setReceivesPlatformVel(false)
  l_1_0.width, l_1_0.height = width, height
  l_1_0.sensedEntities = EntitySet.new()
end

ElectricityBall.tick = function(l_2_0)
  for _,entity in pairs(l_2_0.sensedEntities.entities) do
    local health = entity:get(HealthComponent)
    local animator = entity:get(AnimatorComponent)
    if health and not health.invincible and animator then
      local dirX, dirY = animator:getDirVector()
      local knockBackMag = 512
      health:damage(1, l_2_0.entity, -knockBackMag * dirX, -knockBackMag * dirY, 0.05, 0.3, 1)
    end
  end
  Entity.tick(l_2_0)
end

ElectricityBall.onHitDynamic = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  if l_3_1 then
    if l_3_2 == MOAIBox2DArbiter.BEGIN then
      l_3_0.sensedEntities:addEntity(l_3_1)
    else
      if l_3_2 == MOAIBox2DArbiter.END then
        l_3_0.sensedEntities:removeEntity(l_3_1)
      end
    end
  end
end

return ElectricityBall

