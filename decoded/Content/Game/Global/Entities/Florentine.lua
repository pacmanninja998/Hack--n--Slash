-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Florentine.lua 

local Action = require("Action")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local EntitySet = require("EntitySet")
local Item = require("Item")
local Shader = require("Shader")
local Gui = require("Gui")
local Direction = require("Direction")
local Disassembly = require("Disassembly")
local Math = require("DFCommon.Math")
local Delegate = require("DFMoai.Delegate")
local CommonActions = require("CommonActions")
local Class = require("Class")
local InteractionComponent = require("Components.InteractionComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
local HealthComponent = require("Components.HealthComponent")
local PlatformComponent = require("Components.PlatformComponent")
local FactionComponent = require("Components.FactionComponent")
local FunctionComponent = require("Components.FunctionComponent")
local InteractAction = Class.create(Action, "InteractAction")
InteractAction.init = function(l_1_0, l_1_1)
  l_1_0.target = EntityRef.new(l_1_1)
end

InteractAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  local interact = l_2_0.target.entity:get(InteractionComponent)
  interact:startInteract(l_2_0.entity)
  l_2_0.entity:updateInteract()
end

InteractAction.stop = function(l_3_0)
  Action.stop(l_3_0)
  if l_3_0.target.entity then
    local interact = l_3_0.target.entity:get(InteractionComponent)
    interact:stopInteract(l_3_0.entity)
  end
end

InteractAction.tick = function(l_4_0)
  Action.tick(l_4_0)
  if not l_4_0.target.entity then
    return false
  end
  local interact = l_4_0.target.entity:get(InteractionComponent)
  return interact:isInteracting(l_4_0.entity)
end

local HaltAction = Class.create(Action, "HaltAction")
HaltAction.start = function(l_5_0, l_5_1)
  Action.start(l_5_0, l_5_1)
end

HaltAction.tick = function(l_6_0)
  Action.tick(l_6_0)
  l_6_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_6_0.entity:get(AnimatorComponent):play("Breathe", l_6_0.entity.MOVE_FRAMES_PER_SECOND)
  return true
end

HaltAction.stop = function(l_7_0)
  Action.stop(l_7_0)
end

local GhostTransformAction = Class.create(Action, "GhostTransformAction")
GhostTransformAction.tick = function(l_8_0)
  local physics = l_8_0.entity:get(PhysicsComponent)
  if physics and physics.body and physics.fixture then
    local category, collidesWithCategories = physics.category, physics.collidesWithCategories
    if l_8_0.entity:isGhost() then
      if l_8_0.entity.interactSensor then
        l_8_0.entity.interactSensor.fixture:destroy()
        l_8_0.entity.interactSensor = nil
      end
      physics:destroy()
      physics:init(nil, nil, nil, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.ALL_CATEGORY)
      l_8_0.entity.prop:setColor(1, 1, 1, 1)
      l_8_0.entity:createInteractSensor()
    else
      if l_8_0.entity.interactSensor then
        l_8_0.entity.interactSensor.fixture:destroy()
        l_8_0.entity.interactSensor = nil
      end
      physics:destroy()
      physics:init(nil, nil, nil, PhysicsComponent.GHOST_CATEGORY, PhysicsComponent.GHOST_CATEGORY)
      l_8_0.entity.prop:setColor(1, 1, 1, 0.5)
      l_8_0.entity:createInteractSensor()
    end
  end
  return false
end

local PrototypeTeleport = Class.create(CommonActions.PlayAnimation, "PrototypeTeleport")
PrototypeTeleport.MOVEMENT_COMPLETE_RATIO = 0.75
PrototypeTeleport.init = function(l_9_0, l_9_1, l_9_2, l_9_3)
  Class.super(PrototypeTeleport).init(l_9_0, "Teleport_In")
  l_9_0.portalRef = EntityRef.new(l_9_1)
  l_9_0.name = l_9_1.name
  local fnComponent = l_9_1:get(FunctionComponent)
  if fnComponent then
    l_9_0.name = fnComponent.name
  end
  l_9_0.prototype = l_9_2
  l_9_0.targetPC = l_9_3
end

PrototypeTeleport.start = function(l_10_0, l_10_1)
  Class.super(PrototypeTeleport).start(l_10_0, l_10_1)
  l_10_0.startX, l_10_0.startY = l_10_1:getPosition(), l_10_1
end

PrototypeTeleport.tick = function(l_11_0)
  local result = Class.super(PrototypeTeleport).tick(l_11_0)
  if result and l_11_0.portalRef:isValid() then
    local targetX, targetY = l_11_0.portalRef.entity:getPosition()
    local t = math.min(1, (1 - l_11_0.remaining / l_11_0.totalTime) / l_11_0.MOVEMENT_COMPLETE_RATIO)
    local posX, posY = Math.lerp(l_11_0.startX, targetX, t), Math.lerp(l_11_0.startY, targetY, t)
    local entityX, entityY = l_11_0.entity:getPosition()
    l_11_0.entity:get(SpriteComponent).prop:setLoc(posX - entityX, posY - entityY)
  end
  return result
end

PrototypeTeleport.stop = function(l_12_0)
  Class.super(PrototypeTeleport).stop(l_12_0)
  l_12_0.entity:setVisible(false)
  l_12_0.entity:get(SpriteComponent).prop:setLoc(0, 0)
  l_12_0.entity:room():queueUpdate(function()
    if self.prototype then
      self.entity.host:enterPrototype(self.entity:world(), self.name, self.prototype, self.targetPC)
    else
      self.entity:room():savePrototype()
      self.entity.host:removeRoom()
    end
   end)
end

local Florentine = Class.create(Entity, "Florentine")
Florentine.addIntegerField("MOVE_SPEED", 300)
Florentine.MOVE_FRAMES_PER_SECOND = 15
Florentine.POOF_DELAY = 0.25
Florentine.INTERACT_SENSOR_SIZE = 143
Florentine.INTERACT_SENSOR_ANGLE = 90
Florentine.SOLID_POSITIONS_BUFFER_SIZE = 10
Florentine.TEXT_COLOR = {0.40392156862745, 0.85882352941176, 0.72156862745098}
Florentine.init = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4, l_13_5, l_13_6)
  Entity.init(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4)
  if not l_13_6 then
    l_13_6 = {}
  end
  l_13_0.state = l_13_6
  InterfaceComponent.new(l_13_0)
  SpriteComponent.new(l_13_0, "Characters/Princess/Princess")
  AnimatorComponent.new(l_13_0, false, l_13_5)
  ControllerComponent.new(l_13_0)
  PhysicsComponent.new(l_13_0, 24, 24, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.ALL_CATEGORY)
  SceneComponent.new(l_13_0)
  SoundComponent.new(l_13_0, {})
  FactionComponent.new(l_13_0, "GOOD")
  local animator = l_13_0:get(AnimatorComponent)
  animator:registerEventCallback(l_13_0, "footstep", l_13_0.onFootstep)
  HealthComponent.new(l_13_0, l_13_6.maxHealth, l_13_6.curHealth, l_13_6.damageMultiplier, 1, 0.05)
  l_13_0:get(HealthComponent).onDamaged:register(l_13_0.onHealthChanged, l_13_0)
  l_13_0:get(HealthComponent).onMaxHealthChanged:register(l_13_0.onHealthChanged, l_13_0)
  l_13_0:get(HealthComponent).onKilled:register(l_13_0.onKilled, l_13_0)
  local HealthGui = Gui.load("Content/Game/Global/Gui/HealthGui")
  l_13_0.prop:setScl(0.65)
  l_13_0:get(PhysicsComponent):setCollisionHandler(PhysicsComponent.ALL_CATEGORY, l_13_0.onCollision, l_13_0, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  l_13_0.lastSolidPositions = {}
  for i = 1, l_13_0.SOLID_POSITIONS_BUFFER_SIZE do
    l_13_0.lastSolidPositions[i] = {l_13_2, l_13_3}
  end
  l_13_0:createInteractSensor()
  l_13_0.disableInputRefCount = 0
  l_13_0.contactEntities = EntitySet.new()
  l_13_0.actionEvent = Delegate.new()
  l_13_0.moveEvent = Delegate.new()
  l_13_0.chargeBeginEvent = Delegate.new()
  l_13_0.chargeCompleteEvent = Delegate.new()
  l_13_0.chargeEndEvent = Delegate.new()
  l_13_0.scaleFactor = 1
  l_13_0:room():markShadowedEntity(l_13_0)
  l_13_0.debugGui = nil
end

Florentine.onCollision = function(l_14_0, l_14_1, l_14_2)
  if l_14_1 then
    if l_14_2 == MOAIBox2DArbiter.BEGIN then
      l_14_0.contactEntities:addEntity(l_14_1)
    else
      l_14_0.contactEntities:removeEntity(l_14_1)
    end
    l_14_0:updateInteract()
  end
end

Florentine.onHealthChanged = function(l_15_0)
  local health = l_15_0:get(HealthComponent)
  if l_15_0.state.curHealth <= health.curHealth then
    l_15_0:get(SoundComponent):playCue("UI/Hacking_UI/Heart_Gained", nil, 0.5)
  end
  l_15_0.state.curHealth = health.curHealth
  l_15_0.state.maxHealth = health.maxHealth
end

Florentine.onKilled = function(l_16_0)
  if l_16_0.state.curHealth > 0 then
    l_16_0:destroy()
  end
end

Florentine.setDefaultShader = function(l_17_0, l_17_1)
  Entity.setDefaultShader(l_17_0, l_17_1)
  if l_17_0.shadowBuffer then
    l_17_0:setShadowBuffer(l_17_0.shadowBuffer)
  end
end

Florentine.resetShader = function(l_18_0)
  Entity.resetShader(l_18_0)
  if l_18_0.shadowBuffer then
    l_18_0:setShadowBuffer(l_18_0.shadowBuffer)
  end
end

Florentine.halt = function(l_19_0, l_19_1, l_19_2)
  if l_19_1 and (not l_19_0.action or not l_19_0.action:is(HaltAction)) then
    if l_19_2 then
      l_19_0:queueAction(HaltAction.new())
    else
      l_19_0:forceAction(HaltAction.new())
      do return end
      if l_19_0.action and l_19_0.action:is(HaltAction) then
        l_19_0:forceAction()
      end
    end
  end
  if l_19_1 then
    l_19_0:disableInput()
  else
    l_19_0:enableInput()
  end
end

Florentine.disableInput = function(l_20_0)
  l_20_0.disableInputRefCount = l_20_0.disableInputRefCount + 1
  assert(l_20_0.disableInputRefCount >= 0, "Must call florentine:halt() in pairs!")
end

Florentine.enableInput = function(l_21_0)
  l_21_0.disableInputRefCount = l_21_0.disableInputRefCount - 1
  assert(l_21_0.disableInputRefCount >= 0, "Must call florentine:halt() in pairs!")
end

Florentine.inputEnabled = function(l_22_0)
  return l_22_0.disableInputRefCount == 0
end

Florentine.tick = function(l_23_0)
  local posX, posY = l_23_0:getPosition()
  local controller = l_23_0:get(ControllerComponent)
  if not l_23_0.action then
    local action = nil
    if l_23_0:inputEnabled() then
      if l_23_0.interactEntities.count > 0 then
        l_23_0:updateInteract()
      end
      if controller:consumeNewMotive("Interact") then
        controller:consumeNewMotive("Dismiss")
        local interactEntity = l_23_0:getInteractEntity()
        if interactEntity then
          action = InteractAction.new(interactEntity)
        end
      end
    end
    if action then
      l_23_0:queueAction(action)
      l_23_0.actionEvent:dispatch(action)
    end
  end
  if not l_23_0.action and #l_23_0.actionQueue == 0 then
    local animator = l_23_0:get(AnimatorComponent)
    if l_23_0:move(l_23_0.MOVE_SPEED, true) then
      animator:play("Run", l_23_0.MOVE_FRAMES_PER_SECOND)
      if not l_23_0.lastPoof or l_23_0.lastPoof + l_23_0.POOF_DELAY < MOAISim.getElapsedTime() then
        Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_23_0.layer, posX, posY, nil, l_23_0.scaleFactor)
        l_23_0.lastPoof = MOAISim.getElapsedTime()
      else
        l_23_0.lastPoof = nil
        animator:play("Breathe", l_23_0.MOVE_FRAMES_PER_SECOND)
      end
    end
  end
  Entity.tick(l_23_0)
end

Florentine.move = function(l_24_0, l_24_1, l_24_2)
  local controller = l_24_0:get(ControllerComponent)
  local nx, ny = 0, 0
  if l_24_0:inputEnabled() then
    nx, ny = controller:getDirectionVector()
    if nx == 0 and ny == 0 then
      if controller:hasMotive("MoveN") then
        ny = ny + 1
      end
      if controller:hasMotive("MoveS") then
        ny = ny - 1
      end
      if controller:hasMotive("MoveE") then
        nx = nx + 1
      end
      if controller:hasMotive("MoveW") then
        nx = nx - 1
      end
    end
  end
  local animator = l_24_0:get(AnimatorComponent)
  local physics = l_24_0:get(PhysicsComponent)
  if nx ~= 0 or ny ~= 0 then
    local mag = math.sqrt((nx) * (nx) + (ny) * (ny))
    if mag < 0.5 then
      nx, ny = (nx) / mag * 0.5, (ny) / mag * 0.5
    end
    local dx, dy = nx * l_24_1, ny * l_24_1
    dy = dy * Direction.VEL_RATIO
    physics:setLinearVelocity(dx, dy)
    if l_24_2 then
      local oldDirection = animator:getDirection()
      animator:updateDirection(nx, ny)
      if oldDirection ~= animator:getDirection() then
        l_24_0:onFootstep()
      end
    end
    l_24_0.moveEvent:dispatch()
    return true
  else
    physics:setLinearVelocity(0, 0)
    return false
  end
end

Florentine.createInteractSensor = function(l_25_0)
  if l_25_0.interactSensor then
    l_25_0.interactSensor.fixture:destroy()
    l_25_0.interactSensor = nil
  end
  l_25_0.interactEntities = EntitySet.new()
  local physics = l_25_0:get(PhysicsComponent)
  l_25_0.interactSensor = physics:addCircleSensor(l_25_0.INTERACT_SENSOR_SIZE, PhysicsComponent.ALL_CATEGORY)
  l_25_0.interactSensor.entityEnterEvent:register(l_25_0.onInteractEntityEnter, l_25_0)
  l_25_0.interactSensor.entityLeaveEvent:register(l_25_0.onInteractEntityLeave, l_25_0)
  l_25_0.interactSensor.fixture:setDebugColor(1, 1, 1, 0)
end

Florentine.onInteractEntityEnter = function(l_26_0, l_26_1)
  local interact = l_26_1:get(InteractionComponent)
  if not interact then
    return 
  end
  l_26_0.interactEntities:addEntity(l_26_1)
  interact.sensorEvent:dispatch(l_26_0, true)
  interact.enabledEvent:register(l_26_0.onEntityInteractEnabled, l_26_0)
  l_26_0:updateInteract()
end

Florentine.onInteractEntityLeave = function(l_27_0, l_27_1)
  local interact = l_27_1:get(InteractionComponent)
  if not interact then
    return 
  end
  l_27_0.interactEntities:removeEntity(l_27_1)
  interact.sensorEvent:dispatch(l_27_0, false)
  interact.enabledEvent:unregister(l_27_0.onEntityInteractEnabled, l_27_0)
  l_27_0:updateInteract()
end

Florentine.onEntityInteractEnabled = function(l_28_0, l_28_1)
  l_28_0:updateInteract()
end

Florentine.updateInteract = function(l_29_0)
  local interactEntity = nil
  if not l_29_0.action then
    interactEntity = l_29_0:getInteractEntity()
  end
  if l_29_0.interactInterface then
    local currentEntity = l_29_0.interactInterface.target.entity
  end
  if interactEntity == currentEntity then
    return 
  end
  local interface = l_29_0:get(InterfaceComponent)
  if l_29_0.interactInterface then
    interface:removeInterface(l_29_0.interactInterface)
    l_29_0.interactInterface = nil
  end
  if interactEntity then
    local InteractIconGui = Gui.load("Content/Game/Global/Gui/InteractIconGui")
    local offsetX, offsetY = interactEntity:get(InteractionComponent):getOffset()
    l_29_0.interactInterface = InteractIconGui.new(l_29_0, interactEntity, offsetX, offsetY)
    interface:pushInterface(l_29_0.interactInterface)
  end
end

Florentine.getInteractEntity = function(l_30_0)
  local closestInteractEntity, closestInteractDistSq = nil, nil
  local x, y = l_30_0:getPosition()
  local dirX, dirY = l_30_0:get(AnimatorComponent):getDirVector()
  if l_30_0.interactSensor then
    for _,entity in pairs(l_30_0.interactEntities.entities) do
      local interact = entity:get(InteractionComponent)
      if interact and interact:canInteract(l_30_0) then
        local ex, ey = entity:getPosition()
        local offsetX, offsetY = interact:getOffset()
        local dx, dy = ex + offsetX - x, ey + offsetY - y
        local distSq = dx * dx + dy * dy
        local normX, normY = Math.normalize(dx, dy)
        local angle = math.deg(math.acos(normX * dirX + normY * dirY))
        if math.abs(angle) < l_30_0.INTERACT_SENSOR_ANGLE and (not closestInteractDistSq or distSq < closestInteractDistSq) and (not interact.requiresContact or l_30_0.contactEntities:hasEntity(entity)) then
          closestInteractEntity, closestInteractDistSq = entity, distSq
        end
      end
    end
  end
  return closestInteractEntity
end

Florentine.setSolidPosition = function(l_31_0, l_31_1, l_31_2)
  l_31_0.lastSolidPositions = {{l_31_1, l_31_2}}
end

Florentine.getSolidPosition = function(l_32_0)
  local solidX, solidY = 0, 0
  if #l_32_0.lastSolidPositions > 0 then
    solidX, solidY = unpack(l_32_0.lastSolidPositions[math.ceil(#l_32_0.lastSolidPositions / 2)])
  end
  return solidX, solidY
end

Florentine.isGhost = function(l_33_0)
  local physics = l_33_0:get(PhysicsComponent)
  return physics.category == PhysicsComponent.GHOST_CATEGORY and physics.collidesWithCategories == PhysicsComponent.GHOST_CATEGORY
end

Florentine.toggleGhost = function(l_34_0)
  l_34_0:insertAction(GhostTransformAction.new())
end

Florentine.teleportInClassRoom = function(l_35_0, l_35_1)
  local fullPath = "Data/" .. l_35_1.entityPath .. ".lua"
  local body = loadfile(fullPath)
  local disassembly = Disassembly.new(body)
  return l_35_0:teleportInPrototype(l_35_1, disassembly.prototype)
end

Florentine.teleportInPrototype = function(l_36_0, l_36_1, l_36_2, l_36_3)
  local action = PrototypeTeleport.new(l_36_1, l_36_2, l_36_3)
  l_36_0:forceAction(action)
  return action
end

Florentine.exitPrototype = function(l_37_0, l_37_1)
  local action = PrototypeTeleport.new(l_37_1)
  l_37_0:forceAction(action)
  return action
end

Florentine.isHackable = function(l_38_0, l_38_1)
  return false
end

Florentine.scale = function(l_39_0, l_39_1)
  l_39_0.scaleFactor = l_39_0.scaleFactor * l_39_1
  local sprite = l_39_0:get(SpriteComponent)
  local animator = l_39_0:get(AnimatorComponent)
  local scale = l_39_0.prop:getScl()
  scale = l_39_1 * scale
  l_39_0.prop:setScl(scale)
  l_39_0.label.textBox:setScl(l_39_0.scaleFactor)
  l_39_0.MOVE_SPEED = l_39_1 * l_39_0.MOVE_SPEED
  local physics = l_39_0:get(PhysicsComponent)
  physics.fixture:destroy()
  physics.width, physics.height = l_39_1 * physics.width, l_39_1 * physics.height
  local halfWidth, halfHeight = physics.width * 0.5, physics.height * 0.5
  physics.x0, physics.y0, physics.x1, physics.y1 = -halfWidth, -halfHeight, halfWidth, halfHeight
  physics.fixture = physics:addRect(physics.x0, physics.y0, physics.x1, physics.y1)
  if physics.collisionHandlerData then
    physics:setCollisionHandler(physics.collisionHandlerData.mask, physics.collisionHandlerData.handler, physics.collisionHandlerData.firstArg, physics.collisionHandlerData.phaseMask)
  end
  l_39_0.INTERACT_SENSOR_SIZE = l_39_0.INTERACT_SENSOR_SIZE * l_39_1
  l_39_0:createInteractSensor()
end

Florentine.toggleDebugGui = function(l_40_0)
  if not l_40_0.debugGui then
    local DebugGui = Gui.load("Content/Game/Global/Gui/DebugGui")
    l_40_0.debugGui = DebugGui.new()
  end
  if l_40_0.showingDebugGui then
    l_40_0:get(InterfaceComponent):removeInterface(l_40_0.debugGui)
    l_40_0.showingDebugGui = false
  else
    l_40_0:get(InterfaceComponent):pushInterface(l_40_0.debugGui)
    l_40_0.showingDebugGui = true
  end
end

Florentine.teleport = function(l_41_0, l_41_1, l_41_2)
  l_41_0:forceAction()
  l_41_0:setPosition(l_41_1, l_41_2)
  Trace(TT_Info, "Teleport to position %.2f, %.2f", l_41_1, l_41_2)
end

return Florentine

