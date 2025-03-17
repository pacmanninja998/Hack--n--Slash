-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveStash\Bridge Tile.lua 

local Entity = require("Entity")
local FloatingTile = Entity.cache:load("Content/Game/CrackerCavern/Entities/FloatingTile")
local LayoutEntity = require("Class").create(FloatingTile, "Bridge Tile")
local SpriteComponent = require("Components.SpriteComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  FloatingTile.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_4)
end

return LayoutEntity

