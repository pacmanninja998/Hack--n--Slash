-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\GlyphFlameHolder.lua 

local Entity = require("Entity")
local GlyphFlameHolder = require("Class").create(Entity, "GlyphFlameHolder")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
GlyphFlameHolder.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local xScl = (l_1_5 == Direction.DIR_SE or l_1_5 == Direction.DIR_NE) and -1 or 1
  local side = (l_1_5 == Direction.DIR_NW or l_1_5 == Direction.DIR_NE) and "Top" or "Bottom"
  SpriteComponent.new(l_1_0, "Interactions/Props/GlyphFlameHolder/GlyphFlameHolder", side)
  l_1_0.prop:setScl(xScl, 1)
  PhysicsComponent.new(l_1_0, 96, 96, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:get(SpriteComponent).prop:setPriority(-40)
end

return GlyphFlameHolder

