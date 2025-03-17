-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CavePillar.lua 

local Class = require("Class")
local Entity = require("Entity")
local CavePillar = Class.create(Entity, "CavePillar")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
CavePillar.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/CavePillar/CavePillar", "Default")
  PhysicsComponent.new(l_1_0, {rect = {-32, -16, 32, 16}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
end

CavePillar.isHackable = function(l_2_0)
  return true
end

return CavePillar

