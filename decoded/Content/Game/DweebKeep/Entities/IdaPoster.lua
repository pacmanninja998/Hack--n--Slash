-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\IdaPoster.lua 

local Entity = require("Entity")
local WantedPoster = Entity.cache:load("Content/Game/DweebKeep/Entities/WantedPoster")
local IdaPoster = require("Class").create(WantedPoster, "IdaPoster")
IdaPoster.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  WantedPoster.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, "Ida")
end

return IdaPoster

