-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\TowerLevel5.lua 

local Class = require("Class")
local Room = require("Room")
local TowerLevel5 = Room.classFromLayout("Content/Game/DourTower/Layouts/TowerLevel5", "TowerLevel5", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local Item = require("Item")
local Music = require("Music")
local Math = require("DFCommon.Math")
local Shader = require("Shader")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local SceneComponent = require("Components.SceneComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
TowerLevel5.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("Staircase4 exit", "Content/Game/DourTower/Rooms/Staircase4", "Exit_Rt")
  l_1_0:defineCollisionExit("DRMRoof exit", "Content/Game/DourTower/Rooms/DRMRoof", "TowerLevel5 exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  l_1_0:makeStairs("West Ascending Stairs ", 3, Direction.DIR_W, 0.8)
  l_1_0:makeStairs("East Ascending Stairs ", 3, Direction.DIR_E, 0.8)
  Music:setReverb("Exterior")
  Music:playAmbient("Ambience/Ambience/TowerLevel5_Ambience")
  l_1_0:getCollisionArea("Battle trigger"):setActive(false)
  l_1_0:getEntity("Hole"):setVisible(l_1_0:getState().WALL_SMASHED ~= nil)
  l_1_0:openDoors(true)
end

TowerLevel5.onAliceCreated = function(l_2_0, l_2_1)
  Class.super(TowerLevel5).onAliceCreated(l_2_0, l_2_1)
  l_2_0.referenceCamDepth = 2000
  l_2_0.fadeEvent:register(l_2_0.onFade, l_2_0)
  local alice = l_2_0:getAlice()
  if not alice.state.escapedRoof then
    l_2_0:prepareForBattle()
  else
    if not alice.state.sawEntrapment then
      l_2_0:prepareForEntrapment()
    else
      l_2_0:postEntrapmentSetup()
      if not alice.state.tookBook then
        l_2_0:createBook()
      end
    end
  end
end

TowerLevel5.onFade = function(l_3_0, l_3_1, l_3_2)
  if l_3_1 == l_3_0.FADE_IN and not l_3_2 then
    local alice = l_3_0:getAlice()
    if alice.state.escapedRoof and not alice.state.sawEntrapment then
      l_3_0:playEntrapmentScene()
    end
  end
end

TowerLevel5.prepareForBattle = function(l_4_0)
  local eve = l_4_0:getEntity("Eve")
  eve:setVisible(false)
  local christo = l_4_0:getEntity("Christo")
  christo:setVisible(false)
  christo:setPosition(l_4_0:getEntity("Center locator"):getPosition())
  l_4_0:getCollisionArea("Battle trigger"):setActive(true)
  l_4_0:defineLogicTrigger("Battle trigger", l_4_0.onBattleTrigger, l_4_0, true, MOAIBox2DArbiter.BEGIN)
end

TowerLevel5.prepareForEntrapment = function(l_5_0)
  l_5_0:getCollisionArea("Battle trigger"):setActive(false)
  local eve = l_5_0:getEntity("Eve")
  eve:setVisible(true)
  local christo = l_5_0:getEntity("Christo")
  christo:setVisible(true)
  christo:setPosition(l_5_0:getEntity("Entrapment setup locator"):getPosition())
  l_5_0:createBook()
  l_5_0:openDoors(true)
end

TowerLevel5.createBook = function(l_6_0)
  local posX, posY = l_6_0:getEntity("Center locator"):getPosition()
  local book = Entity.create("Content/Game/DourTower/Entities/Book", l_6_0:getLayerByOrder(0), posX, posY, "PrincessChambersCopy")
  book:setRoomPath("Content/Game/DourTower/Rooms/PrincessChambersCopy")
  book:get(InteractionComponent).interactEvent:register(l_6_0.onBookInteract, l_6_0)
end

TowerLevel5.postEntrapmentSetup = function(l_7_0)
  l_7_0:getCollisionArea("Battle trigger"):setActive(false)
end

TowerLevel5.onBookInteract = function(l_8_0, l_8_1)
  local alice = l_8_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local book = self:getEntity("PrincessChambersCopy")
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    alice:halt(true)
    l_1_0:speakLineLeft(alicePortrait, "He trapped himself. He was always his own worst enemy.", "MildlyConcerned")
    l_1_0:speakLineRight(bobPortrait, "He trapped Eve too.", "Sad")
    l_1_0:speakLineLeft(alicePortrait, "They're bonded...", "Default4")
    l_1_0:speakLineRight(bobPortrait, "What should we do with the book?", "Judgemental")
    l_1_0:speakLineLeft(alicePortrait, "I don't know. Let's hold on to it for now", "Spooked")
    l_1_0:sleep(0.2)
    alice.state.tookBook = true
    interactor:get(InventoryComponent):insertItem("Content/Game/Global/Items/LibraryBookItem", {filePath = "Data/" .. book.path .. ".lua"})
    book:get(InteractionComponent):stopInteract(self.entity)
    book:destroy()
    l_1_0:sleep(0.5)
    l_1_0:speakLineRight(bobPortrait, "What do we do now?", "Talk3")
    l_1_0:speakLineLeft(alicePortrait, "Let's go see what's through that other door.", "Default3")
    alice:halt(false)
   end)
end

TowerLevel5.playEntrapmentScene = function(l_9_0)
  local alice = l_9_0:getAlice()
  local bob = l_9_0:getBob()
  alice.state.sawEntrapment = true
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
    alice:halt(true)
    l_1_0:speakLineRight(wizardPortrait, "You got off the roof.", "Shocked")
    l_1_0:speakLineLeft(bobPortrait, "Yep! $ALICE just jumped down the hole.", "Excited")
    l_1_0:speakLineLeft(bobPortrait, "I didn't need to.", "Default")
    l_1_0:speakLineLeft(bobPortrait, "I can fly.", "Judgemental")
    l_1_0:speakLineLeft(alicePortrait, "...", "EyeRoll")
    l_1_0:speakLineRight(wizardPortrait, "No matter. My trap is complete.", "Frown")
    l_1_0:speakLineRight(wizardPortrait, "I have made a nice little room for you.", "Default")
    l_1_0:speakLineRight(wizardPortrait, "It's actually a copy of the princess's chambers. Very opulent.", "Angelic")
    l_1_0:speakLineLeft(bobPortrait, "Ooh!", "Excited")
    l_1_0:speakLineRight(wizardPortrait, "...", "Unbelieving")
    l_1_0:speakLineRight(wizardPortrait, "Once you are sucked inside, the book will be encyphered so that it is unreadable.", "Happy")
    l_1_0:speakLineRight(wizardPortrait, "You'll never be able to leave. No one will ever be able to reach you.", "Frown")
    l_1_0:speakLineLeft(alicePortrait, "...Unless someone decyphers it.", "Talk2")
    l_1_0:speakLineRight(wizardPortrait, "Silence! Meet your end!", "Angry")
    l_1_0.skipping = false
    local eve = self:getEntity("Eve")
    local christo = self:getEntity("Christo")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:playAnimation(christo, "CastSpell", 1, 45)
    local book = self:getEntity("PrincessChambersCopy")
    book:trapHostEntity()
    l_1_0:sleep(1)
    l_1_0:floatText(christo, "Wait, why is it pulling me in?")
    l_1_0:sleep(0.5)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:playAnimation(christo, "CastSpell", 1, 45)
    l_1_0:floatText(christo, "Stop it!")
    l_1_0:sleep(0.5)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:playAnimation(christo, "CastSpell", 1, 45)
    l_1_0:floatText(eve, "Christo!")
    eve:beExcited(christo)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:playAnimation(christo, "CastSpell", 1, 45)
    l_1_0:sleep(0.25)
    l_1_0:floatText(christo, "My code must have--")
    l_1_0:sleep(0.25)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
    l_1_0:floatText(christo, "--A BUUUUUUUUUUUuuuuuuuug")
    l_1_0:sleep(0.5)
    l_1_0:floatText(bob, "What's a bug?")
    alice:halt(false)
   end)
end

TowerLevel5.onBattleTrigger = function(l_10_0, l_10_1)
  if l_10_0.battleStarted then
    return 
  end
  if l_10_1:is(Alice) then
    l_10_0:startBattle()
  end
end

TowerLevel5.startBattle = function(l_11_0)
  local alice = l_11_0:getAlice()
  local christo = l_11_0:getEntity("Christo")
  l_11_0.battleStarted = true
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
    alice:halt(true)
    self:openDoors(false)
    alice:get(SoundComponent):playCue("SFX/Hackable_Objects/ArmoryGate_Close")
    self:stopCameraShake(l_1_0, 0.5, 0.3)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    christo:setVisible(true)
    l_1_0:playAnimation(christo, "Appear")
    l_1_0:sleep(0.2)
    l_1_0:face(christo, Direction.DIR_N)
    l_1_0:sleep(0.3)
    l_1_0:speakLineRight(wizardPortrait, "So...it has come to this.", "Frown")
    l_1_0:speakLineLeft(alicePortrait, "...", "EyeRoll")
    l_1_0:speakLineLeft(bobPortrait, "Hey.", "Talk")
    l_1_0:speakLineRight(wizardPortrait, "This proves I was right all along.", "Default")
    l_1_0:speakLineRight(wizardPortrait, "You've caused enormous amounts of damage.", "Happy")
    l_1_0:speakLineRight(wizardPortrait, "Consorted with criminals.", "Frown")
    l_1_0:speakLineRight(wizardPortrait, "Broken out of prison.", "Concerned")
    l_1_0:speakLineRight(wizardPortrait, "Detonated explosives in a government building.", "Angelic")
    l_1_0:speakLineRight(wizardPortrait, "And been a horrid jerk.", "Angry")
    l_1_0:speakLineLeft(alicePortrait, "At least there's one thing you're better than us at.", "Snobby")
    l_1_0:speakLineRight(wizardPortrait, "Only I can be trusted with any kind of power.", "Frown")
    l_1_0:speakLineRight(wizardPortrait, "So there's really only one thing to do.", "Angry")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
    l_1_0:face(christo, Direction.DIR_S)
    l_1_0:playAnimation(christo, "Disappear")
    self.battleLine = 1
    christo:startBattle(alice, {576, 84, 1706, 444})
    christo.schemas.DEFEATED:registerValueSetHandler(christo, self.onChristoDefeated, self)
    christo.castFireballEvent:register(self.onChristoCastFireball, self)
    Music:playMusic("Music/Music/WizardTower_Level5")
    alice:halt(false)
   end)
end

TowerLevel5.onChristoDefeated = function(l_12_0, l_12_1, l_12_2)
  local alice = l_12_0:getAlice()
  local christo = l_12_0:getEntity("Christo")
  if l_12_2 then
    christo:stopBattle()
  end
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
    local wizardBatPortrait = l_1_0:addCharacter("Portraits/WizardBat/WizardBat")
    Music:playMusic()
    alice:halt(true)
    l_1_0:sleep(1)
    l_1_0:face(christo, Direction.DIR_S)
    l_1_0:speakLineLeft(alicePortrait, "Do you give up?", "StinkEye")
    l_1_0:speakLineRight(wizardPortrait, "Nnn...you're moderately skilled with explosives...", "Angry")
    l_1_0:speakLineLeft(bobPortrait, "She's learning!", "Excited")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
    l_1_0:playAnimation(christo, "Disappear", 1, 45)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:teleportTo(christo, self:getEntity("Bat locator"))
    l_1_0:playAnimation(christo, "Appear", 1, 45)
    l_1_0:speakLineRight(wizardPortrait, "...but how are your skills...", "Default")
    Music:playMusic("Music/Music/WizardTower_Level5")
    l_1_0.skipping = false
    local quakeCue = MOAIFmodEventMgr.playEvent2D("SFX/Cutscenes/WizardTower_Earthquake")
    self:startCameraShake(l_1_0, 1, 0.5)
    l_1_0:face(christo, Direction.DIR_S)
    local transformCue = christo:get(SoundComponent):playCue("SFX/Characters/Wizard_Bat/WizardBat_Transform")
    l_1_0:playAnimation(christo, "Transform")
    christo:setVisible(false)
    local bat = Entity.create("Content/Game/DourTower/Entities/WizardBat", christo.layer, christo:getPosition())
    l_1_0:playAnimation(bat, "Transform")
    christo:get(SoundComponent):stopCue(transformCue)
    self:stopCameraShake(l_1_0, 2, 0.5)
    quakeCue:stop()
    l_1_0:speakLineRight(wizardBatPortrait, "...AGAINST A BAT?!", "Aah")
    l_1_0:speakLineLeft(alicePortrait, "...probably equally good?", "Talk2")
    l_1_0:speakLineRight(wizardBatPortrait, "I WILL DESTROY YOU!", "Laugh")
    l_1_0.skipping = false
    l_1_0:face(bat, Direction.DIR_E)
    l_1_0:playAnimation(bat, "BreakThroughWall_TakeOff")
    bat:destroy()
    local wallX, wallY = self:getEntity("Wall locator"):getPosition()
    Entity.create("Content/Game/DourTower/Entities/BreakThroughWall", self:getLayerByOrder(0), wallX, wallY)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard_Bat/WizardBat_Destroy_Wall")
    self:getState().WALL_SMASHED = true
    self:getEntity("Hole"):setVisible(true)
    self:stopCameraShake(l_1_0, 1, 1)
    l_1_0:sleep(1)
    l_1_0:speakLineLeft(alicePortrait, "...are we supposed to follow him?", "Talk2")
    l_1_0:speakLineLeft(bobPortrait, "I don't see why we would. He said he was going to destroy us.", "Talk2")
    l_1_0:speakLineLeft(alicePortrait, "Hmm... actually, he might be about to do something REALLY stupid. I'm following him.", "StinkEye")
    l_1_0:speakLineLeft(bobPortrait, "Jumping out of a hole at the top of a tower seems pretty stupid too.", "Talk3")
    l_1_0:speakLineLeft(alicePortrait, "Let's just finish this.", "Suspicious")
    alice:halt(false)
    alice.host:handleRoomExit(alice, "Content/Game/DourTower/Rooms/LibraryRoof")
   end)
end

TowerLevel5.onChristoCastFireball = function(l_13_0)
  local alice = l_13_0:getAlice()
  local christo = l_13_0:getEntity("Christo")
  alice:get(SceneComponent):play(function(l_1_0)
    if self.battleLine == 1 then
      l_1_0:floatText(christo, "FIREBALLS! FOOOOOOSH.")
    else
      if self.battleLine == 2 then
        l_1_0:floatText(christo, "You'll never defeat me!")
      else
        if self.battleLine == 3 then
          l_1_0:floatText(christo, "I'm invincible!")
        else
          if self.battleLine == 4 then
            l_1_0:floatText(christo, "I can't be hacked!")
          else
            if self.battleLine == 5 then
              l_1_0:floatText(christo, "My fireballs do infinite damage!")
            else
              if self.battleLine == 6 then
                l_1_0:floatText(christo, "I'm better than you!")
              else
                if self.battleLine == 7 then
                  l_1_0:floatText(christo, "I rule this kingdom!")
                else
                  if self.battleLine == 8 then
                    l_1_0:floatText(christo, "No one can stop me!")
                  else
                    if self.battleLine == 9 then
                      l_1_0:floatText(christo, "I will end you!")
                    else
                      local randomIndex = math.random(5)
                      if randomIndex == 1 then
                        l_1_0:floatText(christo, "Ha ha!")
                      elseif randomIndex == 2 then
                        l_1_0:floatText(christo, "Tremble before my might!")
                      elseif randomIndex == 3 then
                        l_1_0:floatText(christo, "Just give up!")
                      elseif randomIndex == 4 then
                        l_1_0:floatText(christo, "You suck at this!")
                      elseif randomIndex == 5 then
                        l_1_0:floatText(christo, "You deserve this!")
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    self.battleLine = self.battleLine + 1
   end)
end

TowerLevel5.openDoors = function(l_14_0, l_14_1)
  l_14_0:getEntity("TrapDoor_Lft"):setVisible(not l_14_1)
  l_14_0:getEntity("TrapDoor_Rt"):setVisible(not l_14_1)
  l_14_0:getCollisionArea("TrapDoor 1"):setActive(not l_14_1)
  l_14_0:getCollisionArea("TrapDoor 2"):setActive(not l_14_1)
end

TowerLevel5.makeStairs = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4)
  local gameplayLayer = l_15_0:getLayerByOrder(0)
  for i = 1, l_15_2 do
    local stairsName = l_15_1 .. tostring(i)
    Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, nil, l_15_0.collisionAreasByName[stairsName], l_15_3, l_15_4)
  end
end

TowerLevel5.startScene = function(l_16_0, l_16_1)
  if l_16_1 == "Bonding ritual" then
    l_16_0:bondingRitualReaction()
  elseif l_16_1 == "Lab ruins" then
    l_16_0:labRuinsReaction()
  elseif l_16_1 == "Healed swamp king" then
    l_16_0:healedSwampKingReaction()
  end
end

TowerLevel5.healedSwampKingReaction = function(l_17_0)
  MOAIFmodEventMgr.stopAllEvents()
  Music:playMusic("Music/Music/Wizard_Cutscene_Cue")
  Music:playAmbient("Ambience/Ambience/TowerLevel5_Ambience")
  local christo = l_17_0:getEntity("Christo")
  local eve = l_17_0:getEntity("Eve")
  christo:get(SceneComponent):play(function(l_1_0)
    local evePortrait = l_1_0:addCharacter("Portraits/Eve/Eve")
    local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
    l_1_0:teleportTo(eve, self:getEntity("Window locator"))
    l_1_0:face(eve, Direction.DIR_N)
    l_1_0:teleportTo(christo, self:getEntity("Throne locator"))
    l_1_0:face(christo, Direction.DIR_S)
    l_1_0:sleep(1)
    l_1_0:speakLineLeft(wizardPortrait, "The swamp is probably just a freak accident.  A turtle's probably blocking the flow of the pump.")
    l_1_0:speakLineRight(evePortrait, "Couldn't somebody be out there?")
    l_1_0:speakLineLeft(wizardPortrait, "No, something more would have happened by now.")
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.5)
    local quakeCue = MOAIFmodEventMgr.playEvent2D("SFX/Cutscenes/WizardTower_Earthquake")
    self:insertPostEffect(cameraShake)
    l_1_0:animate(0.5, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.5, 1, l_1_0))
      end)
    l_1_0:animate(1.5, function(l_2_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(1, 0, l_2_0))
      end)
    self:removePostEffect(cameraShake)
    quakeCue:stop()
    eve:beExcited(self:getEntity("Window locator"))
    l_1_0:sleep(1)
    l_1_0:speakLineLeft(wizardPortrait, "Now that is just disrespectful.")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
    l_1_0:playAnimation(christo, "Disappear")
    self:universe().hosts.primary:cutBack("Healed swamp king")
   end)
end

TowerLevel5.labRuinsReaction = function(l_18_0)
  MOAIFmodEventMgr.stopAllEvents()
  Music:playMusic("Music/Music/Wizard_Cutscene_Cue")
  Music:playAmbient("Ambience/Ambience/TowerLevel5_Ambience")
  local christo = l_18_0:getEntity("Christo")
  local eve = l_18_0:getEntity("Eve")
  christo:get(SceneComponent):play(function(l_1_0)
    local evePortrait = l_1_0:addCharacter("Portraits/Eve/Eve")
    local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
    l_1_0:teleportTo(eve, self:getEntity("Window locator"))
    l_1_0:face(eve, Direction.DIR_S)
    l_1_0:teleportTo(christo, self:getEntity("Throne locator"))
    l_1_0:face(christo, Direction.DIR_S)
    l_1_0:sleep(0.5)
    l_1_0:speakLineLeft(wizardPortrait, "I think I'd be cooler with a theme song.", "Happy")
    l_1_0:sleep(0.5)
    l_1_0:speakLineRight(evePortrait, "No.", "Default")
    l_1_0:speakLineLeft(wizardPortrait, "Hm.  It is hard to get cooler than I already am.", "Skeptical")
    l_1_0:speakLineRight(evePortrait, "That's not what I--", "Bored")
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.2)
    local quakeCue = christo:get(SoundComponent):playCue("SFX/Cutscenes/WizardTower_Earthquake", nil, 0.5)
    self:insertPostEffect(cameraShake)
    l_1_0:animate(1, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.2, 0, l_1_0))
      end)
    self:removePostEffect(cameraShake)
    christo:get(SoundComponent):stopCue(quakeCue)
    eve:beExcited(self:getEntity("Window locator"))
    l_1_0:sleep(0.5)
    l_1_0:speakLineRight(evePortrait, "What's happening with the swamp?", "Default")
    l_1_0:speakLineLeft(wizardPortrait, "I set up that whole vat deal.  You remember.", "Unbelieving")
    l_1_0:speakLineRight(evePortrait, "But the swamp looks...healthy.", "Default")
    l_1_0:speakLineLeft(wizardPortrait, "...", "Concerned")
    l_1_0:speakLineLeft(wizardPortrait, "The swamp king should be able to deal with any troublemakers. Still, keep an eye on it.", "Frown")
    l_1_0:speakLineRight(evePortrait, "...", "EvilGrin")
    self:universe().hosts.primary:cutBack("Lab ruins")
   end)
end

TowerLevel5.bondingRitualReaction = function(l_19_0)
  MOAIFmodEventMgr.stopAllEvents()
  Music:playMusic("Music/Music/Wizard_Cutscene_Cue")
  Music:playAmbient("Ambience/Ambience/TowerLevel5_Ambience")
  local christo = l_19_0:getEntity("Christo")
  christo:get(SceneComponent):play(function(l_1_0)
    local evePortrait = l_1_0:addCharacter("Portraits/Eve/Eve")
    local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:teleportTo(christo, self:getEntity("Teleport 1"))
    l_1_0:playAnimation(christo, "Appear")
    l_1_0:speakLineLeft(wizardPortrait, "WI-ZARD! ZAP.", "Angry")
    l_1_0:sleep(0.5)
    l_1_0:speakLineRight(evePortrait, "Eh.", "Bored")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
    l_1_0:playAnimation(christo, "Disappear")
    christo.prop:setVisible(false)
    l_1_0:teleportTo(christo, self:getEntity("Teleport 2"))
    l_1_0:sleep(0.5)
    christo.prop:setVisible(true)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:playAnimation(christo, "Appear")
    l_1_0:speakLineLeft(wizardPortrait, "MAGIC TIME!  BOOM.", "Angry")
    l_1_0:sleep(1)
    l_1_0:speakLineRight(evePortrait, "...still eh.", "Default")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
    l_1_0:playAnimation(christo, "Disappear")
    christo.prop:setVisible(false)
    l_1_0:teleportTo(christo, self:getEntity("Teleport 4"))
    l_1_0:sleep(0.5)
    christo.prop:setVisible(true)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:playAnimation(christo, "Appear")
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.2)
    local quakeCue = christo:get(SoundComponent):playCue("SFX/Cutscenes/WizardTower_Earthquake", nil, 0.5)
    self:insertPostEffect(cameraShake)
    l_1_0:speakLineLeft(wizardPortrait, "FIREBALLS!  FOOOOOOSH.", "Angry")
    l_1_0:animate(0.5, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.2, 0, l_1_0))
      end)
    self:removePostEffect()
    christo:get(SoundComponent):stopCue(quakeCue)
    l_1_0:speakLineLeft(wizardPortrait, "Oh yeah, THAT was an entrance.")
    l_1_0:speakLineRight(evePortrait, "I think that came from outside.")
    l_1_0:speakLineLeft(wizardPortrait, "Pssh.")
    self:universe().hosts.primary:cutBack("Bonding ritual")
   end)
end

return TowerLevel5

