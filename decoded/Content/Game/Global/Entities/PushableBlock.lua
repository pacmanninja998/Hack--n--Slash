-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\PushableBlock.lua 

local Entity = require("Entity")
local Action = require("Action")
local Direction = require("Direction")
local Math = require("DFCommon.Math")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local PushedAction = require("Class").create(Action, "PushedAction")
PushedAction.WAIT_FRAMES = 1
PushedAction.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0.dir = l_1_1
  l_1_0.duration = math.max(MOAISim.getStep(), l_1_2 or 1)
  l_1_0.dist = l_1_3 or 1
  l_1_0.elapsed = 0
  l_1_0.waitedFrames = 0
  local dirX, dirY = Direction.dirToVector(l_1_0.dir)
  l_1_0.speed = 64 * l_1_0.dist / l_1_0.duration
  l_1_0.velX, l_1_0.velY = l_1_0.speed * dirX, l_1_0.speed * dirY
end

PushedAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.entity:createNav()
  l_2_0.cue = l_2_0.entity:get(SoundComponent):playCue("SFX/Hackable_Objects/SlidingStone_Loop", nil, 0.5)
end

PushedAction.tick = function(l_3_0)
  if l_3_0.waitedFrames <= PushedAction.WAIT_FRAMES then
    l_3_0.waitedFrames = l_3_0.waitedFrames + 1
    if PushedAction.WAIT_FRAMES < l_3_0.waitedFrames then
      if l_3_0.entity:updateNavOpen() then
        local physics = l_3_0.entity:get(PhysicsComponent)
        physics:setLinearVelocity(l_3_0.velX, l_3_0.velY)
      else
        return false
      end
    else
      return true
    end
  end
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  return l_3_0.elapsed < l_3_0.duration
end

PushedAction.stop = function(l_4_0)
  local physics = l_4_0.entity:get(PhysicsComponent)
  physics:setLinearVelocity(0, 0)
  if l_4_0.cue then
    l_4_0.entity:get(SoundComponent):stopCue(l_4_0.cue)
  end
  Action.stop(l_4_0)
end

local PushableBlock = require("Class").create(Entity, "PushableBlock")
PushableBlock.COLLIDE_MASK = PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.LOW_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY
PushableBlock.TIME_BEFORE_PUSH_STARTS = 3
PushableBlock.TILES_PER_PUSH = 1
PushableBlock.SECONDS_PER_PUSH = 0.5
PushableBlock.init = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  Entity.init(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  if HackStartAct == "EGW" then
    SpriteComponent.new(l_5_0, "Interactions/Props/Block_Dungeon/Block_Dungeon")
  else
    SpriteComponent.new(l_5_0, "Interactions/Props/Block/Block")
  end
  SoundComponent.new(l_5_0)
  PhysicsComponent.new(l_5_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.KINEMATIC)
  AnimatorComponent.new(l_5_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  local physics = l_5_0:get(PhysicsComponent)
  physics:setCollisionHandler(l_5_0.COLLIDE_MASK, l_5_0.onHitSolid, l_5_0, MOAIBox2DArbiter.POST_SOLVE)
  l_5_0.pushDir = nil
  l_5_0.pushTime = 0
  l_5_0.lastPush = 0
  l_5_0.lastContact = 0
  l_5_0.prop:setScl(0.25)
  l_5_0.physicsScale = 1
end

PushableBlock.canPush = function(l_6_0)
  return true
end

PushableBlock.onHitSolid = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5)
  if not l_7_0.action and l_7_1 and l_7_1:is(Alice) then
    local contactNormX, contactNormY = l_7_5:getContactNormal()
    local direction = Direction.vectorToDir(-contactNormX, -contactNormY)
    local curTime = MOAISim.getElapsedTime()
    local controller = l_7_1:get(ControllerComponent)
    local pushDir = direction
    if l_7_0.TILES_PER_PUSH < 0 then
      pushDir = Direction.rotate(direction, 4)
    end
    local isPushing = false
    if controller then
      if controller:hasMotive("Move" .. Direction.dirToName(direction)) then
        isPushing = true
      end
      local dirX, dirY = controller:getDirectionVector()
      if dirX ~= 0 or dirY ~= 0 then
        local vectorDir = Direction.vectorToDir(dirX, dirY, false)
        if vectorDir == direction then
          isPushing = true
        end
      end
    end
    if isPushing then
      if l_7_0.pushDir ~= pushDir then
        l_7_0.pushDir = pushDir
        l_7_0.pushTime = 0
        l_7_0.lastPush = MOAISim.getElapsedTime()
      else
        local elapsed = curTime - l_7_0.lastPush
        l_7_0.pushTime = l_7_0.pushTime + elapsed
      end
      l_7_0.lastContact = curTime
    end
  end
end

PushableBlock.createNav = function(l_8_0)
  if l_8_0.navBody then
    l_8_0.navBody:destroy()
    l_8_0.navShadow:destroy()
  end
  local dirX, dirY = Direction.dirToVector(l_8_0.pushDir)
  local x0, y0 = -30 * l_8_0.physicsScale + 64 * l_8_0.physicsScale * math.min(0, dirX), -30 * l_8_0.physicsScale + 64 * l_8_0.physicsScale * math.min(0, dirY)
  local x1, y1 = 30 * l_8_0.physicsScale + 64 * l_8_0.physicsScale * math.max(0, dirX), 30 * l_8_0.physicsScale + 64 * l_8_0.physicsScale * math.max(0, dirY)
  l_8_0.navBody = l_8_0.layer.world:addBody(MOAIBox2DBody.DYNAMIC)
  l_8_0.navBody:setTransform(l_8_0:getPosition())
  l_8_0.navSensor = PhysicsComponent.Sensor.new(PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.NAV_CATEGORY, PhysicsComponent.NAV_CATEGORY, true)
  local navFixture = l_8_0.navBody:addRect(x0, y0, x1, y1)
  l_8_0.navSensor:setFixture(navFixture)
  local posX, posY = l_8_0:getPosition()
  local centerX, centerY = posX + l_8_0.physicsScale * 64 * dirX, posY + l_8_0.physicsScale * 64 * dirY
  l_8_0.navShadow = Entity.create("Content/Game/Global/Entities/BlockShadow", l_8_0:room():getLayerByOrder(-1), centerX, centerY)
  l_8_0:updateNavOpen()
end

PushableBlock.updateNavOpen = function(l_9_0)
  if l_9_0.navSensor then
    local isOpen = true
    for fixture,count in pairs(l_9_0.navSensor.entities) do
      isOpen = false
      if fixture:getBody() then
        local entity = fixture:getBody().entity
        if entity and (entity == l_9_0 or entity:is(Alice)) then
          isOpen = true
        end
      end
      if not isOpen then
        do return end
      end
    end
    if isOpen then
      l_9_0.navShadow:setColor(0.074509803921569, 0.85098039215686, 0, 0.5)
    else
      l_9_0.navShadow:setColor(0.85098039215686, 0.074509803921569, 0, 0.5)
      return isOpen
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PushableBlock.tick = function(l_10_0)
  if not l_10_0.pushDir then
    l_10_0.pushTime = 0
  end
  if l_10_0:canPush() and l_10_0.pushTime > 0 then
    local physics = l_10_0:get(PhysicsComponent)
    if not l_10_0.navBody then
      l_10_0:createNav()
    else
      local isOpen = l_10_0:updateNavOpen()
      if l_10_0.TIME_BEFORE_PUSH_STARTS < l_10_0.pushTime then
        if isOpen then
          if l_10_0.onPushed then
            l_10_0:onPushed()
          end
          for i = 1, math.abs(l_10_0.TILES_PER_PUSH) do
            local pushedAction = PushedAction.new(l_10_0.pushDir, math.abs(l_10_0.SECONDS_PER_PUSH), 1 * l_10_0.physicsScale)
            l_10_0:queueAction(pushedAction)
          end
        end
        l_10_0.pushTime, l_10_0.lastPush = 0, 0
      end
    end
  end
  local curTime = MOAISim.getElapsedTime()
  if l_10_0.pushDir and curTime - l_10_0.lastContact > 0.05 and not l_10_0:isDoing(PushedAction) then
    l_10_0.pushTime, l_10_0.lastPush = 0, 0
    l_10_0.pushDir = nil
    if l_10_0.navBody then
      l_10_0.navShadow:destroy()
      l_10_0.navBody:destroy()
      l_10_0.navBody = nil
      l_10_0.navSensor = nil
    end
  end
  Entity.tick(l_10_0)
end

return PushableBlock

