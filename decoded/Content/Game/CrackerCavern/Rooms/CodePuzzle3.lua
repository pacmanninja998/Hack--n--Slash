-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CodePuzzle3.lua 

local Class = require("Class")
local CodeTrap = require("Room").cache:load("Content/Game/CrackerCavern/Rooms/CodeTrap")
local CodePuzzle3 = Class.create(CodeTrap, "CodePuzzle3")
local SceneComponent = require("Components.SceneComponent")
CodePuzzle3.DOOR_KEY = "impossible"
CodePuzzle3.onInit = function(l_1_0)
  Class.super(CodePuzzle3).onInit(l_1_0)
  l_1_0:defineCollisionExit("West exit", "Content/Game/CrackerCavern/Rooms/CodePuzzle2", "East exit")
  l_1_0:defineCollisionExit("East exit", "Content/Game/CrackerCavern/Rooms/CaveStash", "CaveLab exit")
  l_1_0:getEntity("Port 1").VALUE = 9999
  l_1_0:getEntity("Port 2"):destroy()
  l_1_0:getEntity("Port 3"):destroy()
  l_1_0:getEntity("Port 4"):destroy()
  l_1_0:getEntity("UnhackableGateDoor (north)"):setLabelText(l_1_0.DOOR_KEY)
  l_1_0:getEntity("Signpost"):setFunction(l_1_0.computeDoorKey, "computeDoorKey")
  l_1_0:getEntity("Signpost").interactEndEvent:register(l_1_0.onSignpostInteractEnd, l_1_0)
end

CodePuzzle3.computeDoorKey = function(l_2_0)
  if l_2_0.VALUE * 0 > 0 then
    return "impossible"
  end
end

CodePuzzle3.onSignpostInteractEnd = function(l_3_0, l_3_1)
  local alice = l_3_0:getAlice()
  local alicePortrait = l_3_1:addAlicePortrait()
  local bobPortrait = l_3_1:addCharacter("Portraits/Bob/Bob")
  alice:halt(true)
  l_3_1:speakLineLeft(alicePortrait, "LT? MUL?", "Talk2")
  l_3_1:speakLineRight(bobPortrait, "I've got nothing. I bet we can figure out how it works, though.", "Talk")
  alice:halt(false)
end

CodePuzzle3.onTrapTrigger = function(l_4_0)
  Class.super(CodePuzzle3).onTrapTrigger(l_4_0)
  l_4_0.locked = true
  local alice = l_4_0:getAlice()
  alice.state.beganCodePuzzles = true
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    alice:halt(true)
    l_1_0:sleep(0.5)
    l_1_0:speakLineRight(bobPortrait, "Just how many identical caves are there in this place?", "Hrmm")
    alice:halt(false)
   end)
end

CodePuzzle3.tick = function(l_5_0)
  Class.super(CodePuzzle3).tick(l_5_0)
  if l_5_0.locked and l_5_0.computeDoorKey(l_5_0:getEntity("Port 1")) == l_5_0.DOOR_KEY then
    l_5_0:getEntity("UnhackableGateDoor (north)").OPEN = true
    l_5_0:getEntity("UnhackableGateDoor (south)").OPEN = true
    l_5_0.locked = false
  end
end

return CodePuzzle3

