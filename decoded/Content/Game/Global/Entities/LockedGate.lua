-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\LockedGate.lua 

local Entity = require("Entity")
local Action = require("Action")
local Direction = require("Direction")
local SpriteSheet = require("SpriteSheet")
local Delegate = require("DFMoai.Delegate")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local OpenAction = require("Class").create(Action, "OpenAction")
OpenAction.ANIMATION = "Opening"
OpenAction.FAIL_ANIMATION = "TryOpen"
OpenAction.FRAMES_PER_SECOND = 15
OpenAction.FAIL_FRAMES_PER_SECOND = 15
OpenAction.END_ANIM = "Open"
OpenAction.END_FAIL_ANIM = "Closed"
OpenAction.init = function(l_1_0, l_1_1, l_1_2)
  Action.init(l_1_0)
  l_1_0.interactor = l_1_1
  l_1_0.noAnimation = l_1_2
end

OpenAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  if not l_2_0.noAnimation then
    if l_2_0.entity:locked() then
      l_2_0.entity:get(SoundComponent):playCue(l_2_0.entity.rattleSound, nil, 0.5)
      l_2_0.sequence = l_2_0.entity:get(AnimatorComponent):playOnce(l_2_0.FAIL_ANIMATION, l_2_0.FAIL_FRAMES_PER_SECOND)
    else
      l_2_0.entity:get(SoundComponent):playCue(l_2_0.entity.openSound, nil, 0.5)
      l_2_0.sequence = l_2_0.entity:get(AnimatorComponent):playOnce(l_2_0.ANIMATION, l_2_0.FRAMES_PER_SECOND)
    end
  end
end

OpenAction.tick = function(l_3_0)
  if l_3_0.entity:get(AnimatorComponent):isPlaying(l_3_0.sequence) then
    return true
  else
    local animator = l_3_0.entity:get(AnimatorComponent)
    local physics = l_3_0.entity:get(PhysicsComponent)
    if not l_3_0.entity:locked() then
      physics.fixture:destroy()
      local direction = animator:getDirection()
      local minX, minY, maxX, maxY = unpack(l_3_0.entity.openRect)
      if minX and minY and maxX and maxY then
        if direction == Direction.DIR_W then
          physics.fixture = physics.body:addRect(minX, minY, maxX, maxY)
        else
          if direction == Direction.DIR_E then
            physics.fixture = physics.body:addRect(-maxX, minY, -minX, maxY)
          end
        end
        physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
      end
      l_3_0.entity.open = true
      l_3_0.entity.gateEvent:dispatch(l_3_0.entity, true)
      animator:play(l_3_0.END_ANIM)
    else
      animator:play(l_3_0.END_FAIL_ANIM)
    end
    if l_3_0.interactor then
      l_3_0.entity:get(InteractionComponent):stopInteract(l_3_0.interactor)
      if l_3_0.interactor.halt then
        l_3_0.interactor:halt(false)
      end
    end
    return false
  end
end

local CloseAction = require("Class").create(Action, "CloseAction")
CloseAction.ANIMATION = "Closing"
CloseAction.FRAMES_PER_SECOND = 15
CloseAction.END_ANIM = "Closed"
CloseAction.init = function(l_4_0, l_4_1, l_4_2)
  Action.init(l_4_0)
  l_4_0.interactor = l_4_1
  l_4_0.noAnimation = l_4_2
end

CloseAction.start = function(l_5_0, l_5_1)
  Action.start(l_5_0, l_5_1)
  if not l_5_0.noAnimation then
    l_5_0.entity:get(SoundComponent):playCue(l_5_0.entity.closeSound, nil, 0.5)
    l_5_0.sequence = l_5_0.entity:get(AnimatorComponent):playOnce(l_5_0.ANIMATION, l_5_0.FRAMES_PER_SECOND)
  end
end

CloseAction.tick = function(l_6_0)
  if l_6_0.entity:get(AnimatorComponent):isPlaying(l_6_0.sequence) then
    return true
  else
    local animator = l_6_0.entity:get(AnimatorComponent)
    local physics = l_6_0.entity:get(PhysicsComponent)
    physics.fixture:destroy()
    local minX, minY, maxX, maxY = unpack(l_6_0.entity.closedRect)
    if minX and minY and maxX and maxY then
      local direction = l_6_0.entity:get(AnimatorComponent):getDirection()
      if direction == Direction.DIR_W then
        physics.fixture = physics.body:addRect(minX, minY, maxX, maxY)
      else
        if direction == Direction.DIR_E then
          physics.fixture = physics.body:addRect(-maxX, minY, -minX, maxY)
        end
      end
      physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
    end
    animator:play(l_6_0.END_ANIM)
    if l_6_0.interactor then
      l_6_0.entity:get(InteractionComponent):stopInteract(l_6_0.interactor)
      if l_6_0.interactor.halt then
        l_6_0.interactor:halt(false)
      end
    end
    l_6_0.entity.open = false
    l_6_0.entity.gateEvent:dispatch(l_6_0.entity, false)
    return false
  end
end

local LockedGate = require("Class").create(Entity, "LockedGate")
LockedGate.init = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5, l_7_6, l_7_7, l_7_8, l_7_9)
  Entity.init(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  SpriteComponent.new(l_7_0, "Interactions/Props/Placeholder/JailGate/JailGate")
  if l_7_5 == Direction.DIR_N or l_7_5 == Direction.DIR_S then
    l_7_5 = Direction.DIR_E
  end
  AnimatorComponent.new(l_7_0, false, l_7_5, Direction.DIR_W)
  PhysicsComponent.new(l_7_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SoundComponent.new(l_7_0, nil, 0)
  InteractionComponent.new(l_7_0)
  l_7_0.hackOffsetY = 128
  if not l_7_8 then
    l_7_0.closedRect = {-96, 0, 96, 16}
  end
  if not l_7_9 then
    l_7_0.openRect = {-96, 0, 0, 16}
  end
  local physics = l_7_0:get(PhysicsComponent)
  local minX, minY, maxX, maxY = unpack(l_7_0.closedRect)
  if l_7_5 == Direction.DIR_W then
    physics.fixture = physics.body:addRect(minX, minY, maxX, maxY)
    l_7_0.hackFixture = physics.body:addRect(0, 0, 96, 96)
  else
    physics.fixture = physics.body:addRect(-maxX, minY, -minX, maxY)
    l_7_0.hackFixture = physics.body:addRect(-96, 0, 0, 96)
  end
  l_7_0.hackFixture:setFilter(PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.SENSOR_CATEGORY, nil)
  l_7_0.hackFixture:setSensor(true)
  l_7_0.LOCKED = true
  l_7_0.open = false
  l_7_0:get(AnimatorComponent):play(CloseAction.END_ANIM)
  l_7_0:get(InteractionComponent).interactEvent:register(l_7_0.onInteract, l_7_0)
  if not l_7_7 then
    l_7_0.lightSheet = SpriteSheet.load("Interactions/Props/Placeholder/GateLight/GateLight")
    l_7_0.lightXPos = l_7_5 == Direction.DIR_W and 48 or -48
    l_7_0.lockedLightProp = MOAIProp.new()
    l_7_0.lockedLightProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
    local deck, index = l_7_0.lightSheet:getDeck("GateLight", 1, false)
    l_7_0.lockedLightProp:setDeck(deck)
    l_7_0.lockedLightProp:setIndex(index)
    l_7_0:attachProp(l_7_0.lockedLightProp)
    l_7_0.lockedLightProp:setLoc(l_7_0.lightXPos, 16)
    l_7_0.lockedLightProp:setPriority(48)
    l_7_0.lockedLightProp:setColor(1, 0, 0)
  end
  l_7_0.storeState = not l_7_6
  l_7_0.gateEvent = Delegate.new()
  if l_7_0.storeState then
    local stateOpen = l_7_0.layer.room:getState()[l_7_0.name .. " open"]
    if stateOpen then
      l_7_0:setLocked(false)
      l_7_0:setOpen(stateOpen, nil, true)
    end
    l_7_0.gateEvent:register(l_7_0.storeRoomState, l_7_0)
  end
  l_7_0.rattleSound = "SFX/Hackable_Objects/CaveGate_Rattle"
  l_7_0.openSound = "SFX/Hackable_Objects/CaveGate_Open"
  l_7_0.closeSound = "SFX/Hackable_Objects/CaveGate_Open"
end

LockedGate.onInteract = function(l_8_0, l_8_1)
  if not l_8_0.action then
    l_8_0:setOpen(not l_8_0.open, l_8_1)
  end
end

LockedGate.storeRoomState = function(l_9_0, l_9_1, l_9_2)
  l_9_1.layer.room:getState()[l_9_1.name .. " open"] = l_9_2
end

LockedGate.updateLightColors = function(l_10_0)
  if l_10_0.lockedLightProp then
    if l_10_0:locked() then
      l_10_0.lockedLightProp:setColor(1, 0, 0)
    else
      l_10_0.lockedLightProp:setColor(0, 1, 0)
    end
  end
end

LockedGate.setOpen = function(l_11_0, l_11_1, l_11_2, l_11_3)
  if l_11_1 ~= l_11_0.open then
    if l_11_1 then
      l_11_0:forceAction(OpenAction.new(l_11_2, l_11_3))
    else
      l_11_0:forceAction(CloseAction.new(l_11_2, l_11_3))
    end
  end
  if l_11_2 and l_11_2.halt then
    l_11_2:halt(true)
  end
end

LockedGate.setLocked = function(l_12_0, l_12_1)
  l_12_0.LOCKED = l_12_1
end

LockedGate.locked = function(l_13_0)
  return l_13_0.LOCKED
end

LockedGate.isHackable = function(l_14_0)
  return true
end

return LockedGate

