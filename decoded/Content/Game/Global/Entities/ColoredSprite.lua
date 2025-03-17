-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\ColoredSprite.lua 

local Entity = require("Entity")
local ColoredSprite = require("Class").create(Entity, "ColoredSprite")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local Flocking = require("Flocking")
ColoredSprite.createColorClass = function(l_1_0)
  local class = require("Class").create(ColoredSprite, l_1_0 .. "Sprite")
  class.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
    ColoredSprite.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, color)
   end
  return class
end

ColoredSprite.init = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  Entity.init(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_0.color = l_2_5
  SpriteComponent.new(l_2_0, "Characters/Sprites/Sprites")
  AnimatorComponent.new(l_2_0, true)
  PhysicsComponent.new(l_2_0, 8, 8, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.SENSOR_CATEGORY)
  l_2_0.prop:setScl(0.65)
  l_2_0:get(SpriteComponent).prop:setPriority(32)
  l_2_0:get(AnimatorComponent):play(l_2_0.color .. "_Fly")
  l_2_0:get(PhysicsComponent):setReceivesPlatformVel(false)
  l_2_0:forceAction(Flocking.OrbitAction.new())
end

return ColoredSprite

