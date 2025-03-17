-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\InnerPrisonLock\Port.lua 

local Class = require("Class")
local Entity = require("Entity")
local LayoutEntity = Class.create(Entity, "Port")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local Direction = require("Direction")
LayoutEntity.addIntegerField("OFFSET", 0)
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DweebKeep/InnerPrisonLock/InnerPrisonLock", l_1_4)
  PhysicsComponent.new(l_1_0, {rect = {-32, 40, 48, 108}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
end

LayoutEntity.isHackable = function(l_2_0, l_2_1)
  return not l_2_1 or not l_2_0.direction or Direction.rotate(l_2_1, 4) == l_2_0.direction
end

return LayoutEntity

