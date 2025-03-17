-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\GateDoor.lua 

local Class = require("Class")
local Entity = require("Entity")
local GateDoor = Class.create(Entity, "GateDoor")
local Delegate = require("DFMoai.Delegate")
local CommonActions = require("CommonActions")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
GateDoor.Open = Class.create(CommonActions.PlayAnimation, "GateDoor.Open")
GateDoor.Open.init = function(l_1_0, l_1_1)
  l_1_0.instant = l_1_1
  CommonActions.PlayAnimation.init(l_1_0, "Open")
end

GateDoor.Open.tick = function(l_2_0)
  if l_2_0.instant then
    return false
  end
  if not l_2_0.cue then
    l_2_0.cue = l_2_0.entity:get(SoundComponent):playCue("SFX/Hackable_Objects/CaveGate_Open", nil, 0.5)
  end
  return CommonActions.PlayAnimation.tick(l_2_0)
end

GateDoor.Open.stop = function(l_3_0)
  l_3_0.entity:get(AnimatorComponent):play("Opened")
end

GateDoor.Close = Class.create(CommonActions.PlayAnimation, "GateDoor.Close")
GateDoor.Close.init = function(l_4_0, l_4_1)
  l_4_0.instant = l_4_1
  CommonActions.PlayAnimation.init(l_4_0, "Open", 1, -AnimatorComponent.DEFAULT_FRAME_RATE)
end

GateDoor.Close.tick = function(l_5_0)
  if l_5_0.instant then
    return false
  end
  if not l_5_0.cue then
    l_5_0.cue = l_5_0.entity:get(SoundComponent):playCue("SFX/Cutscenes/CaveEntrance_GateClose", nil, 0.5)
  end
  return CommonActions.PlayAnimation.tick(l_5_0)
end

GateDoor.Close.stop = function(l_6_0)
  l_6_0.entity:get(AnimatorComponent):play("DefaultPose")
end

GateDoor.Rattle = Class.create(CommonActions.PlayAnimation, "GateDoor.Rattle")
GateDoor.Rattle.init = function(l_7_0)
  CommonActions.PlayAnimation.init(l_7_0, "Rattle")
end

GateDoor.Rattle.start = function(l_8_0, l_8_1)
  CommonActions.PlayAnimation.start(l_8_0, l_8_1)
  l_8_0.entity:get(SoundComponent):playCue("SFX/Hackable_Objects/CaveGate_Rattle", nil, 0.5)
end

GateDoor.Rattle.stop = function(l_9_0)
  l_9_0.entity:get(AnimatorComponent):play("DefaultPose")
end

GateDoor.addBooleanField("OPEN", false)
GateDoor.init = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  Entity.init(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  SpriteComponent.new(l_10_0, "Interactions/Props/GateDoor/GateDoor")
  AnimatorComponent.new(l_10_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  PhysicsComponent.new(l_10_0, {rect = {-48, 0, 48, 80}, category = PhysicsComponent.HITTABLE_CATEGORY, collidesWithCategories = PhysicsComponent.SENSOR_CATEGORY, bodyType = MOAIBox2DBody.DYNAMIC})
  InteractionComponent.new(l_10_0)
  SoundComponent.new(l_10_0, {})
  l_10_0:get(AnimatorComponent):play("DefaultPose")
  l_10_0:get(InteractionComponent).interactEvent:register(l_10_0.onInteract, l_10_0)
  l_10_0.openEvent = Delegate.new()
  l_10_0.rattleEvent = Delegate.new()
  l_10_0.hitEvent = Delegate.new()
  l_10_0.isOpen = false
  l_10_0.prop:setScl(0.5)
  l_10_0.schemas.OPEN:registerValueSetHandler(l_10_0, l_10_0.onOpenSet, l_10_0)
end

GateDoor.onOpenSet = function(l_11_0, l_11_1)
  if l_11_0.isOpen ~= l_11_1 then
    if l_11_1 then
      l_11_0:open()
    else
      l_11_0:close()
    end
  end
end

GateDoor.open = function(l_12_0, l_12_1)
  l_12_0.isOpen = true
  l_12_0.openEvent:dispatch(true)
  l_12_0:get(InteractionComponent):setEnabled(false)
  if not l_12_0:isDoing(GateDoor.Close) then
    l_12_0:forceAction(GateDoor.Open.new(l_12_1))
  else
    l_12_0:forceAction()
    l_12_0:get(AnimatorComponent):play("Opened")
  end
end

GateDoor.close = function(l_13_0, l_13_1)
  l_13_0.isOpen = false
  l_13_0.openEvent:dispatch(false)
  l_13_0:get(InteractionComponent):setEnabled(true)
  if not l_13_0:isDoing(GateDoor.Open) then
    l_13_0:forceAction(GateDoor.Close.new(l_13_1))
  else
    l_13_0:forceAction()
    l_13_0:get(AnimatorComponent):play("DefaultPose")
  end
end

GateDoor.isHackable = function(l_14_0)
  return true
end

GateDoor.rattle = function(l_15_0)
  l_15_0.rattleEvent:dispatch()
  l_15_0:forceAction(GateDoor.Rattle.new())
end

GateDoor.onInteract = function(l_16_0, l_16_1)
  if not l_16_0.isOpened then
    l_16_0:rattle()
  end
  l_16_0:get(InteractionComponent):stopInteract(l_16_1)
end

return GateDoor

