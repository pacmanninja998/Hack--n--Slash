-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\ORCPoster.lua 

local Entity = require("Entity")
local WantedPoster = Entity.cache:load("Content/Game/DweebKeep/Entities/WantedPoster")
local ORCPoster = require("Class").create(WantedPoster, "ORCPoster")
ORCPoster.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  WantedPoster.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, "ORC", "Chicco")
end

return ORCPoster

