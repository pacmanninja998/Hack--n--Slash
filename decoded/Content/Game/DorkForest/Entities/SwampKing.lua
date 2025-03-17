-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\SwampKing.lua 

local Class = require("Class")
local Delegate = require("DFMoai.Delegate")
local Entity = require("Entity")
local EntitySet = require("EntitySet")
local SpriteSheet = require("SpriteSheet")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local ShadowComponent = require("Components.ShadowComponent")
local FactionComponent = require("Components.FactionComponent")
local SoundComponent = require("Components.SoundComponent")
local CommonActions = require("CommonActions")
local SwampTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/SwampTurtle")
local CorruptedTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/CorruptedTurtle")
local SwampKing = Class.create(Entity, "SwampKing")
SwampKing.Attack = Class.create(CommonActions.Attack, "SwampKing.Attack")
SwampKing.Attack.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  CommonActions.Attack.init(l_1_0, l_1_1, l_1_0.onHit, l_1_0, {hitMask = PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, animEvent = l_1_2, animEventHandler = l_1_0.onSFXAnimEvent, animEventFirstArg = l_1_0})
  l_1_0.animSFXCue = l_1_3
end

SwampKing.Attack.onSFXAnimEvent = function(l_2_0)
  if l_2_0.animSFXCue then
    l_2_0.entity:get(SoundComponent):playCue(l_2_0.animSFXCue, false)
  end
end

SwampKing.Attack.onHit = function(l_3_0, l_3_1)
  local health = l_3_1:get(HealthComponent)
  if health then
    l_3_1:get(HealthComponent):damageKnockback(1, l_3_0.entity, 700, 0.4)
  elseif not l_3_1.host then
    l_3_1:destroy()
  end
end

SwampKing.BreatheGas = Class.create(CommonActions.PlayAnimation, "SwampKing.BreatheGas")
SwampKing.BreatheGas.init = function(l_4_0, l_4_1)
  CommonActions.PlayAnimation.init(l_4_0, l_4_1)
end

SwampKing.BreatheGas.start = function(l_5_0, l_5_1)
  CommonActions.PlayAnimation.start(l_5_0, l_5_1)
  l_5_0.entity:get(AnimatorComponent):registerEventCallback(l_5_0, "Breathe", l_5_0.onBreatheEvent)
  l_5_0.entity:get(SoundComponent):playCue("SFX/Characters/Behemoth/Behemoth_Breath", false)
end

SwampKing.BreatheGas.stop = function(l_6_0)
  CommonActions.PlayAnimation.stop(l_6_0)
  l_6_0.entity:get(AnimatorComponent):unregisterEventCallback(l_6_0, "Breathe", l_6_0.onBreatheEvent)
end

SwampKing.BreatheGas.onBreatheEvent = function(l_7_0)
  local x, y = l_7_0.entity:getPosition()
  local gas = Entity.create("Content/Game/Global/Entities/Effect", l_7_0.entity.layer, x, y, nil, "Behemoth_" .. l_7_0.animation)
  PhysicsComponent.new(gas, {rect = {-8, -8, 8, 8}, category = PhysicsComponent.SENSOR_CATEGORY, isSensor = true})
  gas.prop:setScl(1.4)
  gas:get(AnimatorComponent):registerHitboxFilter("Gas", PhysicsComponent.HITTABLE_CATEGORY, l_7_0.onGasHitEntity, l_7_0)
end

SwampKing.BreatheGas.onGasHitEntity = function(l_8_0, l_8_1)
  if l_8_1:is(SwampTurtle) and not l_8_1:isDoing(SwampTurtle.CorruptAction) then
    l_8_1:forceAction(SwampTurtle.CorruptAction.new())
  else
    if not l_8_1:is(CorruptedTurtle) then
      local health = l_8_1:get(HealthComponent)
      if health then
        l_8_1:get(HealthComponent):damageKnockback(1, l_8_0.entity)
      end
    end
  end
end

SwampKing.HitReact = Class.create(CommonActions.PlayAnimation, "SwampKing.HitReact")
SwampKing.HitReact.init = function(l_9_0)
  CommonActions.PlayAnimation.init(l_9_0, "HitReact_Frnt")
end

SwampKing.Stun = Class.create(CommonActions.PlayAnimation, "SwampKing.Stun")
SwampKing.Stun.init = function(l_10_0)
  CommonActions.PlayAnimation.init(l_10_0, "Stunned_Frnt")
end

SwampKing.Stun.start = function(l_11_0, l_11_1)
  CommonActions.PlayAnimation.start(l_11_0, l_11_1)
  l_11_0.cue = l_11_0.entity:get(SoundComponent):playCue("SFX/Characters/Behemoth/Behemoth_Stunned", false)
end

SwampKing.Stun.stop = function(l_12_0)
  CommonActions.PlayAnimation.stop(l_12_0)
  if l_12_0.cue then
    l_12_0.cue:stop()
  end
end

SwampKing.TransformExit = Class.create(CommonActions.PlayAnimation, "SwampKing.TransformExit")
SwampKing.TransformExit.init = function(l_13_0)
  CommonActions.PlayAnimation.init(l_13_0, "HitReact_Frnt", 1, -5)
end

SwampKing.Transform = Class.create(CommonActions.PlayAnimation, "SwampKing.Transform")
SwampKing.Transform.init = function(l_14_0, l_14_1)
  CommonActions.PlayAnimation.init(l_14_0, "Death_Frnt", 0.4, 5)
  l_14_0.targetSheet = l_14_1
end

SwampKing.Transform.start = function(l_15_0, l_15_1)
  CommonActions.PlayAnimation.start(l_15_0, l_15_1)
  l_15_0.entity:get(HealthComponent).invincible = true
end

SwampKing.Transform.stop = function(l_16_0)
  CommonActions.PlayAnimation.stop(l_16_0)
  l_16_0.entity:get(HealthComponent).invincible = false
  l_16_0.entity:get(SpriteComponent):setSpriteSheet(l_16_0.targetSheet)
  l_16_0.entity:get(AnimatorComponent):setSuffix()
  l_16_0.entity:queueAction(SwampKing.TransformExit.new())
end

SwampKing.Idle = Class.create(CommonActions.PlayAnimation, "SwampKing.Idle")
SwampKing.Idle.init = function(l_17_0)
  CommonActions.PlayAnimation.init(l_17_0, "Breathe_Frnt")
end

SwampKing.Idle.start = function(l_18_0, l_18_1)
  CommonActions.PlayAnimation.start(l_18_0, l_18_1)
  l_18_0.entity:get(AnimatorComponent):registerHitboxFilter("Left", PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, l_18_0.onSawLeft, l_18_0)
  l_18_0.entity:get(AnimatorComponent):registerHitboxFilter("Front", PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, l_18_0.onSawFront, l_18_0)
  l_18_0.entity:get(AnimatorComponent):registerHitboxFilter("Right", PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, l_18_0.onSawRight, l_18_0)
end

SwampKing.Idle.onSawLeft = function(l_19_0, l_19_1)
  if l_19_1:is(SwampTurtle) then
    l_19_0.entity:forceAction(SwampKing.BreatheGas.new("BreatheGas_Lft"))
  else
    if l_19_0:shouldAttack(l_19_1) then
      l_19_0.entity:forceAction(SwampKing.Attack.new("Stomp_Lft", "stomp_sfx", "SFX/Characters/Behemoth/Behemoth_Stomp"))
    end
  end
end

SwampKing.Idle.onSawFront = function(l_20_0, l_20_1)
  if l_20_1:is(SwampTurtle) then
    l_20_0.entity:forceAction(SwampKing.BreatheGas.new("BreatheGas_Frnt"))
  else
    if l_20_0:shouldAttack(l_20_1) then
      l_20_0.entity:forceAction(SwampKing.Attack.new("Bite_Frnt"))
    end
  end
end

SwampKing.Idle.onSawRight = function(l_21_0, l_21_1)
  if l_21_1:is(SwampTurtle) then
    l_21_0.entity:forceAction(SwampKing.BreatheGas.new("BreatheGas_Rt"))
  else
    if l_21_0:shouldAttack(l_21_1) then
      l_21_0.entity:forceAction(SwampKing.Attack.new("Stomp_Rt", "stomp_sfx", "SFX/Characters/Behemoth/Behemoth_Stomp"))
    end
  end
end

SwampKing.Idle.shouldAttack = function(l_22_0, l_22_1)
  if l_22_0.entity.jerks:hasEntity(l_22_1) then
    return true
  end
  if l_22_1:is(CorruptedTurtle) and not l_22_0.entity.noShell then
    return false
  end
  return l_22_0.entity:get(FactionComponent):isEnemy(l_22_1)
end

SwampKing.Idle.stop = function(l_23_0)
  CommonActions.PlayAnimation.stop(l_23_0)
  l_23_0.entity:get(AnimatorComponent):clearHitboxFilter("Left")
  l_23_0.entity:get(AnimatorComponent):clearHitboxFilter("Front")
  l_23_0.entity:get(AnimatorComponent):clearHitboxFilter("Right")
end

SwampKing.addIntegerField("CORRUPTION", 1000)
SwampKing.init = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4)
  Entity.init(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4)
  SpriteComponent.new(l_24_0, "Characters/Behemoth_Shell/Behemoth_Shell")
  FactionComponent.new(l_24_0, "BAD")
  ShadowComponent.new(l_24_0)
  SoundComponent.new(l_24_0, {})
  PhysicsComponent.new(l_24_0, {rect = {-200, 0, 200, 400}, category = PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY, collidesWithCategories = PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.SENSOR_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_24_0.jerks = EntitySet.new()
  l_24_0.clearCorruptionEvent = Delegate.new()
  l_24_0.noShellSheet = SpriteSheet.load("Characters/Behemoth/Behemoth")
  l_24_0.uncorruptedSheet = SpriteSheet.load("Characters/Behemoth_Uncorrupted/Behemoth_Uncorrupted")
  local animator = AnimatorComponent.new(l_24_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  animator:setSuffix("_Shell")
  local health = HealthComponent.new(l_24_0, 3)
  health.onDamaged:register(l_24_0.onDamaged, l_24_0)
  health.onKilled:register(l_24_0.onKilled, l_24_0)
  l_24_0.prop:setScl(1.4)
  l_24_0:queueAction(SwampKing.Idle.new())
end

SwampKing.onFieldSet = function(l_25_0, l_25_1, l_25_2)
  if l_25_1 == "CORRUPTION" and l_25_2 <= 0 then
    l_25_0:clearCorruption()
  end
end

SwampKing.clearCorruption = function(l_26_0)
  l_26_0:forceAction(SwampKing.Transform.new("Characters/Behemoth_Uncorrupted/Behemoth_Uncorrupted"))
  l_26_0.clearCorruptionEvent:dispatch()
end

SwampKing.isHackable = function(l_27_0)
  return l_27_0.noShell == true and l_27_0.CORRUPTION > 0
end

SwampKing.tick = function(l_28_0)
  Entity.tick(l_28_0)
  if not l_28_0.action then
    l_28_0:queueAction(SwampKing.Idle.new())
  end
end

SwampKing.onDamaged = function(l_29_0, l_29_1, l_29_2)
  if not l_29_0.noShell then
    l_29_0:forceAction(SwampKing.HitReact.new())
    l_29_0:queueAction(SwampKing.Stun.new())
  end
  l_29_0.jerks:addEntity(l_29_2)
end

SwampKing.onKilled = function(l_30_0)
  if not l_30_0.noShell then
    l_30_0:forceAction(SwampKing.Transform.new("Characters/Behemoth/Behemoth"))
    l_30_0.noShell = true
  end
end

return SwampKing

