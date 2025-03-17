-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\WardenMace.lua 

local Class = require("Class")
local Action = require("Action")
local Entity = require("Entity")
local WardenMace = Class.create(Entity, "WardenMace")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
local EntityRef = require("EntityRef")
local SpriteSheet = require("SpriteSheet")
local Math = require("DFCommon.Math")
WardenMace.ChaseAction = Class.create(Action, "WardenMace.ChaseAction")
WardenMace.ChaseAction.DEFAULT_DURATION = 3
WardenMace.ChaseAction.VEL_TRACKING = 0.3
WardenMace.ChaseAction.init = function(l_1_0, l_1_1)
  if not l_1_1 then
    l_1_0.duration = l_1_0.DEFAULT_DURATION
  end
  l_1_0.elapsed = 0
end

WardenMace.ChaseAction.tick = function(l_2_0)
  Action.tick(l_2_0)
  l_2_0.elapsed = l_2_0.elapsed + MOAISim.getStep()
  if l_2_0.elapsed < l_2_0.duration and l_2_0.entity.targetRef:isValid() then
    local physics = l_2_0.entity:get(PhysicsComponent)
    local targetX, targetY = l_2_0.entity.targetRef.entity:getPosition()
    local ballX, ballY = l_2_0.entity:getPosition()
    local dirX, dirY = Math.normalize(targetX - ballX, targetY - ballY)
    local scaledVel = Math.lerp(l_2_0.entity.initVel, 0, l_2_0.elapsed / l_2_0.duration)
    local targetVelX, targetVelY = scaledVel * dirX, scaledVel * dirY
    local curVelX, curVelY = physics:getLinearVelocity()
    physics:setLinearVelocity(Math.lerp(curVelX, targetVelX, l_2_0.VEL_TRACKING), Math.lerp(curVelY, targetVelY, l_2_0.VEL_TRACKING))
    return true
  else
    l_2_0.entity:queueAction(WardenMace.ReturnAction.new())
  end
end

WardenMace.ReturnAction = Class.create(Action, "WardenMace.ChaseAction")
WardenMace.ReturnAction.DEFAULT_SPEED = 700
WardenMace.ReturnAction.STOP_DIST = 16
WardenMace.ReturnAction.VEL_TRACKING = 0.5
WardenMace.ReturnAction.init = function(l_3_0, l_3_1)
  Action.init(l_3_0)
  if not l_3_1 then
    l_3_0.speed = l_3_0.DEFAULT_SPEED
  end
end

WardenMace.ReturnAction.start = function(l_4_0, l_4_1)
  Action.start(l_4_0, l_4_1)
  l_4_0.entity:get(PhysicsComponent).fixture:setSensor(true)
end

WardenMace.ReturnAction.tick = function(l_5_0)
  Action.tick(l_5_0)
  local physics = l_5_0.entity:get(PhysicsComponent)
  local targetX, targetY = l_5_0.entity:getThrowingPos()
  local ballX, ballY = l_5_0.entity:getPosition()
  local diffX, diffY = targetX - ballX, targetY - ballY
  local distance = Math.length(diffX, diffY)
  if l_5_0.STOP_DIST < distance then
    local dirX, dirY = diffX / distance, diffY / distance
    local targetVelX, targetVelY = l_5_0.speed * dirX, l_5_0.speed * dirY
    local curVelX, curVelY = physics:getLinearVelocity()
    physics:setLinearVelocity(Math.lerp(curVelX, targetVelX, l_5_0.VEL_TRACKING), Math.lerp(curVelY, targetVelY, l_5_0.VEL_TRACKING))
    return true
  end
end

WardenMace.ReturnAction.stop = function(l_6_0)
  l_6_0.entity:destroy()
  Action.stop(l_6_0)
end

WardenMace.HIT_SPEED = 200
WardenMace.SPEED_THRESH = 10
WardenMace.SPEED_FRAME_THRESH = 4
WardenMace.init = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5, l_7_6, l_7_7, l_7_8, l_7_9, l_7_10, l_7_11, l_7_12)
  Entity.init(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  l_7_0:setLabelText("")
  SpriteComponent.new(l_7_0, "Characters/Warden/Warden", "Mace_Ball")
  PhysicsComponent.new(l_7_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY, MOAIBox2DBody.DYNAMIC, true)
  l_7_0:get(SpriteComponent).prop:setPriority(160)
  local physics = l_7_0:get(PhysicsComponent)
  physics.fixture = physics.body:addCircle(0, 0, 38)
  physics.fixture:setSensor(physics.isSensor)
  physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
  physics:setReceivesPlatformVel(false)
  l_7_0.initVelX, l_7_0.initVelY = l_7_6 or 0, l_7_7 or -64
  l_7_0.initVel = Math.length(l_7_0.initVelX, l_7_0.initVelY)
  physics:setLinearVelocity(l_7_0.initVelX, l_7_0.initVelY)
  physics:setCollisionHandler(PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY, l_7_0.onHit, l_7_0, MOAIBox2DArbiter.BEGIN)
  l_7_0.throwerRef = EntityRef.new(l_7_5)
  l_7_0.targetRef = EntityRef.new(l_7_8)
  l_7_0.chainLinks = {}
  l_7_0.wardenSpritesheet = SpriteSheet.load("Characters/Warden/Warden")
  for i = 1, l_7_9 do
    local chainLink = MOAIProp.new()
    chainLink:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
    local deck, index = l_7_0.wardenSpritesheet:getDeck("Mace_ChainLink", 1, false)
    chainLink:setDeck(deck)
    chainLink:setIndex(index)
    chainLink:setPriority(128)
    l_7_0:attachProp(chainLink)
    table.insert(l_7_0.chainLinks, chainLink)
  end
  l_7_0.damage = l_7_10
  l_7_0.damageVelX, l_7_0.damageVelY = l_7_11, l_7_12
  l_7_0.framesStopped = 0
  if l_7_0.targetRef:isValid() then
    l_7_0:queueAction(WardenMace.ChaseAction.new())
  end
end

WardenMace.onHit = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  if l_8_1 and l_8_1:is(Alice) and l_8_0:isDoing(WardenMace.ChaseAction) then
    local damageVelX, damageVelY = l_8_0.damageVelX, l_8_0.damageVelY
    local normX, normY = l_8_5:getContactNormal()
    damageVelX, damageVelY = damageVelX + l_8_0.HIT_SPEED * normX, damageVelY + l_8_0.HIT_SPEED * normY
    l_8_1:get(HealthComponent):damage(l_8_0.damage, l_8_0, damageVelX, damageVelY, 0.4, 0.5, 0.7)
    l_8_0:forceAction(WardenMace.ReturnAction.new())
  end
end

WardenMace.getThrowingPos = function(l_9_0)
  if l_9_0.targetRef:isValid() then
    local thrower = l_9_0.throwerRef.entity
    local jointX, jointY = thrower:get(AnimatorComponent):getJointLoc("MaceStart")
    if jointX and jointY then
      local worldX, worldY = thrower.prop:modelToWorld(jointX, jointY, 0)
      return worldX, worldY
    else
      return thrower:getPosition()
    end
  else
    return l_9_0:getPosition()
  end
end

WardenMace.tick = function(l_10_0)
  if l_10_0:isDoing(WardenMace.ChaseAction) then
    local physics = l_10_0:get(PhysicsComponent)
    local velX, velY = physics:getLinearVelocity()
    if Math.lengthSquared(velX, velY) < l_10_0.SPEED_THRESH ^ 2 then
      l_10_0.framesStopped = l_10_0.framesStopped + 1
      if l_10_0.SPEED_FRAME_THRESH < l_10_0.framesStopped then
        l_10_0:forceAction(WardenMace.ReturnAction.new())
      else
        l_10_0.framesStopped = 0
      end
    end
  end
  local startX, startY = l_10_0:getThrowingPos()
  local posX, posY = l_10_0:getPosition()
  local diffX, diffY = posX - startX, posY - startY
  local dirX, dirY = Math.normalize(diffX, diffY)
  local angle = math.deg(math.atan2(dirY, dirX)) - 90
  for i,chainProp in ipairs(l_10_0.chainLinks) do
    local ratio = (i - 1) / #l_10_0.chainLinks
    local lerpX, lerpY = Math.lerp(startX, posX, ratio), Math.lerp(startY, posY, ratio)
    chainProp:setLoc(lerpX - posX, lerpY - posY)
    chainProp:setRot(0, 0, angle)
    chainProp:forceUpdate()
    prevPosX, prevPosY = lerpX, lerpY
  end
  Entity.tick(l_10_0)
end

return WardenMace

