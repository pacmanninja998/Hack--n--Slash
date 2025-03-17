-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\IdasCell\Port.lua 

local Class = require("Class")
local Entity = require("Entity")
local LayoutEntity = Class.create(Entity, "Port")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
LayoutEntity.addIntegerField("DIAL_SPEED", 0, -5, 5)
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DweebKeep/IdasCell/IdasCell", l_1_4)
  PhysicsComponent.new(l_1_0, {rect = {-48, 64, 80, 180}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_1_0:setLabelText("")
end

LayoutEntity.isHackable = function(l_2_0)
  return true
end

return LayoutEntity

