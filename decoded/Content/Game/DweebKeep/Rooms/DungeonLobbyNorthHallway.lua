-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\DungeonLobbyNorthHallway.lua 

local DungeonLobbyNorthHallway = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/HallwayVertical", "DungeonLobbyNorthHallway", "Content/Game/Global/Rooms/GameRoom")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local InventoryComponent = require("Components.InventoryComponent")
local ArtifactItem = require("Item").load("Content/Game/Global/Items/ArtifactItem")
DungeonLobbyNorthHallway.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("North exit", "Content/Game/DweebKeep/Rooms/SecurityGate", "DungeonLobbyNorthHallway exit")
  l_1_0:defineCollisionExit("South exit", "Content/Game/DweebKeep/Rooms/DungeonLobby", "DungeonLobbyNorthHallway exit")
  require("Music"):playMusic("Music/Music/InnerPrison_Cue1", false)
  require("Music"):playAmbient("Ambience/Ambience/Castle_Ambience2")
  l_1_0.buttonMap = {{" ", "X", " ", " ", "X", " "}, {"X", " ", " ", " ", " ", "X"}, {" ", "X", " ", " ", "X", " "}, {" ", " ", " ", " ", " ", " "}, {"X", "X", " ", " ", "X", "X"}, {" ", "X", "X", "X", "X", " "}}
  local chest = l_1_0:getEntity("TreasureChest")
  if not chest.isOpen then
    chest.prop:setVisible(false)
    chest:get(InteractionComponent):setEnabled(false)
  end
  for j = 0, 5 do
    do
      for i = 0, 5 do
        do
          local plate = l_1_0:getPlate(i, j)
          if plate then
            plate.locked = true
            local target = l_1_0.buttonMap[j + 1][i + 1]
            plate:setLabelText(target)
            if target == "X" and chest.isOpen then
              plate:press()
            end
            plate.pressedEvent:register(function(l_1_0, l_1_1)
              self:onPlatePressed(i, j, l_1_1)
                  end)
          end
        end
      end
    end
  end
  if not chest.isOpen then
    l_1_0:resetPlates()
    l_1_0:getEntity("Reset PressurePlate").pressedEvent:register(l_1_0.onResetPressed, l_1_0)
  end
  l_1_0:defineTreasureChestScene("TreasureChest", l_1_0.onTreasureChest, l_1_0, "Opening_Cylinder")
  l_1_0.hsvTint = {0.083, -0.111, 0}
end

DungeonLobbyNorthHallway.onResetPressed = function(l_2_0, l_2_1, l_2_2)
  if l_2_2 and not l_2_0:getEntity("TreasureChest").isOpen then
    l_2_0:resetPlates()
  end
end

DungeonLobbyNorthHallway.resetPlates = function(l_3_0)
  for j = 0, 5 do
    for i = 0, 5 do
      local plate = l_3_0:getPlate(i, j)
      plate.locked = false
      plate:refreshState()
      plate.locked = true
    end
  end
  l_3_0:getPlate(1, 2):press()
  l_3_0:getPlate(4, 2):press()
end

DungeonLobbyNorthHallway.getPlate = function(l_4_0, l_4_1, l_4_2)
  return l_4_0:getEntity("PressurePlate " .. l_4_1 .. "," .. l_4_2)
end

DungeonLobbyNorthHallway.onPlatePressed = function(l_5_0)
  local match = true
  for j = 0, 5 do
    for i = 0, 5 do
      local plate = l_5_0:getPlate(i, j)
      local target = l_5_0.buttonMap[j + 1][i + 1]
      local shouldBePressed = target == "X"
      if plate.pressed ~= shouldBePressed then
        match = false
      end
    end
  end
  local chest = l_5_0:getEntity("TreasureChest")
  if not chest.isOpen then
    chest.prop:setVisible(match)
    chest:get(InteractionComponent):setEnabled(match)
    chest:get(PhysicsComponent).fixture:setSensor(not match)
    if match then
      chest:get(SoundComponent):playCue("SFX/Objects/Chest_Appear", nil, 0.5)
    end
  end
end

DungeonLobbyNorthHallway.onTreasureChest = function(l_6_0, l_6_1, l_6_2)
  local alicePortrait = l_6_1:addAlicePortrait()
  local bobPortrait = l_6_1:addCharacter("Portraits/Bob/Bob")
  l_6_1:speakLineLeft(alicePortrait, "Aw, bits.", "Cylinder")
  l_6_1:speakLineRight(bobPortrait, "What's wrong?", "Talk3")
  l_6_1:speakLineLeft(alicePortrait, "I was hoping for a sword, but it's just an artifact.", "SidewaysGlance")
  l_6_1:speakLineRight(bobPortrait, "Artifacts are cool, though! It's still treasure.", "Excited")
  l_6_2:get(InventoryComponent):insertItem("Content/Game/Global/Items/ArtifactItem", ArtifactItem.synthesizeHostArtifact("TIME_DISTORTION"))
  l_6_1:speakLineLeft(alicePortrait, "Ooh, actually, it's labeled <c:72FEFDFF>TIME_DISTORTION</c>. That does sound useful.", "Spooked")
  l_6_1:speakLineRight(bobPortrait, "Oh! Oh! We should slow down time and say something cool like \"oohhhhhh yeahhhhhh.\"", "Talk")
  l_6_1:speakLineLeft(alicePortrait, "...", "EyeRoll")
end

return DungeonLobbyNorthHallway

