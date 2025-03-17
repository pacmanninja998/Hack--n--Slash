-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Debug\Rooms\West.lua 

local Room = require("Room")
local West = Room.classFromLayout("Content/Game/Debug/Layouts/West", "West")
West.onInit = function(l_1_0, l_1_1, l_1_2)
  l_1_0.permutation = tonumber(l_1_2) or 1
  l_1_0:defineLogicTrigger("West exit", l_1_0.onWestExit, l_1_0, true)
end

West.onWestExit = function(l_2_0, l_2_1)
  if l_2_1.host then
    l_2_1.host:insertRoom(l_2_0.world, "Content/Game/Debug/Rooms/East," .. l_2_0.permutation + 1)
  end
end

return West

