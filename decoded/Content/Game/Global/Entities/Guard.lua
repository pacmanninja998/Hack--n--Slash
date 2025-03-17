-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Guard.lua 

local Class = require("Class")
local Delegate = require("DFMoai.Delegate")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local Guard = require("Class").create(Entity, "Guard")
local Direction = require("Direction")
local Math = require("DFCommon.Math")
local ShadowComponent = require("Components.ShadowComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
local SwimmingComponent = require("Components.SwimmingComponent")
local SoundComponent = require("Components.SoundComponent")
local LogoComponent = require("Components.LogoComponent")
local FactionComponent = require("Components.FactionComponent")
local Action = require("Action")
local CommonActions = require("CommonActions")
Guard.FallAction = Class.create(CommonActions.PlayAnimation, "Guard.FallAction")
Guard.TARGET_SCALE = 0.05
Guard.FallAction.init = function(l_1_0)
  Class.super(Guard.FallAction).init(l_1_0, "Falling", 1, 5)
end

Guard.FallAction.start = function(l_2_0, l_2_1)
  l_2_1:get(AnimatorComponent):setFacing(Direction.DIR_S)
  Class.super(Guard.FallAction).start(l_2_0, l_2_1)
  l_2_0.entity:get(SoundComponent):playCue("SFX/Characters/Alice/Fall_In_Abyss", nil, 0.5)
end

Guard.FallAction.tick = function(l_3_0)
  local t = 1 - l_3_0.remaining / l_3_0.totalTime
  local scl = Math.lerp(0.65, Guard.TARGET_SCALE, t)
  l_3_0.entity.prop:setScl(scl)
  return Class.super(Guard.FallAction).tick(l_3_0)
end

Guard.FallAction.stop = function(l_4_0)
  l_4_0.entity:destroy()
end

Guard.ChargeAction = Class.create(Action, "Guard.ChargeAction")
Guard.CHARGE_TIME = 6
Guard.ChargeAction.init = function(l_5_0, l_5_1)
  Action.init(l_5_0)
  l_5_0.target = EntityRef.new(l_5_1)
end

Guard.ChargeAction.start = function(l_6_0, l_6_1)
  Action.start(l_6_0, l_6_1)
  l_6_0.entity:get(AnimatorComponent):registerHitboxFilter("spear", PhysicsComponent.DYNAMIC_CATEGORY, l_6_0.onHit, l_6_0)
  l_6_0.entity:get(AnimatorComponent):play("AttackWalk")
  l_6_0.audioEvent = l_6_0.entity:get(SoundComponent):playCue("SFX/Characters/Guard/Guard_FS", nil, 0.5)
  l_6_0.remaining = l_6_0.entity.CHARGE_TIME
  l_6_0.targetUpdateRemaining = 0
end

Guard.ChargeAction.stop = function(l_7_0)
  Action.stop(l_7_0)
  l_7_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_7_0.entity:get(AnimatorComponent):clearHitboxFilter("spear")
  l_7_0.entity:get(SoundComponent):stopCue(l_7_0.audioEvent)
end

Guard.ChargeAction.tick = function(l_8_0)
  if not l_8_0.target:isValid() then
    return false
  end
  l_8_0.targetUpdateRemaining = l_8_0.targetUpdateRemaining - MOAISim.getStep()
  if l_8_0.targetUpdateRemaining < 0 then
    local sourceX, sourceY = l_8_0.entity:getPosition()
    local targetX, targetY = l_8_0.target.entity:getPosition()
    local dx, dy = targetX - sourceX, targetY - sourceY
    l_8_0.nx, l_8_0.ny = Math.normalize(dx, dy), dx
    l_8_0.targetUpdateRemaining = 0.5
  end
  local nx, ny = l_8_0.nx, l_8_0.ny
  l_8_0.entity:get(PhysicsComponent):setLinearVelocity(nx * l_8_0.entity.MOVE_SPEED, ny * l_8_0.entity.MOVE_SPEED)
  if math.abs(ny) < math.abs(nx) then
    ny = 0
  else
    nx = 0
  end
  l_8_0.entity:get(AnimatorComponent):updateDirection(nx, ny)
  l_8_0.remaining = l_8_0.remaining - MOAISim.getStep()
  return l_8_0.remaining > 0
end

Guard.ChargeAction.onHit = function(l_9_0, l_9_1)
  l_9_0.entity:hitEntity(l_9_1, true)
end

Guard.addIntegerField("MOVE_SPEED", 200)
Guard.addIntegerField("DAMAGE_PER_HIT", 1)
Guard.addEditableField("IDLE_ROUTINE", LogoComponent.createBehaviorSchema())
Guard.PERCEPTION_DISTANCE = 500
Guard.FIELD_OF_VIEW_ANGLE = 30
Guard.init = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
  Entity.init(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  ShadowComponent.new(l_10_0)
  SpriteComponent.new(l_10_0, "Characters/Guard/Guard")
  AnimatorComponent.new(l_10_0, nil, l_10_5)
  SwimmingComponent.new(l_10_0)
  SoundComponent.new(l_10_0, {})
  PhysicsComponent.new(l_10_0, 48, 48, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, PhysicsComponent.ALL_CATEGORY - PhysicsComponent.DYNAMIC_CATEGORY, MOAIBox2DBody.DYNAMIC)
  HealthComponent.new(l_10_0, 3, 3, 1, 1, 1)
  LogoComponent.new(l_10_0)
  FactionComponent.new(l_10_0, "BAD")
  l_10_0:get(HealthComponent).onKilled:register(l_10_0.onKilled, l_10_0)
  l_10_0.IDLE_ROUTINE = {{TYPE = "IDLE", SECONDS = 1}}
  l_10_0.prop:setScl(0.65)
  l_10_0.hitbox = l_10_0:get(PhysicsComponent):addRectSensor(-64, 0, 64, 120, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY)
  l_10_0.hitbox.entityEnterEvent:register(l_10_0.onHitboxEntityEnterEvent, l_10_0)
  l_10_0.hackFixture = l_10_0:get(PhysicsComponent):addRect(-64, 0, 64, 120, PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.SENSOR_CATEGORY)
  l_10_0.perception = l_10_0:get(PhysicsComponent):addPerceptionSensor(l_10_0.PERCEPTION_DISTANCE, l_10_0.FIELD_OF_VIEW_ANGLE)
  l_10_0.perception.entityEnterEvent:register(l_10_0.onPerceptionEntityEnterEvent, l_10_0)
  l_10_0.perception.entityLeaveEvent:register(l_10_0.onPerceptionEntityLeaveEvent, l_10_0)
  l_10_0.targetEntity = EntityRef.new()
  l_10_0.targetFoundEvent = Delegate.new()
  l_10_0:get(SwimmingComponent).enterWaterEvent:register(l_10_0.onEnterWater, l_10_0)
  l_10_0:get(AnimatorComponent):play("Breathe")
end

Guard.onKilled = function(l_11_0)
  l_11_0:destroy()
end

Guard.onEnterWater = function(l_12_0)
  l_12_0:forceAction(Guard.FallAction.new())
end

Guard.isHackable = function(l_13_0, l_13_1)
  local guardDirection = l_13_0:get(AnimatorComponent):getDirection()
  return l_13_1 == guardDirection
end

Guard.tick = function(l_14_0)
  Entity.tick(l_14_0)
  if not l_14_0.action then
    l_14_0.charging = false
  end
  if not l_14_0.charging and l_14_0.targetEntity:isValid() then
    l_14_0.charging = true
    l_14_0:forceAction(Guard.ChargeAction.new(l_14_0.targetEntity.entity))
    l_14_0:queueAction(CommonActions.PlayAnimation.new("Breathe", 2))
  end
  if l_14_0.action then
    return 
  end
  l_14_0:get(LogoComponent):setBehavior(l_14_0.IDLE_ROUTINE)
end

Guard.onHitboxEntityEnterEvent = function(l_15_0, l_15_1)
  l_15_0:hitEntity(l_15_1, false)
end

Guard.hitEntity = function(l_16_0, l_16_1, l_16_2)
  if l_16_0:get(FactionComponent):isEnemy(l_16_1) then
    if not l_16_2 then
      l_16_1:get(HealthComponent):damageKnockback(l_16_0.DAMAGE_PER_HIT, l_16_0)
    else
      l_16_1:get(HealthComponent):damageKnockback(l_16_0.DAMAGE_PER_HIT, l_16_0, 700, 0.4)
    end
  end
end

Guard.onPerceptionEntityEnterEvent = function(l_17_0, l_17_1)
  if not l_17_0.targetEntity:isValid() and l_17_0:get(FactionComponent):isEnemy(l_17_1) then
    l_17_0.targetEntity:setEntity(l_17_1)
    l_17_0.targetFoundEvent:dispatch(l_17_1)
  end
end

Guard.onPerceptionEntityLeaveEvent = function(l_18_0, l_18_1)
  if l_18_0.targetEntity:equals(l_18_1) then
    l_18_0.targetEntity:setEntity()
  end
end

return Guard

