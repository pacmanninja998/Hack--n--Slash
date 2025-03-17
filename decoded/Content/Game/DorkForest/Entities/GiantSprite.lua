-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\GiantSprite.lua 

local Entity = require("Entity")
local GiantSprite = require("Class").create(Entity, "GiantSprite")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local CommonActions = require("CommonActions")
GiantSprite.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/QueenFairy/QueenFairy")
  AnimatorComponent.new(l_1_0, true)
  PhysicsComponent.new(l_1_0, 192, 192, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_1_0)
  l_1_0:get(AnimatorComponent):play("Idle")
end

return GiantSprite

