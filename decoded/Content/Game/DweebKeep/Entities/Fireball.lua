-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Fireball.lua 

local Entity = require("Entity")
local Fireball = require("Class").create(Entity, "Fireball")
local Direction = require("Direction")
local EntitySet = require("EntitySet")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
Fireball.ANIMATION = "Fireball"
Fireball.FRAMES_PER_SECOND = 1
Fireball.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/Fireball/Fireball")
  AnimatorComponent.new(l_1_0, false, l_1_5, Direction.DIR_E)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIMATION, l_1_0.FRAMES_PER_SECOND)
  l_1_0.velX, l_1_0.velY = l_1_6 or 64, l_1_7 or 0
  l_1_0.scale = l_1_8 or 1
  l_1_0.spawner = l_1_9
  l_1_0.damage = l_1_10 or 1
  l_1_0.prop:setScl(l_1_0.scale, l_1_0.scale)
  l_1_0:get(SpriteComponent).prop:setPriority(16)
  l_1_0.sensedEntities = EntitySet.new()
  PhysicsComponent.new(l_1_0, 56 * l_1_0.scale, 56 * l_1_0.scale, PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.DYNAMIC, true)
  local physics = l_1_0:get(PhysicsComponent)
  physics:setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY, l_1_0.onHit, l_1_0, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  physics:setLinearVelocity(l_1_0.velX, l_1_0.velY * Direction.VEL_RATIO)
  physics:setReceivesPlatformVel(false)
end

Fireball.tick = function(l_2_0)
  for _,entity in pairs(l_2_0.sensedEntities.entities) do
    local health = entity:get(HealthComponent)
    local animator = entity:get(AnimatorComponent)
    if health and not health.invincible and animator then
      local dirX, dirY = animator:getDirVector()
      local knockBackMag = 512
      health:damage(l_2_0.damage, l_2_0, -knockBackMag * dirX, -knockBackMag * dirY, 0.05, 0.3, 1)
    end
  end
  Entity.tick(l_2_0)
end

Fireball.onHit = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  local category, _, _ = l_3_4:getFilter()
  local fireballSpawner = Entity.cache:load("Content/Game/DweebKeep/Entities/FireballSpawner")
  if (not l_3_1 and category == PhysicsComponent.HIGH_CATEGORY) or l_3_1 and l_3_1:is(fireballSpawner) and l_3_1 ~= l_3_0.spawner then
    l_3_0:destroy()
  elseif l_3_1 and category == PhysicsComponent.DYNAMIC_CATEGORY then
    if l_3_2 == MOAIBox2DArbiter.BEGIN then
      l_3_0.sensedEntities:addEntity(l_3_1)
    else
      if l_3_2 == MOAIBox2DArbiter.END then
        l_3_0.sensedEntities:removeEntity(l_3_1)
      end
    end
  end
end

return Fireball

