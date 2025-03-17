-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\SolidBlock.lua 

local Entity = require("Entity")
local SolidBlock = require("Class").create(Entity, "SolidBlock")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
SolidBlock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/SolidBlock/SolidBlock")
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.WATER_CATEGORY, nil, MOAIBox2DBody.STATIC)
end

return SolidBlock

