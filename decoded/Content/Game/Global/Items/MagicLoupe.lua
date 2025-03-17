-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\MagicLoupe.lua 

local Class = require("Class")
local Item = require("Item")
local Action = require("Action")
local Room = require("Room")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local CommonActions = require("CommonActions")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local HealthComponent = require("Components.HealthComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local FunctionComponent = require("Components.FunctionComponent")
local Music = require("Music")
local Shader = require("Shader")
local Signpost = require("Entity").cache:load("Content/Game/Global/Entities/Signpost")
local MagicLoupe = Class.create(Item, "MagicLoupe")
MagicLoupe.PutOnAction = Class.create(CommonActions.PlayAnimation, "MagicLoupe.PutOnAction")
MagicLoupe.TakeOffAction = Class.create(CommonActions.PlayAnimation, "MagicLoupe.TakeOffAction")
MagicLoupe.WearAction = Class.create(Action, "MagicLoupe.WearAction")
MagicLoupe.PrototypePortalAction = Class.create(Action, "MagicLoupe.PrototypePortalAction")
MagicLoupe.PrototypePortalAction.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0.louperRef = EntityRef.new(l_1_1)
  l_1_0.prototype = l_1_2
end

MagicLoupe.PrototypePortalAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.portalShader = Shader.load("Content/Game/Global/Shaders/Stunned")
  l_2_0.entity:setCurrentShader(l_2_0.portalShader)
  local x, y = l_2_0.entity:getPosition()
  l_2_0.portal = Entity.create("Content/Game/Global/Entities/Effects/PortalExternal", l_2_0.entity:room():getLayerByOrder(0), x, y + 25, nil, 0.35)
  local physics = l_2_0.entity:get(PhysicsComponent)
  if physics then
    local x0, y0, x1, y1 = l_2_0.entity:getWorldBounds()
    x0, y0 = l_2_0.entity.prop:worldToModel(x0, y0)
    x1, y1 = l_2_0.entity.prop:worldToModel(x1, y1)
    local sensorFactor = 1.1
    l_2_0.sensor = physics:addRectSensor(sensorFactor * x0, sensorFactor * y0, sensorFactor * x1, sensorFactor * y1)
    l_2_0.sensor.entityEnterEvent:register(l_2_0.onSensorEntityEnter, l_2_0)
  end
end

MagicLoupe.PrototypePortalAction.onSensorEntityEnter = function(l_3_0, l_3_1)
  if l_3_0.louperRef:equals(l_3_1) and l_3_1:isDoing(MagicLoupe.WearAction) then
    l_3_0:teleportEntity(l_3_1)
  end
end

MagicLoupe.PrototypePortalAction.teleportEntity = function(l_4_0, l_4_1, l_4_2)
  if l_4_0.entity:isProtected() then
    l_4_1:get(HealthComponent):damageKnockback(1, l_4_0.entity, 400)
  else
    l_4_0.teleportAction = l_4_1:teleportInPrototype(l_4_0.entity, l_4_0.prototype, l_4_2)
  end
end

MagicLoupe.PrototypePortalAction.tick = function(l_5_0)
  if not l_5_0.louperRef:isValid() then
    return false
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_5_0.teleportAction and l_5_0.louperRef.entity.action ~= l_5_0.teleportAction then
    return l_5_0.louperRef.entity:isDoing(MagicLoupe.WearAction) or l_5_0.louperRef.entity:isDoing(MagicLoupe.TargetPrototype)
  end
  return true
end

MagicLoupe.PrototypePortalAction.stop = function(l_6_0)
  l_6_0.entity:resetShader()
  l_6_0.sensor.fixture:destroy()
  l_6_0.portal:fadeOut()
end

MagicLoupe.PutOnAction.init = function(l_7_0, l_7_1)
  CommonActions.PlayAnimation.init(l_7_0, "PutOnLoupe")
  l_7_0.motive = l_7_1
end

MagicLoupe.PutOnAction.start = function(l_8_0, l_8_1)
  CommonActions.PlayAnimation.start(l_8_0, l_8_1)
  l_8_0.queuedTakeOff = false
  l_8_0.shader = Shader.load("Content/Game/Global/Shaders/MagicLoupe")
  l_8_0.shader:setFragmentUniformFloat("ShaderIntensity", 0)
  l_8_0.entity:room():insertPostEffect(l_8_0.shader)
end

MagicLoupe.PutOnAction.stop = function(l_9_0)
  l_9_0.entity:room():removePostEffect(l_9_0.shader)
end

MagicLoupe.PutOnAction.tick = function(l_10_0)
  local running = CommonActions.PlayAnimation.tick(l_10_0)
  local intensity = 1 - l_10_0.remaining / l_10_0.totalTime
  l_10_0.shader:setFragmentUniformFloat("ShaderIntensity", intensity)
  local controller = l_10_0.entity:get(ControllerComponent)
  if controller:hasNewMotive(l_10_0.motive) then
    controller:consumeNewMotive(l_10_0.motive)
    l_10_0.queuedTakeOff = true
  end
  if not running then
    if l_10_0.queuedTakeOff then
      l_10_0.entity:queueAction(MagicLoupe.TakeOffAction.new(l_10_0.motive))
    else
      l_10_0.entity:queueAction(MagicLoupe.WearAction.new(l_10_0.motive))
    end
  end
  return running
end

MagicLoupe.TakeOffAction.init = function(l_11_0, l_11_1)
  CommonActions.PlayAnimation.init(l_11_0, "PutOnLoupe", 1, -AnimatorComponent.DEFAULT_FRAME_RATE)
  l_11_0.motive = l_11_1
end

MagicLoupe.TakeOffAction.start = function(l_12_0, l_12_1)
  CommonActions.PlayAnimation.start(l_12_0, l_12_1)
  l_12_0.queuedPutOn = false
  l_12_0.shader = Shader.load("Content/Game/Global/Shaders/MagicLoupe")
  l_12_0.shader:setFragmentUniformFloat("ShaderIntensity", 1)
  l_12_0.entity:room():insertPostEffect(l_12_0.shader)
end

MagicLoupe.TakeOffAction.stop = function(l_13_0)
  l_13_0.entity:room():removePostEffect(l_13_0.shader)
end

MagicLoupe.TakeOffAction.tick = function(l_14_0)
  local running = CommonActions.PlayAnimation.tick(l_14_0)
  local intensity = l_14_0.remaining / l_14_0.totalTime
  l_14_0.shader:setFragmentUniformFloat("ShaderIntensity", intensity)
  local controller = l_14_0.entity:get(ControllerComponent)
  if controller:hasNewMotive(l_14_0.motive) then
    controller:consumeNewMotive(l_14_0.motive)
    l_14_0.queuedPutOn = true
  end
  if not running and l_14_0.queuedPutOn then
    l_14_0.entity:queueAction(MagicLoupe.PutOnAction.new(l_14_0.motive))
  end
  return running
end

MagicLoupe.WearAction.MOVE_FACTOR = 0.66666666666667
MagicLoupe.WearAction.init = function(l_15_0, l_15_1)
  Action.init(l_15_0)
  l_15_0.motive = l_15_1
end

MagicLoupe.WearAction.start = function(l_16_0, l_16_1)
  Action.start(l_16_0, l_16_1)
  l_16_0.previousAmbientCue = Music:getAmbientCue()
  Music:playAmbient("Ambience/Ambience/3rdEyeHat_Drone")
  l_16_0.shader = Shader.load("Content/Game/Global/Shaders/MagicLoupe")
  l_16_0.shader:setFragmentUniformFloat("ShaderIntensity", 1)
  local room = l_16_0.entity:room()
  room:insertPostEffect(l_16_0.shader)
  for name,fnEntity in pairs(room.entitiesByName) do
    local fnComponent = fnEntity:get(FunctionComponent)
    if fnComponent then
      fnEntity:insertAction(MagicLoupe.PrototypePortalAction.new(l_16_0.entity, fnComponent.prototype))
    end
  end
end

MagicLoupe.WearAction.stop = function(l_17_0)
  Action.stop(l_17_0)
  Music:playAmbient(l_17_0.previousAmbientCue)
  l_17_0.entity:room():removePostEffect(l_17_0.shader)
end

MagicLoupe.WearAction.tick = function(l_18_0)
  local controller = l_18_0.entity:get(ControllerComponent)
  local animator = l_18_0.entity:get(AnimatorComponent)
  if l_18_0.entity:move(l_18_0.MOVE_FACTOR * l_18_0.entity.MOVE_SPEED * l_18_0.entity.scaleFactor, true) then
    animator:play("Walk_HoldLoupe")
  else
    animator:hold("PutOnLoupe", 7)
  end
  if controller:consumeNewMotive(l_18_0.motive) then
    l_18_0.entity:queueAction(MagicLoupe.TakeOffAction.new(l_18_0.motive))
    return false
  end
  return true
end

MagicLoupe.TargetPrototype = Class.create(CommonActions.PlayAnimation, "MagicLoupe.TargetPrototype")
MagicLoupe.TargetPrototype.init = function(l_19_0, l_19_1, l_19_2)
  Class.super(MagicLoupe.TargetPrototype).init(l_19_0, "PutOnLoupe")
  l_19_0.prototypeEntity = EntityRef.new(l_19_1)
  l_19_0.targetPC = l_19_2
end

MagicLoupe.TargetPrototype.start = function(l_20_0, l_20_1)
  Class.super(MagicLoupe.TargetPrototype).start(l_20_0, l_20_1)
  if l_20_0.prototypeEntity:isValid() then
    local target = l_20_0.prototypeEntity.entity
    target:insertAction(MagicLoupe.PrototypePortalAction.new(l_20_0.entity, target:get(FunctionComponent).prototype))
  end
  l_20_0.shader = Shader.load("Content/Game/Global/Shaders/MagicLoupe")
  l_20_0.shader:setFragmentUniformFloat("ShaderIntensity", 0)
  l_20_0.entity:room():insertPostEffect(l_20_0.shader)
end

MagicLoupe.TargetPrototype.stop = function(l_21_0)
  l_21_0.entity:room():removePostEffect(l_21_0.shader)
end

MagicLoupe.TargetPrototype.tick = function(l_22_0)
  local running = CommonActions.PlayAnimation.tick(l_22_0)
  local intensity = 1 - l_22_0.remaining / l_22_0.totalTime
  l_22_0.shader:setFragmentUniformFloat("ShaderIntensity", intensity)
  if not running and l_22_0.prototypeEntity:isValid() then
    local prototypeEntity = l_22_0.prototypeEntity.entity
    if prototypeEntity.action and prototypeEntity.action:is(MagicLoupe.PrototypePortalAction) then
      prototypeEntity.action:teleportEntity(l_22_0.entity, l_22_0.targetPC)
      return true
    end
  end
  return running
end

MagicLoupe.getAction = function(l_23_0, l_23_1)
  return MagicLoupe.PutOnAction.new(l_23_1)
end

MagicLoupe.getDescription = function(l_24_0)
  return "It's some kind of magnifying lens..."
end

MagicLoupe.getSprite = function(l_25_0)
  return "UI/Placeholder/ItemIcons/MagnifyingGlass/MagnifyingGlass", "MagnifyingGlass"
end

return MagicLoupe

