-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\Armory.lua 

local Armory = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/Armory", "Armory", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
local Entity = require("Entity")
local Direction = require("Direction")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local InventoryComponent = require("Components.InventoryComponent")
local Item = require("Item")
local ArtifactItem = Item.load("Content/Game/Global/Items/ArtifactItem")
Armory.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("SecurityGateHallway exit", "Content/Game/DweebKeep/Rooms/SecurityGateHallway", "North exit")
  l_1_0:defineCollisionExit("ArmoryWestHallway exit", "Content/Game/DweebKeep/Rooms/GlyphRoom", "ArmoryWestHallway exit")
  l_1_0:defineCollisionExit("ArmoryEastHallway exit", "Content/Game/DweebKeep/Rooms/InnerPrisonLock", "ArmoryEastHallway exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 6 do
    Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs W " .. i, l_1_0.collisionAreasByName["Stairs W " .. i], Direction.DIR_W, 0.8)
    Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs E " .. i, l_1_0.collisionAreasByName["Stairs E " .. i], Direction.DIR_E, 0.8)
  end
  for i = 1, 3 do
    Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs N " .. i, l_1_0.collisionAreasByName["Stairs N " .. i], Direction.DIR_N, 0.8)
  end
  local treasureChest = l_1_0.entitiesByName.BoomerangChest
  if treasureChest then
    treasureChest:setItem("Content/Game/Global/Items/ThrowBoomerang", {})
    treasureChest.openedEvent:register(l_1_0.onBoomerangChestOpened, l_1_0)
  end
  for i = 1, 4 do
    l_1_0:getCollisionArea("LowWall " .. tostring(i)).fixture:setFilter(PhysicsComponent.LOW_CATEGORY)
  end
  for i = 1, 4 do
    l_1_0:getEntity("ReflectionBlock " .. tostring(i)).prop:setVisible(false)
  end
  local healthChest = l_1_0.entitiesByName.HealthChest
  l_1_0.leftGate = l_1_0:getEntity("GateBars 1")
  l_1_0.leftGatePortBlock = l_1_0:getEntity("Port")
  l_1_0.leftGatePortBlock.LOCKED = l_1_0.leftGate.LOCKED
  l_1_0.leftGatePortBlock.fieldSetEvent:register(l_1_0.onGateSet, l_1_0)
  local sword = l_1_0:getEntity("SwordPickup")
  if l_1_0:getState()["Took sword"] then
    sword:destroy()
  else
    sword:get(InteractionComponent).interactEvent:register(l_1_0.onSwordInteract, l_1_0)
  end
  local boomerang = l_1_0:getEntity("BoomerangPickup")
  if l_1_0:getState()["Took boomerang"] then
    boomerang:destroy()
  else
    boomerang:get(InteractionComponent).interactEvent:register(l_1_0.onBoomerangInteract, l_1_0)
  end
  Music:playAmbient("Ambience/Ambience/Castle_Ambience1")
  Music:playMusic("Music/Music/Armory_Cue1", false)
  Music:setReverb("Reflective")
  l_1_0.hsvTint = {0.083, -0.111, 0}
  l_1_0:getEntity("Guard (patrol left)").IDLE_ROUTINE = {{TYPE = "MOVE", TILES = 8}, {TYPE = "IDLE", SECONDS = 0.5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "IDLE", SECONDS = 2}}
  l_1_0:getEntity("Guard (patrol right)").IDLE_ROUTINE = {{TYPE = "MOVE", TILES = 8}, {TYPE = "IDLE", SECONDS = 0.5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "IDLE", SECONDS = 2}}
  l_1_0.defaultSoundMat = require("Components.PlatformComponent").SOUND_MAT_STONE
  l_1_0:defineTreasureChestScene("TreasureChest", l_1_0.onTreasureChestOpened, l_1_0, "Opening_Cylinder")
end

Armory.onTreasureChestOpened = function(l_2_0, l_2_1, l_2_2)
  local alicePortrait = l_2_1:addAlicePortrait()
  local bobPortrait = l_2_1:addCharacter("Portraits/Bob/Bob")
  l_2_2:get(InventoryComponent):insertItem("Content/Game/Global/Items/ArtifactItem", ArtifactItem.synthesizeHostArtifact("LIBRARY_ROOT_PATH"))
  l_2_1:speakLineLeft(alicePortrait, "<c:72FEFDFF>LIBRARY_ROOT_PATH</c>...", "Cylinder")
  l_2_1:speakLineLeft(bobPortrait, "Library root path? Those three words have nothing to do with each other.", "Talk3")
end

Armory.onSwordInteract = function(l_3_0, l_3_1, l_3_2)
  local alice = l_3_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local HackItem = Item.cache:load("Content/Game/Global/Items/HackItem")
    local animator = alice:get(AnimatorComponent)
    alice:get(SoundComponent):playCue("SFX/Cutscenes/RetrieveSword", nil, 0.5)
    alice:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
    l_1_0:speakLineLeft(alicePortrait, "Alright! Another sword!", "HappyLaugh")
    local hackSword = alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/HackItem", {plugUsed = true})
    sword:destroy()
    self:getState()["Took sword"] = true
    l_1_0:speakLineLeft(alicePortrait, "Let me just pop this top off...", "Talk2")
    l_1_0:sleep(0.25)
    hackSword:expose()
    l_1_0:sleep(0.25)
    l_1_0:speakLineLeft(alicePortrait, "There!", "BrokenSword")
    l_1_0:speakLineRight(bobPortrait, "Yay! Now it's useful again!", "Excited")
    alice:halt(false)
   end)
end

Armory.onBoomerangInteract = function(l_4_0, l_4_1, l_4_2)
  local alice = l_4_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local boomerangItem = alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/ThrowBoomerang", {plugUsed = true})
    boomerang:destroy()
    alice:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
    self:getState()["Took boomerang"] = true
    l_1_0:speakLineLeft(alicePortrait, "What does this do?", "Boomerang")
    l_1_0:destroyDialog()
    l_1_0:sleep(0.2)
    self.leftGate:setOpen(false)
    l_1_0:sleepWhile(function()
      return self.leftGate.action
      end)
    self.leftGatePortBlock.OPEN = false
    l_1_0:sleep(0.5)
    l_1_0:speakLineRight(bobPortrait, "I think it sets off that trap.", "Sly")
    l_1_0:speakLineLeft(alicePortrait, "Great.", "StinkEye")
    alice:halt(false)
   end)
end

Armory.onGateSet = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_1 == "OPEN" then
    if l_5_3 == l_5_0.leftGatePortBlock then
      l_5_0.leftGate.OPEN = l_5_2
    elseif l_5_3 == l_5_0.rightGatePortBlock then
      l_5_0.rightGate.OPEN = l_5_2
    end
  end
end

Armory.onBoomerangChestOpened = function(l_6_0)
  l_6_0.leftGatePortBlock.OPEN = false
end

return Armory

