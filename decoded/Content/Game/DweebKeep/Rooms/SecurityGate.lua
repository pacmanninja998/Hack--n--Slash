-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\SecurityGate.lua 

local SecurityGate = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/SecurityGate", "SecurityGate", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local LogoComponent = require("Components.LogoComponent")
local Music = require("Music")
local Item = require("Item")
local ArtifactItem = Item.load("Content/Game/Global/Items/ArtifactItem")
local InventoryComponent = require("Components.InventoryComponent")
SecurityGate.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("DungeonLobbyNorthHallway exit", "Content/Game/DweebKeep/Rooms/DungeonLobbyNorthHallway", "North exit")
  l_1_0:defineCollisionExit("SecurityGateHallway exit", "Content/Game/DweebKeep/Rooms/SecurityGateHallway", "South exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 45 do
    local name = "Abyss " .. i
    Entity.create("Content/Game/Global/Entities/Abyss", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  require("Music"):playMusic("Music/Music/InnerPrison_Cue1", false)
  Music:playAmbient("Ambience/Ambience/Castle_Ambience1")
  Music:setReverb("Reflective")
  l_1_0:getEntity("Platform A").ROUTINE = {{TYPE = "MOVE", TILES = 4}, {TYPE = "IDLE", SECONDS = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  l_1_0:getEntity("Platform B").ROUTINE = {{TYPE = "MOVE", TILES = 15, SPEED = 3.75}, {TYPE = "IDLE", SECONDS = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  l_1_0:getEntity("Platform C").ROUTINE = {{TYPE = "MOVE", TILES = 28, SPEED = 7}, {TYPE = "IDLE", SECONDS = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  l_1_0:getEntity("Platform D").ROUTINE = {{TYPE = "MOVE", TILES = 17.625, SPEED = 4.40625}, {TYPE = "IDLE", SECONDS = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  l_1_0:getEntity("Shooter A - Group 1").PATTERN = {{TYPE = "FIRE", SPEED = 200}, {TYPE = "WAIT", FRAMES = 90}}
  l_1_0:getEntity("Shooter B - Group 1").PATTERN = {{TYPE = "FIRE", SPEED = 200}, {TYPE = "WAIT", FRAMES = 90}}
  l_1_0:getEntity("Shooter C - Group 1").PATTERN = {}
  l_1_0:getEntity("Shooter D - Group 1").PATTERN = {{TYPE = "FIRE", SPEED = 200}, {TYPE = "WAIT", FRAMES = 90}}
  l_1_0:getEntity("Shooter A - Group 2").PATTERN = {{TYPE = "WAIT", FRAMES = 20}, {TYPE = "FIRE", SPEED = 200}, {TYPE = "WAIT", FRAMES = 60}}
  l_1_0:getEntity("Shooter B - Group 2").PATTERN = {{TYPE = "WAIT", FRAMES = 40}, {TYPE = "FIRE", SPEED = 200}, {TYPE = "WAIT", FRAMES = 40}}
  l_1_0:getEntity("Shooter C - Group 2").PATTERN = {{TYPE = "WAIT", FRAMES = 60}, {TYPE = "FIRE", SPEED = 200}, {TYPE = "WAIT", FRAMES = 20}}
  l_1_0:getEntity("Shooter A - Group 3").PATTERN = {{TYPE = "FIRE", SPEED = 100, SCALE = 1.5}, {TYPE = "WAIT", FRAMES = 240}}
  l_1_0:getEntity("Shooter C - Group 3").PATTERN = {{TYPE = "FIRE", SPEED = 100, SCALE = 1.5}, {TYPE = "WAIT", FRAMES = 240}}
  l_1_0:getEntity("Shooter B - Group 3").PATTERN = {}
  l_1_0:getEntity("Shooter D - Group 3").PATTERN = {{TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 15}, {TYPE = "FIRE", SPEED = 150, SCALE = 0.5}, {TYPE = "WAIT", FRAMES = 60}}
  l_1_0:getEntity("Shooter A - Group 4").PATTERN = {{TYPE = "FIRE", SPEED = 400}, {TYPE = "WAIT", FRAMES = 90}}
  l_1_0:getEntity("Shooter C - Group 4").PATTERN = {{TYPE = "WAIT", FRAMES = 10}, {TYPE = "FIRE", SPEED = 200}}
  l_1_0.hsvTint = {0.083, -0.111, 0}
  l_1_0:defineTreasureChestScene("TreasureChest", l_1_0.onTreasureChestOpened, l_1_0, "Opening_Sphere")
end

SecurityGate.onTreasureChestOpened = function(l_2_0, l_2_1, l_2_2)
  local alicePortrait = l_2_1:addAlicePortrait()
  local bobPortrait = l_2_1:addCharacter("Portraits/Bob/Bob")
  l_2_2:get(InventoryComponent):insertItem("Content/Game/Global/Items/ArtifactItem", ArtifactItem.synthesizeHostArtifact("BOOMERANGS_HACK_THROWER"))
  l_2_1:speakLineLeft(alicePortrait, "It's another artifact. This one's labeled <c:72FEFDFF>BOOMERANGS_HACK_THROWER</c>.", "Sphere")
end

return SecurityGate

