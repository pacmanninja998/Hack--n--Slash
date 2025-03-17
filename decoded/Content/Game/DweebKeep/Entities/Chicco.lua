-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Chicco.lua 

local Entity = require("Entity")
local Chicco = require("Class").create(Entity, "Chicco")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
Chicco.PERCEPTIBLE_RADIUS = 300
Chicco.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_1_0)
  l_1_0:enableField(false)
  l_1_0.interactionSensor = nil
end

Chicco.enableInteractionSensor = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  if l_2_1 and not l_2_0.interactionSensor then
    local entPosX, entPosY = l_2_0:getPosition()
    local relX, relY = l_2_2 - entPosX, l_2_3 - entPosY
    local minX, minY, maxX, maxY = relX - l_2_4 / 2, relY - l_2_5 / 2, relX + l_2_4 / 2, relY + l_2_5 / 2
    l_2_0.interactionSensor = l_2_0:get(PhysicsComponent):addRectSensor(minX, minY, maxX, maxY, PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.DYNAMIC_CATEGORY)
  elseif not l_2_1 and l_2_0.interactionSensor then
    l_2_0.interactionSensor.fixture:destroy()
    l_2_0.interactionSensor = false
  end
end

Chicco.enableField = function(l_3_0, l_3_1)
  if l_3_1 and not l_3_0.sensor then
    l_3_0.sensor = l_3_0:get(PhysicsComponent):addCircleSensor(l_3_0.PERCEPTIBLE_RADIUS, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.GHOST_CATEGORY, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.GHOST_CATEGORY)
    l_3_0.sensor.entityEnterEvent:register(l_3_0.onEntityEnter, l_3_0)
    l_3_0.sensor.entityLeaveEvent:register(l_3_0.onEntityLeave, l_3_0)
  elseif not l_3_1 and l_3_0.sensor then
    l_3_0.sensor.fixture:destroy()
    l_3_0.sensor = nil
  end
end

Chicco.onEntityEnter = function(l_4_0, l_4_1)
  if l_4_1:is(Alice) and not l_4_1:isGhost() then
    l_4_1:toggleGhost()
  end
end

Chicco.onEntityLeave = function(l_5_0, l_5_1)
  if l_5_1:is(Alice) and l_5_1:isGhost() then
    l_5_1:toggleGhost()
  end
end

return Chicco

