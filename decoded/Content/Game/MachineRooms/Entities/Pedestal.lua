-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Pedestal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Pedestal = Class.create(Entity, "Pedestal")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
Pedestal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Pedestal).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/VariablePedestal/VariablePedestal", "NoPort")
  local scl = 0.25
  l_1_0.prop:setScl(scl)
  local x0, y0, x1, y1 = sprite.sheet:getHitbox("body", "NoPort")
  x0, y0, x1, y1 = x0 * scl, y0 * scl, x1 * scl, y1 * scl
  PhysicsComponent.new(l_1_0, {rect = {x0, y0, x1, y1}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_1_0.crystal = Entity.create("Content/Game/MachineRooms/Entities/Crystal", l_1_0.layer, l_1_2 - 2, l_1_3 + 20)
  l_1_0.crystal.prop:setScl(0.5)
end

return Pedestal

