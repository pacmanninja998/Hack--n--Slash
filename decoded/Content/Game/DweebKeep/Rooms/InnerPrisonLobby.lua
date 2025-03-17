-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\InnerPrisonLobby.lua 

local InnerPrisonLobby = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/InnerPrisonLobby", "InnerPrisonLobby", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
local Entity = require("Entity")
local Direction = require("Direction")
local InventoryComponent = require("Components.InventoryComponent")
local ArtifactItem = require("Item").load("Content/Game/Global/Items/ArtifactItem")
InnerPrisonLobby.onInit = function(l_1_0)
  Music:playMusic(nil)
  l_1_0:defineCollisionExit("IdasCell exit", "Content/Game/DweebKeep/Rooms/IdasCell", "InnerPrisonLobby exit")
  l_1_0:defineCollisionExit("HalcyonsCell exit", "Content/Game/DweebKeep/Rooms/HalcyonsCell", "InnerPrisonLobby exit")
  l_1_0:defineCollisionExit("InnerPrisonLock exit", "Content/Game/DweebKeep/Rooms/InnerPrisonLock", "InnerPrisonLobby exit")
  Music:playAmbient("Ambience/Ambience/Castle_Ambience2")
  Music:setReverb("Reflective")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Staircase", l_1_0:getCollisionArea("Staircase"), Direction.DIR_N, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs (left)", l_1_0:getCollisionArea("Stairs (left)"), Direction.DIR_N, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs (right)", l_1_0:getCollisionArea("Stairs (right)"), Direction.DIR_N, 0.8)
  l_1_0.hsvTint = {0.083, -0.111, 0}
  l_1_0:defineTreasureChestScene("TreasureChest", l_1_0.onTreasureChestOpened, l_1_0, "Opening_Cylinder")
end

InnerPrisonLobby.onTreasureChestOpened = function(l_2_0, l_2_1, l_2_2)
  local alicePortrait = l_2_1:addAlicePortrait()
  local bobPortrait = l_2_1:addCharacter("Portraits/Bob/Bob")
  l_2_1:speakLineLeft(alicePortrait, "Ooh, another artifact.", "Cylinder")
  l_2_2:get(InventoryComponent):insertItem("Content/Game/Global/Items/ArtifactItem", ArtifactItem.synthesizeHostArtifact("INFO_OPACITY"))
  l_2_1:speakLineRight(bobPortrait, "Cool! But why would the wizard just leave treasure here unprotected?", "Talk")
  l_2_1:speakLineLeft(alicePortrait, "Maybe he thought the security leading here was good enough.", "EyeRoll")
  l_2_1:speakLineRight(bobPortrait, "Hah! Maybe we're on our way to THE TREASURE ROOMS.", "OMG")
  l_2_1:speakLineLeft(alicePortrait, "I dunno. Still looks kinda prison-y to me. Let's investigate.", "StinkEye")
end

return InnerPrisonLobby

