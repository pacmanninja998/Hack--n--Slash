-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Automaton.lua 

local Class = require("Class")
local Class = require("Class")
local Entity = require("Entity")
local Automaton = Class.create(Entity, "Automaton")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local LogoComponent = require("Components.LogoComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
local Action = require("Action")
local CommonActions = require("CommonActions")
local CommonLogoInstructions = require("CommonLogoInstructions")
local Delegate = require("DFMoai.Delegate")
local Direction = require("Direction")
local EntityRef = require("EntityRef")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local HackGui = require("Gui").load("Content/Game/Global/Gui/HackGui")
local BeHackedAction = Action.load("Content/Game/Global/Actions/BeHackedAction")
Automaton.Taunt = Class.create(CommonActions.PlayAnimation, "Automaton.Taunt")
Automaton.Taunt.init = function(l_1_0)
  Class.super(Automaton.Taunt).init(l_1_0, "Taunt")
end

Automaton.Taunt.start = function(l_2_0, l_2_1)
  l_2_1:get(AnimatorComponent):setFacing(Direction.DIR_S)
  Class.super(Automaton.Taunt).start(l_2_0, l_2_1)
  l_2_0.entity.charging = true
  l_2_0.cue = l_2_0.entity:get(SoundComponent):playCue("SFX/Characters/Automaton/Automaton_Taunt")
end

Automaton.Taunt.stop = function(l_3_0)
  Class.super(Automaton.Taunt).stop(l_3_0)
  l_3_0.entity.charging = false
  l_3_0.entity.targetEntity:setEntity()
  l_3_0.entity:get(SoundComponent):stopCue(l_3_0.cue)
  l_3_0.entity:neutralize()
end

Automaton.BounceBack = Class.create(CommonActions.PlayAnimation, "Automaton.BounceBack")
Automaton.BounceBack.init = function(l_4_0)
  Class.super(Automaton.BounceBack).init(l_4_0, "BounceBack")
end

Automaton.BounceBack.start = function(l_5_0, l_5_1)
  Class.super(Automaton.BounceBack).start(l_5_0, l_5_1)
  l_5_0.entity.charging = true
  l_5_0.cue = l_5_0.entity:get(SoundComponent):playCue("SFX/Characters/Automaton/Automaton_Stun")
end

Automaton.BounceBack.stop = function(l_6_0)
  Class.super(Automaton.BounceBack).stop(l_6_0)
  l_6_0.entity.charging = false
  l_6_0.entity:get(SoundComponent):stopCue(l_6_0.cue)
end

Automaton.Hack = Class.create(CommonActions.LoopAnimation, "Automaton.Hack")
Automaton.Hack.init = function(l_7_0, l_7_1)
  Class.super(Automaton.Hack).init(l_7_0, "Move")
  l_7_0.target = EntityRef.new(l_7_1)
end

Automaton.Hack.start = function(l_8_0, l_8_1)
  Class.super(Automaton.Hack).start(l_8_0, l_8_1)
  l_8_0.entity.charging = true
  l_8_0.hackGui = HackGui.new(nil, l_8_0.target.entity)
  l_8_0.target.entity:get(InterfaceComponent):pushInterface(l_8_0.hackGui, l_8_0.entity)
  l_8_0.cue = l_8_0.entity:get(SoundComponent):playCue("SFX/Characters/Automaton/Automaton_Hacks")
end

Automaton.Hack.stop = function(l_9_0)
  Class.super(Automaton.Hack).stop(l_9_0)
  if l_9_0.target:isValid() then
    l_9_0.target.entity:get(InterfaceComponent):removeInterface(l_9_0.hackGui)
  end
  l_9_0.entity.charging = false
  l_9_0.entity:get(SoundComponent):stopCue(l_9_0.cue)
end

Automaton.Hack.tick = function(l_10_0)
  Class.super(Automaton.Hack).tick(l_10_0)
  if not l_10_0.target:isValid() then
    return false
  end
  local fieldList = l_10_0.hackGui.editGui.list
  local targetIndex = nil
  for index,item in ipairs(fieldList.guis) do
    if item.valueGui.field == "MOVE_SPEED" then
      targetIndex = index
  else
    end
  end
  if not targetIndex then
    return false
  end
  l_10_0.entity:get(ControllerComponent):setMotive("Down", l_10_0:shouldNavigateDown(fieldList.selectionIndex, targetIndex))
  l_10_0.entity:get(ControllerComponent):setMotive("Up", l_10_0:shouldNavigateUp(fieldList.selectionIndex, targetIndex))
  l_10_0.entity:get(ControllerComponent):setMotive("Left", l_10_0:shouldNavigateLeft(fieldList.selectionIndex, targetIndex))
  l_10_0.entity:get(ControllerComponent):setMotive("Right", l_10_0:shouldNavigateRight(fieldList.selectionIndex, targetIndex))
  if l_10_0.target.entity.MOVE_SPEED ~= 0 then
    return true
  end
  l_10_0.entity:queueAction(Automaton.Taunt.new())
  return false
end

Automaton.Hack.shouldNavigateDown = function(l_11_0, l_11_1, l_11_2)
  if l_11_1 < l_11_2 then
    return true
  end
end

Automaton.Hack.shouldNavigateUp = function(l_12_0, l_12_1, l_12_2)
  if l_12_2 < l_12_1 then
    return true
  end
end

Automaton.Hack.shouldNavigateLeft = function(l_13_0, l_13_1, l_13_2)
  if l_13_1 == l_13_2 and l_13_0.target.entity.MOVE_SPEED > 0 then
    return true
  end
end

Automaton.Hack.shouldNavigateRight = function(l_14_0, l_14_1, l_14_2)
  if l_14_1 == l_14_2 and l_14_0.target.entity.MOVE_SPEED < 0 then
    return true
  end
end

Automaton.Attack = Class.create(CommonActions.Attack, "Automaton.Attack")
Automaton.Attack.init = function(l_15_0)
  Class.super(Automaton.Attack).init(l_15_0, "Attack", l_15_0.onAttackHit, l_15_0, {hitMask = PhysicsComponent.DYNAMIC_CATEGORY})
end

Automaton.Attack.start = function(l_16_0, l_16_1)
  Class.super(Automaton.Attack).start(l_16_0, l_16_1)
  l_16_0.entity.charging = true
  l_16_0.cue = l_16_0.entity:get(SoundComponent):playCue("SFX/Characters/Automaton/Automaton_Stun")
end

Automaton.Attack.stop = function(l_17_0)
  l_17_0.entity.charging = false
  l_17_0.entity:get(SoundComponent):stopCue(l_17_0.cue)
end

Automaton.Attack.onAttackHit = function(l_18_0, l_18_1)
  if l_18_1:is(Alice) then
    if l_18_1:isHackable(l_18_0.entity:get(AnimatorComponent).direction) then
      local hackAction = Automaton.Hack.new(l_18_1)
      l_18_0.entity:forceAction(hackAction)
      l_18_1:forceAction(BeHackedAction.new(l_18_0.entity, hackAction))
    else
      l_18_0.entity:forceAction(Automaton.BounceBack.new())
    end
  end
end

Automaton.Move = Class.create(CommonLogoInstructions.Move, "Automaton.Move")
Automaton.Move.start = function(l_19_0, l_19_1)
  Class.super(Automaton.Move).start(l_19_0, l_19_1)
  l_19_0.cue = l_19_0.entity:get(SoundComponent):playCue("SFX/Characters/Automaton/Automaton_Chase", true)
end

Automaton.Move.stop = function(l_20_0)
  Class.super(Automaton.Move).stop(l_20_0)
  l_20_0.entity:get(SoundComponent):stopCue(l_20_0.cue)
end

Automaton.Seek = Class.create(CommonActions.LoopAnimation, "Automaton.Seek")
Automaton.Seek.init = function(l_21_0, l_21_1)
  Class.super(Automaton.Seek).init(l_21_0, "Move")
  l_21_0.targetEntity = EntityRef.new(l_21_1)
end

Automaton.Seek.start = function(l_22_0, l_22_1)
  Class.super(Automaton.Seek).start(l_22_0, l_22_1)
  l_22_0.entity.charging = true
  l_22_0.cue = l_22_0.entity:get(SoundComponent):playCue("SFX/Characters/Automaton/Automaton_Chase", true)
end

Automaton.Seek.stop = function(l_23_0)
  l_23_0.entity.charging = false
  l_23_0.entity:get(SoundComponent):stopCue(l_23_0.cue)
end

Automaton.Seek.tick = function(l_24_0)
  Class.super(Automaton.Seek).tick(l_24_0)
  if not l_24_0.targetEntity:isValid() then
    return false
  end
  local targetX, targetY = l_24_0:getTargetPosition()
  local entityX, entityY = l_24_0.entity:getPosition()
  local deltaX, deltaY = targetX - entityX, targetY - entityY
  local dist = math.sqrt(deltaX * deltaX + deltaY * deltaY)
  if dist < 10 then
    l_24_0.entity:get(AnimatorComponent):setFacing(l_24_0.targetEntity.entity:get(AnimatorComponent).direction)
    l_24_0.entity:queueAction(Automaton.Attack.new())
    return false
  end
  local moveSpeed = l_24_0.entity.MOVE_SPEED
  if dist < moveSpeed * MOAISim.getStep() then
    moveSpeed = dist / MOAISim.getStep()
  end
  l_24_0.entity:get(PhysicsComponent):setLinearVelocity(deltaX * (moveSpeed) / dist, deltaY * (moveSpeed) / dist)
  if math.abs(deltaY) < math.abs(deltaX) then
    l_24_0.entity:get(AnimatorComponent):updateDirection(deltaX, 0)
    deltaY = 0
  else
    l_24_0.entity:get(AnimatorComponent):updateDirection(0, deltaY)
  end
  return true
end

Automaton.Seek.getTargetPosition = function(l_25_0)
  local targetX, targetY = l_25_0.targetEntity.entity:getPosition()
  local targetAnimator = l_25_0.targetEntity.entity:get(AnimatorComponent)
  local attackOffset = -150
  local dirX, dirY = Direction.dirToVector(targetAnimator.direction)
  local offsetX, offsetY = dirX * attackOffset, dirY * attackOffset
  return targetX + offsetX, targetY + offsetY
end

Automaton.addEditableField("IDLE_ROUTINE", LogoComponent.createBehaviorSchema())
Automaton.addStringField("DID", "YOU")
Automaton.addStringField("THINK", "YOU")
Automaton.addStringField("COULD", "OUTSMART")
Automaton.addBooleanField("ME", false)
Automaton.MOVE_SPEED = 200
Automaton.PERCEPTION_DISTANCE = 300
Automaton.FIELD_OF_VIEW_ANGLE = 45
Automaton.init = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4, l_26_5)
  Class.super(Automaton).init(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4)
  SpriteComponent.new(l_26_0, "Characters/Automatons/Automatons")
  PhysicsComponent.new(l_26_0, 48, 48, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, PhysicsComponent.ALL_CATEGORY - PhysicsComponent.DYNAMIC_CATEGORY, MOAIBox2DBody.DYNAMIC)
  AnimatorComponent.new(l_26_0, AnimatorComponent.DIRECTION_MODE_FRONT_BACK_SIDE, l_26_5)
  ControllerComponent.new(l_26_0)
  SoundComponent.new(l_26_0)
  LogoComponent.new(l_26_0, {MOVE = Automaton.Move})
  l_26_0.IDLE_ROUTINE = {{TYPE = "IDLE", SECONDS = 1}}
  l_26_0.perception = l_26_0:get(PhysicsComponent):addPerceptionSensor(l_26_0.PERCEPTION_DISTANCE, l_26_0.FIELD_OF_VIEW_ANGLE)
  l_26_0.perception.entityEnterEvent:register(l_26_0.onPerceptionEntityEnterEvent, l_26_0)
  l_26_0.targetEntity = EntityRef.new()
  l_26_0.neutralizeEvent = Delegate.new()
end

Automaton.tick = function(l_27_0)
  Class.super(Automaton).tick(l_27_0)
  if l_27_0.disarmed then
    return 
  end
  local TEST_NEUTRALIZE = false
  if TEST_NEUTRALIZE then
    l_27_0:neutralize()
  end
  if not l_27_0.charging and l_27_0.targetEntity:isValid() then
    l_27_0:forceAction(Automaton.Seek.new(l_27_0.targetEntity.entity))
    return 
  end
  l_27_0:idle()
end

Automaton.idle = function(l_28_0)
  if not l_28_0.action then
    l_28_0:get(LogoComponent):setBehavior(l_28_0.IDLE_ROUTINE)
  end
end

Automaton.neutralize = function(l_29_0)
  l_29_0.neutralizeEvent:dispatch()
end

Automaton.disarm = function(l_30_0)
  l_30_0.disarmed = true
  l_30_0:forceAction()
  l_30_0:get(SoundComponent):playCue("SFX/Characters/Automaton/Automaton_Disabled")
  l_30_0:get(AnimatorComponent):play("Disabled")
end

Automaton.isHackable = function(l_31_0, l_31_1)
  local automatonDirection = l_31_0:get(AnimatorComponent):getDirection()
  if l_31_1 == automatonDirection then
    return true
  end
end

Automaton.onPerceptionEntityEnterEvent = function(l_32_0, l_32_1)
  if not l_32_0.targetEntity:isValid() and l_32_1:is(Alice) and l_32_1.MOVE_SPEED ~= 0 then
    l_32_0.targetEntity:setEntity(l_32_1)
  end
end

return Automaton

