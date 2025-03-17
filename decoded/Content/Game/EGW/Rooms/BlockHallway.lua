-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Rooms\BlockHallway.lua 

local BlockHallway = require("Room").classFromLayout("Content/Game/EGW/Layouts/BlockHallway", "BlockHallway", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
BlockHallway.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("GuardHallway exit", "Content/Game/EGW/Rooms/GuardHallway", "BlockHallway exit")
  l_1_0:getEntity("HackBlock").REMAINING_PUSHES = 1
  Music:playAmbient("Ambience/Ambience/Castle_Ambience_Fire")
  Music:setReverb("Reflective")
  Music:playMusic("Music/Music/InnerPrison_Cue1", false)
end

return BlockHallway

