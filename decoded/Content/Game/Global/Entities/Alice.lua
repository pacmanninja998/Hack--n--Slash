-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Alice.lua 

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
local ShadowComponent = require("Components.ShadowComponent")
local ControllerComponent = require("Components.ControllerComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InventoryComponent = require("Components.InventoryComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local SceneComponent = require("Components.SceneComponent")
local SwimmingComponent = require("Components.SwimmingComponent")
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

local AbyssAction = Class.create(Action, "AbyssAction")
AbyssAction.init = function(l_8_0, l_8_1, l_8_2, l_8_3)
  l_8_0.solidPosX = l_8_1
  l_8_0.solidPosY = l_8_2
  l_8_0.targetRoomPath = l_8_3.targetRoomPath
  l_8_0.fallingShader = Shader.load("Content/Game/Global/Shaders/AbyssFalling")
end

AbyssAction.start = function(l_9_0, l_9_1)
  Action.start(l_9_0, l_9_1)
  local physics = l_9_0.entity:get(PhysicsComponent)
  local velX, velY = physics:getLinearVelocity()
  l_9_0.normX, l_9_0.normY = Math.normalize(velX, velY), velX
  physics:setLinearVelocity(0, 0)
  l_9_0.entity:get(SoundComponent):playCue("SFX/Characters/Alice/Fall_In_Abyss", nil, 0.5)
  l_9_0.fallSequence = l_9_0.entity:get(AnimatorComponent):play("Fall_Frnt", l_9_0.FRAMES_PER_SECOND)
  l_9_0.entity:setCurrentShader(l_9_0.fallingShader)
  l_9_0.origScale = l_9_0.entity.prop:getScl()
  l_9_0.animDone = false
  l_9_0.effectDone = false
  l_9_0.elapsed = 0
  l_9_0.fallDuration = 3
  l_9_0.scaleDuration = 1.2
  l_9_0.entity:get(ShadowComponent).prop:setVisible(false)
end

AbyssAction.stop = function(l_10_0)
  if not l_10_0.targetRoomPath then
    if not l_10_0.setPosition then
      l_10_0.entity:room():queueUpdate(function()
    self.entity:setPosition(self.solidPosX, self.solidPosY)
    self.entity:get(PhysicsComponent):setLinearVelocity(-0.01 * self.normX, -0.01 * self.normY)
   end)
    end
    l_10_0.entity:resetShader()
    l_10_0.entity.prop:setScl(l_10_0.origScale)
    l_10_0.entity:get(SpriteComponent).prop:setVisible(true)
    l_10_0.entity:get(ShadowComponent).prop:setVisible(true)
  else
    l_10_0.entity.host:handleRoomExit(l_10_0.entity, l_10_0.targetRoomPath)
  end
end

AbyssAction.tick = function(l_11_0)
  l_11_0.elapsed = l_11_0.elapsed + MOAISim.getStep()
  if l_11_0.fallDuration < l_11_0.elapsed then
    l_11_0.animDone = true
  elseif not l_11_0.animDone then
    local lifetime = l_11_0.elapsed / l_11_0.fallDuration
    local scaleLifetime = l_11_0.elapsed / l_11_0.scaleDuration
    if scaleLifetime > 0.8 then
      scaleLifetime = 0.8
    end
    l_11_0.entity.prop:setScl(l_11_0.origScale * (1 - scaleLifetime))
    local targetSprite = l_11_0.entity:get(SpriteComponent)
    local deck, index = targetSprite.sheet:getDeck(targetSprite.name, targetSprite.frame, targetSprite.looping)
    local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
    local u0, v0, u1, v1 = x0, y0, x2, y2
    local uScale = u1 - u0
    local vScale = v1 - v0
    targetSprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
    targetSprite.material:setShaderValue("shaderDuration", MOAIMaterial.VALUETYPE_FLOAT, lifetime)
  end
  if l_11_0.animDone and not l_11_0.effectDone then
    l_11_0.entity:get(SpriteComponent).prop:setVisible(false)
    l_11_0.effectDone = true
  end
  if l_11_0.animDone and l_11_0.effectDone then
    l_11_0.done = true
  end
  if l_11_0.done then
    l_11_0.entity:setPosition(l_11_0.solidPosX, l_11_0.solidPosY)
    l_11_0.setPosition = true
  end
  return not l_11_0.done
end

local RescuedAction = Class.create(Action, "RescuedAction")
RescuedAction.init = function(l_12_0, l_12_1, l_12_2)
  l_12_0.solidPosX = l_12_1
  l_12_0.solidPosY = l_12_2
end

RescuedAction.start = function(l_13_0, l_13_1)
  Action.start(l_13_0, l_13_1)
  l_13_0.entity:get(SpriteComponent).prop:setVisible(false)
  local physics = l_13_0.entity:get(PhysicsComponent)
  local velX, velY = physics:getLinearVelocity()
  l_13_0.normX, l_13_0.normY = Math.normalize(velX, velY), velX
  physics:setLinearVelocity(0, 0)
  l_13_0.entity:get(SoundComponent):playCue("SFX/Characters/Alice/Fall_In_Water", nil, 0.5)
  local posX, posY = l_13_0.entity:getPosition()
  posX, posY = posX + 1.5 * l_13_0.normX * physics.width, posY + 1.5 * l_13_0.normY * physics.height
  local rippleLayer = l_13_0.entity:room():getLayerByName("Water")
  if not rippleLayer then
    local rippleLayer = l_13_0.entity.layer
  end
  local drownRipples = Entity.create("Content/Game/Global/Entities/DrownRipples", rippleLayer, posX, posY, "DrownRipples", l_13_0.onDone, l_13_0)
end

RescuedAction.onDone = function(l_14_0)
  l_14_0.done = true
  l_14_0.entity:setPosition(l_14_0.solidPosX, l_14_0.solidPosY)
  l_14_0.entity:get(PhysicsComponent):setLinearVelocity(-0.01 * l_14_0.normX, -0.01 * l_14_0.normY)
  l_14_0.entity:get(SpriteComponent).prop:setVisible(true)
end

RescuedAction.tick = function(l_15_0)
  return not l_15_0.done
end

local GhostTransformAction = Class.create(Action, "GhostTransformAction")
GhostTransformAction.tick = function(l_16_0)
  local physics = l_16_0.entity:get(PhysicsComponent)
  if physics and physics.body and physics.fixture then
    local category, collidesWithCategories = physics.category, physics.collidesWithCategories
    if l_16_0.entity:isGhost() then
      if l_16_0.entity.interactSensor then
        l_16_0.entity.interactSensor.fixture:destroy()
        l_16_0.entity.interactSensor = nil
      end
      physics:destroy()
      physics:init(nil, nil, nil, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.ALL_CATEGORY)
      l_16_0.entity.prop:setColor(1, 1, 1, 1)
      l_16_0.entity:createInteractSensor()
    else
      if l_16_0.entity.interactSensor then
        l_16_0.entity.interactSensor.fixture:destroy()
        l_16_0.entity.interactSensor = nil
      end
      physics:destroy()
      physics:init(nil, nil, nil, PhysicsComponent.GHOST_CATEGORY, PhysicsComponent.GHOST_CATEGORY)
      l_16_0.entity.prop:setColor(1, 1, 1, 0.5)
      l_16_0.entity:createInteractSensor()
    end
  end
  return false
end

local OpenTabsAction = Class.create(CommonActions.LoopAnimation, "OpenTabsAction")
OpenTabsAction.init = function(l_17_0)
  Class.super(OpenTabsAction).init(l_17_0, "Breathe")
end

OpenTabsAction.start = function(l_18_0, l_18_1)
  Class.super(OpenTabsAction).start(l_18_0, l_18_1)
  l_18_0.entity.tabsGui.dismissed = false
  l_18_0.entity:get(InterfaceComponent):pushInterface(l_18_0.entity.tabsGui)
  MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/Inventory_Appear")
end

OpenTabsAction.tick = function(l_19_0)
  Class.super(OpenTabsAction).tick(l_19_0)
  local controller = l_19_0.entity:get(ControllerComponent)
  if not l_19_0.entity.tabsGui.dismissed then
    local dismissed = controller:consumeNewMotive("OpenTabs")
  end
  return not dismissed
end

OpenTabsAction.stop = function(l_20_0)
  l_20_0.entity:get(InterfaceComponent):removeInterface(l_20_0.entity.tabsGui)
end

local SleepAction = Class.create(Action, "SleepAction")
SleepAction.ANIMATION = "Hop_IntoBed"
SleepAction.FRAMES_PER_SECOND = 15
SleepAction.JUMP_START_FRAME = 3
SleepAction.JUMPING_FRAMES = 4
SleepAction.init = function(l_21_0, l_21_1, l_21_2, l_21_3)
  l_21_0.bed = l_21_1
  l_21_0.event = l_21_2
  l_21_0.eventTime = l_21_3
end

SleepAction.start = function(l_22_0, l_22_1)
  Action.start(l_22_0, l_22_1)
  l_22_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_22_0.entity:get(SoundComponent):playCue("SFX/Cutscenes/Alice_Hop_In_Bed")
  l_22_0.elapsed = 0
  l_22_0.jumpStartTime = l_22_0.JUMP_START_FRAME / l_22_0.FRAMES_PER_SECOND
  l_22_0.jumpDuration = l_22_0.JUMPING_FRAMES / l_22_0.FRAMES_PER_SECOND
  l_22_0.sequence = l_22_0.entity:get(AnimatorComponent):playOnce(l_22_0.ANIMATION, l_22_0.FRAMES_PER_SECOND)
  local startX, startY = l_22_0.entity:getPosition()
  l_22_0.startOffsetX, l_22_0.startOffsetY = l_22_0.entity.prop:getLoc(), l_22_0.entity.prop
  l_22_0.targetX, l_22_0.targetY = l_22_0.bed:getPosition(), l_22_0.bed
  l_22_0.targetOffsetX, l_22_0.targetOffsetY = l_22_0.targetX - startX - l_22_0.startOffsetX, l_22_0.targetY - startY - l_22_0.startOffsetY + 16
  l_22_0.oldPriority = l_22_0.entity:get(SpriteComponent).prop:getPriority()
  l_22_0.entity:get(SpriteComponent).prop:setPriority(32)
end

SleepAction.tick = function(l_23_0)
  local controller = l_23_0.entity:get(ControllerComponent)
  if l_23_0.jumpStartTime + l_23_0.jumpDuration < l_23_0.elapsed and (controller:hasMotive("MoveN") or controller:hasMotive("MoveS") or controller:hasMotive("MoveE") or controller:hasMotive("MoveW")) then
    return false
  else
    l_23_0.elapsed = l_23_0.elapsed + MOAISim.getStep()
    if l_23_0.eventTime and l_23_0.eventTime < l_23_0.elapsed and l_23_0.event then
      l_23_0.event:dispatch()
      l_23_0.event, l_23_0.eventTime = nil
    end
    if l_23_0.jumpStartTime <= l_23_0.elapsed and l_23_0.elapsed <= l_23_0.jumpStartTime + l_23_0.jumpDuration then
      local jumpProgress = math.min(1, (l_23_0.elapsed - l_23_0.jumpStartTime) / l_23_0.jumpDuration)
      local lerpX, lerpY = Math.lerp(l_23_0.startOffsetX, l_23_0.targetOffsetX, jumpProgress), Math.lerp(l_23_0.startOffsetY, l_23_0.targetOffsetY, jumpProgress)
      l_23_0.entity.prop:setLoc(lerpX, lerpY)
    end
    return true
  end
end

SleepAction.stop = function(l_24_0)
  l_24_0.entity.prop:setLoc(l_24_0.startOffsetX, l_24_0.startOffsetY)
  l_24_0.entity:setPosition(l_24_0.targetX, l_24_0.targetY - 32)
  l_24_0.entity:get(SpriteComponent).prop:setPriority(l_24_0.oldPriority)
  Action.stop(l_24_0)
end

local DieAction = Class.create(Action, "DieAction")
DieAction.ANIMATION = "HitRoll"
DieAction.FRAMES_PER_SECOND = 15
DieAction.start = function(l_25_0, l_25_1)
  Action.start(l_25_0, l_25_1)
  l_25_0.sequence = l_25_0.entity:get(AnimatorComponent):playOnce(l_25_0.ANIMATION, l_25_0.FRAMES_PER_SECOND)
  l_25_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_25_0.cue = l_25_0.entity:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Death", nil, 0.5)
  l_25_0.glitchDuration = 0.6
  l_25_0.glitchOutShader = Shader.load("Content/Game/Global/Shaders/GlitchOut")
  l_25_0.elapsed = 0
  l_25_0.origScaleX, l_25_0.origScaleY = l_25_0.entity.prop:getScl(), l_25_0.entity.prop
  local sprite = l_25_0.entity:get(SpriteComponent)
  local deck, index = sprite.sheet:getDeck(sprite.name, sprite.frame, sprite.looping)
  local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
  local u0, v0, u1, v1 = x0, y0, x2, y2
  local uScale = u1 - u0
  local vScale = v1 - v0
  l_25_0.entity:setDefaultShader(l_25_0.glitchOutShader)
  sprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
end

DieAction.tick = function(l_26_0)
  l_26_0.entity:get(SpriteComponent).material:setShaderValue("deathTime", MOAIMaterial.VALUETYPE_FLOAT, 0)
  l_26_0.elapsed = l_26_0.elapsed + MOAISim.getStep()
  if l_26_0.glitchDuration < l_26_0.elapsed then
    if l_26_0.destroyWhenDone then
      l_26_0.entity:get(SpriteComponent).prop:setVisible(false)
      l_26_0.entity:destroy()
    else
      l_26_0.entity:get(SpriteComponent).prop:setVisible(true)
    end
    return false
  else
    local deathAmount = l_26_0.elapsed / l_26_0.glitchDuration
    local currentSprite = l_26_0.entity:get(SpriteComponent)
    currentSprite.material:setShaderValue("deathTime", MOAIMaterial.VALUETYPE_FLOAT, deathAmount)
    l_26_0.entity.prop:setScl(l_26_0.origScaleX + l_26_0.origScaleX * 0.05 * deathAmount, l_26_0.origScaleY + l_26_0.origScaleY * 15 * deathAmount)
  end
  return l_26_0.entity:get(AnimatorComponent):isPlaying(l_26_0.sequence)
end

DieAction.stop = function(l_27_0)
  local inventory = l_27_0.entity:get(InventoryComponent)
  local StateAmulet = Item.load("Content/Game/Global/Items/StateAmulet")
  for index,item in ipairs(inventory.items) do
    if item:is(StateAmulet) then
      l_27_0.entity:queueAction(item:getAction())
      return 
    end
  end
  l_27_0.entity:get(SpriteComponent).prop:setVisible(false)
  l_27_0.entity.host:gameOver()
end

local RemoveHoodAction = Class.create(Action, "RemoveHoodAction")
RemoveHoodAction.ANIMATION = "PullOffHood"
RemoveHoodAction.FRAMES_PER_SECOND = 30
RemoveHoodAction.HOLD_ANIM = "HoldHood"
RemoveHoodAction.init = function(l_28_0, l_28_1)
  Action.init(l_28_0)
  l_28_0.holdHoodTime = l_28_1
end

RemoveHoodAction.start = function(l_29_0, l_29_1)
  Action.start(l_29_0, l_29_1)
  if not l_29_0.entity.state.hoodless then
    l_29_1:get(SoundComponent):playCue("SFX/Cutscenes/Alice_Stuff_Bed")
    l_29_0.removeHoodSequence = l_29_0.entity:get(AnimatorComponent):playOnce(l_29_0.ANIMATION, l_29_0.FRAMES_PER_SECOND)
  end
  l_29_0.holdHoodElapsed = 0
  l_29_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
end

RemoveHoodAction.tick = function(l_30_0)
  if l_30_0.holdHoodTime > 0 then
    if l_30_0.entity:get(AnimatorComponent):isPlaying(l_30_0.removeHoodSequence) then
      return true
    elseif l_30_0.removeHoodSequence and not l_30_0.holdHoodSequence then
      l_30_0.removeHoodSequence = nil
      l_30_0.holdHoodSequence = l_30_0.entity:get(AnimatorComponent):playOnce(l_30_0.HOLD_ANIM, 0)
      return true
    else
      if l_30_0.entity:get(AnimatorComponent):isPlaying(l_30_0.holdHoodSequence) then
        l_30_0.holdHoodElapsed = l_30_0.holdHoodElapsed + MOAISim.getStep()
        return l_30_0.holdHoodElapsed < l_30_0.holdHoodTime
      else
        return l_30_0.entity:get(AnimatorComponent):isPlaying(l_30_0.removeHoodSequence)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

RemoveHoodAction.stop = function(l_31_0)
  if not l_31_0.entity.state.hoodless then
    l_31_0.entity:get(SpriteComponent):setSpriteSheet("Characters/Hero_Hair/Hero_Hair")
    l_31_0.entity.state.hoodless = true
  end
  l_31_0.entity:get(AnimatorComponent):play("Breathe", l_31_0.MOVE_FRAMES_PER_SECOND)
end

local StuffBedAction = Class.create(Action, "StuffBedAction")
StuffBedAction.ANIMATION = "MakeBedDummy"
StuffBedAction.FRAMES_PER_SECOND = 15
StuffBedAction.init = function(l_32_0, l_32_1, l_32_2)
  Action.init(l_32_0)
  l_32_0.bed = l_32_1
  l_32_0.waitTime = l_32_2
end

StuffBedAction.start = function(l_33_0, l_33_1)
  Action.start(l_33_0, l_33_1)
  local animator = l_33_0.entity:get(AnimatorComponent)
  l_33_0.originalDir = animator:getDirection()
  local bedPosX, bedPosY = l_33_0.bed:getPosition()
  local posX, posY = l_33_0.entity:getPosition()
  local dirToBed = Direction.vectorToDir(bedPosX - posX, bedPosY - posY, false)
  animator:setFacing(dirToBed)
  l_33_0.sequence = animator:playOnce(l_33_0.ANIMATION, l_33_0.FRAMES_PER_SECOND)
  l_33_0.bed:stuffBed()
end

StuffBedAction.tick = function(l_34_0)
  if l_34_0.bed.action then
    return l_34_0.entity:get(AnimatorComponent):isPlaying(l_34_0.sequence)
  end
end

StuffBedAction.stop = function(l_35_0)
  l_35_0.entity:get(AnimatorComponent):setFacing(l_35_0.originalDir)
  Action.stop(l_35_0)
end

local PrototypeTeleport = Class.create(CommonActions.PlayAnimation, "PrototypeTeleport")
PrototypeTeleport.MOVEMENT_COMPLETE_RATIO = 0.75
PrototypeTeleport.init = function(l_36_0, l_36_1, l_36_2, l_36_3)
  Class.super(PrototypeTeleport).init(l_36_0, "Teleport_In")
  l_36_0.portalRef = EntityRef.new(l_36_1)
  l_36_0.name = l_36_1.name
  local fnComponent = l_36_1:get(FunctionComponent)
  if fnComponent then
    l_36_0.name = fnComponent.name
  end
  l_36_0.prototype = l_36_2
  l_36_0.targetPC = l_36_3
end

PrototypeTeleport.start = function(l_37_0, l_37_1)
  Class.super(PrototypeTeleport).start(l_37_0, l_37_1)
  l_37_0.entity:get(ShadowComponent):setEnabled(false)
  l_37_0.startX, l_37_0.startY = l_37_1:getPosition(), l_37_1
end

PrototypeTeleport.tick = function(l_38_0)
  local result = Class.super(PrototypeTeleport).tick(l_38_0)
  if result and l_38_0.portalRef:isValid() then
    local targetX, targetY = l_38_0.portalRef.entity:getPosition()
    local t = math.min(1, (1 - l_38_0.remaining / l_38_0.totalTime) / l_38_0.MOVEMENT_COMPLETE_RATIO)
    local posX, posY = Math.lerp(l_38_0.startX, targetX, t), Math.lerp(l_38_0.startY, targetY, t)
    local entityX, entityY = l_38_0.entity:getPosition()
    l_38_0.entity:get(SpriteComponent).prop:setLoc(posX - entityX, posY - entityY)
  end
  return result
end

PrototypeTeleport.stop = function(l_39_0)
  Class.super(PrototypeTeleport).stop(l_39_0)
  l_39_0.entity:get(ShadowComponent):setEnabled(true)
  l_39_0.entity:setVisible(false)
  l_39_0.entity:get(SpriteComponent).prop:setLoc(0, 0)
  l_39_0.entity:room():queueUpdate(function()
    if self.prototype then
      self.entity.host:enterPrototype(self.entity:world(), self.name, self.prototype, self.targetPC)
    else
      self.entity:room():savePrototype()
      self.entity.host:removeRoom()
    end
   end)
end

local Alice = Class.create(Entity, "Alice")
Alice.addIntegerField("MOVE_SPEED", 300, -1000, 1000)
Alice.MOVE_FRAMES_PER_SECOND = 15
Alice.POOF_DELAY = 0.25
Alice.INTERACT_SENSOR_SIZE = 143
Alice.INTERACT_SENSOR_ANGLE = 90
Alice.SOLID_POSITIONS_BUFFER_SIZE = 10
Alice.TEXT_COLOR = {0.40392156862745, 0.85882352941176, 0.72156862745098}
Alice.init = function(l_40_0, l_40_1, l_40_2, l_40_3, l_40_4, l_40_5, l_40_6, l_40_7)
  Entity.init(l_40_0, l_40_1, l_40_2, l_40_3, l_40_4)
  l_40_0.state = l_40_6
  l_40_0.host = l_40_7
  InterfaceComponent.new(l_40_0)
  if l_40_0.state.hoodless then
    SpriteComponent.new(l_40_0, "Characters/Hero_Hair/Hero_Hair")
  else
    SpriteComponent.new(l_40_0, "Characters/Hero/Hero")
  end
  ShadowComponent.new(l_40_0)
  AnimatorComponent.new(l_40_0, false, l_40_5)
  ControllerComponent.new(l_40_0)
  PhysicsComponent.new(l_40_0, 24, 24, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.ALL_CATEGORY)
  InventoryComponent.new(l_40_0, l_40_6)
  SceneComponent.new(l_40_0)
  SwimmingComponent.new(l_40_0, false)
  SoundComponent.new(l_40_0, {})
  FactionComponent.new(l_40_0, "GOOD")
  local scene = l_40_0:get(SceneComponent)
  scene:mapString("$ALICE", l_40_6.name)
  scene:mapString("$ALICE_UPPER", l_40_6.name:upper())
  scene:mapString("$BOB", l_40_6.bondedSprite)
  if l_40_6.bondedSprite then
    scene:mapString("$BOB_UPPER", l_40_6.bondedSprite:upper())
  end
  local animator = l_40_0:get(AnimatorComponent)
  animator:registerEventCallback(l_40_0, "footstep", l_40_0.onFootstep)
  l_40_0.footstepMaterialSounds = {PlatformComponent.SOUND_MAT_GRASS = "SFX/Characters/Alice/Footsteps/Alice_FS_Grass", PlatformComponent.SOUND_MAT_STONE = "SFX/Characters/Alice/Footsteps/Alice_FS_Stone", PlatformComponent.SOUND_MAT_SAND = "SFX/Characters/Alice/Footsteps/Alice_FS_Sand", PlatformComponent.SOUND_MAT_WET = "SFX/Characters/Alice/Footsteps/Alice_FS_LilyPad", PlatformComponent.SOUND_MAT_WOOD = "SFX/Characters/Alice/Footsteps/Alice_FS_Wood"}
  HealthComponent.new(l_40_0, l_40_6.maxHealth, l_40_6.curHealth, l_40_6.damageMultiplier, 1, 0.05)
  l_40_0:get(HealthComponent).onDamaged:register(l_40_0.onHealthChanged, l_40_0)
  l_40_0:get(HealthComponent).onMaxHealthChanged:register(l_40_0.onHealthChanged, l_40_0)
  l_40_0:get(HealthComponent).onKilled:register(l_40_0.onKilled, l_40_0)
  local HealthGui = Gui.load("Content/Game/Global/Gui/HealthGui")
  local EquippedGui = Gui.load("Content/Game/Global/Gui/EquippedGui")
  l_40_0:get(InterfaceComponent):pushInterface(EquippedGui.new(nil, l_40_0))
  local TabsGui = Gui.load("Content/Game/Global/Gui/TabsGui")
  l_40_0.tabsGui = TabsGui.new(nil, l_40_0)
  l_40_0:get(InterfaceComponent):pushInterface(HealthGui.new(nil, l_40_0))
  local NotificationGui = Gui.load("Content/Game/Global/Gui/NotificationGui")
  l_40_0:get(InterfaceComponent):pushInterface(NotificationGui.new(nil))
  l_40_0.prop:setScl(0.65)
  l_40_0:get(PhysicsComponent):setCollisionHandler(PhysicsComponent.ALL_CATEGORY, l_40_0.onCollision, l_40_0, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  l_40_0:get(SwimmingComponent).enterWaterEvent:register(l_40_0.onEnterWater, l_40_0)
  l_40_0:get(SwimmingComponent).leaveWaterEvent:register(l_40_0.onLeaveWater, l_40_0)
  l_40_0.lastSolidPositions = {}
  for i = 1, l_40_0.SOLID_POSITIONS_BUFFER_SIZE do
    l_40_0.lastSolidPositions[i] = {l_40_2, l_40_3}
  end
  l_40_0:createInteractSensor()
  l_40_0.disableInputRefCount = 0
  l_40_0.contactEntities = EntitySet.new()
  l_40_0.actionEvent = Delegate.new()
  l_40_0.moveEvent = Delegate.new()
  l_40_0.chargeBeginEvent = Delegate.new()
  l_40_0.chargeCompleteEvent = Delegate.new()
  l_40_0.chargeEndEvent = Delegate.new()
  l_40_0.scaleFactor = 1
  l_40_0.day = l_40_0:world():countDays()
  l_40_0:room():markShadowedEntity(l_40_0)
  l_40_0.debugGui = nil
  if l_40_0.state.MOVE_SPEED then
    l_40_0.MOVE_SPEED = l_40_0.state.MOVE_SPEED
  end
  if l_40_0.state.FACTION then
    l_40_0.FACTION = l_40_0.state.FACTION
  end
end

Alice.onFieldSet = function(l_41_0, l_41_1, l_41_2)
  l_41_0.state[l_41_1] = l_41_2
end

Alice.onFootstep = function(l_42_0)
  local soundMaterial = l_42_0:get(PhysicsComponent):getPlatformSoundMaterial()
  if not soundMaterial and not l_42_0:room().defaultSoundMat then
    soundMaterial = PlatformComponent.SOUND_MAT_STONE
  end
  local soundCueName = l_42_0.footstepMaterialSounds[soundMaterial]
  if soundCueName then
    l_42_0:get(SoundComponent):playCue(soundCueName, false, 0.8)
  end
end

Alice.onCollision = function(l_43_0, l_43_1, l_43_2)
  if l_43_1 then
    if l_43_2 == MOAIBox2DArbiter.BEGIN then
      l_43_0.contactEntities:addEntity(l_43_1)
    else
      l_43_0.contactEntities:removeEntity(l_43_1)
    end
    l_43_0:updateInteract()
  end
end

Alice.onHealthChanged = function(l_44_0)
  local health = l_44_0:get(HealthComponent)
  if health.curHealth < l_44_0.state.curHealth then
    l_44_0:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_TakeDamage", nil, 0.5, SoundComponent.PLAY_MODE_KEEP)
    l_44_0:get(SoundComponent):playCue("SFX/Characters/Alice/Heart_Lost", nil, 0.5, SoundComponent.PLAY_MODE_KEEP)
  else
    if l_44_0.state.curHealth <= health.curHealth then
      l_44_0:get(SoundComponent):playCue("UI/Hacking_UI/Heart_Gained", nil, 0.5)
    end
  end
  l_44_0.state.curHealth = health.curHealth
  l_44_0.state.maxHealth = health.maxHealth
end

Alice.onKilled = function(l_45_0)
  if l_45_0.state.curHealth > 0 then
    l_45_0:forceAction(DieAction.new())
  end
end

Alice.setDefaultShader = function(l_46_0, l_46_1)
  Entity.setDefaultShader(l_46_0, l_46_1)
  if l_46_0.shadowBuffer then
    l_46_0:setShadowBuffer(l_46_0.shadowBuffer)
  end
end

Alice.resetShader = function(l_47_0)
  Entity.resetShader(l_47_0)
  if l_47_0.shadowBuffer then
    l_47_0:setShadowBuffer(l_47_0.shadowBuffer)
  end
end

Alice.halt = function(l_48_0, l_48_1, l_48_2)
  if l_48_1 and (not l_48_0.action or not l_48_0.action:is(HaltAction)) then
    if l_48_2 then
      l_48_0:queueAction(HaltAction.new())
    else
      l_48_0:forceAction(HaltAction.new())
      do return end
      if l_48_0.action and l_48_0.action:is(HaltAction) then
        l_48_0:forceAction()
      end
    end
  end
  if l_48_1 then
    l_48_0:disableInput()
  else
    l_48_0:enableInput()
  end
end

Alice.disableInput = function(l_49_0)
  l_49_0.disableInputRefCount = l_49_0.disableInputRefCount + 1
  assert(l_49_0.disableInputRefCount >= 0, "Must call alice:halt() in pairs!")
end

Alice.enableInput = function(l_50_0)
  l_50_0.disableInputRefCount = l_50_0.disableInputRefCount - 1
  assert(l_50_0.disableInputRefCount >= 0, "Must call alice:halt() in pairs!")
end

Alice.inputEnabled = function(l_51_0)
  return l_51_0.disableInputRefCount == 0
end

Alice.tick = function(l_52_0)
  local posX, posY = l_52_0:getPosition()
  local day = l_52_0:world():countDays()
  if day ~= l_52_0.day then
    local health = l_52_0:get(HealthComponent)
    if not -l_52_0.state.HEARTS_PER_DAY then
      health:damage(health.killed or 0, l_52_0)
    end
    l_52_0.day = day
  end
  if l_52_0.state.name ~= l_52_0.label.text then
    l_52_0:setLabelText(l_52_0.state.name)
  end
  local controller = l_52_0:get(ControllerComponent)
  if not l_52_0.action then
    local inventory = (l_52_0:get(InventoryComponent))
    local action = nil
    if l_52_0:inputEnabled() then
      if l_52_0.interactEntities.count > 0 then
        l_52_0:updateInteract()
      end
      if controller:consumeNewMotive("Interact") then
        controller:consumeNewMotive("Dismiss")
        local interactEntity = l_52_0:getInteractEntity()
        if interactEntity then
          action = InteractAction.new(interactEntity)
        end
      end
    end
    if not action and l_52_0:inputEnabled() and controller:consumeNewMotive("UsePrimary") and inventory.primary then
      if inventory.primary.playUseSound then
        MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/UseItem")
      end
      action = inventory.primary:getAction("UsePrimary")
    end
    for i = 1, 4 do
      local motive = "Use" .. i
      if not action and l_52_0:inputEnabled() and controller:consumeNewMotive(motive) then
        local slotItem = inventory.slots[i]
        local key, value = slotItem, nil
        if slotItem then
          if slotItem.playUseSound then
            MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/UseItem")
          end
          action = slotItem:getAction(motive)
        end
      end
    end
    if not action and l_52_0:inputEnabled() and controller:consumeNewMotive("OpenTabs") then
      action = OpenTabsAction.new()
    end
    if action then
      l_52_0:queueAction(action)
      l_52_0.actionEvent:dispatch(action)
    end
  end
  if not l_52_0.action and #l_52_0.actionQueue == 0 then
    local animator = l_52_0:get(AnimatorComponent)
    if l_52_0.state.MOVE_SPEED or l_52_0:move(l_52_0.MOVE_SPEED * l_52_0.scaleFactor, true) then
      animator:play("Run", l_52_0.MOVE_FRAMES_PER_SECOND)
      if not l_52_0.lastPoof or l_52_0.lastPoof + l_52_0.POOF_DELAY < MOAISim.getElapsedTime() then
        Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_52_0.layer, posX, posY, nil, l_52_0.scaleFactor)
        l_52_0.lastPoof = MOAISim.getElapsedTime()
      else
        l_52_0.lastPoof = nil
        animator:play("Breathe", l_52_0.MOVE_FRAMES_PER_SECOND)
      end
    end
  end
  local swimming = l_52_0:get(SwimmingComponent)
  if swimming:onSolidGround() then
    local lastSolidPosX, lastSolidPosY = unpack(l_52_0.lastSolidPositions[1])
    if posX ~= lastSolidPosX or posY ~= lastSolidPosY then
      for i = l_52_0.SOLID_POSITIONS_BUFFER_SIZE, 1, -1 do
        if l_52_0.lastSolidPositions[i - 1] then
          l_52_0.lastSolidPositions[i] = l_52_0.lastSolidPositions[i - 1]
        end
      end
      l_52_0.lastSolidPositions[1] = {posX, posY}
    end
  end
  Entity.tick(l_52_0)
end

Alice.move = function(l_53_0, l_53_1, l_53_2)
  local controller = l_53_0:get(ControllerComponent)
  local nx, ny = 0, 0
  if l_53_0:inputEnabled() then
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
  local animator = l_53_0:get(AnimatorComponent)
  local physics = l_53_0:get(PhysicsComponent)
  if nx ~= 0 or ny ~= 0 then
    local mag = math.sqrt((nx) * (nx) + (ny) * (ny))
    if mag < 0.5 then
      nx, ny = (nx) / mag * 0.5, (ny) / mag * 0.5
    end
    local dx, dy = nx * l_53_1, ny * l_53_1
    dy = dy * Direction.VEL_RATIO
    physics:setLinearVelocity(dx, dy)
    if l_53_2 then
      local oldDirection = animator:getDirection()
      animator:updateDirection(nx, ny)
      if oldDirection ~= animator:getDirection() then
        l_53_0:onFootstep()
      end
    end
    l_53_0.moveEvent:dispatch()
    return true
  else
    physics:setLinearVelocity(0, 0)
    return false
  end
end

Alice.createInteractSensor = function(l_54_0)
  if l_54_0.interactSensor then
    l_54_0.interactSensor.fixture:destroy()
    l_54_0.interactSensor = nil
  end
  l_54_0.interactEntities = EntitySet.new()
  local physics = l_54_0:get(PhysicsComponent)
  l_54_0.interactSensor = physics:addCircleSensor(l_54_0.INTERACT_SENSOR_SIZE, PhysicsComponent.ALL_CATEGORY)
  l_54_0.interactSensor.entityEnterEvent:register(l_54_0.onInteractEntityEnter, l_54_0)
  l_54_0.interactSensor.entityLeaveEvent:register(l_54_0.onInteractEntityLeave, l_54_0)
  l_54_0.interactSensor.fixture:setDebugColor(1, 1, 1, 0)
end

Alice.onInteractEntityEnter = function(l_55_0, l_55_1)
  local interact = l_55_1:get(InteractionComponent)
  if not interact then
    return 
  end
  l_55_0.interactEntities:addEntity(l_55_1)
  interact.sensorEvent:dispatch(l_55_0, true)
  interact.enabledEvent:register(l_55_0.onEntityInteractEnabled, l_55_0)
  l_55_0:updateInteract()
end

Alice.onInteractEntityLeave = function(l_56_0, l_56_1)
  local interact = l_56_1:get(InteractionComponent)
  if not interact then
    return 
  end
  l_56_0.interactEntities:removeEntity(l_56_1)
  interact.sensorEvent:dispatch(l_56_0, false)
  interact.enabledEvent:unregister(l_56_0.onEntityInteractEnabled, l_56_0)
  l_56_0:updateInteract()
end

Alice.onEntityInteractEnabled = function(l_57_0, l_57_1)
  l_57_0:updateInteract()
end

Alice.updateInteract = function(l_58_0)
  local interactEntity = nil
  if not l_58_0.action then
    interactEntity = l_58_0:getInteractEntity()
  end
  if l_58_0.interactInterface then
    local currentEntity = l_58_0.interactInterface.target.entity
  end
  if interactEntity == currentEntity then
    return 
  end
  local interface = l_58_0:get(InterfaceComponent)
  if l_58_0.interactInterface then
    interface:removeInterface(l_58_0.interactInterface)
    l_58_0.interactInterface = nil
  end
  if interactEntity then
    local InteractIconGui = Gui.load("Content/Game/Global/Gui/InteractIconGui")
    local offsetX, offsetY = interactEntity:get(InteractionComponent):getOffset()
    l_58_0.interactInterface = InteractIconGui.new(l_58_0, interactEntity, offsetX, offsetY)
    interface:pushInterface(l_58_0.interactInterface)
  end
end

Alice.getInteractEntity = function(l_59_0)
  local closestInteractEntity, closestInteractDistSq = nil, nil
  local x, y = l_59_0:getPosition()
  local dirX, dirY = l_59_0:get(AnimatorComponent):getDirVector()
  if l_59_0.interactSensor then
    for _,entity in pairs(l_59_0.interactEntities.entities) do
      local interact = entity:get(InteractionComponent)
      if interact and interact:canInteract(l_59_0) then
        local ex, ey = entity:getPosition()
        local offsetX, offsetY = interact:getOffset()
        local dx, dy = ex + offsetX - x, ey + offsetY - y
        local distSq = dx * dx + dy * dy
        local normX, normY = Math.normalize(dx, dy)
        local angle = math.deg(math.acos(normX * dirX + normY * dirY))
        if math.abs(angle) < l_59_0.INTERACT_SENSOR_ANGLE and (not closestInteractDistSq or distSq < closestInteractDistSq) and (not interact.requiresContact or l_59_0.contactEntities:hasEntity(entity)) then
          closestInteractEntity, closestInteractDistSq = entity, distSq
        end
      end
    end
  end
  return closestInteractEntity
end

Alice.setSolidPosition = function(l_60_0, l_60_1, l_60_2)
  l_60_0.lastSolidPositions = {{l_60_1, l_60_2}}
end

Alice.getSolidPosition = function(l_61_0)
  local solidX, solidY = 0, 0
  if #l_61_0.lastSolidPositions > 0 then
    solidX, solidY = unpack(l_61_0.lastSolidPositions[math.ceil(#l_61_0.lastSolidPositions / 2)])
  end
  return solidX, solidY
end

Alice.onEnterWater = function(l_62_0)
  local collidingWater = l_62_0:get(SwimmingComponent):getLastCollidedWater()
  if collidingWater then
    local solidPosX, solidPosY = l_62_0:getSolidPosition()
    local Water = Entity.cache:load("Content/Game/Global/Entities/Water")
    local Abyss = Entity.cache:load("Content/Game/Global/Entities/Abyss")
    if collidingWater:is(Water) and (not l_62_0.action or not l_62_0.action:is(RescuedAction)) then
      l_62_0:forceAction(RescuedAction.new(solidPosX, solidPosY))
      do return end
      if collidingWater:is(Abyss) and (not l_62_0.action or not l_62_0.action:is(AbyssAction)) then
        l_62_0:forceAction(AbyssAction.new(solidPosX, solidPosY, collidingWater))
      end
    end
  end
end

Alice.onLeaveWater = function(l_63_0)
end

Alice.isGhost = function(l_64_0)
  local physics = l_64_0:get(PhysicsComponent)
  return physics.category == PhysicsComponent.GHOST_CATEGORY and physics.collidesWithCategories == PhysicsComponent.GHOST_CATEGORY
end

Alice.toggleGhost = function(l_65_0)
  l_65_0:insertAction(GhostTransformAction.new())
end

Alice.startSleep = function(l_66_0, l_66_1, l_66_2, l_66_3)
  l_66_0:forceAction(SleepAction.new(l_66_1, l_66_2, l_66_3))
end

Alice.removeHoodAndStuffBed = function(l_67_0, l_67_1, l_67_2)
  l_67_0:forceAction(RemoveHoodAction.new(l_67_1))
  l_67_0:queueAction(StuffBedAction.new(l_67_2))
end

Alice.teleportInClassRoom = function(l_68_0, l_68_1)
  local fullPath = "Data/" .. l_68_1.entityPath .. ".lua"
  local body = loadfile(fullPath)
  local disassembly = Disassembly.new(body)
  return l_68_0:teleportInPrototype(l_68_1, disassembly.prototype)
end

Alice.teleportInPrototype = function(l_69_0, l_69_1, l_69_2, l_69_3)
  local action = PrototypeTeleport.new(l_69_1, l_69_2, l_69_3)
  l_69_0:forceAction(action)
  return action
end

Alice.exitPrototype = function(l_70_0, l_70_1)
  local action = PrototypeTeleport.new(l_70_1)
  l_70_0:forceAction(action)
  return action
end

Alice.isTeleporting = function(l_71_0)
  return l_71_0:isDoing(PrototypeTeleport)
end

Alice.isHackable = function(l_72_0, l_72_1)
  local currentDirection = l_72_0:get(AnimatorComponent):getDirection()
  return l_72_1 == currentDirection
end

Alice.scale = function(l_73_0, l_73_1)
  l_73_0.scaleFactor = l_73_0.scaleFactor * l_73_1
  local sprite = l_73_0:get(SpriteComponent)
  local animator = l_73_0:get(AnimatorComponent)
  local scale = l_73_0.prop:getScl()
  scale = l_73_1 * scale
  l_73_0.prop:setScl(scale)
  l_73_0.label.textBox:setScl(l_73_0.scaleFactor)
  local physics = l_73_0:get(PhysicsComponent)
  physics.fixture:destroy()
  physics.width, physics.height = l_73_1 * physics.width, l_73_1 * physics.height
  local halfWidth, halfHeight = physics.width * 0.5, physics.height * 0.5
  physics.x0, physics.y0, physics.x1, physics.y1 = -halfWidth, -halfHeight, halfWidth, halfHeight
  physics.fixture = physics:addRect(physics.x0, physics.y0, physics.x1, physics.y1)
  if physics.collisionHandlerData then
    physics:setCollisionHandler(physics.collisionHandlerData.mask, physics.collisionHandlerData.handler, physics.collisionHandlerData.firstArg, physics.collisionHandlerData.phaseMask)
  end
  l_73_0.INTERACT_SENSOR_SIZE = l_73_0.INTERACT_SENSOR_SIZE * l_73_1
  l_73_0:createInteractSensor()
end

Alice.toggleDebugGui = function(l_74_0)
  if not l_74_0.debugGui then
    local DebugGui = Gui.load("Content/Game/Global/Gui/DebugGui")
    l_74_0.debugGui = DebugGui.new()
  end
  if l_74_0.showingDebugGui then
    l_74_0:get(InterfaceComponent):removeInterface(l_74_0.debugGui)
    l_74_0.showingDebugGui = false
  else
    l_74_0:get(InterfaceComponent):pushInterface(l_74_0.debugGui)
    l_74_0.showingDebugGui = true
  end
end

Alice.teleport = function(l_75_0, l_75_1, l_75_2)
  local abyssAction = l_75_0:isDoing(AbyssAction)
  if abyssAction then
    abyssAction.setPosition = true
  end
  l_75_0:forceAction()
  l_75_0:setPosition(l_75_1, l_75_2)
  Trace(TT_Info, "Teleport to position %.2f, %.2f", l_75_1, l_75_2)
end

return Alice

