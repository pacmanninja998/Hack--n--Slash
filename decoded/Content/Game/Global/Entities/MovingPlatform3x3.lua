-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\MovingPlatform3x3.lua 

local Entity = require("Entity")
local MovingPlatform = Entity.cache:load("Content/Game/Global/Entities/MovingPlatform")
local MovingPlatform3x3 = require("Class").create(MovingPlatform, "MovingPlatform3x3")
MovingPlatform3x3.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  MovingPlatform.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, 3, 3)
end

return MovingPlatform3x3

