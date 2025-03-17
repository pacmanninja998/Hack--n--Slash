-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\BoomerangProjectile.lua 

local Entity = require("Entity")
local BoomerangProjectile = require("Class").create(Entity, "BoomerangProjectile")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local ReflectionComponent = require("Components.ReflectionComponent")
local SoundComponent = require("Components.SoundComponent")
local Math = require("DFCommon.Math")
local Action = require("Action")
local Direction = require("Direction")
local HackAction = Action.load("Content/Game/Global/Actions/HackAction")
local BeHackedAction = Action.load("Content/Game/Global/Actions/BeHackedAction")
local EntityRef = require("EntityRef")
BoomerangProjectile.SPIN_FRAMES_PER_SECOND = 20
BoomerangProjectile.MAX_DISTANCE = 900
BoomerangProjectile.ATTRACTION_SPEED = 600
BoomerangProjectile.SLOW_START = 0.8
BoomerangProjectile.HACK_SENSOR_RADIUS = 24
BoomerangProjectile.COLLIDE_SENSOR_RADIUS = 12
BoomerangProjectile.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/Boomerang/Boomerang")
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY, nil, 1, true)
  AnimatorComponent.new(l_1_0, true, l_1_5)
  SoundComponent.new(l_1_0, {})
  l_1_0.thrower = EntityRef.new(l_1_6)
  l_1_0.item = l_1_7
  l_1_0.initVelX = l_1_8
  l_1_0.initVelY = l_1_9
  l_1_0.initSpeed = math.sqrt(l_1_8 * l_1_8 + l_1_9 * l_1_9)
  l_1_0.hackedObject = nil
  l_1_0.distanceToPlayer = 0
  l_1_0.comingBack = false
  l_1_0.hacking = false
  l_1_0.distanceTraveled = 0
  l_1_0.reflectEntity = nil
  l_1_0.renewDistanceOnReflect = false
  local animator = l_1_0:get(AnimatorComponent)
  animator:play("Spin", l_1_0.SPIN_FRAMES_PER_SECOND)
  l_1_0:get(SpriteComponent).prop:setPriority(160)
  local physics = l_1_0:get(PhysicsComponent)
  physics:setLinearVelocity(l_1_0.initVelX, l_1_0.initVelY)
  l_1_0.hackSensor = physics:addCircleSensor(l_1_0.HACK_SENSOR_RADIUS, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.SENSOR_CATEGORY)
  l_1_0.hackSensor.entityEnterEvent:register(l_1_0.onHackHit, l_1_0)
  l_1_0.collideSensor = physics.body:addCircle(0, 0, l_1_0.COLLIDE_SENSOR_RADIUS)
  l_1_0.collideSensor:setSensor(true)
  l_1_0.collideSensor:setFilter(PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY)
  l_1_0.collideSensor:setCollisionHandler(function(l_1_0, l_1_1, l_1_2, l_1_3)
    local hitBody = l_1_2:getBody()
    self:onCollision(hitBody.entity, l_1_0, l_1_1, l_1_2, l_1_3)
   end, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY)
  l_1_0.prevX, l_1_0.prevY = l_1_2, l_1_3
  l_1_0.throwSound = l_1_0:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Boomerang_Throw", false)
  l_1_0.loopSound = l_1_0:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Boomerang_Loop", false)
end

BoomerangProjectile.tick = function(l_2_0)
  local physics = l_2_0:get(PhysicsComponent)
  if l_2_0.hacking then
    if l_2_0.loopSound then
      l_2_0:get(SoundComponent):stopCue(l_2_0.loopSound)
      l_2_0.loopSound = nil
    end
    physics:setLinearVelocity(0, 0)
    if not l_2_0.thrower:isValid() or not l_2_0.thrower.entity:isDoing(HackAction) then
      l_2_0.hacking = false
      local animator = l_2_0:get(AnimatorComponent)
      animator.framesPerSecond = l_2_0.SPIN_FRAMES_PER_SECOND
      l_2_0.comingBack = true
    else
      local curX, curY = physics:getPosition()
      local diffX, diffY = curX - l_2_0.prevX, curY - l_2_0.prevY
      l_2_0.distanceTraveled = l_2_0.distanceTraveled + math.sqrt(diffX * diffX + diffY * diffY)
      l_2_0.prevX, l_2_0.prevY = curX, curY
      local curVelX, curVelY = physics:getLinearVelocity()
      local curSpeed = math.sqrt(curVelX * curVelX + curVelY * curVelY)
      if not l_2_0.comingBack and l_2_0.distanceTraveled < l_2_0.MAX_DISTANCE then
        local ratioTraveled = l_2_0.distanceTraveled / l_2_0.MAX_DISTANCE
        if l_2_0.SLOW_START < ratioTraveled then
          local recip = 0.9 / (1 - l_2_0.SLOW_START)
          local slowRatio = 1 - recip * (ratioTraveled - l_2_0.SLOW_START)
          local curDirX, curDirY = curVelX / curSpeed, curVelY / curSpeed
          physics:setLinearVelocity(curDirX * l_2_0.initSpeed * slowRatio, curDirY * l_2_0.initSpeed * slowRatio)
        elseif not l_2_0.loopSound then
          l_2_0.loopSound = l_2_0:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Boomerang_Loop")
        end
        if not l_2_0.comingBack then
          l_2_0.comingBack = true
          physics:setLinearVelocity(0, 0)
        else
          if l_2_0.thrower:isValid() then
            local targetPhysics = l_2_0.thrower.entity:get(PhysicsComponent)
            local targetX, targetY = targetPhysics:getPosition()
            diffX, diffY = targetX - curX, targetY - curY
            local distance = math.sqrt((diffX) * (diffX) + (diffY) * (diffY))
            if distance > 10 then
              local dirX = (diffX) / distance
              local dirY = (diffY) / distance
              local speed = (curSpeed + l_2_0.ATTRACTION_SPEED) / 2
              local physics = l_2_0:get(PhysicsComponent)
              physics:setLinearVelocity(dirX * speed, dirY * speed)
            else
              l_2_0.item.releasedBoomerang = false
              if l_2_0.loopSound then
                l_2_0:get(SoundComponent):stopCue(l_2_0.loopSound)
                l_2_0.loopSound = nil
              end
              l_2_0:destroy()
            end
            l_2_0.distanceToPlayer = distance
          end
        end
      end
    end
  end
  Entity.tick(l_2_0)
end

BoomerangProjectile.onHackHit = function(l_3_0, l_3_1)
  local velX, velY = l_3_0:get(PhysicsComponent):getLinearVelocity()
  if velX ~= 0 or velY ~= 0 then
    local boomerangDir = Direction.vectorToDir(velX, velY, true, math.pi / 8)
    if l_3_0.thrower:equals(l_3_1) then
      if not l_3_0:universe().state.state.BOOMERANGS_HACK_THROWER then
        return 
      end
      if not l_3_0.comingBack then
        return 
      end
    end
    if l_3_1:isHackable(boomerangDir) then
      local source = l_3_0.thrower.entity
      local target = l_3_1
      if l_3_0.loopSound then
        l_3_0:get(SoundComponent):stopCue(l_3_0.loopSound)
        l_3_0.loopSound = nil
      end
      if not l_3_0.hackedObject then
        l_3_0.hackedObject = target
        local hackAction = HackAction.new(target)
        source:forceAction(hackAction)
        target:insertAction(BeHackedAction.new(source, hackAction))
        l_3_0.hacking = true
        local animator = l_3_0:get(AnimatorComponent)
        animator.framesPerSecond = 0
      end
    end
  end
end

BoomerangProjectile.onCollision = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  if l_4_2 == MOAIBox2DArbiter.BEGIN then
    if l_4_1 then
      local reflection = l_4_1:get(ReflectionComponent)
    end
    local physics = l_4_0:get(PhysicsComponent)
    if l_4_0.comingBack and l_4_1 and l_4_0.thrower:equals(l_4_1) then
      l_4_0:onHackHit(l_4_1)
      if l_4_0.hacking then
        return 
      end
      if l_4_0.loopSound then
        l_4_0:get(SoundComponent):stopCue(l_4_0.loopSound)
        l_4_0.loopSound = nil
      end
      l_4_1:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Boomerang_Catch", false)
      l_4_0.item.releasedBoomerang = false
      l_4_0:destroy()
      do return end
      if reflection and not l_4_0.reflectEntity then
        l_4_0:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Boomerang_Ricochet")
        local reflectDirX, reflectDirY, restitution = reflection:reflect(physics:getLinearVelocity())
        reflectDirX, reflectDirY = Math.normalize(reflectDirX, reflectDirY)
        physics:setLinearVelocity(reflectDirX * l_4_0.initSpeed * restitution, reflectDirY * l_4_0.initSpeed * restitution)
        if l_4_0.renewDistanceOnReflect then
          l_4_0.distanceTraveled = l_4_0.MAX_DISTANCE * (1 - restitution)
        end
        l_4_0.reflectEntity = l_4_1
      elseif not l_4_1 or not l_4_1.host then
        physics:setLinearVelocity(0, 0)
        l_4_0.distanceTraveled = l_4_0.MAX_DISTANCE
      else
        if l_4_2 == MOAIBox2DArbiter.END and l_4_0.reflectEntity == l_4_1 then
          l_4_0.reflectEntity = nil
        end
      end
    end
  end
end

return BoomerangProjectile

