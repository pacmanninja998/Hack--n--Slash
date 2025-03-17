-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Rooms\CaveTrap.lua 

local Class = require("Class")
local CaveTrap = require("Room").classFromLayout("Content/Game/DorkForest/Layouts/CaveTrap", "CaveTrap", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
local SceneComponent = require("Components.SceneComponent")
local HealthComponent = require("Components.HealthComponent")
local InventoryComponent = require("Components.InventoryComponent")
local InteractionComponent = require("Components.InteractionComponent")
local HackItem = require("Item").load("Content/Game/Global/Items/HackItem")
local ArtifactItem = require("Item").load("Content/Game/Global/Items/ArtifactItem")
local Music = require("Music")
local Direction = require("Direction")
CaveTrap.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("BobTrap exit", "Content/Game/DorkForest/Rooms/BobTrap", "CaveTrap exit")
  l_1_0.hsvTint = {0, 0, 0}
  Music:playMusic(nil)
  Music:playAmbient("Ambience/Ambience/CaveTrap_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  l_1_0.fadeEvent:register(l_1_0.onFade, l_1_0)
  l_1_0:enableWater()
end

CaveTrap.onAliceCreated = function(l_2_0, l_2_1)
  Class.super(CaveTrap).onAliceCreated(l_2_0, l_2_1)
  if l_2_1.state.trapped then
    l_2_1.prop:setVisible(false)
    l_2_0:getEntity("TreasureChest"):destroy()
  else
    if l_2_1.state.entryArea == nil then
      l_2_0:defineTreasureChestScene("TreasureChest", l_2_0.onTreasureChestOpened, l_2_0, "Opening_Cylinder")
    else
      l_2_0:getEntity("TreasureChest"):destroy()
    end
  end
  l_2_0:setUpGate()
end

CaveTrap.onTreasureChestOpened = function(l_3_0, l_3_1, l_3_2)
  local alicePortrait = l_3_1:addAlicePortrait()
  local bobPortrait = l_3_1:addCharacter("Portraits/Bob/Bob")
  l_3_2:get(InventoryComponent):insertItem("Content/Game/Global/Items/ArtifactItem", ArtifactItem.synthesizeHostArtifact("DAY_NIGHT_SPEED"))
  l_3_1:speakLineLeft(alicePortrait, "This chest wasn't here before.", "Spooked")
  l_3_1:speakLineRight(bobPortrait, "What is that thing?", "Talk2")
  l_3_1:speakLineLeft(alicePortrait, "It's labeled <c:72FEFDFF>DAY_NIGHT_SPEED</c>.", "Cylinder")
  l_3_1:speakLineRight(bobPortrait, "Huh. I've heard stories about night time, but I'm pretty sure it's make-believe.", "Talk")
end

CaveTrap.fade = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  if l_4_1 == l_4_0.FADE_IN then
    local alice = l_4_0:getAlice()
    do
      if alice.state.trapped then
        alice:get(SceneComponent):play(function(l_1_0)
        alice:halt(true)
        l_1_0:displayTitleCard(2, "ACT 2")
        l_1_0:displayTitleCard(4, "IN WHICH I\nMEET A NEW FRIEND\nAND START AN ADVENTURE")
        alice:halt(false)
        Class.super(CaveTrap).fade(self, type, duration, host, exitArgs)
         end)
        return 
      end
    end
  end
  Class.super(CaveTrap).fade(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
end

CaveTrap.onFade = function(l_5_0, l_5_1, l_5_2)
  if l_5_1 == l_5_0.FADE_IN and not l_5_2 then
    local alice = l_5_0:getAlice()
    if alice.state.trapped then
      alice.prop:setVisible(true)
      l_5_0:playTrapScene()
    end
  end
end

CaveTrap.playTrapScene = function(l_6_0)
  l_6_0:aliceMonologue(function(l_1_0, l_1_1, l_1_2)
    l_1_2:halt(true)
    l_1_2:get(AnimatorComponent):setFacing(Direction.DIR_S)
    l_1_2:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_CaveTrap_Fall")
    l_1_0:playAnimation(l_1_2, "Fall_CaveTrap")
    l_1_0:speakLineLeft(l_1_1, "Phew. That fall could've hurt.\n<c:8>To advance conversations:</>", "Default", false, "Select")
    l_1_2:get(SoundComponent):playCue("SFX/Cutscenes/SwordFall_CaveTrap", nil, 0.5)
    l_1_0:playAnimation(l_1_2, "SwordFall_CaveTrap")
    local sword = Entity.create("Content/Game/DorkForest/Entities/CaveTrapSword", self:getLayerByOrder(0), l_1_2:getPosition())
    sword:get(InteractionComponent).interactEvent:register(self.onSwordInteract, self)
    l_1_0:speakLineLeft(l_1_1, "Ow.", "Angry")
    l_1_2.moveEvent:register(self.onAliceMove, self)
    self.moveTimer = self:addTimer(2, self.onMoveTimeout, self)
    l_1_2:halt(false)
   end)
end

CaveTrap.onSwordInteract = function(l_7_0, l_7_1, l_7_2)
  l_7_0:aliceMonologue(function(l_1_0, l_1_1, l_1_2)
    l_1_2:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
    l_1_0:speakLineLeft(l_1_1, "I'm glad I... borrowed this sword. Maybe I can use it to bust out of here.\n<c:8>To swing your sword:</>", "Default3", false, "UsePrimary")
    l_1_2:get(InventoryComponent):insertItem("Content/Game/Global/Items/HackItem", {})
    sword:destroy()
    self:setHackingHintsEnabled(true)
   end)
end

CaveTrap.onAliceMove = function(l_8_0)
  l_8_0:getAlice().moveEvent:unregister(l_8_0.onAliceMove, l_8_0)
  l_8_0.moveTimer:cancel()
end

CaveTrap.onMoveTimeout = function(l_9_0)
  l_9_0:getAlice().moveEvent:unregister(l_9_0.onAliceMove, l_9_0)
  l_9_0.moveTimer = nil
  l_9_0:aliceMonologue(function(l_1_0, l_1_1, l_1_2)
    l_1_0:speakLineLeft(l_1_1, "Who would install a pitfall trap in the forest?", "Surprised")
    l_1_0:speakLineLeft(l_1_1, "I probably don't want to meet them. Time to look for a way out.\n<c:8>To move:</c>", "Angry", false, "Up", "Left", "Down", "Right")
   end)
end

CaveTrap.setUpGate = function(l_10_0)
  local gateDoor = l_10_0:getEntity("GateDoor")
  l_10_0.gateHitCount = 0
  gateDoor.openEvent:register(l_10_0.onGateDoorOpen, l_10_0)
  gateDoor.rattleEvent:register(l_10_0.onGateDoorFirstRattle, l_10_0)
  if l_10_0:getState()["Gate opened"] then
    gateDoor:open(true)
  end
end

CaveTrap.onGateDoorFirstRattle = function(l_11_0)
  local gateDoor = l_11_0:getEntity("GateDoor")
  gateDoor.rattleEvent:unregister(l_11_0.onGateDoorFirstRattle, l_11_0)
  l_11_0:aliceMonologue(function(l_1_0, l_1_1, l_1_2)
    l_1_0:sleep(0.5)
    l_1_0:speakLineLeft(l_1_1, "Locked. Maybe I can get it open with the sword.", "Talk2")
   end)
end

CaveTrap.setHackingHintsEnabled = function(l_12_0, l_12_1)
  local alice = l_12_0:getAlice()
  local inventory = alice:get(InventoryComponent)
  local index = inventory:findItemIndex("Content/Game/Global/Items/HackItem")
  if not index then
    return 
  end
  local hackItem = inventory.items[index]
  if l_12_1 then
    hackItem.exposedEvent:register(l_12_0.onHackItemExposed, l_12_0)
    hackItem.hackBeginEvent:register(l_12_0.onHackBegin, l_12_0)
    hackItem.hackEndEvent:register(l_12_0.onHackEnd, l_12_0)
  else
    hackItem.exposedEvent:unregister(l_12_0.onHackItemExposed, l_12_0)
    hackItem.hackBeginEvent:unregister(l_12_0.onHackBegin, l_12_0)
    hackItem.hackEndEvent:unregister(l_12_0.onHackEnd, l_12_0)
  end
end

CaveTrap.onHackItemExposed = function(l_13_0)
  l_13_0:aliceMonologue(function(l_1_0, l_1_1, l_1_2)
    l_1_0:speakLineLeft(l_1_1, "Ack, did I break it? Was that part supposed to come off?", "BrokenSword")
   end)
end

CaveTrap.onHackBegin = function(l_14_0)
  l_14_0.hacking = true
end

CaveTrap.onHackEnd = function(l_15_0)
  if l_15_0:getEntity("GateDoor").locked and not l_15_0.hintedAtUnlock then
    l_15_0:aliceMonologue(function(l_1_0, l_1_1, l_1_2)
    l_1_0:speakLineLeft(l_1_1, "Whaaaaat was that?", "FreakedOut")
   end)
  else
    l_15_0.hintedAtUnlock = true
  end
  l_15_0.hacking = false
end

CaveTrap.onGateDoorOpen = function(l_16_0, l_16_1)
  l_16_0:getState()["Gate opened"] = l_16_1
  if l_16_0:getAlice().state.trapped and l_16_1 then
    l_16_0:getAlice().state.trapped = false
  end
  l_16_0:getCollisionArea("Lower gate"):setActive(not l_16_1)
  l_16_0:setHackingHintsEnabled(false)
end

CaveTrap.aliceMonologue = function(l_17_0, l_17_1, l_17_2)
  local alice = l_17_0:getAlice()
  local sceneComponent = alice:get(SceneComponent)
  if sceneComponent:isPlayingScene() and l_17_2 then
    sceneComponent:destroy()
  else
    return 
  end
  sceneComponent:play(function(l_1_0)
    alice:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    handler(l_1_0, alicePortrait, alice)
    alice:halt(false)
   end)
end

return CaveTrap

