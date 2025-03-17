-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryCenter.lua 

local Entity = require("Entity")
local LibraryCenter = require("Class").create(Entity, "LibraryCenter")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
LibraryCenter.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/LibraryCenter/LibraryCenter", "Abyss")
  l_1_0:get(SpriteComponent).prop:setPriority(-256)
end

LibraryCenter.setGarden = function(l_2_0, l_2_1)
  if l_2_1 == Direction.DIR_W then
    l_2_0:get(SpriteComponent):setSprite("Left Garden")
  else
    if l_2_1 == Direction.DIR_E then
      l_2_0:get(SpriteComponent):setSprite("Right Garden")
    end
  end
end

return LibraryCenter

