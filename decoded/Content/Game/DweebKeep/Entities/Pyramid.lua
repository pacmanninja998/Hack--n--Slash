-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Pyramid.lua 

local Entity = require("Entity")
local Pyramid = require("Class").create(Entity, "Pyramid")
local SpriteComponent = require("Components.SpriteComponent")
Pyramid.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Pyramid/Pyramid")
  l_1_0:get(SpriteComponent).prop:setPriority(-60)
  l_1_0:setLabelText("")
end

return Pyramid

