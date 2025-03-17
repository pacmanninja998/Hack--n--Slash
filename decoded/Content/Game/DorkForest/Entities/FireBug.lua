-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\FireBug.lua 

local Entity = require("Entity")
local EntityRef = require("EntityRef")
local EntitySet = require("EntitySet")
local Action = require("Action")
local Math = require("DFCommon.Math")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local Flocking = require("Flocking")
local Torch = Entity.cache:load("Content/Game/Global/Entities/Torch")
local TorchBlock = Entity.cache:load("Content/Game/Global/Entities/TorchBlock")
local FireBug = require("Class").create(Entity, "FireBug")
FireBug.PIXELS_PER_SECOND = 2000
FireBug.PERCEPTION_RADIUS = 200
FireBug.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/Sprite/Sprite")
  AnimatorComponent.new(l_1_0, true)
  PhysicsComponent.new(l_1_0, 8, 8, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, PhysicsComponent.SENSOR_CATEGORY, MOAIBox2DBody.DYNAMIC, true)
  l_1_0:get(AnimatorComponent):play("DefaultPose")
  l_1_0.torches = EntitySet.new()
  l_1_0.closeTorch = nil
  l_1_0.sensor = l_1_0:get(PhysicsComponent):addCircleSensor(l_1_0.PERCEPTION_RADIUS, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.SENSOR_CATEGORY)
  l_1_0.sensor.entityEnterEvent:register(l_1_0.onEntityEnterPerception, l_1_0)
  l_1_0.sensor.entityLeaveEvent:register(l_1_0.onEntityLeavePerception, l_1_0)
  l_1_0.prop:setColor(0.9, 0.5, 0, 1)
end

FireBug.onEntityEnterPerception = function(l_2_0, l_2_1)
  if l_2_1:is(Torch) or l_2_1:is(TorchBlock) then
    l_2_0.torches:addEntity(l_2_1)
  end
end

FireBug.onEntityLeavePerception = function(l_3_0, l_3_1)
  if l_3_1:is(Torch) then
    l_3_0.torches:removeEntity(l_3_1)
  end
end

FireBug.getClosestTorch = function(l_4_0)
  local closeTorch, closeTorchDistSq = nil, nil
  local posX, posY = l_4_0:getPosition()
  for _,torch in pairs(l_4_0.torches.entities) do
    local torchX, torchY = torch:getPosition()
    local distSq = Math.distance2DSquared(posX, posY, torchX, torchY)
    if not closeTorchDistSq or distSq < closeTorchDistSq then
      closeTorch = torch
      closeTorchDistSq = distSq
    end
  end
  return closeTorch, closeTorchDistSq
end

FireBug.tick = function(l_5_0)
  Entity.tick(l_5_0)
  local closeTorch, closeTorchDistSq = l_5_0:getClosestTorch()
  if not l_5_0.action then
    l_5_0:forceAction(Flocking.OrbitAction.new(nil, nil, closeTorch))
  end
  if closeTorch ~= l_5_0.closeTorch and l_5_0.action and l_5_0.action:is(Flocking.OrbitAction) then
    l_5_0.closeTorch = closeTorch
    l_5_0.action:setTarget(closeTorch)
  end
  if l_5_0.createSpark then
    l_5_0.createSpark = nil
    local posX, posY = l_5_0:getPosition()
    local spark = Entity.create("Content/Game/Global/Entities/Spark", l_5_0.layer, posX, posY)
  end
end

FireBug.onSwordHit = function(l_6_0)
  l_6_0.createSpark = true
end

return FireBug

