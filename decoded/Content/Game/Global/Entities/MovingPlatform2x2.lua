-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\MovingPlatform2x2.lua 

local Entity = require("Entity")
local MovingPlatform = Entity.cache:load("Content/Game/Global/Entities/MovingPlatform")
local MovingPlatform2x2 = require("Class").create(MovingPlatform, "MovingPlatform2x2")
MovingPlatform2x2.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  MovingPlatform.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, 2, 2)
end

return MovingPlatform2x2

