-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\UnhackableGateDoor.lua 

local Class = require("Class")
local Entity = require("Entity")
local Delegate = require("DFMoai.Delegate")
local CommonActions = require("CommonActions")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local UnhackableGateDoor = Class.create(Entity, "UnhackableGateDoor")
UnhackableGateDoor.Open = Class.create(CommonActions.PlayAnimation, "UnhackableGateDoor.Open")
UnhackableGateDoor.Open.init = function(l_1_0)
  CommonActions.PlayAnimation.init(l_1_0, "Closing", 1, -AnimatorComponent.DEFAULT_FRAME_RATE)
end

UnhackableGateDoor.Open.start = function(l_2_0, l_2_1)
  CommonActions.PlayAnimation.start(l_2_0, l_2_1)
  l_2_0.entity:get(SoundComponent):playCue("SFX/Hackable_Objects/CaveGate_Open", nil, 0.5)
end

UnhackableGateDoor.Open.stop = function(l_3_0)
  l_3_0.entity:get(AnimatorComponent):play("Open")
end

UnhackableGateDoor.Close = Class.create(CommonActions.PlayAnimation, "UnhackableGateDoor.Close")
UnhackableGateDoor.Close.init = function(l_4_0)
  CommonActions.PlayAnimation.init(l_4_0, "Closing")
end

UnhackableGateDoor.Close.start = function(l_5_0, l_5_1)
  CommonActions.PlayAnimation.start(l_5_0, l_5_1)
  l_5_0.entity:get(SoundComponent):playCue("SFX/Cutscenes/CaveEntrance_GateClose", nil, 0.5)
end

UnhackableGateDoor.Close.stop = function(l_6_0)
  l_6_0.entity:get(AnimatorComponent):play("Closed")
end

UnhackableGateDoor.addBooleanField("OPEN", false)
UnhackableGateDoor.init = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  Entity.init(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  SpriteComponent.new(l_7_0, "Interactions/Props/UnhackableGateDoor/UnhackableGateDoor", "Closed")
  AnimatorComponent.new(l_7_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  PhysicsComponent.new(l_7_0, {rect = {-48, 0, 48, 80}, category = PhysicsComponent.HITTABLE_CATEGORY, collidesWithCategories = PhysicsComponent.SENSOR_CATEGORY, bodyType = MOAIBox2DBody.DYNAMIC})
  SoundComponent.new(l_7_0, {})
  l_7_0.isOpen = false
  l_7_0.openedEvent = Delegate.new()
  l_7_0.schemas.OPEN:registerValueSetHandler(l_7_0, l_7_0.onOpenSet, l_7_0)
end

UnhackableGateDoor.isHackable = function(l_8_0)
  return false
end

UnhackableGateDoor.onOpenSet = function(l_9_0, l_9_1)
  if l_9_0.isOpen ~= l_9_1 then
    if l_9_1 then
      l_9_0:open()
    else
      l_9_0:close()
    end
  end
end

UnhackableGateDoor.open = function(l_10_0)
  l_10_0.isOpen = true
  l_10_0.openedEvent:dispatch(true)
  l_10_0:forceAction(UnhackableGateDoor.Open.new())
end

UnhackableGateDoor.close = function(l_11_0)
  l_11_0.isOpen = false
  l_11_0.openedEvent:dispatch(false)
  l_11_0:forceAction(UnhackableGateDoor.Close.new())
end

return UnhackableGateDoor

