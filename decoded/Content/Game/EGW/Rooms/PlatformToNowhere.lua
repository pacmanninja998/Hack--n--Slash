-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Rooms\PlatformToNowhere.lua 

local Class = require("Class")
local PlatformToNowhere = require("Room").classFromLayout("Content/Game/EGW/Layouts/PlatformToNowhere", "PlatformToNowhere", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
local Entity = require("Entity")
local Direction = require("Direction")
local LogoComponent = require("Components.LogoComponent")
local InventoryComponent = require("Components.InventoryComponent")
PlatformToNowhere.TILE_PLACE_SECONDS = 0.25
PlatformToNowhere.onInit = function(l_1_0)
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  l_1_0:defineCollisionExit("Hub exit", "Content/Game/EGW/Rooms/Hub", "PlatformToNowhere exit")
  Entity.create("Content/Game/Global/Entities/Abyss", gameplayLayer, nil, nil, "Abyss", l_1_0:getCollisionArea("Abyss"))
  l_1_0.placeDelay = 0
  l_1_0.tileQueue = {}
  l_1_0:getEntity("PressurePlate").pressedEvent:register(l_1_0.onPressurePlatePressed, l_1_0)
  l_1_0:defineTreasureChestScene("TreasureChest (breakpoint bombs)", l_1_0.onTreasureChestScene, l_1_0)
  for i = 1, 2 do
    Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, nil, l_1_0.collisionAreasByName["Stairs " .. i], Direction.DIR_W, 0.5)
  end
  Music:playAmbient("Ambience/Ambience/Castle_Ambience_Fire")
  Music:setReverb("Reflective")
  Music:playMusic(nil)
end

PlatformToNowhere.onTreasureChestScene = function(l_2_0, l_2_1, l_2_2)
  l_2_2:get(InventoryComponent):insertItem("Content/Game/Global/Items/BombItem")
  local alicePortrait = l_2_1:addAlicePortrait()
  l_2_1:speakLineLeft(alicePortrait, "It's a bunch of bombs!", "Excited")
  l_2_1:speakLineLeft(alicePortrait, "They're all labeled \"breakpoint.\" I wonder if they do something besides blow stuff up.", "Spooked")
end

PlatformToNowhere.tick = function(l_3_0)
  Class.super(PlatformToNowhere).tick(l_3_0)
  if #l_3_0.tileQueue ~= 0 then
    if l_3_0.placeDelay > 0 then
      l_3_0.placeDelay = l_3_0.placeDelay - MOAISim.getStep()
    else
      local tile = l_3_0.tileQueue[1]
      table.remove(l_3_0.tileQueue, 1)
      tile:enable()
      l_3_0.placeDelay = l_3_0.TILE_PLACE_SECONDS
    end
  end
end

PlatformToNowhere.onPressurePlatePressed = function(l_4_0, l_4_1, l_4_2)
  if l_4_2 then
    l_4_0:destroyBridge()
    l_4_0:buildBridge()
  end
end

PlatformToNowhere.destroyBridge = function(l_5_0)
  for name,entity in pairs(l_5_0.entitiesByName) do
    if name:find("Bridge Tile") == 1 then
      entity:disable()
    end
  end
end

PlatformToNowhere.buildBridge = function(l_6_0)
  l_6_0.placeDelay = 0
  l_6_0.tileQueue = {}
  for pieceIndex = 1, 8 do
    l_6_0:queueBridgeTile(pieceIndex)
  end
end

PlatformToNowhere.queueBridgeTile = function(l_7_0, l_7_1)
  local entity = l_7_0.entitiesByName["Bridge Tile " .. l_7_1]
  if entity then
    table.insert(l_7_0.tileQueue, entity)
  end
end

return PlatformToNowhere

