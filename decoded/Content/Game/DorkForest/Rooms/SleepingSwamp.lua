-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Rooms\SleepingSwamp.lua 

local Class = require("Class")
local SleepingSwamp = require("Room").classFromLayout("Content/Game/DorkForest/Layouts/SleepingSwamp", "SleepingSwamp", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local SwampTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/SwampTurtle")
local Direction = require("Direction")
local SceneComponent = require("Components.SceneComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local LogoComponent = require("Components.LogoComponent")
local Music = require("Music")
local InteractionComponent = require("Components.InteractionComponent")
SleepingSwamp.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("LabRuinsExit", "Content/Game/DorkForest/Rooms/LabRuins", "SleepingSwampExit")
  if not HackDemo then
    l_1_0:defineCollisionExit("CentralForestExit", "Content/Game/DorkForest/Rooms/CentralForest", "SleepingSwampExit")
  end
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 24 do
    local name = "Water " .. i
    Entity.create("Content/Game/Global/Entities/Water", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  local nappingTurtle = l_1_0:getEntity("SwampTurtle (napping)")
  nappingTurtle.IDLE_BEHAVIOR = {{TYPE = "SLEEP", SECONDS = 1}}
  local napStump = l_1_0:getEntity("Stump (napping turtle)")
  napStump:attachEntity(nappingTurtle)
  local physics = nappingTurtle:get(PhysicsComponent)
  physics.isSensor = true
  physics.fixture:setSensor(true)
  Music:playAmbient("Ambience/Ambience/SleepingSwamp_Ambience")
  Music:setReverb("ExteriorSlap")
  for i = 1, 23 do
    local name = "SwampTurtle (sleeping " .. i .. ")"
    l_1_0:getEntity(name).IDLE_BEHAVIOR = {{TYPE = "SLEEP", SECONDS = 0.5}}
  end
  l_1_0:getEntity("SwampTurtle (patrolling 1)").IDLE_BEHAVIOR = {{TYPE = "IDLE", SECONDS = 2}, {TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 1}, {TYPE = "IDLE", SECONDS = 2}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 1}, {TYPE = "IDLE", SECONDS = 0.5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "TURN", DIRECTION = "right"}}
  l_1_0:getEntity("SwampTurtle (patrolling 2)").IDLE_BEHAVIOR = {{TYPE = "MOVE", TILES = 3}, {TYPE = "IDLE", SECONDS = 2}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "TURN", DIRECTION = "right"}}
  l_1_0:getEntity("SwampTurtle (patrolling 3)").IDLE_BEHAVIOR = {{TYPE = "MOVE", TILES = 1}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "TURN", DIRECTION = "right"}}
  local giantSprite = l_1_0:getEntity("GiantSprite")
  giantSprite:get(InteractionComponent).interactEvent:register(l_1_0.onGiantSpriteInteract, l_1_0)
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/SleepingSwamp_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/SleepingSwamp_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/SleepingSwamp_ShadowGradient"
  l_1_0.timeOfDayRampMagnitude = 1.7
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0.defaultSoundMat = require("Components.PlatformComponent").SOUND_MAT_SAND
  l_1_0:enableTimeOfDay()
  l_1_0:enableWater()
end

SleepingSwamp.onBobCreated = function(l_2_0, l_2_1)
  Music:playMusic(nil)
  Class.super(SleepingSwamp).onBobCreated(l_2_0, l_2_1)
  if l_2_1 then
    l_2_1.stumpOccupiedEvent:register(l_2_0.onStumpOccupied, l_2_0)
    l_2_1.singingEventTime = 1
    l_2_1.singingEvent:register(l_2_0.onBobSing, l_2_0)
  end
end

SleepingSwamp.onGiantSpriteInteract = function(l_3_0, l_3_1)
  l_3_1:get(SceneComponent):play(function(l_1_0)
    interactor:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local giantSpritePortrait = l_1_0:addCharacter("Portraits/QueenFairy/QueenFairy")
    if not interactor.host.queenSpriteGaveHearts then
      l_1_0:speakLineLeft(alicePortrait, "Whoa! Hey there.", "Spooked")
      l_1_0:speakLineRight(giantSpritePortrait, "Hello, human. I'm pretty relaxed today, so I'll give you some hearts.")
      interactor.host.maxHealth = interactor.host.maxHealth + 10
      interactor.host.queenSpriteGaveHearts = true
    else
      l_1_0:speakLineLeft(alicePortrait, "How's it going?", "Excited")
      l_1_0:speakLineRight(giantSpritePortrait, "I already gave you some hearts. Don't be greedy. I've got a nice chill mood going.")
    end
    interactor:halt(false)
   end)
end

SleepingSwamp.onStumpOccupied = function(l_4_0, l_4_1)
  if not l_4_0:getState().SceneSingingIntroduction then
    local alice = l_4_0:getAlice()
    do
      alice:halt(true)
      local sceneComponent = alice:get(SceneComponent)
      sceneComponent:play(function(l_1_0)
        self:getState().SceneSingingIntroduction = true
        local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
        local alicePortrait = l_1_0:addAlicePortrait()
        l_1_0:speakLineRight(bobPortrait, "Hey!  Get off the stage!", "Sing")
        l_1_0:speakLineLeft(alicePortrait, "What?  A stage?  Where?", "Spooked")
        l_1_0:speakLineRight(bobPortrait, "He's a terrible mime.  TURTLE!  MOVE OVER!  MY TURN!", "Angry")
        l_1_0:speakLineLeft(alicePortrait, "$BOB!  It's a turtle on a stump!  ...and what do you mean, your turn?", "Snobby")
        l_1_0:speakLineRight(bobPortrait, "I feel musical.", "Sing")
        l_1_0:speakLineLeft(alicePortrait, "There's another stump over there in the water.", "Default")
        l_1_0:speakLineRight(bobPortrait, "Ooh!  You'll love Aria in 56k!", "Excited")
        alice:halt(false)
         end)
    end
  end
end

SleepingSwamp.onBobSing = function(l_5_0, l_5_1)
  if not l_5_0:getState().SceneAnnoyingSinging then
    local alice = l_5_0:getAlice()
    do
      alice:halt(true)
      local sceneComponent = alice:get(SceneComponent)
      sceneComponent:play(function(l_1_0)
        self:getState().SceneAnnoyingSinging = true
        local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
        local alicePortrait = l_1_0:addAlicePortrait()
        l_1_0:speakLineLeft(alicePortrait, "Oh bits!  My ears!", "Laughing")
        l_1_0:speakLineLeft(bobPortrait, "Feels good, right?  It gets better!", "Sing")
        l_1_0:speakLineLeft(alicePortrait, "You're scaring the turtles!", "Laughing")
        l_1_0:speakLineRight(bobPortrait, "Not opera fans, eh? It's okay. It's an acquired taste.", "Sing")
        l_1_0:speakLineLeft(alicePortrait, "...", "Angry")
        alice:halt(false)
         end)
    end
  end
end

return SleepingSwamp

