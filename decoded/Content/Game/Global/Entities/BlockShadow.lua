-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\BlockShadow.lua 

local Class = require("Class")
local Entity = require("Entity")
local BlockShadow = Class.create(Entity, "BlockShadow")
local SpriteComponent = require("Components.SpriteComponent")
BlockShadow.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(BlockShadow).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/BlockShadow/BlockShadow")
end

BlockShadow.setColor = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_0.prop:setColor(l_2_1, l_2_2, l_2_3, l_2_4)
end

return BlockShadow

