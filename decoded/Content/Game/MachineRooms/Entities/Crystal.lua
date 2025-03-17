-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Crystal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Crystal = Class.create(Entity, "Crystal")
local SpriteSheet = require("SpriteSheet")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
Crystal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Crystal).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local physics = PhysicsComponent.new(l_1_0, {rect = {-8, -16, 8, 16}, category = PhysicsComponent.DYNAMIC_CATEGORY, collidesWithCategories = PhysicsComponent.SENSOR_CATEGORY, bodyType = MOAIBox2DBody.DYNAMIC, isSensor = true})
  physics.fixture:setDebugColor(1, 0, 0, 0)
  local sprite = SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/Crystal/Crystal")
  sprite.prop:setPriority(100)
  local interact = InteractionComponent.new(l_1_0)
  interact.sensorEvent:register(l_1_0.onSensorEvent, l_1_0)
  interact:setEnabled(false)
  l_1_0:setLabelText("")
end

Crystal.setCrystalColor = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0.colorIndex, l_2_0.isOrigin = l_2_2, l_2_3
  local r, g, b = unpack(l_2_1.colors[l_2_2])
  l_2_0:get(SpriteComponent).prop:setColor(r / 255, g / 255, b / 255)
end

Crystal.onSensorEvent = function(l_3_0, l_3_1, l_3_2)
  l_3_0:room():activateStreams(l_3_1, l_3_0.colorIndex, l_3_2)
end

return Crystal

