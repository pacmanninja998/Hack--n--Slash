-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryUpStairs.lua 

local Entity = require("Entity")
local LibraryStairs = Entity.cache:load("Content/Game/DourTower/Entities/LibraryStairs")
local LibraryUpStairs = require("Class").create(LibraryStairs, "LibraryUpStairs")
LibraryUpStairs.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  LibraryStairs.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, true)
end

return LibraryUpStairs

