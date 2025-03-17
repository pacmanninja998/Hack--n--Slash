-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\SecurityGateHallway.lua 

local SecurityGateHallway = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/HallwayStairs", "SecurityGateHallway", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local Direction = require("Direction")
SecurityGateHallway.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("South exit", "Content/Game/DweebKeep/Rooms/SecurityGate", "SecurityGateHallway exit")
  l_1_0:defineCollisionExit("North exit", "Content/Game/DweebKeep/Rooms/Armory", "SecurityGateHallway exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 1", l_1_0.collisionAreasByName["Stairs 1"], Direction.DIR_W, 0.5)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 2", l_1_0.collisionAreasByName["Stairs 2"], Direction.DIR_E, 0.5)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 3", l_1_0.collisionAreasByName["Stairs 3"], Direction.DIR_W, 0.5)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 4", l_1_0.collisionAreasByName["Stairs 4"], Direction.DIR_N, 0.8)
  require("Music"):playMusic("Music/Music/DungeonLobby_Cue1", false)
  require("Music"):playAmbient("Ambience/Ambience/Castle_Ambience2")
  l_1_0.hsvTint = {0.083, -0.111, 0}
end

return SecurityGateHallway

