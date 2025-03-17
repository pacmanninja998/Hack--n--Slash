-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\WardenEntrance.lua 

local Class = require("Class")
local Room = require("Room")
local GameRoom = Room.cache:load("Content/Game/Global/Rooms/GameRoom")
local WardenEntrance = Room.classFromLayout("Content/Game/DweebKeep/Layouts/WardenEntrance", "WardenEntrance", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local Music = require("Music")
local Direction = require("Direction")
WardenEntrance.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("SecretTunnel exit", "Content/Game/DweebKeep/Rooms/SecretTunnel", "WardenEntrance exit")
  l_1_0:defineCollisionExit("WardenEntranceHallway exit", "Content/Game/DweebKeep/Rooms/WardenEntranceHallway", "North exit")
  require("Music"):playMusic("Music/Music/Warden_Cue1", false)
  Music:playAmbient("Ambience/Ambience/Castle_Ambience2")
  Music:setReverb("Reflective")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  l_1_0.warden = l_1_0:getEntity("Warden")
  l_1_0.warden:get(InteractionComponent):setEnabled(false)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 1", l_1_0.collisionAreasByName["Stairs 1"], Direction.DIR_W, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 2", l_1_0.collisionAreasByName["Stairs 2"], Direction.DIR_E, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 3", l_1_0.collisionAreasByName["Stairs 3"], Direction.DIR_N, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 4", l_1_0.collisionAreasByName["Stairs 4"], Direction.DIR_N, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 5", l_1_0.collisionAreasByName["Stairs 5"], Direction.DIR_N, 0.8)
  l_1_0:defineLogicTrigger("Warden trigger", l_1_0.onWardenTrigger, l_1_0)
  l_1_0.hsvTint = {0.083, -0.111, 0}
end

WardenEntrance.onWardenTrigger = function(l_2_0)
  local alice = l_2_0:getAlice()
  local sceneComponent = alice:get(SceneComponent)
  sceneComponent:play(function(l_1_0)
    alice:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local wardenPortrait = l_1_0:addCharacter("Portraits/Warden/Warden")
    local playerName = alice.state.name
    local isPrisoner = false
    for i,prisonerName in ipairs(self:universe().state.state.prisoners) do
      if prisonerName == playerName then
        isPrisoner = true
    else
      end
    end
    if isPrisoner then
      l_1_0:speakLineRight(wardenPortrait, "Halt! Let me see your names...")
      l_1_0:speakLineLeft(alicePortrait, "Huh?", "Spooked")
      l_1_0:speakLineRight(wardenPortrait, "Hmm... <c:72FEFDFF>$ALICE</>...")
      l_1_0:speakLineRight(wardenPortrait, "Your name's in the prisoner roster! And your photo's right next to it!")
      l_1_0:speakLineLeft(alicePortrait, "Uh oh.", "Surprised")
      l_1_0:speakLineRight(wardenPortrait, "... and <c:72FEFDFF>$BOB</>. Your name isn't in the roster. Move along.")
      l_1_0:speakLineLeft(bobPortrait, "Oh, come on...", "Sad")
      l_1_0:speakLineLeft(alicePortrait, "He's with me.", "Angry")
      l_1_0:speakLineRight(wardenPortrait, "Well then! You two are in big trouble. I'm putting you back in your cell!")
      self.warden.AGGRESSIVE = true
      self.warden.targetRef:setEntity(alice)
    else
      l_1_0:speakLineRight(wardenPortrait, "Halt! Let me see your names...")
      l_1_0:speakLineLeft(alicePortrait, "Huh?", "Spooked")
      l_1_0:speakLineRight(wardenPortrait, "Hmm... <c:72FEFDFF>$ALICE</>... not in the roster...")
      l_1_0:speakLineLeft(alicePortrait, "Phew.")
      l_1_0:speakLineRight(wardenPortrait, "... <c:72FEFDFF>$BOB</>... not in the roster...")
      l_1_0:speakLineLeft(bobPortrait, "Ha! Of course not.")
      l_1_0:speakLineRight(wardenPortrait, "So then. What's your business here?")
      l_1_0:speakLineLeft(alicePortrait, "Well! Er...", "Spooked")
      l_1_0:speakLineRight(wardenPortrait, "Did maintenance send you? Those sounds coming from the sewer are just getting weirder.")
      l_1_0:speakLineLeft(alicePortrait, "...yes. We are absolutely from maintenance.", "Surprised")
      l_1_0:speakLineLeft(bobPortrait, "Obviously.")
      l_1_0:speakLineRight(wardenPortrait, "Well get in there then! All that racket is making it impossible to nap.")
    end
    alice:halt(false)
   end)
end

return WardenEntrance

