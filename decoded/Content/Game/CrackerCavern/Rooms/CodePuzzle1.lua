-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CodePuzzle1.lua 

local Class = require("Class")
local CodeTrap = require("Room").cache:load("Content/Game/CrackerCavern/Rooms/CodeTrap")
local CodePuzzle1 = Class.create(CodeTrap, "CodePuzzle1")
local SceneComponent = require("Components.SceneComponent")
CodePuzzle1.onInit = function(l_1_0)
  Class.super(CodePuzzle1).onInit(l_1_0)
  l_1_0:defineCollisionExit("West exit", "Content/Game/CrackerCavern/Rooms/CaveLab", "CaveLab exit")
  l_1_0:defineCollisionExit("East exit", "Content/Game/CrackerCavern/Rooms/CodePuzzle2", "West exit")
  l_1_0:getEntity("Port 1").VALUE = 2
  l_1_0:getEntity("Port 2"):destroy()
  l_1_0:getEntity("Port 3"):destroy()
  l_1_0:getEntity("Port 4"):destroy()
  l_1_0:getEntity("UnhackableGateDoor (north)"):setLabelText("4")
  l_1_0:getEntity("Signpost"):setFunction(l_1_0.computeDoorKey, "computeDoorKey")
  l_1_0:getEntity("Signpost").interactEndEvent:register(l_1_0.onSignpostInteractEnd, l_1_0)
end

CodePuzzle1.computeDoorKey = function(l_2_0)
  return l_2_0.VALUE + 1
end

CodePuzzle1.onTrapTrigger = function(l_3_0)
  Class.super(CodePuzzle1).onTrapTrigger(l_3_0)
  l_3_0.locked = true
  local alice = l_3_0:getAlice()
  alice.state.beganCodePuzzles = true
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    alice:halt(true)
    l_1_0:sleep(0.5)
    l_1_0:speakLineRight(bobPortrait, "Trapped again! I thought this cave looked familiar.", "OMG")
    l_1_0:speakLineLeft(alicePortrait, "You didn't see this coming?", "NonPlussed")
    l_1_0:speakLineRight(bobPortrait, "Nope.", "Judgemental")
    l_1_0:speakLineLeft(alicePortrait, "$BOB... we've been trapped in this same type of cave several times now.", "Talk2")
    l_1_0:speakLineRight(bobPortrait, "I was kidding! Let's figure out some algorithm stuff!", "Sing")
    alice:halt(false)
   end)
end

CodePuzzle1.onSignpostInteractEnd = function(l_4_0, l_4_1)
  local alice = l_4_0:getAlice()
  local alicePortrait = l_4_1:addAlicePortrait()
  local bobPortrait = l_4_1:addCharacter("Portraits/Bob/Bob")
  alice:halt(true)
  if not alice.state.discussedAlgorithms then
    alice.state.discussedAlgorithms = true
    l_4_1:speakLineLeft(alicePortrait, "\"computeDoorKey\"-- I guess that's the name of the algorithm.", "Talk2")
    l_4_1:speakLineRight(bobPortrait, "Does all that stuff describe the algorithm?", "OMG")
    l_4_1:speakLineLeft(alicePortrait, "It's a little impenetrable.", "Worried")
    l_4_1:speakLineRight(bobPortrait, "Well, we're not algorithmicists.", "Judgemental")
    l_4_1:speakLineLeft(alicePortrait, "Are you getting anything from it?", "Default4")
    l_4_1:speakLineRight(bobPortrait, "Hmm... ADD is probably addition, right?", "Excited")
    l_4_1:speakLineLeft(alicePortrait, "\"Port\" is listed in \"arguments.\" That's probably that port outside the cell.", "EyeRoll")
    l_4_1:speakLineRight(bobPortrait, "Hah! Figures we wouldn't be able to get to it from in here.", "Silly")
    l_4_1:speakLineLeft(alicePortrait, "Well, I'm guessing we need to change the algorithm to output the key to the door.", "Nerdy")
    l_4_1:speakLineRight(bobPortrait, "We gotta use that loupe! That's a fun word to say. Loupe.", "Judgemental")
  else
    l_4_1:speakLineLeft(alicePortrait, "Any new insights?", "Loupe")
    l_4_1:speakLineRight(bobPortrait, "Nope. Wait... do you think ADD could stand for Alogrithm Destruction Device? Maybe we shouldn't touch it.", "Sad")
    l_4_1:speakLineLeft(alicePortrait, "I think you're thinking about it too hard.", "Talk")
    l_4_1:speakLineRight(bobPortrait, "Well, then you can be the one to touch it.", "Judgemental")
  end
  alice:halt(false)
end

CodePuzzle1.tick = function(l_5_0)
  Class.super(CodePuzzle1).tick(l_5_0)
  if l_5_0.locked and l_5_0.computeDoorKey(l_5_0:getEntity("Port 1")) == 4 then
    l_5_0:getEntity("UnhackableGateDoor (north)").OPEN = true
    l_5_0:getEntity("UnhackableGateDoor (south)").OPEN = true
    l_5_0.locked = false
  end
end

return CodePuzzle1

