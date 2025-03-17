-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\ArrowIcon.lua 

local Entity = require("Entity")
local ArrowIcon = require("Class").create(Entity, "ArrowIcon")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
ArrowIcon.FRAMES_PER_SECOND = 5
ArrowIcon.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/ArrowIcon/ArrowIcon")
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play("ArrowIcon", l_1_0.FRAMES_PER_SECOND)
end

return ArrowIcon

