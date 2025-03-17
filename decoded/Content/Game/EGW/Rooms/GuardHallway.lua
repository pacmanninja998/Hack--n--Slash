-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Rooms\GuardHallway.lua 

local GuardHallway = require("Room").classFromLayout("Content/Game/EGW/Layouts/GuardHallway", "GuardHallway", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
GuardHallway.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("BlockHallway exit", "Content/Game/EGW/Rooms/BlockHallway", "GuardHallway exit")
  l_1_0:defineCollisionExit("Hub exit", "Content/Game/EGW/Rooms/Hub", "GuardHallway exit")
  l_1_0:defineTreasureChestScene("TreasureChest (max health artifact)", l_1_0.onMaxHealthTreasureChestScene, l_1_0, "Opening_Cylinder")
  Music:playAmbient("Ambience/Ambience/Castle_Ambience_Fire")
  Music:setReverb("Reflective")
  l_1_0:getEntity("Guard").IDLE_ROUTINE = {{TYPE = "IDLE", SECONDS = 5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "right"}}
end

GuardHallway.onMaxHealthTreasureChestScene = function(l_2_0, l_2_1, l_2_2)
  local alicePortrait = l_2_1:addAlicePortrait()
  l_2_1:speakLineLeft(alicePortrait, "It's a strange artifact labeled <c:72FEFDFF>maxHealth</c>. I bet I can tune it with my amulet.", "Spooked")
  table.insert(l_2_2.host.state.discoveredValues, "maxHealth")
end

return GuardHallway

