-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\ArmoryWestHallway.lua 

local ArmoryWestHallway = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/HallwayHorizontal", "ArmoryWestHallway", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
ArmoryWestHallway.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("West exit", "Content/Game/DweebKeep/Rooms/GlyphRoom", "ArmoryWestHallway exit")
  l_1_0:defineCollisionExit("East exit", "Content/Game/DweebKeep/Rooms/Armory", "ArmoryWestHallway exit")
  require("Music"):playMusic("Music/Music/DungeonLobby_Cue1", false)
  require("Music"):playAmbient("Ambience/Ambience/Castle_Ambience2")
  Music:setReverb("Reflective")
  l_1_0.hsvTint = {0.083, -0.111, 0}
end

return ArmoryWestHallway

