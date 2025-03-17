-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Warden.lua 

local Class = require("Class")
local Entity = require("Entity")
local Action = require("Action")
local Warden = Class.create(Entity, "Warden")
local EntityRef = require("EntityRef")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local HealthComponent = require("Components.HealthComponent")
local CommonActions = require("CommonActions")
local Math = require("DFCommon.Math")
local SoundComponent = require("Components.SoundComponent")
local WardenMace = Entity.cache:load("Content/Game/DweebKeep/Entities/WardenMace")
Warden.IdleAction = Class.create(CommonActions.PlayAnimation, "Warden.IdleAction")
Warden.IdleAction.init = function(l_1_0, l_1_1)
  CommonActions.PlayAnimation.init(l_1_0, "Breathe_FrntMace", l_1_1, 15)
end

Warden.IdleAction.stop = function(l_2_0)
  if l_2_0.entity.AGGRESSIVE and l_2_0.entity.targetRef:isValid() then
    l_2_0.entity:queueAction(Warden.ChargeAttackAction.new())
  else
    l_2_0.entity:queueAction(Warden.IdleAction.new())
  end
  CommonActions.PlayAnimation.stop(l_2_0)
end

Warden.ChargeAttackAction = Class.create(Action, "Warden.ChargeAttackAction")
Warden.ChargeAttackAction.ANIMATION = "Attack_WindUp"
Warden.ChargeAttackAction.ATTACK_DIST = 750
Warden.ChargeAttackAction.start = function(l_3_0, l_3_1)
  Action.start(l_3_0, l_3_1)
  local animator = l_3_0.entity:get(AnimatorComponent)
  l_3_0.sequence = animator:playOnce(l_3_0.ANIMATION)
  l_3_0.swingCue = l_3_0.entity:get(SoundComponent):playCue("SFX/Characters/Warden/Warden_ChainSwing_Loop", nil, 0.5)
end

Warden.ChargeAttackAction.tick = function(l_4_0)
  Action.tick(l_4_0)
  if l_4_0.entity.targetRef:isValid() then
    local target = l_4_0.entity.targetRef.entity
    local animator = l_4_0.entity:get(AnimatorComponent)
    if animator:isPlaying(l_4_0.sequence) then
      return true
    else
      local targetX, targetY = l_4_0.entity.targetRef.entity:getPosition()
      local posX, posY = l_4_0.entity:getPosition()
      local diffX, diffY = targetX - posX, targetY - posY
      local distSq = diffX * diffX + diffY * diffY
      local health = target:get(HealthComponent)
      if l_4_0.entity.AGGRESSIVE and health and health.curHealth > 0 and distSq < l_4_0.ATTACK_DIST ^ 2 then
        l_4_0.entity:queueAction(Warden.AttackAction.new(diffX, diffY))
        return false
      else
        l_4_0.sequence = animator:playOnce(l_4_0.ANIMATION)
        return true
      end
    end
  end
end

Warden.ChargeAttackAction.stop = function(l_5_0)
  Action.stop(l_5_0)
  if l_5_0.swingCue then
    l_5_0.swingCue:stop()
  end
end

Warden.AttackAction = Class.create(CommonActions.Attack, "Warden.AttackAction")
Warden.AttackAction.THROW_ANIM_FRONT = "Attack_Throw"
Warden.AttackAction.THROW_ANIM_LEFT = "Attack_ThrowLft"
Warden.AttackAction.THROW_ANIM_RIGHT = "Attack_ThrowRt"
Warden.AttackAction.PICKUP_ANIM_FRONT = "Attack_BacktoWindUp"
Warden.AttackAction.PICKUP_ANIM_LEFT = "Attack_BacktoWindUpLft"
Warden.AttackAction.PICKUP_ANIM_RIGHT = "Attack_BacktoWindUpRt"
Warden.AttackAction.THROW_SPEED = 1400
Warden.AttackAction.PICKUP_DIST = 100
Warden.AttackAction.init = function(l_6_0, l_6_1, l_6_2)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_6_1 > 0 and (0.75 * math.abs(l_6_2) < l_6_1 or l_6_2 > 0) then
    l_6_0.throwAnim = Warden.AttackAction.THROW_ANIM_LEFT
    l_6_0.pickupAnim = Warden.AttackAction.PICKUP_ANIM_LEFT
  elseif l_6_1 < 0 and (0.75 * math.abs(l_6_2) < math.abs(l_6_1) or l_6_2 > 0) then
    l_6_0.throwAnim = Warden.AttackAction.THROW_ANIM_RIGHT
    l_6_0.pickupAnim = Warden.AttackAction.PICKUP_ANIM_RIGHT
  else
    l_6_0.throwAnim = Warden.AttackAction.THROW_ANIM_FRONT
    l_6_0.pickupAnim = Warden.AttackAction.PICKUP_ANIM_FRONT
  end
  l_6_0.thrownCue = nil
  l_6_0.swingCue = nil
  CommonActions.Attack.init(l_6_0, l_6_0.throwAnim, l_6_0.onHit, l_6_0, {hitboxName = "Mace", hitMask = PhysicsComponent.DYNAMIC_CATEGORY})
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Warden.AttackAction.start = function(l_7_0, l_7_1)
  local animator = l_7_1:get(AnimatorComponent)
  animator:registerEventCallback(l_7_0, "MaceStart", l_7_0.onMaceStart)
  animator:registerEventCallback(l_7_0, "MaceEnd", l_7_0.onMaceEnd)
  animator:registerEventCallback(l_7_0, "Charge", l_7_0.onCharge)
  CommonActions.Attack.start(l_7_0, l_7_1)
  l_7_0.maceBallRef = EntityRef.new()
  l_7_0.thrown = false
  if l_7_0.thrownCue then
    l_7_0.thrownCue:stop()
  end
end

Warden.AttackAction.onHit = function(l_8_0, l_8_1)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  if l_8_1 and l_8_1:is(Alice) then
    if l_8_0.thrownCue then
      l_8_0.thrownCue:stop()
    end
    l_8_1:get(SoundComponent):playCue("SFX/Characters/Warden/Warden_WeaponImpact", nil, 0.5)
    l_8_1:get(HealthComponent):damage(1, l_8_0, damageVelX, damageVelY, 0.25, 0.3, 0.5)
  end
end

Warden.AttackAction.onMaceStart = function(l_9_0)
  local jointX, jointY = l_9_0.entity:get(AnimatorComponent):getJointLoc("MaceStart")
  if jointX and jointY and l_9_0.entity.targetRef:isValid() then
    local maceX, maceY = l_9_0.entity.prop:modelToWorld(jointX, jointY, 0)
    local throwAngle = math.rad(-60)
    local velX, velY = l_9_0.THROW_SPEED * math.cos(throwAngle), l_9_0.THROW_SPEED * math.sin(throwAngle)
    local maceBall = Entity.create("Content/Game/DweebKeep/Entities/WardenMace", l_9_0.entity.layer, maceX, maceY, l_9_0.entity.name .. " mace", l_9_0.entity, velX, velY, l_9_0.entity.targetRef.entity, 10, l_9_0.entity.MACE_DAMAGE, 0, -l_9_0.entity.MACE_KNOCKBACK)
    l_9_0.maceBallRef:setEntity(maceBall)
    l_9_0.thrown = true
    if l_9_0.swingCue then
      l_9_0.swingCue:stop()
    end
    l_9_0.thrownCue = l_9_0.entity:get(SoundComponent):playCue("SFX/Characters/Warden/Warden_ChainThrow_Loop", nil, 0.5)
  end
end

Warden.AttackAction.onMaceEnd = function(l_10_0)
  if l_10_0.swingCue then
    l_10_0.swingCue:stop()
  end
  if l_10_0.thrownCue then
    l_10_0.thrownCue:stop()
  end
  if l_10_0.maceBallRef:isValid() then
    l_10_0.maceBallRef.entity:destroy()
  end
end

Warden.AttackAction.onCharge = function(l_11_0)
  l_11_0.doCharge = true
end

Warden.AttackAction.tick = function(l_12_0)
  local animator = l_12_0.entity:get(AnimatorComponent)
  if not l_12_0.pickupSequence and l_12_0.maceBallRef:isValid() then
    local maceBall = l_12_0.maceBallRef.entity
    if maceBall:isDoing(WardenMace.ReturnAction) then
      local maceX, maceY = maceBall:getPosition()
      local throwX, throwY = maceBall:getThrowingPos()
      local dist = Math.distance2D(maceX, maceY, throwX, throwY)
      if dist < Warden.AttackAction.PICKUP_DIST then
        l_12_0.pickupSequence = animator:playOnce(l_12_0.pickupAnim)
      end
    end
  end
  local attacking = CommonActions.Attack.tick(l_12_0)
  if attacking then
    return true
  elseif not l_12_0.doCharge and not l_12_0.maceBallRef:isValid() then
    return animator:isPlaying(l_12_0.pickupSequence)
  end
end

Warden.AttackAction.stop = function(l_13_0)
  l_13_0.entity:queueAction(Warden.ChargeAttackAction.new())
  local animator = l_13_0.entity:get(AnimatorComponent)
  animator:unregisterEventCallback(l_13_0, "MaceStart", l_13_0.onMaceStart)
  animator:unregisterEventCallback(l_13_0, "MaceEnd", l_13_0.onMaceEnd)
  animator:unregisterEventCallback(l_13_0, "Charge", l_13_0.onCharge)
  CommonActions.Attack.stop(l_13_0)
  l_13_0.entity.attackCounter = l_13_0.entity.attackCounter + 1
  l_13_0.entity.MACE_DAMAGE = 2 ^ l_13_0.entity.attackCounter
  l_13_0.entity.MACE_KNOCKBACK = math.min(1400, l_13_0.entity.MACE_KNOCKBACK * 1.1)
end

Warden.addBooleanField("AGGRESSIVE", false)
Warden.addIntegerField("MACE_DAMAGE", 1)
Warden.addIntegerField("MACE_KNOCKBACK", 700)
Warden.init = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4)
  Entity.init(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4)
  SpriteComponent.new(l_14_0, "Characters/Warden/Warden", "Breathe")
  AnimatorComponent.new(l_14_0, true)
  SoundComponent.new(l_14_0, {})
  PhysicsComponent.new(l_14_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_14_0)
  l_14_0.attackCounter = 0
  l_14_0:get(SpriteComponent).prop:setPriority(192)
  l_14_0.targetRef = EntityRef.new()
  l_14_0:queueAction(Warden.IdleAction.new(1))
end

return Warden

