-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\RedSprite.lua 

local Action = require("Action")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local EntitySet = require("EntitySet")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
local Direction = require("Direction")
local Flocking = require("Flocking")
local Stump = Entity.cache:load("Content/Game/DorkForest/Entities/Stump")
local Math = require("DFCommon.Math")
local Delegate = require("DFMoai.Delegate")
local CommonActions = require("CommonActions")
local BeHackedAction = Action.load("Content/Game/Global/Actions/BeHackedAction")
local SingAction = require("Class").create(Action, "SingAction")
SingAction.STOP_DISTANCE_SQ = 1
SingAction.SLOW_DISTANCE = 32
SingAction.APPROACH_SPEED = 800
SingAction.SING_FRAMES_PER_SECOND = 4
SingAction.HERO_STOP_DISTANCE = 300
SingAction.init = function(l_1_0, l_1_1)
  l_1_0.stump = l_1_1
end

SingAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.singing = false
  l_2_0.singingElapsed = 0
  l_2_0.dispatchedSingingEvent = false
end

SingAction.tick = function(l_3_0)
  Action.tick(l_3_0)
  local stumpPosX, stumpPosY = l_3_0.stump:getPosition()
  stumpPosY = stumpPosY + 16
  local posX, posY = l_3_0.entity:getPosition()
  local distSq = Math.distance2DSquared(posX, posY, stumpPosX, stumpPosY)
  if l_3_0.STOP_DISTANCE_SQ < distSq then
    local deltaX, deltaY = stumpPosX - posX, stumpPosY - posY
    local normX, normY = Math.normalize(deltaX, deltaY)
    local velX, velY = normX * l_3_0.APPROACH_SPEED, normY * l_3_0.APPROACH_SPEED
    local dist = math.sqrt(distSq)
    if dist < l_3_0.SLOW_DISTANCE then
      velX, velY = velX * dist / l_3_0.SLOW_DISTANCE, velY * dist / l_3_0.SLOW_DISTANCE
    end
    l_3_0.entity:get(PhysicsComponent):setLinearVelocity(velX, velY)
  elseif not l_3_0.singing then
    local attachedEntity = l_3_0.stump:getAttachedEntity()
    if attachedEntity then
      l_3_0.entity.stumpOccupiedEvent:dispatch(l_3_0.stump)
      l_3_0.entity.investigatedStumps:addEntity(l_3_0.stump)
      return false
    else
      l_3_0.stump:attachEntity(l_3_0.entity)
      l_3_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
      l_3_0.entity:get(AnimatorComponent):play("Sing", l_3_0.SING_FRAMES_PER_SECOND)
      l_3_0.cue = l_3_0.entity:get(SoundComponent):playCue("SFX/Characters/Bob/Bob_Song", true, l_3_0.entity.SINGING_VOLUME / 10, nil, true)
      l_3_0.singing = true
      l_3_0.effect = Entity.create("Content/Game/Global/Entities/Effects/Sing_VFX", l_3_0.entity.layer, l_3_0.entity:getPosition())
    end
  end
  if l_3_0.entity.bondedEntity:isValid() then
    local heroPosX, heroPosY = l_3_0.entity.bondedEntity.entity:getPosition()
    local heroDistSq = Math.distance2DSquared(posX, posY, heroPosX, heroPosY)
    if 1.2 * l_3_0.HERO_STOP_DISTANCE ^ 2 < heroDistSq then
      return false
    end
  end
  if l_3_0.singing then
    l_3_0.singingElapsed = l_3_0.singingElapsed + MOAISim.getStep()
    if l_3_0.entity.singingEventTime < l_3_0.singingElapsed and not l_3_0.dispatchedSingingEvent then
      l_3_0.entity.singingEvent:dispatch()
      l_3_0.dispatchedSingingEvent = true
    end
  end
  return true
end

SingAction.stop = function(l_4_0)
  Action.stop(l_4_0)
  if l_4_0.singing and l_4_0.stump and l_4_0.stump:getAttachedEntity() == l_4_0.entity then
    l_4_0.stump:attachEntity(nil)
  end
  if l_4_0.cue then
    l_4_0.entity:get(SoundComponent):stopCue(l_4_0.cue)
  end
  if l_4_0.effect then
    l_4_0.effect:destroy()
  end
end

local PonderAction = require("Class").create(Action, "PonderAction")
PonderAction.start = function(l_5_0, l_5_1)
  Action.start(l_5_0, l_5_1)
  l_5_0.entity:get(InteractionComponent):setEnabled(true)
  l_5_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
end

PonderAction.stop = function(l_6_0, l_6_1)
  l_6_0.entity:get(InteractionComponent):setEnabled(false)
end

PonderAction.tick = function(l_7_0)
  Action.tick(l_7_0)
  return true
end

local BeExcitedAction = require("Class").create(Action, "BeExcitedAction")
BeExcitedAction.RADIUS = 50
BeExcitedAction.REVOLUTIONS = 2
BeExcitedAction.REVOLUTION_SECONDS = 2
BeExcitedAction.MAX_SPEED = 2000
BeExcitedAction.init = function(l_8_0, l_8_1, l_8_2)
  Action.init(l_8_0)
  l_8_0.direction = l_8_2
  if not l_8_0.direction then
    local randomValue = math.random()
    if randomValue < 0.5 then
      l_8_0.direction = -1
    else
      l_8_0.direction = 1
    end
  end
  l_8_0.targetEntityRef = EntityRef.new(l_8_1)
end

BeExcitedAction.start = function(l_9_0, l_9_1)
  Action.start(l_9_0, l_9_1)
  l_9_0.elapsed = 0
  l_9_0.centerX, l_9_0.centerY = l_9_0.entity:getPosition(), l_9_0.entity
  l_9_0.entity:get(AnimatorComponent):play("Fly")
end

BeExcitedAction.stop = function(l_10_0)
end

BeExcitedAction.tick = function(l_11_0)
  Action.tick(l_11_0)
  if l_11_0.targetEntityRef and l_11_0.targetEntityRef.entity then
    l_11_0.centerX, l_11_0.centerY = l_11_0.targetEntityRef.entity:getPosition(), l_11_0.targetEntityRef.entity
  end
  local step = MOAISim.getStep()
  l_11_0.elapsed = l_11_0.elapsed + step
  local theta = l_11_0.direction * l_11_0.elapsed * 2 * math.pi / l_11_0.REVOLUTION_SECONDS
  local targetX, targetY = l_11_0.centerX + math.sin(theta * 0.5) * l_11_0.RADIUS, l_11_0.centerY + math.sin(theta) * l_11_0.RADIUS * 0.5
  local x, y = l_11_0.entity.prop:modelToWorld()
  local vx, vy = (targetX - x) / step, (targetY - y) / step
  local distSq = vx * vx + vy * vy
  local maxSpeed = l_11_0.MAX_SPEED
  if maxSpeed * maxSpeed < distSq then
    local scalar = maxSpeed / math.sqrt(distSq)
    vx, vy = vx * scalar, vy * scalar
  end
  local physics = l_11_0.entity:get(PhysicsComponent)
  physics:setLinearVelocity(vx, vy)
  if math.abs(theta) < l_11_0.REVOLUTIONS * 4 * math.pi then
    return true
  end
  if l_11_0.entity.excitingEntity:isValid() then
    l_11_0.entity:queueAction(l_11_0)
  end
  return false
end

local FollowBonded = require("Class").create(Flocking.FollowAction, "FollowBonded")
FollowBonded.CIRCLE_SPEED_THRESH = 32
FollowBonded.TURN_WAIT = 0.5
FollowBonded.IDLE_WAIT_MIN = 2
FollowBonded.IDLE_WAIT_MAX = 8
FollowBonded.IDLE_PROBABILITIES = {{p = 0.3, name = "DartLeft_Idle"}, {p = 0.6, name = "DartRight_Idle"}, {p = 0.85, name = "LookAround"}, {p = 0.95, name = "Spin_Idle"}}
FollowBonded.start = function(l_12_0, l_12_1)
  Flocking.FollowAction.start(l_12_0, l_12_1)
  l_12_0.circling = true
  l_12_0.turning = false
  l_12_0.timeSinceIdle = 0
  l_12_0.entity:get(AnimatorComponent):play("Fly")
end

FollowBonded.updateDirection = function(l_13_0, l_13_1)
  local animator = l_13_0.entity:get(AnimatorComponent)
  local curDir = animator:getDirection()
  if curDir ~= l_13_1 then
    if not l_13_0.turning then
      local animName = nil
      if curDir == Direction.DIR_S and l_13_1 == Direction.DIR_W then
        animName = "Turn_Fnt_to_LftSide"
      else
        if curDir == Direction.DIR_W and l_13_1 == Direction.DIR_N then
          animName = "Turn_LftSide_To_Bk"
        else
          if curDir == Direction.DIR_N and l_13_1 == Direction.DIR_E then
            animName = "Turn_Bk_To_RtSide"
          else
            if curDir == Direction.DIR_E and l_13_1 == Direction.DIR_S then
              animName = "Turn_RtSide_to_Fnt"
            else
              if curDir == Direction.DIR_S and l_13_1 == Direction.DIR_E then
                animName = "Turn_Fnt_to_RtSide"
              else
                if curDir == Direction.DIR_E and l_13_1 == Direction.DIR_N then
                  animName = "Turn_RtSide_To_Bk"
                else
                  if curDir == Direction.DIR_N and l_13_1 == Direction.DIR_W then
                    animName = "Turn_Bk_To_LftSide"
                  else
                    if curDir == Direction.DIR_W and l_13_1 == Direction.DIR_S then
                      animName = "Turn_LftSide_to_Fnt"
                    else
                      if curDir == Direction.DIR_N and l_13_1 == Direction.DIR_S then
                        animName = "Turn_Bk_to_Fnt"
                      else
                        if curDir == Direction.DIR_S and l_13_1 == Direction.DIR_N then
                          animName = "Turn_Fnt_to_Bk"
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      if animName then
        l_13_0.turnSequence = animator:playOnce(animName)
        l_13_0.turning = true
      else
        if not animator:isPlaying(l_13_0.turnSequence) then
          l_13_0.turnSequence = nil
          l_13_0.turning = false
          local dirX, dirY = Direction.dirToVector(l_13_1)
          animator:updateDirection(dirX, dirY)
          animator:play("Fly")
        else
          animator:play("Fly")
        end
      end
    end
  end
end

FollowBonded.tick = function(l_14_0)
  if l_14_0.targetEntityRef:isValid() then
    local target = l_14_0.targetEntityRef.entity
    local targetPhysics = target:get(PhysicsComponent)
    local targetVelX, targetVelY = targetPhysics:getLinearVelocity()
    local targetVel = Math.length(targetVelX, targetVelY)
    local shouldCircle = l_14_0.CIRCLE_SPEED_THRESH < targetVel
    local animator = l_14_0.entity:get(AnimatorComponent)
    local curDirection = animator:getDirection()
    local targetDirection = target:get(AnimatorComponent):getDirection()
    if shouldCircle ~= l_14_0.circling then
      l_14_0.circling = shouldCircle
      if l_14_0.circling then
        l_14_0.period = l_14_0.initPeriod
      else
        l_14_0.period = 0
      end
    end
    if l_14_0.circling then
      l_14_0.timeSinceIdle = 0
      if l_14_0.dx and l_14_0.dy then
        local normX, normY = Math.normalize(l_14_0.dx, l_14_0.dy)
        local dirToTarget = Direction.vectorToDir(normX, normY)
        l_14_0:updateDirection(dirToTarget)
      elseif not l_14_0.idleWait then
        l_14_0.idleWait = FollowBonded.IDLE_WAIT_MIN + math.random() * (FollowBonded.IDLE_WAIT_MAX - FollowBonded.IDLE_WAIT_MIN)
      end
      l_14_0.timeSinceIdle = l_14_0.timeSinceIdle + MOAISim.getStep()
      if FollowBonded.TURN_WAIT < l_14_0.timeSinceIdle then
        l_14_0:updateDirection(targetDirection)
      end
      if l_14_0.idleWait < l_14_0.timeSinceIdle and curDirection == targetDirection and not l_14_0.turning then
        local rand = (math.random())
        local animName = nil
        for i,data in ipairs(FollowBonded.IDLE_PROBABILITIES) do
          if rand < data.p then
            animName = data.name
        else
          end
        end
        if animName and animator:hasAnimation(animName) then
          l_14_0.entity:queueAction(CommonActions.PlayAnimation.new(animName))
          return false
        end
        l_14_0.timeSinceIdle = 0
      end
    end
  end
  return Flocking.FollowAction.tick(l_14_0)
end

local RedSprite = require("Class").create(Entity, "RedSprite")
RedSprite.SINGING_VOLUME = 5
RedSprite.PERCEPTION_RADIUS = 300
RedSprite.TEXT_COLOR = {0.96862745098039, 0.31372549019608, 0.3843137254902}
RedSprite.init = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4)
  Entity.init(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4)
  local sheetPath = "Characters/RedSprite/RedSprite"
  if l_15_4 == "Eve" then
    sheetPath = "Characters/Eve/Eve"
  end
  SpriteComponent.new(l_15_0, sheetPath)
  AnimatorComponent.new(l_15_0, AnimatorComponent.DIRECTION_MODE_FRONT_BACK_SIDE, nil, Direction.DIR_E)
  PhysicsComponent.new(l_15_0, 8, 8, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.SENSOR_CATEGORY)
  InteractionComponent.new(l_15_0)
  SoundComponent.new(l_15_0)
  l_15_0.prop:setScl(0.65)
  l_15_0:get(PhysicsComponent):setReceivesPlatformVel(false)
  l_15_0:get(SpriteComponent).prop:setPriority(32)
  l_15_0:get(AnimatorComponent):play("Fly")
  l_15_0:get(InteractionComponent):setEnabled(false)
  l_15_0:createSensor()
  l_15_0.bondedEntity = EntityRef.new()
  l_15_0.excitingEntity = EntityRef.new()
  l_15_0.nearbyStumps = EntitySet.new()
  l_15_0.stumpOccupiedEvent = Delegate.new()
  l_15_0.investigatedStumps = EntitySet.new()
  l_15_0.singingEvent = Delegate.new()
  l_15_0.singingEventTime = 0
  l_15_0.scaleFactor = 1
  l_15_0:room():markShadowedEntity(l_15_0)
end

RedSprite.tick = function(l_16_0)
  if l_16_0.nearbyStumps.count > 0 then
    local refPosX, refPosY = l_16_0:getPosition()
    if l_16_0.bondedEntity:isValid() then
      refPosX, refPosY = l_16_0.bondedEntity.entity:getPosition()
    end
    local nearDistSq, nearStump = nil, nil
    for _,stump in pairs(l_16_0.nearbyStumps.entities) do
      local stumpPosX, stumpPosY = stump:getPosition()
      local stumpDistSq = Math.distance2DSquared(refPosX, refPosY, stumpPosX, stumpPosY)
      if not nearDistSq or stumpDistSq < nearDistSq then
        nearStump = stump
        nearDistSq = stumpDistSq
      end
    end
    if nearStump and nearDistSq < SingAction.HERO_STOP_DISTANCE ^ 2 and not l_16_0.investigatedStumps:hasEntity(nearStump) and (l_16_0.action and ((not l_16_0.action:is(SingAction) and not l_16_0.action:is(BeHackedAction)) or l_16_0.action:is(SingAction) and l_16_0.action.stump ~= nearStump)) then
      l_16_0:forceAction(SingAction.new(nearStump))
    end
  end
  local followAction = l_16_0:isDoing(FollowBonded)
  if followAction and followAction.targetEntityRef:isValid() and followAction.targetEntityRef.entity:is(Alice) then
    followAction.offsetX, followAction.offsetY = 0, 32 * l_16_0.scaleFactor
  end
  if not l_16_0.action then
    if l_16_0.bondedEntity:isValid() then
      l_16_0:bond(l_16_0.bondedEntity.entity)
    else
      l_16_0:forceAction(Flocking.OrbitAction.new())
    end
  end
  Entity.tick(l_16_0)
end

RedSprite.createSensor = function(l_17_0)
  if l_17_0.sensor then
    l_17_0.sensor.fixture:destroy()
    l_17_0.sensor = nil
  end
  l_17_0.sensor = l_17_0:get(PhysicsComponent):addCircleSensor(l_17_0.PERCEPTION_RADIUS, PhysicsComponent.DYNAMIC_CATEGORY)
  l_17_0.sensor.entityEnterEvent:register(l_17_0.onEntityEnterPerception, l_17_0)
  l_17_0.sensor.entityLeaveEvent:register(l_17_0.onEntityLeavePerception, l_17_0)
  l_17_0.sensor.fixture:setDebugColor(1, 1, 1, 0)
end

RedSprite.bond = function(l_18_0, l_18_1)
  l_18_0.bondedEntity:setEntity(l_18_1)
  l_18_0:forceAction(FollowBonded.new(nil, nil, l_18_1, nil, nil, 5, nil, 400))
  l_18_0:get(InteractionComponent):setEnabled(false)
end

RedSprite.ponder = function(l_19_0, l_19_1)
  if l_19_1 then
    l_19_0:forceAction(PonderAction.new())
  else
    l_19_0:forceAction()
  end
end

RedSprite.watchForClass = function(l_20_0, l_20_1, l_20_2, l_20_3)
  local handlerFilter = function(l_1_0)
    if l_1_0:is(class) then
      handler(firstArg, l_1_0)
    end
   end
  l_20_0.sensor.entityEnterEvent:register(handlerFilter, nil)
end

RedSprite.watchForEntity = function(l_21_0, l_21_1, l_21_2, l_21_3)
  local handlerFilter = function(l_1_0)
    if l_1_0 == entity then
      handler(firstArg)
    end
   end
  l_21_0.sensor.entityEnterEvent:register(handlerFilter, nil)
end

RedSprite.onEntityEnterPerception = function(l_22_0, l_22_1)
  if l_22_1:is(Stump) then
    l_22_0.nearbyStumps:addEntity(l_22_1)
  end
end

RedSprite.beExcited = function(l_23_0, l_23_1)
  if l_23_1 then
    l_23_0.excitingEntity = EntityRef.new(l_23_1)
    l_23_0:forceAction(BeExcitedAction.new(l_23_1))
  else
    l_23_0:forceAction()
  end
end

RedSprite.onEntityLeavePerception = function(l_24_0, l_24_1)
  if l_24_1:is(Stump) then
    l_24_0.nearbyStumps:removeEntity(l_24_1)
  end
  if l_24_0.excitingEntity:equals(l_24_1) then
    l_24_0.excitingEntity:setEntity()
  end
end

RedSprite.isHackable = function(l_25_0)
  if l_25_0.action and l_25_0.action:is(SingAction) then
    return l_25_0.action.singing
  end
end

RedSprite.onFieldSet = function(l_26_0, l_26_1, l_26_2)
  if l_26_1 == "SINGING_VOLUME" then
    local singAction = l_26_0:isDoing(SingAction)
    if singAction and singAction.cue then
      l_26_0:get(SoundComponent):setVolume(singAction.cue, l_26_0.SINGING_VOLUME / 10)
    end
  end
end

RedSprite.scale = function(l_27_0, l_27_1)
  l_27_0.scaleFactor = l_27_0.scaleFactor * l_27_1
  local scale = l_27_0.prop:getScl()
  scale = l_27_1 * scale
  l_27_0.prop:setScl(scale)
  l_27_0.label.textBox:setScl(l_27_0.scaleFactor)
  local physics = l_27_0:get(PhysicsComponent)
  physics.fixture:destroy()
  physics.width, physics.height = l_27_1 * physics.width, l_27_1 * physics.height
  local halfWidth, halfHeight = physics.width * 0.5, physics.height * 0.5
  physics.x0, physics.y0, physics.x1, physics.y1 = -halfWidth, -halfHeight, halfWidth, halfHeight
  physics.fixture = physics:addRect(physics.x0, physics.y0, physics.x1, physics.y1)
  if physics.collisionHandlerData then
    physics:setCollisionHandler(physics.collisionHandlerData.mask, physics.collisionHandlerData.handler, physics.collisionHandlerData.firstArg, physics.collisionHandlerData.phaseMask)
  end
  local followAction = l_27_0:isDoing(FollowBonded)
  if followAction and followAction.targetEntityRef:isValid() then
    followAction.radius = followAction.radius * l_27_1
    followAction.maxSpeed = followAction.maxSpeed * l_27_1
  end
  l_27_0.PERCEPTION_RADIUS = l_27_0.PERCEPTION_RADIUS * l_27_1
  l_27_0:createSensor()
end

return RedSprite

