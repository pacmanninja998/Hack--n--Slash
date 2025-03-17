-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\PressurePlate.lua 

local Entity = require("Entity")
local Action = require("Action")
local Delegate = require("DFMoai.Delegate")
local EntitySet = require("EntitySet")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local TransitionAction = require("Class").create(Action, "TransitionAction")
TransitionAction.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Action.init(l_1_0)
  l_1_0.transitionAnim = l_1_1
  l_1_0.transitionFramerate = l_1_2
  l_1_0.endAnim = l_1_3
  l_1_0.endState = l_1_4
end

TransitionAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  if l_2_0.transitionAnim then
    l_2_0.sequence = l_2_0.entity:get(AnimatorComponent):playOnce(l_2_0.transitionAnim, l_2_0.transitionFramerate)
  end
end

TransitionAction.tick = function(l_3_0)
  Action.tick(l_3_0)
  local animator = l_3_0.entity:get(AnimatorComponent)
  if not animator:isPlaying(l_3_0.sequence) then
    l_3_0.entity:get(AnimatorComponent):play(l_3_0.endAnim)
    l_3_0.entity.pressed = l_3_0.endState
    l_3_0.entity.pressedEvent:dispatch(l_3_0.entity, l_3_0.endState)
    return false
  else
    return true
  end
end

local PressurePlate = require("Class").create(Entity, "PressurePlate")
PressurePlate.TRANSITION_DELAY = 0.1
PressurePlate.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5, l_4_6)
  Entity.init(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  local spriteSheet = l_4_6 and l_4_6.spriteSheet or "Interactions/Props/Placeholder/PressurePlate/PressurePlate"
  SpriteComponent.new(l_4_0, spriteSheet)
  AnimatorComponent.new(l_4_0, true)
  SoundComponent.new(l_4_0, {})
  PhysicsComponent.new(l_4_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.DYNAMIC, true)
  l_4_0:get(SpriteComponent).prop:setPriority(-64)
  l_4_0.unpressedAnim = l_4_6 and l_4_6.unpressedAnim or "Unpressed"
  l_4_0.unpressAnim = l_4_6 and l_4_6.unpressAnim or "Unpress"
  l_4_0.pressedAnim = l_4_6 and l_4_6.pressedAnim or "Pressed"
  l_4_0.pressAnim = l_4_6 and l_4_6.pressAnim or "Press"
  l_4_0.pressCue = l_4_6 and l_4_6.pressCue or "SFX/Objects/PressurePlate_On"
  l_4_0.unpressCue = l_4_6 and l_4_6.unpressCue or "SFX/Objects/PressurePlate_Off"
  l_4_0:get(AnimatorComponent):play(l_4_0.unpressedAnim, 0)
  l_4_0:makeSensor(24)
  l_4_0.pressed = false
  l_4_0.pressedEvent = Delegate.new()
  l_4_0.whiteList = nil
  l_4_0.blackList = {}
  l_4_0.pressingEntities = EntitySet.new()
  l_4_0.pressedChangeTime, l_4_0.pressedChange = nil
end

PressurePlate.makeSensor = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  if l_5_0.entitySensor then
    l_5_0.entitySensor.fixture:destroy()
  end
  if l_5_1 and l_5_2 and l_5_3 and l_5_4 then
    l_5_0.entitySensor = l_5_0:get(PhysicsComponent):addRectSensor(l_5_1, l_5_2, l_5_3, l_5_4)
  elseif l_5_1 and not l_5_2 and not l_5_3 and not l_5_4 then
    l_5_0.entitySensor = l_5_0:get(PhysicsComponent):addCircleSensor(l_5_1)
  end
  l_5_0.entitySensor.entityEnterEvent:register(l_5_0.refreshState, l_5_0)
  l_5_0.entitySensor.entityLeaveEvent:register(l_5_0.refreshState, l_5_0)
end

PressurePlate.tick = function(l_6_0)
  if l_6_0.pressedChangeTime then
    local curTime = MOAISim.getElapsedTime()
    if l_6_0.TRANSITION_DELAY < curTime - l_6_0.pressedChangeTime and l_6_0.pressedChange ~= l_6_0.pressed and not l_6_0.action then
      if l_6_0.pressedChange then
        if l_6_0.pressCue then
          l_6_0:get(SoundComponent):playCue(l_6_0.pressCue, nil, 0.5)
        end
        l_6_0:forceAction(TransitionAction.new(l_6_0.pressAnim, 30, l_6_0.pressedAnim, true))
      elseif l_6_0.unpressCue then
        l_6_0:get(SoundComponent):playCue(l_6_0.unpressCue, nil, 0.5)
      end
      l_6_0:forceAction(TransitionAction.new(l_6_0.unpressAnim, 30, l_6_0.unpressedAnim, false))
      l_6_0.pressedChangeTime, l_6_0.pressedChange = nil
    end
  end
  Entity.tick(l_6_0)
end

PressurePlate.refreshState = function(l_7_0)
  local pressed = false
  l_7_0.pressingEntities:clear()
  for entity,count in pairs(l_7_0.entitySensor.entities) do
    local blocked = false
    local physics = entity:get(PhysicsComponent)
    if count > 0 and physics and physics.receivesPlatformVel then
      if l_7_0.whiteList then
        if not l_7_0.whiteList[entity] then
          blocked = not l_7_0.whiteList[entity:class()]
        else
          blocked = false
        end
        if not blocked and l_7_0.blackList and not l_7_0.blackList[entity] then
          blocked = l_7_0.blackList[entity:class()]
        end
        if not blocked then
          l_7_0.pressingEntities:addEntity(entity)
        end
      end
    end
    pressed = l_7_0.pressingEntities.count > 0
    local curTime = MOAISim.getElapsedTime()
    if not l_7_0.locked or pressed then
      l_7_0.pressedChange = pressed
      l_7_0.pressedChangeTime = curTime
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PressurePlate.press = function(l_8_0)
  l_8_0.pressedChange = true
  l_8_0.pressedChangeTime = MOAISim.getElapsedTime()
end

PressurePlate.getClosestPresser = function(l_9_0)
  local posX, posY = l_9_0:getPosition()
  local closest, closestDistSq = nil, nil
  for entity,count in pairs(l_9_0.pressingEntities.entities) do
    local presserX, presserY = entity:getPosition()
    local dx, dy = presserX - posX, presserY - posY
    local distSq = dx * dx + dy * dy
    if not closestDistSq or distSq < closestDistSq then
      closest = entity
      closestDistSq = distSq
    end
  end
  return closest
end

return PressurePlate

