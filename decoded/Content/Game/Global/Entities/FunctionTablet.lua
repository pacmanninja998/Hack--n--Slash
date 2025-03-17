-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\FunctionTablet.lua 

local Entity = require("Entity")
local FunctionTablet = require("Class").create(Entity, "FunctionTablet")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local FunctionComponent = require("Components.FunctionComponent")
FunctionTablet.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/FunctionTablet/FunctionTablet")
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  FunctionComponent.new(l_1_0, l_1_6, l_1_7, l_1_8)
end

return FunctionTablet

