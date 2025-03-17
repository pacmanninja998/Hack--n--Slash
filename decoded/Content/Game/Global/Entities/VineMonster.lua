-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\VineMonster.lua 

local Entity = require("Entity")
local VineMonster = require("Class").create(Entity, "VineMonster")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local FlammableComponent = require("Components.FlammableComponent")
local Delegate = require("DFMoai.Delegate")
local Direction = require("Direction")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
VineMonster.FLEE_SPEED = 450
VineMonster.IDLE_FRAMES_PER_SECOND = 1
VineMonster.FLEE_FRAMES_PER_SECOND = 8
VineMonster.ATTACK_FRAMES_PER_SECOND = 1
VineMonster.CATEGORY = PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY
VineMonster.COLLIDE_MASK = PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.LOW_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY
VineMonster.STOPPING_ANGLE = 135
VineMonster.SPEED_EPSILON = 1
VineMonster.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/VineMonster/VineMonster")
  AnimatorComponent.new(l_1_0, true)
  PhysicsComponent.new(l_1_0, 62, 62, l_1_0.CATEGORY, nil, MOAIBox2DBody.STATIC, false)
  FlammableComponent.new(l_1_0, 2, 64)
  local flammable = l_1_0:get(FlammableComponent)
  flammable:registerOnLit(l_1_0.onLit, l_1_0)
  flammable:registerOnDone(l_1_0.onDone, l_1_0, 2)
  l_1_0.startFlee = false
  l_1_0.stopFlee = false
  l_1_0.fleeing = false
  l_1_0.fleeX, l_1_0.fleeY = 0, 0
  l_1_0.framesFleeing = 0
  l_1_0.startAttack = false
end

VineMonster.onLit = function(l_2_0)
  l_2_0.prop:setColor(1, 0, 0, 1)
end

VineMonster.onDone = function(l_3_0)
  local x, y = l_3_0:getPosition()
  Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_3_0.layer, x, y)
  l_3_0:destroy()
end

VineMonster.onHitObstacle = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  if l_4_0.fleeing and (not l_4_1 or l_4_1:is(Alice) or l_4_0 ~= l_4_1) then
    local physics = l_4_0:get(PhysicsComponent)
    local contactNormX, contactNormY = l_4_5:getContactNormal()
    local prevVelX, prevVelY = l_4_0.fleeX, l_4_0.fleeY
    local curVelX, curVelY = physics.body:getLinearVelocity()
    local velContactDot = contactNormX * l_4_0.fleeX + contactNormY * l_4_0.fleeY
    local velContactAngle = math.deg(math.acos(velContactDot))
    local curSpeedSq = curVelX * curVelX + curVelY * curVelY
    if l_4_0.STOPPING_ANGLE < velContactAngle or curSpeedSq < l_4_0.SPEED_EPSILON and l_4_0.framesFleeing > 30 then
      l_4_0.stopFlee = true
    end
  end
end

VineMonster.onSwordHit = function(l_5_0, l_5_1)
  local swingerAnimator = l_5_1:get(AnimatorComponent)
  local direction = swingerAnimator:getDirection()
  local dirX, dirY = Direction.dirToVector(direction)
  local oppositeDir = Direction.vectorToDir(-dirX, -dirY)
  if not l_5_0.fleeing then
    do return end
    l_5_0.startFlee = true
    l_5_0.fleeX, l_5_0.fleeY = swingerAnimator:getDirVector(), swingerAnimator
    do return end
    l_5_0.startAttack = true
  else
    local x, y = l_5_0:getPosition()
    Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_5_0.layer, x, y)
  end
end

VineMonster.tick = function(l_6_0)
  local animator = l_6_0:get(AnimatorComponent)
  local physics = l_6_0:get(PhysicsComponent)
  if l_6_0.startFlee and not l_6_0.fleeing then
    physics:destroy()
    physics:init(l_6_0, physics.width, physics.height, l_6_0.CATEGORY, nil, MOAIBox2DBody.DYNAMIC, false)
    physics:setCollisionHandler(l_6_0.COLLIDE_MASK, l_6_0.onHitObstacle, l_6_0, MOAIBox2DArbiter.POST_SOLVE)
    l_6_0.startFlee = false
    l_6_0.fleeing = true
  elseif l_6_0.stopFlee and l_6_0.fleeing then
    physics:destroy()
    physics:init(l_6_0, physics.width, physics.height, l_6_0.CATEGORY, nil, MOAIBox2DBody.STATIC, false)
    l_6_0.stopFlee = false
    l_6_0.fleeing = false
    l_6_0.framesFleeing = 0
  elseif l_6_0.fleeing then
    animator:play("Flee", l_6_0.FLEE_FRAMES_PER_SECOND)
    physics:setLinearVelocity(l_6_0.FLEE_SPEED * l_6_0.fleeX, l_6_0.FLEE_SPEED * l_6_0.fleeY)
    l_6_0.framesFleeing = l_6_0.framesFleeing + 1
  elseif l_6_0.startAttack then
    animator:play("Attack", l_6_0.ATTACK_FRAMES_PER_SECOND)
    l_6_0.startAttack = false
  else
    animator:play("VineMonster", l_6_0.IDLE_FRAMES_PER_SECOND)
  end
  Entity.tick(l_6_0)
end

return VineMonster

