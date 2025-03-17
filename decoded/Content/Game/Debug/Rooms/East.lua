-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Debug\Rooms\East.lua 

local Room = require("Room")
local East = Room.classFromLayout("Content/Game/Debug/Layouts/East", "East")
East.onInit = function(l_1_0, l_1_1, l_1_2)
  l_1_0.permutation = tonumber(l_1_2) or 1
  l_1_0:defineLogicTrigger("East exit", l_1_0.onEastExit, l_1_0, true)
end

East.onEastExit = function(l_2_0, l_2_1)
  if l_2_1.host then
    l_2_1.host:insertRoom(l_2_0.world, "Content/Game/Debug/Rooms/West," .. l_2_0.permutation + 1)
  end
end

return East

