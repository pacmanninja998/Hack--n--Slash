-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\Script.lua 

local Class = require("Class")
local Entity = require("Entity")
local Script = Class.create(Entity, "Script")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local LogoComponent = require("Components.LogoComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
Script.addIntegerField("MOVE_SPEED", 75)
Script.TEXT_COLOR = {0.86274509803922, 0.4, 0.11764705882353}
Script.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/ScriptKitty/ScriptKitty")
  SoundComponent.new(l_1_0, {})
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_FRONT_BACK_SIDE, l_1_5)
  PhysicsComponent.new(l_1_0, {rect = {-8, -8, 8, 8}, category = PhysicsComponent.DYNAMIC_CATEGORY, collidesWithCategories = PhysicsComponent.ALL_CATEGORY - PhysicsComponent.DYNAMIC_CATEGORY - PhysicsComponent.HITTABLE_CATEGORY, bodyType = MOAIBox2DBody.DYNAMIC})
  LogoComponent.new(l_1_0)
  l_1_0:get(AnimatorComponent):play("Breathe")
  l_1_0.prop:setScl(0.65)
  l_1_0.sitting = false
end

Script.tick = function(l_2_0)
  Entity.tick(l_2_0)
  l_2_0:get(AnimatorComponent):play(l_2_0.action or (l_2_0.sitting and "Sit") or "Breathe")
end

Script.sit = function(l_3_0)
  l_3_0.sitting = true
  l_3_0:get(AnimatorComponent):play("Sit")
end

return Script

