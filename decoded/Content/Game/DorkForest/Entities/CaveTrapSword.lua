-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\CaveTrapSword.lua 

local Entity = require("Entity")
local Sword = require("Class").create(Entity, "Sword")
local SpriteComponent = require("Components.SpriteComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
Sword.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Sword/Sword")
  PhysicsComponent.new(l_1_0, {rect = {-100, -50, -30, 0}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  InteractionComponent.new(l_1_0, false, -126, -29)
  l_1_0.prop:setScl(0.65)
end

return Sword

