-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\GlyphWallStrut.lua 

local Entity = require("Entity")
local GlyphWallStrut = require("Class").create(Entity, "GlyphWallStrut")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
GlyphWallStrut.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/GlyphWallStrut/GlyphWallStrut")
  if l_1_5 == Direction.DIR_W then
    l_1_0.prop:setScl(-1, 1)
  end
  PhysicsComponent.new(l_1_0, 40, 142, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:get(SpriteComponent).prop:setPriority(-60)
end

return GlyphWallStrut

