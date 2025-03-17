-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Christo.lua 

local Class = require("Class")
local Entity = require("Entity")
local Christo = Class.create(Entity, "Christo")
local CommonActions = require("CommonActions")
local Delegate = require("DFMoai.Delegate")
local Direction = require("Direction")
local EntityRef = require("EntityRef")
local EntitySet = require("EntitySet")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
Christo.AttackAnimation = Class.create(CommonActions.PlayAnimation, "Christo.CastFireball")
Christo.AttackAnimation.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(Christo.AttackAnimation).init(l_1_0, l_1_1, 1, l_1_2)
end

Christo.AttackAnimation.start = function(l_2_0, l_2_1)
  Class.super(Christo.AttackAnimation).start(l_2_0, l_2_1)
  l_2_0.entity.attacking = true
end

Christo.AttackAnimation.stop = function(l_3_0)
  Class.super(Christo.AttackAnimation).stop(l_3_0)
  l_3_0.entity.attacking = false
end

Christo.Appear = Class.create(Christo.AttackAnimation, "Christo.Appear")
Christo.Appear.init = function(l_4_0)
  Class.super(Christo.Appear).init(l_4_0, "Appear", 45)
end

Christo.Appear.start = function(l_5_0, l_5_1)
  local animator = l_5_1:get(AnimatorComponent)
  l_5_0.direction = animator.direction
  animator:setFacing(Direction.DIR_S)
  Class.super(Christo.Appear).start(l_5_0, l_5_1)
end

Christo.Appear.stop = function(l_6_0)
  Class.super(Christo.Appear).stop(l_6_0)
  l_6_0.entity:get(AnimatorComponent):setFacing(l_6_0.direction)
  l_6_0.entity:queueAction(Christo.CastFireball.new())
end

Christo.Disappear = Class.create(Christo.AttackAnimation, "Christo.Disappear")
Christo.Disappear.init = function(l_7_0)
  Class.super(Christo.Disappear).init(l_7_0, "Disappear", 45)
end

Christo.Disappear.start = function(l_8_0, l_8_1)
  local animator = l_8_1:get(AnimatorComponent)
  l_8_0.direction = animator.direction
  animator:setFacing(Direction.DIR_S)
  Class.super(Christo.Disappear).start(l_8_0, l_8_1)
  l_8_0.entity:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
end

Christo.Disappear.stop = function(l_9_0)
  Class.super(Christo.Disappear).stop(l_9_0)
  l_9_0.entity:get(AnimatorComponent):setFacing(l_9_0.direction)
end

Christo.CastFireball = Class.create(Christo.AttackAnimation, "Christo.CastFireball")
Christo.CastFireball.init = function(l_10_0)
  Class.super(Christo.CastFireball).init(l_10_0, "CastSpell", 30)
end

Christo.CastFireball.start = function(l_11_0, l_11_1)
  Class.super(Christo.CastFireball).start(l_11_0, l_11_1)
  l_11_0.entity:get(AnimatorComponent):registerEventCallback(l_11_0, "Cast", l_11_0.onCast)
  l_11_0.entity:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
end

Christo.CastFireball.stop = function(l_12_0)
  Class.super(Christo.CastFireball).stop(l_12_0)
  l_12_0.entity:get(AnimatorComponent):unregisterEventCallback(l_12_0, "Cast", l_12_0.onCast)
  l_12_0.entity:queueAction(Christo.Disappear.new())
end

Christo.CastFireball.onCast = function(l_13_0)
  local animator = l_13_0.entity:get(AnimatorComponent)
  local direction = animator.direction
  local locX, locY = animator:getJointLoc("Cast")
  local posX, posY = l_13_0.entity.prop:modelToWorld(locX, locY, 0)
  local fireball = Entity.create("Content/Game/Global/Entities/Fireball", l_13_0.entity.layer, posX, posY, nil, direction, 1, l_13_0.entity.MOVE_SPEED)
  fireball.DAMAGE = l_13_0.entity.DAMAGE
  l_13_0.entity:get(SoundComponent):playCue("SFX/Objects/Fireball", nil)
  l_13_0.entity.fireballs:addEntity(fireball)
end

Christo.Seek = Class.create(CommonActions.LoopAnimation, "Christo.Seek")
Christo.Seek.init = function(l_14_0, l_14_1, l_14_2, l_14_3)
  Class.super(Christo.Seek).init(l_14_0, "Walk")
  l_14_0.attackX, l_14_0.attackY, l_14_0.direction = l_14_1, l_14_2, l_14_3
end

Christo.Seek.start = function(l_15_0, l_15_1)
  Class.super(Christo.Seek).start(l_15_0, l_15_1)
  l_15_0.entity.attacking = true
  l_15_0.entity:setVisible(false)
end

Christo.Seek.stop = function(l_16_0)
  Class.super(Christo.Seek).stop(l_16_0)
  l_16_0.entity.attacking = false
  l_16_0.entity:setVisible(true)
end

Christo.Seek.tick = function(l_17_0)
  Class.super(Christo.Seek).tick(l_17_0)
  local posX, posY = l_17_0.entity:getPosition()
  local deltaX, deltaY = l_17_0.attackX - posX, l_17_0.attackY - posY
  local dist = math.sqrt(deltaX * deltaX + deltaY * deltaY)
  if dist < 10 then
    l_17_0.entity:castFireball(l_17_0.direction)
    return false
  end
  local moveSpeed = l_17_0.entity.MOVE_SPEED
  if dist < moveSpeed * MOAISim.getStep() then
    moveSpeed = dist / MOAISim.getStep()
  end
  l_17_0.entity:get(PhysicsComponent):setLinearVelocity(deltaX * (moveSpeed) / dist, deltaY * (moveSpeed) / dist)
  if math.abs(deltaY) < math.abs(deltaX) then
    l_17_0.entity:get(AnimatorComponent):updateDirection(deltaX, 0)
    deltaY = 0
  else
    l_17_0.entity:get(AnimatorComponent):updateDirection(0, deltaY)
  end
  return true
end

Christo.addIntegerField("ATTACK_DISTANCE", 400)
Christo.addIntegerField("HEALTH", 1 / 0)
Christo.addIntegerField("DAMAGE", 1 / 0)
Christo.addBooleanField("DEFEATED", false)
Christo.addIntegerField("MOVE_SPEED", 400)
Christo.addIntegerField("FIREBALL_SPEED", 400)
Christo.TEXT_COLOR = {0.96862745098039, 0.31372549019608, 0.3843137254902}
Christo.init = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4, l_18_5)
  Entity.init(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4)
  SpriteComponent.new(l_18_0, "Characters/Wizard/Wizard")
  PhysicsComponent.new(l_18_0, 48, 48, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, PhysicsComponent.ALL_CATEGORY - PhysicsComponent.DYNAMIC_CATEGORY, MOAIBox2DBody.DYNAMIC)
  ControllerComponent.new(l_18_0)
  InterfaceComponent.new(l_18_0)
  AnimatorComponent.new(l_18_0)
  SceneComponent.new(l_18_0)
  SoundComponent.new(l_18_0, {})
  l_18_0.prop:setScl(0.65)
  l_18_0.target = EntityRef.new()
  l_18_0.castFireballEvent = Delegate.new()
  l_18_0.fireballs = EntitySet.new()
  l_18_0:get(SpriteComponent).prop:setPriority(32)
end

Christo.startBattle = function(l_19_0, l_19_1, l_19_2)
  l_19_0.target:setEntity(l_19_1)
  l_19_0.battleRect = l_19_2
end

Christo.stopBattle = function(l_20_0)
  l_20_0.target:setEntity()
  l_20_0.battleRect = nil
  for fireball in pairs(l_20_0.fireballs.entities) do
    fireball:destroy()
  end
  l_20_0:forceAction(nil)
end

Christo.isHackable = function(l_21_0)
  return false
end

Christo.tick = function(l_22_0)
  Entity.tick(l_22_0)
  if l_22_0.action then
    return 
  end
  if not l_22_0.attacking and l_22_0.target:isValid() then
    l_22_0:seekTarget()
  else
    l_22_0:get(AnimatorComponent):play("Breathe")
  end
end

Christo.seekTarget = function(l_23_0)
  if not l_23_0.target.entity:get(PhysicsComponent):isActive() then
    return 
  end
  local targetX, targetY = l_23_0.target.entity:getPosition()
  local getAttackPosition = function(l_1_0)
    local offsetX, offsetY = Direction.dirToVector(l_1_0)
    local posX, posY = targetX + offsetX * self.ATTACK_DISTANCE, targetY + offsetY * self.ATTACK_DISTANCE
    posX = math.max(self.battleRect[1], math.min(self.battleRect[3], posX))
    posY = math.max(self.battleRect[2], math.min(self.battleRect[4], posY))
    local dx, dy = targetX - posX, targetY - posY
    return posX, posY, dx * dx + dy * dy
   end
  local attackX, attackY, attackDirection = nil, nil, nil
  if l_23_0.battleRect[4] < targetY then
    attackX, attackY = getAttackPosition(Direction.DIR_S)
    attackDirection = Direction.DIR_N
  else
    local attackDistSq = nil
    for index,direction in ipairs(Direction.CARDINALS) do
      local posX, posY, distSq = getAttackPosition(direction)
      if not attackDistSq or attackDistSq < distSq then
        attackX, attackY, attackDirection, attackDistSq = posX, posY, Direction.rotate(direction, 4), distSq
      end
    end
  end
  l_23_0:forceAction(Christo.Seek.new(attackX, attackY, attackDirection))
end

Christo.castFireball = function(l_24_0, l_24_1)
  l_24_0:get(AnimatorComponent):setFacing(l_24_1)
  l_24_0:queueAction(Christo.Appear.new())
  l_24_0.castFireballEvent:dispatch()
end

return Christo

