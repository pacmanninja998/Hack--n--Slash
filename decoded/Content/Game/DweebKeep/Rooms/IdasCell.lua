-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\IdasCell.lua 

local Room = require("Room")
local Class = require("Class")
local IdasCell = Room.classFromLayout("Content/Game/DweebKeep/Layouts/IdasCell", "IdasCell", "Content/Game/Global/Rooms/GameRoom")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local SceneComponent = require("Components.SceneComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local Music = require("Music")
IdasCell.LOCK_SPEED = 50
IdasCell.onInit = function(l_1_0)
  Music:playMusic(nil)
  l_1_0:defineCollisionExit("InnerPrisonLobby exit", "Content/Game/DweebKeep/Rooms/InnerPrisonLobby", "IdasCell exit")
  l_1_0.nextNote = 1
  l_1_0.elapsed = 0
  l_1_0.ida = l_1_0.entitiesByName.Ida
  l_1_0.ida:get(InteractionComponent).interactEvent:register(l_1_0.onInteractIda, l_1_0)
  require("Music"):playMusic("Music/Music/InnerPrison_Cue1", false)
  Music:setReverb("Reflective")
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  l_1_0:getEntity(l_1_0:getEntity("SecondField")).correctEvent:register(function(l_1_0)
    self:onRingCorrect(l_1_0, 1)
   end)
  l_1_0:getEntity("SecondRing").correctEvent:register(function(l_2_0)
    self:onRingCorrect(l_2_0, 2)
   end)
  l_1_0:getEntity("ThirdRing").correctEvent:register(function(l_3_0)
    self:onRingCorrect(l_3_0, 3)
   end)
  l_1_0:getEntity("FourthRing").correctEvent:register(function(l_4_0)
    self:onRingCorrect(l_4_0, 4)
   end)
  l_1_0:getEntity("FirstRing").incorrectEvent:register(function(l_5_0)
    self:onRingIncorrect(l_5_0)
   end)
  l_1_0:getEntity("SecondRing").incorrectEvent:register(function(l_6_0)
    self:onRingIncorrect(l_6_0)
   end)
  l_1_0:getEntity("ThirdRing").incorrectEvent:register(function(l_7_0)
    self:onRingIncorrect(l_7_0)
   end)
  l_1_0:getEntity("FourthRing").incorrectEvent:register(function(l_8_0)
    self:onRingIncorrect(l_8_0)
   end)
   -- DECOMPILER ERROR: Overwrote pending register.

   -- Warning: undefined locals caused missing assignments!
end

IdasCell.onRingCorrect = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 ~= l_2_0:getAlice() then
    return 
  end
  for i = 1, l_2_2 - 1 do
    local ringField = l_2_0.ringFields[i]
    if not ringField.prop:isVisible() then
      ringField.prop:setVisible(true)
      ringField:get(SoundComponent):playCue("SFX/Objects/IdasCell_LightOn", false)
    end
  end
  for i = l_2_2, #l_2_0.ringFields do
    local ringField = l_2_0.ringFields[i]
    if ringField.prop:isVisible() then
      ringField.prop:setVisible(false)
      ringField:get(SoundComponent):playCue("SFX/Objects/IdasCell_LightOff", false)
    end
  end
end

IdasCell.onRingIncorrect = function(l_3_0, l_3_1)
  if l_3_1 ~= l_3_0:getAlice() then
    return 
  end
  local changedRing = nil
  for i = 1, #l_3_0.ringFields do
    local ringField = l_3_0.ringFields[i]
    if not ringField.prop:isVisible() then
      ringField.prop:setVisible(true)
      changedRing = ringField
    end
  end
  if changedRing then
    changedRing:get(SoundComponent):playCue("SFX/Objects/IdasCell_LightOff", false)
  end
  local alice = l_3_0:getAlice()
  l_3_0:queueUpdate(function()
    alice:get(SceneComponent):play(function(l_1_0)
      l_1_0:teleportTo(alice, self:getEntity("Ring teleport target"))
      alice:get(SoundComponent):playCue("SFX/Objects/IdasCell_Teleport", false)
      if not self:getState().Teleported then
        alice:halt(true)
        l_1_0:sleep(0.5)
        local alicePortrait = l_1_0:addAlicePortrait()
        local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
        l_1_0:speakLineLeft(alicePortrait, "... Wuh?", "Surprised")
        l_1_0:speakLineRight(bobPortrait, "Did you learn how to teleport? That is so cool.", "OMG")
        l_1_0:speakLineLeft(alicePortrait, "I didn't do it! I think it happened when I touched that ring.", "Spooked")
        l_1_0:speakLineRight(bobPortrait, "How are we going to get to the center?", "Talk")
        l_1_0:speakLineLeft(alicePortrait, "We can figure this out...", "Default2")
        alice:halt(false)
        self:getState().Teleported = true
      end
      end)
   end)
end

IdasCell.tick = function(l_4_0)
  local dialSpeed = l_4_0:getEntity("Port").DIAL_SPEED
  l_4_0:getEntity("FirstRing"):get(PhysicsComponent).body:setAngularVelocity(dialSpeed * l_4_0.LOCK_SPEED)
  if dialSpeed ~= 0 and not l_4_0.dialCue then
    l_4_0.dialCue = l_4_0:getEntity("FirstRing"):get(SoundComponent):playCue("SFX/Objects/IdasCell_Puzzle", nil, 0.5)
  elseif dialSpeed == 0 and l_4_0.dialCue then
    l_4_0.dialCue:stop()
    l_4_0.dialCue = nil
  end
  Class.super(IdasCell).tick(l_4_0)
end

IdasCell.onInteractIda = function(l_5_0, l_5_1)
  local alice = l_5_0:getAlice()
  local sceneComponent = alice:get(SceneComponent)
  sceneComponent:play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local idaPortrait = l_1_0:addCharacter("Portraits/Ida/Ida")
    alice:halt(true)
    l_1_0:speakLineLeft(bobPortrait, "Hi!", "Excited")
    l_1_0:speakLineRight(idaPortrait, "...", "Default")
    if not self:getState()["Spoke to Ida"] then
      alice:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
      alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/IdaCommunicator")
      l_1_0:speakLineLeft(alicePortrait, "Uh... thanks!", "Spooked")
      l_1_0:speakLineRight(bobPortrait, "Whoa, did you just speak telepathically to her? Are you rediscovering latent psychic abilities?", "OMG")
      l_1_0:speakLineLeft(alicePortrait, "No, $BOB. She just handed me this thing.", "Pyramid")
      l_1_0:speakLineRight(bobPortrait, "I bet if you use it you'll gain psychic powers.", "Judgemental")
      l_1_0:speakLineRight(idaPortrait, "...", "Annoyed")
      l_1_0:speakLineLeft(alicePortrait, "Hah. I'm pretty sure that means 'no.'", "Talk2")
      l_1_0:speakLineRight(idaPortrait, "...", "Default")
      self:getState()["Spoke to Ida"] = true
    else
      l_1_0:speakLineLeft(bobPortrait, "...I'm an excellent conversationalist if you ever want to chat!", "Sing")
      l_1_0:speakLineLeft(alicePortrait, "$BOB, let it go.", "DopeySmile")
    end
    self.ida:get(InteractionComponent):stopInteract(interactor)
    alice:halt(false)
   end)
end

return IdasCell

