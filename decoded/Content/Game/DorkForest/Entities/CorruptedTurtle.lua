-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\CorruptedTurtle.lua 

local Class = require("Class")
local Entity = require("Entity")
local EntitySet = require("EntitySet")
local Action = require("Action")
local Direction = require("Direction")
local Shader = require("Shader")
local AnimatorComponent = require("Components.AnimatorComponent")
local FactionComponent = require("Components.FactionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local HealthComponent = require("Components.HealthComponent")
local SoundComponent = require("Components.SoundComponent")
local ShadowComponent = require("Components.ShadowComponent")
local LogoComponent = require("Components.LogoComponent")
local CommonActions = require("CommonActions")
local CorruptedTurtle = Class.create(Entity, "CorruptedTurtle")
local Block = Entity.cache:load("Content/Game/Global/Entities/Block")
CorruptedTurtle.addIntegerField("HEALTH", 2)
CorruptedTurtle.addEditableField("IDLE_BEHAVIOR", LogoComponent.createBehaviorSchema())
CorruptedTurtle.addIntegerField("DAMAGE", 1)
CorruptedTurtle.addIntegerField("HEARTS_TO_DROP", 0, 0, 100)
CorruptedTurtle.addIntegerField("MOVE_SPEED", 100)
CorruptedTurtle.CHASE_SPEED = 120
CorruptedTurtle.addIntegerField("CHARGE_SPEED", 300)
CorruptedTurtle.addIntegerField("CHARGE_DISTANCE", 400)
CorruptedTurtle.START_CHARGE_DISTANCE = 200
CorruptedTurtle.addIntegerField("PERCEPTION_DISTANCE", 300)
CorruptedTurtle.addIntegerField("FIELD_OF_VIEW_ANGLE", 100)
CorruptedTurtle.addIntegerField("FLIPPED_OVER_SECONDS", 3)
CorruptedTurtle.addBooleanField("EXPLODE_ON_CHARGE_HIT", false)
CorruptedTurtle.ChargeAction = Class.create(Action, "CorruptedTurtle.ChargeAction")
CorruptedTurtle.ChargeAction.start = function(l_1_0, l_1_1)
  Action.start(l_1_0, l_1_1)
  for entity,_ in pairs(l_1_0.entity.hitRegion.entities) do
    if not entity:is(CorruptedTurtle) then
      local health = entity:get(HealthComponent)
      if health then
        health:damageKnockback(l_1_0.entity.DAMAGE, l_1_0.entity, 100)
      end
    end
  end
  l_1_0.remaining = l_1_0.entity.CHARGE_DISTANCE / math.abs(l_1_0.entity.CHARGE_SPEED)
  local nx, ny = Direction.dirToVector(l_1_0.entity:get(AnimatorComponent).direction)
  l_1_0.entity:get(PhysicsComponent):setLinearVelocity(nx * l_1_0.entity.CHARGE_SPEED, ny * l_1_0.entity.CHARGE_SPEED)
  l_1_0.entity:get(AnimatorComponent):registerHitboxFilter("head", PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, l_1_0.onHeadHit, l_1_0, true)
  l_1_0.entity:get(AnimatorComponent):play("Charge")
  l_1_0.cue = l_1_0.entity:get(SoundComponent):playCue("SFX/Characters/Turtle/CorruptedTurtle_RunLoop", nil, 0.5)
  l_1_0.hitTarget = false
  l_1_0.entity.charging = true
end

CorruptedTurtle.ChargeAction.tick = function(l_2_0)
  Action.tick(l_2_0)
  l_2_0.remaining = l_2_0.remaining - MOAISim.getStep()
  return not l_2_0.hitTarget and l_2_0.remaining > 0
end

CorruptedTurtle.ChargeAction.pause = function(l_3_0)
  l_3_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_3_0:helperPauseAnimation()
end

CorruptedTurtle.ChargeAction.resume = function(l_4_0)
  l_4_0:helperResumeAnimation()
end

CorruptedTurtle.ChargeAction.stop = function(l_5_0)
  Action.stop(l_5_0)
  l_5_0.entity:get(AnimatorComponent):clearHitboxFilter("head")
  l_5_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_5_0.entity.charging = false
  l_5_0.entity:get(SoundComponent):stopCue(l_5_0.cue)
end

CorruptedTurtle.ChargeAction.onHeadHit = function(l_6_0, l_6_1)
  if l_6_1 then
    if l_6_1:is(Block) then
      l_6_1:crumble()
    end
    local health = l_6_1:get(HealthComponent)
    if health then
      health:damageKnockback(l_6_0.entity.DAMAGE, l_6_0.entity, 100)
    end
  end
  if l_6_0.entity.EXPLODE_ON_CHARGE_HIT then
    l_6_0.entity:explode()
  else
    l_6_0.entity:flip()
  end
end

CorruptedTurtle.FlipOverAction = Class.create(CommonActions.PlayAnimation, "CorruptedTurtle.FlipOverAction")
CorruptedTurtle.FlipOverAction.init = function(l_7_0, l_7_1)
  l_7_0.bellyUp = l_7_1
  local animation = nil
  if l_7_0.bellyUp then
    animation = "FlipOver"
  else
    animation = "FlipBackOver"
  end
  CommonActions.PlayAnimation.init(l_7_0, animation)
end

CorruptedTurtle.FlipOverAction.onFlippedBackOver = function(l_8_0)
  l_8_0.entity.flipped = false
end

CorruptedTurtle.FlipOverAction.start = function(l_9_0, l_9_1)
  CommonActions.PlayAnimation.start(l_9_0, l_9_1)
  if l_9_0.bellyUp then
    l_9_0.entity.flipped = true
  else
    l_9_0.entity:get(AnimatorComponent):registerEventCallback(l_9_0, "Flipped", l_9_0.onFlippedBackOver)
  end
end

CorruptedTurtle.FlipOverAction.tick = function(l_10_0)
  return CommonActions.PlayAnimation.tick(l_10_0)
end

CorruptedTurtle.FlipOverAction.pause = function(l_11_0)
  CommonActions.PlayAnimation.pause(l_11_0)
  l_11_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
end

CorruptedTurtle.FlipOverAction.stop = function(l_12_0)
  CommonActions.PlayAnimation.stop(l_12_0)
  l_12_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  if not l_12_0.bellyUp then
    l_12_0.entity:get(AnimatorComponent):unregisterEventCallback(l_12_0, "Flipped", l_12_0.onFlippedBackOver)
  end
end

CorruptedTurtle.ExplodeAction = Class.create(Action, "CorruptedTurtle.ExplodeAction")
CorruptedTurtle.ExplodeAction.start = function(l_13_0, l_13_1)
  Action.start(l_13_0, l_13_1)
  l_13_0.entity:get(AnimatorComponent):registerHitboxFilter("Explosion", PhysicsComponent.DYNAMIC_CATEGORY, l_13_0.onExplosionHit, l_13_0, true)
  l_13_0.sequence = l_13_0.entity:get(AnimatorComponent):playOnce("Explode")
  l_13_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_13_0.entity:get(SoundComponent):playCue("SFX/Characters/Turtle/CorruptedTurtle_Explode", nil, 0.5)
end

CorruptedTurtle.ExplodeAction.onExplosionHit = function(l_14_0, l_14_1)
  if l_14_1 then
    local health = l_14_1:get(HealthComponent)
    if health then
      health:damageKnockback(l_14_0.entity.DAMAGE, l_14_0.entity, 100)
    end
  end
end

CorruptedTurtle.ExplodeAction.tick = function(l_15_0)
  Action.tick(l_15_0)
  return l_15_0.entity:get(AnimatorComponent):isPlaying(l_15_0.sequence)
end

CorruptedTurtle.ExplodeAction.pause = function(l_16_0)
  l_16_0:helperPauseAnimation()
end

CorruptedTurtle.ExplodeAction.resume = function(l_17_0)
  l_17_0:helperResumeAnimation()
end

CorruptedTurtle.ExplodeAction.stop = function(l_18_0)
  Action.stop(l_18_0)
  l_18_0.entity:dropLoot()
  l_18_0.entity:get(AnimatorComponent):clearHitboxFilter("Explosion")
  l_18_0.entity:get(SpriteComponent).prop:setVisible(false)
  l_18_0.entity:destroy()
end

CorruptedTurtle.ChaseAction = Class.create(Action, "CorruptedTurtle.ChaseAction")
CorruptedTurtle.ChaseAction.init = function(l_19_0, l_19_1)
  Action.init(l_19_0)
  l_19_0.target = l_19_1
end

CorruptedTurtle.ChaseAction.start = function(l_20_0, l_20_1)
  Action.start(l_20_0, l_20_1)
  l_20_0.entity:get(AnimatorComponent):play("Move")
end

CorruptedTurtle.ChaseAction.tick = function(l_21_0)
  Action.tick(l_21_0)
  if l_21_0.target then
    if l_21_0.entity:canChargeEntity(l_21_0.target, l_21_0.entity.START_CHARGE_DISTANCE) then
      l_21_0.entity:queueAction(CorruptedTurtle.ChargeWarmupAction.new(l_21_0.target))
      return false
    else
      local posX, posY = l_21_0.entity:getPosition()
      local targetX, targetY = l_21_0.target:getPosition()
      local diffX, diffY = targetX - posX, targetY - posY
      local dist = math.sqrt(diffX * diffX + diffY * diffY)
      if dist < 1.5 * l_21_0.entity.PERCEPTION_DISTANCE then
        local dirX, dirY = diffX / dist, diffY / dist
        local velX, velY = l_21_0.entity.CHASE_SPEED * dirX, l_21_0.entity.CHASE_SPEED * dirY
        l_21_0.entity:get(PhysicsComponent):setLinearVelocity(velX, velY)
        local animator = l_21_0.entity:get(AnimatorComponent)
        local chaseDir = Direction.vectorToDir(velX, velY)
        local animDir = animator:getDirection()
        if animDir ~= chaseDir then
          animator:setFacing(chaseDir)
        end
        return true
      else
        return false
      end
    end
  end
end

CorruptedTurtle.ChaseAction.pause = function(l_22_0)
  l_22_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_22_0:helperPauseAnimation()
end

CorruptedTurtle.ChaseAction.resume = function(l_23_0)
  l_23_0:helperResumeAnimation()
end

CorruptedTurtle.ChaseAction.stop = function(l_24_0)
  Action.stop(l_24_0)
end

CorruptedTurtle.ChargeWarmupAction = Class.create(CommonActions.PlayAnimation, "CorruptedTurtle.ChargeWarmupAction")
CorruptedTurtle.ChargeWarmupAction.COMMITTED_RATIO = 0.66666666666667
CorruptedTurtle.ChargeWarmupAction.init = function(l_25_0, l_25_1)
  CommonActions.PlayAnimation.init(l_25_0, "ChargeWarmup")
  l_25_0.target = l_25_1
end

CorruptedTurtle.ChargeWarmupAction.start = function(l_26_0, l_26_1)
  CommonActions.PlayAnimation.start(l_26_0, l_26_1)
  l_26_0.cue = l_26_0.entity:get(SoundComponent):playCue("SFX/Characters/Turtle/CorruptedTurtle_Windup", nil, 0.5)
end

CorruptedTurtle.ChargeWarmupAction.tick = function(l_27_0)
  l_27_0.canCharge = (l_27_0.remaining / l_27_0.totalTime >= 1 - l_27_0.COMMITTED_RATIO and l_27_0.entity:canChargeEntity(l_27_0.target, 1.5 * l_27_0.entity.START_CHARGE_DISTANCE))
  if CommonActions.PlayAnimation.tick(l_27_0) then
    return l_27_0.canCharge
  end
end

CorruptedTurtle.ChargeWarmupAction.pause = function(l_28_0)
  CommonActions.PlayAnimation.pause(l_28_0)
  l_28_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
end

CorruptedTurtle.ChargeWarmupAction.stop = function(l_29_0)
  CommonActions.PlayAnimation.stop(l_29_0)
  l_29_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_29_0.entity:get(SoundComponent):stopCue(l_29_0.cue)
  if l_29_0.canCharge then
    l_29_0.entity:queueAction(CorruptedTurtle.ChargeAction.new())
  end
end

CorruptedTurtle.DieAction = Class.create(Action, "CorruptedTurtle.DieAction")
CorruptedTurtle.DieAction.ANIMATION = "Explode"
CorruptedTurtle.DieAction.FRAMES_PER_SECOND = 15
CorruptedTurtle.DieAction.SPAWN_EVENT = "Explode"
CorruptedTurtle.DieAction.start = function(l_30_0, l_30_1)
  Action.start(l_30_0, l_30_1)
  l_30_0.entity = l_30_1
  l_30_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_30_0.glitchDuration = 0.3
  l_30_0.glitchOutShader = Shader.load("Content/Game/Global/Shaders/GlitchOut")
  l_30_0.elapsed = 0
  l_30_0.origScaleX, l_30_0.origScaleY = l_30_0.entity.prop:getScl(), l_30_0.entity.prop
  l_30_0.entity:setCurrentShader(l_30_0.glitchOutShader)
  l_30_0.cue = l_30_0.entity:get(SoundComponent):playCue("SFX/Characters/Turtle/Turtle_Death", nil, 0.5)
end

CorruptedTurtle.DieAction.tick = function(l_31_0)
  Action.tick(l_31_0)
  l_31_0.elapsed = l_31_0.elapsed + MOAISim.getStep()
  l_31_0.entity:get(SpriteComponent).material:setShaderValue("deathTime", MOAIMaterial.VALUETYPE_FLOAT, 0)
  if l_31_0.glitchDuration < l_31_0.elapsed then
    if l_31_0.destroyWhenDone then
      l_31_0.entity:get(SpriteComponent).prop:setVisible(false)
      l_31_0.entity:destroy()
    else
      l_31_0.entity:get(SpriteComponent).prop:setVisible(true)
    end
    return false
  else
    local deathAmount = l_31_0.elapsed / l_31_0.glitchDuration
    local currentSprite = l_31_0.entity:get(SpriteComponent)
    currentSprite.material:setShaderValue("deathTime", MOAIMaterial.VALUETYPE_FLOAT, deathAmount)
    l_31_0.entity.prop:setScl(l_31_0.origScaleX + l_31_0.origScaleX * 0.05 * deathAmount, l_31_0.origScaleY + l_31_0.origScaleY * 15 * deathAmount)
  end
  return true
end

CorruptedTurtle.DieAction.stop = function(l_32_0)
  l_32_0.entity:dropLoot()
  l_32_0.entity:get(SpriteComponent).prop:setVisible(false)
  l_32_0.entity:destroy()
end

CorruptedTurtle.init = function(l_33_0, l_33_1, l_33_2, l_33_3, l_33_4, l_33_5, l_33_6)
  Entity.init(l_33_0, l_33_1, l_33_2, l_33_3, l_33_4)
  l_33_0.HIT_RADIUS = 30
  l_33_0.MAX_CHEW_SECONDS = 5
  l_33_0.MAX_IDLE_SECONDS = 3
  l_33_0.IDLE_WALK_MIN_PIXELS = 20
  l_33_0.IDLE_WALK_MAX_PIXELS = 100
  l_33_0.HEARTS_TO_DROP = math.random(0, 1)
  l_33_0.IDLE_BEHAVIOR = {{TYPE = "IDLE", SECONDS = 3}, {TYPE = "TURN", DIRECTION = "random"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "MOVE", TILES = 1}}
  SpriteComponent.new(l_33_0, l_33_6)
  AnimatorComponent.new(l_33_0, AnimatorComponent.DIRECTION_MODE_FRONT_SIDE_BACK, l_33_5)
  PhysicsComponent.new(l_33_0, 62, 62, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, PhysicsComponent.ALL_CATEGORY - PhysicsComponent.DYNAMIC_CATEGORY - PhysicsComponent.HITTABLE_CATEGORY, MOAIBox2DBody.DYNAMIC, false)
  FactionComponent.new(l_33_0, "BAD")
  HealthComponent.new(l_33_0, l_33_0.HEALTH, l_33_0.HEALTH, 1, 0, 0.05)
  SoundComponent.new(l_33_0, {})
  ShadowComponent.new(l_33_0, 0, -32)
  LogoComponent.new(l_33_0)
  l_33_0.hitRegion = l_33_0:get(PhysicsComponent):addCircleSensor(l_33_0.HIT_RADIUS)
  l_33_0.hitRegion.entityEnterEvent:register(l_33_0.onHitRegionEntityEnter, l_33_0)
  l_33_0.perceivedEntities = EntitySet.new()
  l_33_0.perception = l_33_0:get(PhysicsComponent):addPerceptionSensor(l_33_0.PERCEPTION_DISTANCE, l_33_0.FIELD_OF_VIEW_ANGLE)
  l_33_0.perception.entityEnterEvent:register(l_33_0.onPerceptionEntityEnterEvent, l_33_0)
  l_33_0.perception.entityLeaveEvent:register(l_33_0.onPerceptionEntityLeaveEvent, l_33_0)
  l_33_0:get(HealthComponent).onDamaged:register(l_33_0.onDamaged, l_33_0)
  local animator = l_33_0:get(AnimatorComponent)
  animator:play("Breathe")
  animator:enableRootMotion()
  animator:registerEventCallback(l_33_0, "footstep", l_33_0.onFootstep)
  l_33_0:get(HealthComponent).onKilled:register(l_33_0.onKilled, l_33_0)
  l_33_0.flipped, l_33_0.charging = false, false
  l_33_0.prop:setScl(0.75)
end

CorruptedTurtle.onFootstep = function(l_34_0)
  l_34_0:get(SoundComponent):playCue("SFX/Characters/Turtle/Turtle_Walk", false)
end

CorruptedTurtle.onHitRegionEntityEnter = function(l_35_0, l_35_1)
end

CorruptedTurtle.onPerceptionEntityEnterEvent = function(l_36_0, l_36_1)
  l_36_0.perceivedEntities:addEntity(l_36_1)
end

CorruptedTurtle.onPerceptionEntityLeaveEvent = function(l_37_0, l_37_1)
  l_37_0.perceivedEntities:removeEntity(l_37_1)
end

CorruptedTurtle.canChargeEntity = function(l_38_0, l_38_1, l_38_2)
  local posX, posY = l_38_0:getPosition()
  local targetX, targetY = l_38_1:getPosition()
  local diffX, diffY = targetX - posX, targetY - posY
  local distSq = diffX * diffX + diffY * diffY
  local direction = Direction.vectorToDir(diffX, diffY, false, math.pi / 8)
  return (direction and distSq < l_38_2 * l_38_2) or distSq < 100
end

CorruptedTurtle.dropLoot = function(l_39_0)
  for i = 1, l_39_0.HEARTS_TO_DROP do
    local posX, posY = l_39_0:getPosition()
    local angle = 2 * math.pi * math.random()
    local speed = math.random(50, 150)
    local velX, velY = speed * math.cos(angle), speed * math.sin(angle)
    Entity.create("Content/Game/Global/Entities/HealthPickup", l_39_0.layer, posX, posY, nil, nil, 1, velX, velY)
  end
end

CorruptedTurtle.onBiteHit = function(l_40_0, l_40_1)
  local health = l_40_1:get(HealthComponent)
  if health then
    health:damageKnockback(l_40_0.DAMAGE, l_40_0, 100)
  end
end

CorruptedTurtle.isHackable = function(l_41_0)
  return l_41_0.flipped
end

CorruptedTurtle.flip = function(l_42_0)
  l_42_0:get(SoundComponent):playCue("SFX/Characters/Turtle/CorruptedTurtle_Impact", nil, 0.5)
  l_42_0:forceAction(CorruptedTurtle.FlipOverAction.new(true))
  l_42_0:queueAction(CommonActions.PlayAnimation.new("FlippedBreathe", l_42_0.FLIPPED_OVER_SECONDS))
  l_42_0:queueAction(CorruptedTurtle.FlipOverAction.new(false))
end

CorruptedTurtle.explode = function(l_43_0)
  if not l_43_0.action or not l_43_0.action:is(CorruptedTurtle.ExplodeAction) then
    l_43_0:forceAction(CorruptedTurtle.ExplodeAction.new())
  end
end

CorruptedTurtle.onKilled = function(l_44_0)
  if not l_44_0:isDoing(CorruptedTurtle.DieAction) then
    l_44_0:forceAction(CorruptedTurtle.DieAction.new())
  end
end

CorruptedTurtle.tick = function(l_45_0)
  Entity.tick(l_45_0)
  if not l_45_0.flipped and not l_45_0.charging and (not l_45_0.action or l_45_0:isDoing(CommonActions.Attack) or not l_45_0:isDoing(CorruptedTurtle.ExplodeAction)) then
    local x, y = l_45_0:getPosition()
    for _,entity in pairs(l_45_0.perceivedEntities.entities) do
      if l_45_0:get(FactionComponent):isEnemy(entity) then
        local ex, ey = entity:getPosition()
        local dx, dy = ex - x, ey - y
        local distSq = dx * dx + dy * dy
        if not l_45_0.action or not l_45_0:isDoing(CorruptedTurtle.ChaseAction) and not l_45_0:isDoing(CorruptedTurtle.ChargeWarmupAction) then
          l_45_0:forceAction(CorruptedTurtle.ChaseAction.new(entity))
      end
    end
  end
  if l_45_0.action then
    return 
  end
  l_45_0:get(LogoComponent):setBehavior(l_45_0.IDLE_BEHAVIOR)
end

CorruptedTurtle.onDamaged = function(l_46_0, l_46_1, l_46_2, l_46_3, l_46_4)
  l_46_0.HEALTH = l_46_0:get(HealthComponent).curHealth
end

CorruptedTurtle.onFieldSet = function(l_47_0, l_47_1, l_47_2)
  if l_47_1 == "HEALTH" then
    l_47_0:get(HealthComponent):setHealth(l_47_2)
  elseif l_47_1 == "PERCEPTION_DISTANCE" or l_47_1 == "FIELD_OF_VIEW_ANGLE" then
    l_47_0.perception.length = l_47_0.PERCEPTION_DISTANCE
    l_47_0.perception.angle = l_47_0.FIELD_OF_VIEW_ANGLE
    l_47_0.perception:updateDirection(l_47_0, true)
  end
end

CorruptedTurtle.getTurnAnim = function(l_48_0, l_48_1)
  local animator = l_48_0:get(AnimatorComponent)
  local curDir = animator:getDirection()
  local deltaToAnim = {-2 = "Lft", 2 = "Rt"}
  if math.abs(l_48_1) == 2 then
    if animator.directionMode ~= AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS and (curDir == Direction.DIR_W or curDir == Direction.DIR_E) and curDir ~= animator.nativeSide then
      l_48_1 = -l_48_1
    end
    return "Turn_" .. deltaToAnim[l_48_1]
  end
end

return CorruptedTurtle

