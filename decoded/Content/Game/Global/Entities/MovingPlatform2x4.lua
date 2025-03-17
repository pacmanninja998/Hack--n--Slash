-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\MovingPlatform2x4.lua 

local Entity = require("Entity")
local MovingPlatform = Entity.cache:load("Content/Game/Global/Entities/MovingPlatform")
local MovingPlatform2x4 = require("Class").create(MovingPlatform, "MovingPlatform4x4")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
MovingPlatform2x4.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  MovingPlatform.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, true, 2, 4)
  l_1_0.prop:setScl(1, 1)
  l_1_0:get(SpriteComponent).prop:setPriority(-128)
  l_1_0:get(AnimatorComponent):play("Narrow", 0)
end

return MovingPlatform2x4

