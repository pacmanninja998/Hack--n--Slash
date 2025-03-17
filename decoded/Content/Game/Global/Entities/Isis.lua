-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Isis.lua 

local Entity = require("Entity")
local Isis = require("Class").create(Entity, "Isis")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local LogoComponent = require("Components.LogoComponent")
local SoundComponent = require("Components.SoundComponent")
Isis.addIntegerField("MOVE_SPEED", 100)
Isis.TEXT_COLOR = {0.89803921568627, 0.29411764705882, 0.12941176470588}
Isis.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/Isis/Isis")
  SoundComponent.new(l_1_0, {})
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_SIDE, l_1_5, Direction.DIR_W)
  PhysicsComponent.new(l_1_0, {rect = {-8, -8, 8, 8}, category = PhysicsComponent.DYNAMIC_CATEGORY, collidesWithCategories = PhysicsComponent.ALL_CATEGORY - PhysicsComponent.DYNAMIC_CATEGORY - PhysicsComponent.HITTABLE_CATEGORY, bodyType = MOAIBox2DBody.DYNAMIC})
  InteractionComponent.new(l_1_0)
  LogoComponent.new(l_1_0)
  l_1_0:get(AnimatorComponent):play("Breathe")
  l_1_0.prop:setScl(0.65)
end

Isis.tick = function(l_2_0)
  Entity.tick(l_2_0)
  if not l_2_0.action then
    l_2_0:get(AnimatorComponent):play("Breathe")
  end
end

return Isis

