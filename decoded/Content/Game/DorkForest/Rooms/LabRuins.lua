-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Rooms\LabRuins.lua 

local Class = require("Class")
local LabRuins = require("Room").classFromLayout("Content/Game/DorkForest/Layouts/LabRuins", "LabRuins", "Content/Game/Global/Rooms/GameRoom")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
local PlatformComponent = require("Components.PlatformComponent")
local Entity = require("Entity")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local Music = require("Music")
local Shader = require("Shader")
local Direction = require("Direction")
local Math = require("DFCommon.Math")
LabRuins.onInit = function(l_1_0)
  local finalPassword = "wizardrules"
  local startPassword = ""
  if l_1_0:universe().state.state.hidePasswordFeedback then
    finalPassword = "wizardrulez"
  end
  local passwordEntry = l_1_0.entitiesByName.PortRock
  if passwordEntry then
    for i = 1, string.len(finalPassword) do
      local passCharChecker = l_1_0.entitiesByName["PassCharChecker " .. tostring(i)]
      if passCharChecker then
        passCharChecker:setChar(string.sub(finalPassword, i, i))
        passwordEntry:setCharChecker(i, passCharChecker)
      end
    end
    passwordEntry:checkPassword(true)
  end
  l_1_0:defineTreasureChestScene("TreasureChest", l_1_0.onChestOpen, l_1_0, "Opening_Note")
  Music:playMusic(nil)
  l_1_0:defineMusicTrigger("Music trigger", "Music/Music/LabRuins_Cue1")
  Music:playAmbient("Ambience/Ambience/CentralForest_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/LabRuins_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/LabRuins_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/LabRuins_ShadowGradient"
  l_1_0.timeOfDayRampMagnitude = 1.7
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0:enableTimeOfDay()
  l_1_0:enableWater()
  l_1_0.corruptedWaterSourcePoint = l_1_0.entitiesByName["SFX/SourcePoints/SpookyPath_Corrupted_Water"]
  local healAmount = l_1_0:universe().state.state.forestHealAmount
  l_1_0:setHealAmount(healAmount)
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 2 do
    local platformName = "StoneFloor" .. tostring(i)
    local platformArea = l_1_0:getCollisionArea(platformName)
    Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, platformName, platformArea, nil, true, PlatformComponent.SOUND_MAT_STONE)
  end
  for i = 1, 2 do
    local name = "Water " .. i
    Entity.create("Content/Game/Global/Entities/Water", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  local stairsW = Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs W", l_1_0.collisionAreasByName["Stairs W"], Direction.DIR_W, 0.5)
  stairsW:get(PlatformComponent).soundMaterial = PlatformComponent.SOUND_MAT_STONE
  Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, "WoodFloor1", (l_1_0:getCollisionArea("WoodFloor1")), nil, true, PlatformComponent.SOUND_MAT_WOOD)
  l_1_0.defaultSoundMat = PlatformComponent.SOUND_MAT_SAND
  if healAmount >= 0 then
    l_1_0.corruptedWaterSourcePoint.cue:stop()
  end
end

LabRuins.onAliceCreated = function(l_2_0, l_2_1)
  Class.super(LabRuins).onAliceCreated(l_2_0, l_2_1)
  if not HackDemo or l_2_1.host.extraDemoPuzzle then
    l_2_0:defineCollisionExit("SleepingSwampExit", "Content/Game/DorkForest/Rooms/SleepingSwamp", "LabRuinsExit")
  end
end

LabRuins.setHealAmount = function(l_3_0, l_3_1)
  if not l_3_0:getLayerByName("Water") then
    return 
  end
  l_3_0:universe().state.state.forestHealAmount = l_3_1
  if l_3_1 >= 0 then
    if l_3_0.corruptedWaterShader then
      local layer = l_3_0:getLayerByName("Water")
      do
        for _,chunkset in ipairs(layer.chunksets) do
          chunkset:resetShader()
        end
        l_3_0.corruptedWaterShader = nil
      end
    end
    if not l_3_0:getState()["Shown Wizard Cutscene"] then
      local alice = l_3_0:getAlice()
      if alice then
        alice:get(SceneComponent):play(function(l_1_0)
        local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
        local quakeCue = MOAIFmodEventMgr.playEvent2D("SFX/Cutscenes/WizardTower_Earthquake")
        cameraShake:setFragmentUniformFloat("shaderDuration", 0.05)
        alice:get(SoundComponent):playCue("SFX/Objects/CorruptionMachine_Shutdown", nil, 0.5)
        self:insertPostEffect(cameraShake)
        alice:halt(true)
        l_1_0:animate(2, function(l_1_0)
          cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.05, 0.8, l_1_0))
            end)
        alice.host:cutToWizard("Lab ruins")
        quakeCue:stop()
        self:removePostEffect()
        self:getState()["Shown Wizard Cutscene"] = true
         end)
      end
    end
    if l_3_0.corruptedWaterSourcePoint.cue then
      l_3_0.corruptedWaterSourcePoint.cue:stop()
    elseif not l_3_0.corruptedWaterShader then
      local layer = l_3_0:getLayerByName("Water")
      l_3_0.corruptedWaterShader = Shader.create("Content/Game/Global/Shaders/CorruptedWater")
      for _,chunkset in ipairs(layer.chunksets) do
        chunkset:setCurrentShader(l_3_0.corruptedWaterShader)
      end
      if not l_3_0.corruptedWaterSourcePoint then
        l_3_0.corruptedWaterSourcePoint = l_3_0.entitiesByName["SFX/SourcePoints/SpookyPath_Corrupted_Water"]
      end
      l_3_0.corruptedWaterSourcePoint:restartSound()
    end
  end
  if l_3_0.corruptedWaterShader then
    local corruptionLevel = math.max(0, math.min(999, -l_3_1) * 0.001)
    l_3_0.corruptedWaterShader:setFragmentUniformFloat("CorruptionIntensity", corruptionLevel)
  end
end

LabRuins.startScene = function(l_4_0, l_4_1)
  if l_4_1 == "Lab ruins" then
    l_4_0:finishLabRuins()
  end
end

LabRuins.finishLabRuins = function(l_5_0)
  local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
  local alice = l_5_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    if HackDemo then
      l_1_0:speakLineRight(bobPortrait, "Our heroes have valiantly restored health to the forest.", "Sing")
      l_1_0:speakLineLeft(alicePortrait, "Why are you talking like that?", "Spooked")
      l_1_0:speakLineRight(bobPortrait, "But their adventure is far from finished. Mystery and danger await.", "Sad")
      l_1_0:speakLineLeft(alicePortrait, "$BOB?", "Surprised")
      l_1_0:speakLineRight(bobPortrait, "What lies on the other side of the swamp?", "Sing")
      l_1_0:speakLineLeft(alicePortrait, "$BOB, what is going on right now?", "FreakedOut")
      l_1_0:speakLineRight(bobPortrait, "Can $ALICE and $BOB uncover the wizard's nefarious scheme?", "Sad")
      l_1_0:speakLineLeft(alicePortrait, "$BOB! What's with you? We haven't even met a wizard.", "Angry")
      l_1_0:speakLineRight(bobPortrait, "Find out in...", "Excited")
      l_1_0:speakLineRight(bobPortrait, "The full version of Hack 'n' Slash! Coming soon to a digital retailer temporally near you!", "Sing")
      l_1_0:speakLineLeft(alicePortrait, "I give up.", "Snobby")
      l_1_0:speakLineRight(bobPortrait, "...", "Sly")
      alice.host.completeTheGame = true
    else
      l_1_0:speakLineRight(bobPortrait, "Aw, man...", "Sad")
      l_1_0:speakLineLeft(alicePortrait, "What are you sad about? I'm pretty sure we just healed the swamp.", "Snobby")
      l_1_0:speakLineRight(bobPortrait, "Doesn't that mean our adventure is over?", "Sad")
      MOAIFmodEventMgr.playEvent2D("SFX/Characters/Behemoth/Behemoth_Roar")
      self:insertPostEffect(cameraShake)
      l_1_0:animate(0.5, function(l_1_0)
        cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0, 0.2, l_1_0))
         end)
      l_1_0:animate(1.5, function(l_2_0)
        cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.2, 0, l_2_0))
         end)
      self:removePostEffect(cameraShake)
      l_1_0:speakLineLeft(alicePortrait, "Um, $BOB... what's on the other side of the swamp?")
      l_1_0:speakLineRight(bobPortrait, "Let's find out!")
      MOAIFmodEventMgr.playEvent2D("SFX/Characters/Behemoth/Behemoth_RoarAngry")
      self:insertPostEffect(cameraShake)
      l_1_0:animate(0.5, function(l_3_0)
        cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0, 0.2, l_3_0))
         end)
      l_1_0:animate(1.5, function(l_4_0)
        cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.2, 0, l_4_0))
         end)
      self:removePostEffect(cameraShake)
      l_1_0:speakLineLeft(alicePortrait, "It sounds kinda dangerous over there.")
      l_1_0:speakLineRight(bobPortrait, "Yeah!  It's an adventure!")
      l_1_0:speakLineLeft(alicePortrait, "Heh. Yeah.")
      alice:halt(false)
    end
   end)
end

LabRuins.onChestOpen = function(l_6_0, l_6_1, l_6_2)
  local alicePortrait = l_6_1:addAlicePortrait()
  local bobPortrait = l_6_1:addCharacter("Portraits/Bob/Bob")
  l_6_1:speakLineLeft(alicePortrait, "There's a note in here.", "Default4")
  l_6_2:get(InventoryComponent):insertItem("Content/Game/DorkForest/Items/VatsPasswordNote")
  l_6_1:speakLineRight(bobPortrait, "Maybe it's the treasure map that leads to this chest!", "Excited")
  l_6_1:speakLineLeft(alicePortrait, "Wait, why would-- nevermind.", "Talk2")
end

return LabRuins

