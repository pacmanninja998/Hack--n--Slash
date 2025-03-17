-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\ExitAbyss.lua 

local Entity = require("Entity")
local Abyss = Entity.cache:load("Content/Game/Global/Entities/Abyss")
local ExitAbyss = require("Class").create(Abyss, "ExitAbyss")
local SwimmingComponent = require("Components.SwimmingComponent")
ExitAbyss.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Abyss.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0.targetRoomPath = l_1_6
end

return ExitAbyss

