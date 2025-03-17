-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Raven.lua 

local Entity = require("Entity")
local Action = require("Action")
local EntityRef = require("EntityRef")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local FactionComponent = require("Components.FactionComponent")
local Raven = require("Class").create(Entity, "Raven")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local Rocks = Entity.cache:load("Content/Game/DorkForest/Entities/Rocks")
Raven.FlyAction = require("Class").create(Action, "Raven.FlyAction")
Raven.TAKEOFF_HEIGHT = 100
Raven.TAKEOFF_SPEED = 75
Raven.FlyAction.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.targetX, l_1_0.targetY, l_1_0.speed, l_1_0.animation = l_1_1, l_1_2, l_1_3, l_1_4
end

Raven.FlyAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.entity:get(AnimatorComponent):play(l_2_0.animation or "Fly")
  if l_2_0.entity.perched then
    l_2_0.entity:get(SoundComponent):playCue("SFX/Characters/Raven/Raven_Liftoff", false, 0.3)
  end
  l_2_0.entity.perched = false
end

Raven.FlyAction.tick = function(l_3_0)
  Action.tick(l_3_0)
  local selfX, selfY = l_3_0.entity:getPosition()
  local dx, dy = l_3_0.targetX - selfX, l_3_0.targetY - selfY
  local l = math.sqrt(dx * dx + dy * dy)
  if l < 5 then
    return false
  end
  local nx, ny = dx / l, dy / l
  local speed = math.min(l / MOAISim.getStep(), l_3_0.speed)
  l_3_0.entity:get(PhysicsComponent):setLinearVelocity(speed * nx, speed * ny)
  return true
end

Raven.FlyAction.stop = function(l_4_0)
  l_4_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
end

Raven.DisappearAction = require("Class").create(Action, "Raven.DisappearAction")
Raven.DisappearAction.start = function(l_5_0, l_5_1)
  Action.start(l_5_0, l_5_1)
  l_5_0.entity:destroy()
end

Raven.AttackAction = require("Class").create(Action, "Raven.AttackAction")
Raven.AttackAction.init = function(l_6_0, l_6_1)
  l_6_0.target = EntityRef.new(l_6_1)
end

Raven.AttackAction.start = function(l_7_0, l_7_1)
  Action.start(l_7_0, l_7_1)
  l_7_0.entity:get(AnimatorComponent):play("Attack")
  l_7_0.entity:get(AnimatorComponent):registerHitboxFilter("Bite", PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, l_7_0.onHit, l_7_0)
  l_7_0.hit = false
  if not l_7_0.entity.attackCue then
    l_7_0.entity.attackCue = l_7_0.entity:get(SoundComponent):playCue("SFX/Characters/Raven/Raven_Attack_Loop", true, 0.3)
  end
end

Raven.AttackAction.stop = function(l_8_0)
  l_8_0.entity:get(AnimatorComponent):play("Fly")
  l_8_0.entity:get(AnimatorComponent):clearHitboxFilter("Bite")
  l_8_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  if l_8_0.entity.KEEP_ATTACKING then
    local theta = math.random(2 * math.pi)
    local nx, ny = math.cos(theta), math.sin(theta)
    local selfX, selfY = l_8_0.entity:getPosition()
    l_8_0.entity:queueAction(Raven.FlyAction.new(selfX + nx * l_8_0.entity.TAKEOFF_HEIGHT, selfY + ny * l_8_0.entity.TAKEOFF_HEIGHT, l_8_0.entity.ATTACK_SPEED))
  else
    l_8_0.entity:flyAway(false)
  end
end

Raven.AttackAction.tick = function(l_9_0)
  if not l_9_0.target:isValid() or not l_9_0.entity.AGGRESSIVE then
    return false
  end
  local selfX, selfY = l_9_0.entity:getPosition()
  local targetX, targetY = l_9_0.target.entity:getPosition()
  local dx, dy = targetX - selfX, targetY - selfY
  local l = math.sqrt(dx * dx + dy * dy)
  local nx, ny = dx / l, dy / l
  l_9_0.entity:get(AnimatorComponent):updateDirection(nx, 0)
  l_9_0.entity:get(PhysicsComponent):setLinearVelocity(nx * l_9_0.entity.ATTACK_SPEED, ny * l_9_0.entity.ATTACK_SPEED)
  return true
end

Raven.AttackAction.onHit = function(l_10_0, l_10_1)
  if l_10_1:is(Alice) then
    l_10_1:get(HealthComponent):damage(l_10_0.entity.DAMAGE_PER_HIT, l_10_0.entity)
  else
    if l_10_1:is(Rocks) then
      l_10_1:scare()
    else
      return 
    end
  end
  l_10_0.target:setEntity()
end

Raven.addIntegerField("ATTACK_SPEED", 300)
Raven.addIntegerField("DAMAGE_PER_HIT", 1)
Raven.addBooleanField("KEEP_ATTACKING", false)
Raven.addBooleanField("AGGRESSIVE", true)
Raven.init = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5)
  Entity.init(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4)
  SpriteComponent.new(l_11_0, "Characters/Raven/Raven")
  AnimatorComponent.new(l_11_0, AnimatorComponent.DIRECTION_MODE_SIDE, l_11_5)
  PhysicsComponent.new(l_11_0, 32, 32, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, PhysicsComponent.SENSOR_CATEGORY, MOAIBox2DBody.DYNAMIC, true)
  SoundComponent.new(l_11_0)
  l_11_0:get(AnimatorComponent):play("Breathe")
  l_11_0.prop:setScl(0.65)
  l_11_0.perched = true
  l_11_0.sensor = l_11_0:get(PhysicsComponent):addCircleSensor(300, PhysicsComponent.DYNAMIC_CATEGORY)
  l_11_0.sensor.entityEnterEvent:register(l_11_0.onEntityEnterPerception, l_11_0)
  l_11_0.sensor.entityLeaveEvent:register(l_11_0.onEntityLeavePerception, l_11_0)
  l_11_0.attackEntity = EntityRef.new()
end

Raven.isHackable = function(l_12_0)
  return true
end

Raven.flyAway = function(l_13_0, l_13_1)
  local posX, posY = l_13_0:getPosition()
  local room = l_13_0:room()
  local distLeft, distRight = posX - room.originX, room.originX + room.sizeX - posX
  local distBottom, distTop = posY - room.originY, room.originY + room.sizeY - posY
  local minDist = math.min(distLeft, distRight, distBottom, distTop)
  local targetX, targetY = posX, posY
  local buffer = 100
  if minDist == distLeft then
    targetX = room.originX - buffer
  elseif minDist == distRight then
    targetX = room.originX + room.sizeX + buffer
  elseif minDist == distBottom then
    targetY = room.originY - buffer
  else
    targetY = room.originY + room.sizeY + buffer
  end
  if l_13_1 then
    l_13_0:forceAction(Raven.FlyAction.new(targetX, targetY, l_13_0.ATTACK_SPEED))
  else
    l_13_0:queueAction(Raven.FlyAction.new(targetX, targetY, l_13_0.ATTACK_SPEED))
  end
  l_13_0:queueAction(Raven.DisappearAction.new())
end

Raven.tick = function(l_14_0)
  Entity.tick(l_14_0)
  if l_14_0.action then
    return 
  end
  if l_14_0.AGGRESSIVE and l_14_0.attackEntity:isValid() then
    local posX, posY = l_14_0:getPosition()
    local takeOffX, takeOffY = posX, posY + l_14_0.TAKEOFF_HEIGHT
    if l_14_0.perched then
      l_14_0:queueAction(l_14_0.FlyAction.new(takeOffX, takeOffY, l_14_0.TAKEOFF_SPEED, "LiftOff"))
    end
    l_14_0:queueAction(l_14_0.AttackAction.new(l_14_0.attackEntity.entity, posX, posY))
  end
end

Raven.onSwordHit = function(l_15_0, l_15_1)
  l_15_0:flyAway(true)
end

Raven.onEntityEnterPerception = function(l_16_0, l_16_1)
  if not l_16_0.attackEntity:isValid() and (l_16_1:is(Alice) or l_16_1:is(Rocks)) then
    l_16_0.attackEntity:setEntity(l_16_1)
  end
end

Raven.onEntityLeavePerception = function(l_17_0, l_17_1)
  if l_17_0.attackEntity:equals(l_17_1) then
    l_17_0.attackEntity:setEntity()
  end
end

Raven.preDestroy = function(l_18_0)
  if l_18_0.attackCue then
    l_18_0:get(SoundComponent):stopCue(l_18_0.attackCue)
  end
end

return Raven

