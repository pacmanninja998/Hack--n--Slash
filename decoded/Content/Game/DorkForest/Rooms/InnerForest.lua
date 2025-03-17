-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Rooms\InnerForest.lua 

local Class = require("Class")
local InnerForest = require("Room").classFromLayout("Content/Game/DorkForest/Layouts/InnerForest", "InnerForest", "Content/Game/Global/Rooms/GameRoom")
local SceneComponent = require("Components.SceneComponent")
local InventoryComponent = require("Components.InventoryComponent")
local Direction = require("Direction")
local Entity = require("Entity")
local Music = require("Music")
local Item = require("Item")
local Shader = require("Shader")
local Math = require("DFCommon.Math")
local CorruptedTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/CorruptedTurtle")
local TurtleSpawner = Entity.cache:load("Content/Game/DorkForest/Entities/TurtleSpawner")
local SwampTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/SwampTurtle")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
InnerForest.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("CentralForestExit", "Content/Game/DorkForest/Rooms/CentralForest", "InnerForestExit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  l_1_0.leftStairs = Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Left Stairs", l_1_0.collisionAreasByName["Left Stairs"], Direction.DIR_E, 0.3)
  l_1_0.rightStairs = Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Right Stairs", l_1_0.collisionAreasByName["Right Stairs"], Direction.DIR_W, 0.3)
  require("Music"):playMusic("Music/Music/BehemothFight_Cue1", false)
  Music:playAmbient("Ambience/Ambience/CentralForest_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  local leftSpawner = l_1_0:getEntity("TurtleSpawner (left)")
  leftSpawner.SPAWN_BEHAVIOR = {{TYPE = "MOVE", TILES = 6}}
  leftSpawner.MAX_ACTIVE_TURTLES = 3
  leftSpawner.SECONDS_BETWEEN_SPAWNS = 5
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/InnerForest_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/InnerForest_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/InnerForest_ShadowGradient"
  l_1_0.timeOfDayRampMagnitude = 1.7
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0:enableTimeOfDay()
  l_1_0:enableWater()
  l_1_0:getEntity("SwampKing").clearCorruptionEvent:register(l_1_0.onClearCorruption, l_1_0)
  l_1_0.fadeEvent:register(l_1_0.onFade, l_1_0)
end

InnerForest.onFade = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == l_2_0.FADE_IN and not l_2_2 then
    local alice = l_2_0:getAlice()
    do
      local bob = l_2_0:getBob()
      alice:get(SceneComponent):play(function(l_1_0)
        if not self:getState()["Healed swamp king"] then
          local alicePortrait = l_1_0:addAlicePortrait()
          local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
          alice:halt(true)
          l_1_0:speakLineRight(bobPortrait, "Whoa... that's the swamp king. He's... angrier than I remember.", "Sad")
          l_1_0:speakLineLeft(alicePortrait, "He's probably just corrupted like the others.", "Snobby")
          l_1_0:speakLineRight(bobPortrait, "...I'm gonna hang back and let you handle this one, Red.", "Sly")
          bob:beExcited(self:getEntity("Bob appearance locator"))
          l_1_0:sleep(0.5)
          bob.prop:setVisible(false)
          alice:halt(false)
        end
         end)
    end
  end
end

InnerForest.onClearCorruption = function(l_3_0)
  for name,entity in pairs(l_3_0.entitiesByName) do
    if entity:is(CorruptedTurtle) or entity:is(SwampTurtle) then
      entity:destroy()
      for name,entity in (for generator) do
      end
      if entity:is(TurtleSpawner) then
        entity:setActive(fase)
      end
    end
    do
      local alice = l_3_0:getAlice()
      alice:get(SceneComponent):play(function(l_1_0)
      alice:halt(true)
      local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
      cameraShake:setFragmentUniformFloat("shaderDuration", 0.2)
      local quakeCue = MOAIFmodEventMgr.playEvent2D("SFX/Cutscenes/WizardTower_Earthquake")
      self:insertPostEffect(cameraShake)
      l_1_0:animate(2, function(l_1_0)
        cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.2, 1, l_1_0))
         end)
      if not self:getState()["Healed swamp king"] then
        self:getState()["Healed swamp king"] = true
        alice.host:cutToWizard("Healed swamp king")
        self:removePostEffect(cameraShake)
      end
      quakeCue:stop()
      end)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

InnerForest.startScene = function(l_4_0, l_4_1)
  if l_4_1 == "Healed swamp king" then
    l_4_0:finishHealedSwampKing()
  end
end

InnerForest.finishHealedSwampKing = function(l_5_0)
  local alice = l_5_0:getAlice()
  local bob = l_5_0:getBob()
  local x, y = l_5_0:getEntity("Wizard appearance locator"):getPosition()
  local christo = Entity.create("Content/Game/Global/Entities/Christo", l_5_0:getLayerByOrder(0), x, y, "Christo")
  local eve = Entity.create("Content/Game/Global/Entities/RedSprite", l_5_0:getLayerByOrder(0), x, y, "Eve")
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local evePortrait = l_1_0:addCharacter("Portraits/Eve/Eve")
    local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
    bob.prop:setVisible(false)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:playAnimation(christo, "Appear")
    l_1_0:speakLineRight(wizardPortrait, "WIZARD!  BOO!", "Angry")
    l_1_0:speakLineLeft(alicePortrait, "Wah!", "FreakedOut")
    l_1_0:speakLineRight(wizardPortrait, "You better be scared.  I had this swamp just how I liked it.", "Angry")
    l_1_0:speakLineLeft(alicePortrait, "You just startled me.", "Spooked")
    l_1_0:speakLineRight(wizardPortrait, "Oh look!  The swamp king is nice now.  Yeah, that's super useful.", "Frown")
    l_1_0:speakLineLeft(alicePortrait, "Why twist the swamp like this?", "Angry")
    l_1_0:speakLineRight(wizardPortrait, "It keeps everybody safe!  Like that sword you stole used to.", "Default")
    l_1_0:speakLineLeft(alicePortrait, "Safe?!  People won't even leave the village!", "Laughing")
    l_1_0:speakLineRight(wizardPortrait, "It's safe at the castle.  ...and in the village.  But not here, and especially not now.", "Frown")
    l_1_0:speakLineLeft(alicePortrait, "...", "Angry")
    l_1_0:teleportTo(bob, self:getEntity("Bob appearance locator"))
    bob.prop:setVisible(true)
    bob:beExcited(alice)
    l_1_0:sleep(1)
    l_1_0:speakLineLeft(bobPortrait, "Phew!  That was awesome!  Oh hey, buddy, who's your red friend?", "Sing")
    l_1_0:speakLineRight(wizardPortrait, "A red sprite?  Are those two bonded?!", "Shocked")
    l_1_0:speakLineRight(evePortrait, "Yes.", "EvilGrin")
    l_1_0:speakLineLeft(alicePortrait, "Your sprite is red--", "Spooked")
    l_1_0:speakLineRight(wizardPortrait, "You're not going to ruin everything.  I won't let you.", "Angry")
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
    l_1_0:playAnimation(christo, "Disappear", 1, 45)
    christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
    l_1_0:teleportTo(christo, alice)
    l_1_0:playAnimation(christo, "Appear", 1, 45)
    christo:get(SoundComponent):playCue("SFX/Cutscenes/Wizard_GrabAlice", nil, 0.5)
    l_1_0:playAnimation(christo, "CastSpell")
    l_1_0:speakLineLeft(bobPortrait, "Hey now, that doesn't seem very friendly--", "Sad")
    l_1_0:speakLineLeft(alicePortrait, "Let go!", "Laughing")
    l_1_0:speakLineRight(wizardPortrait, "You're coming with me.", "Angry")
    alice.state.trapped = true
    alice.host:handleRoomExit(alice, "Content/Game/DweebKeep/Rooms/GeneralCells")
   end)
end

return InnerForest

