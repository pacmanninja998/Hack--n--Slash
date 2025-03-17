-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\BreakThroughWall.lua 

local Class = require("Class")
local Entity = require("Entity")
local BreakThroughWall = Class.create(Entity, "BreakThroughWall")
local AnimatorComponent = require("Components.AnimatorComponent")
local SpriteComponent = require("Components.SpriteComponent")
BreakThroughWall.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(BreakThroughWall).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX")
  local animator = AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  animator:playOnce("Tower_BreakThroughWall")
end

return BreakThroughWall

