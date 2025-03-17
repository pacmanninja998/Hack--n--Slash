-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CodePuzzle2.lua 

local Class = require("Class")
local CodeTrap = require("Room").cache:load("Content/Game/CrackerCavern/Rooms/CodeTrap")
local CodePuzzle2 = Class.create(CodeTrap, "CodePuzzle2")
CodePuzzle2.DOOR_KEY = "freedom"
CodePuzzle2.onInit = function(l_1_0)
  Class.super(CodePuzzle2).onInit(l_1_0)
  l_1_0:defineCollisionExit("West exit", "Content/Game/CrackerCavern/Rooms/CodePuzzle1", "East exit")
  l_1_0:defineCollisionExit("East exit", "Content/Game/CrackerCavern/Rooms/CodePuzzle3", "West exit")
  l_1_0:getEntity("Port 1"):destroy()
  l_1_0:getEntity("Port 2"):destroy()
  l_1_0:getEntity("Port 3"):destroy()
  l_1_0:getEntity("Port 4"):destroy()
  l_1_0:getEntity("UnhackableGateDoor (north)"):setLabelText(l_1_0.DOOR_KEY)
  l_1_0:getEntity("Signpost"):setFunction(l_1_0.computeDoorKey, "computeDoorKey")
  l_1_0:getEntity("Signpost").interactEndEvent:register(l_1_0.onSignpostInteractEnd, l_1_0)
end

CodePuzzle2.computeDoorKey = function()
  return "ran" .. "dom"
end

CodePuzzle2.onSignpostInteractEnd = function(l_3_0, l_3_1)
  local alice = l_3_0:getAlice()
  local alicePortrait = l_3_1:addAlicePortrait()
  local bobPortrait = l_3_1:addCharacter("Portraits/Bob/Bob")
  alice:halt(true)
  l_3_1:speakLineRight(bobPortrait, "\"computeDoorKey\"-- did we wind up in the same room again?", "Talk3")
  l_3_1:speakLineLeft(alicePortrait, "No, it's different. I think we're dealing with words now.", "Default4")
  l_3_1:speakLineRight(bobPortrait, "Ah! Let's warp in.", "NoWay")
  alice:halt(false)
end

CodePuzzle2.tick = function(l_4_0)
  Class.super(CodePuzzle2).tick(l_4_0)
  if l_4_0.locked and l_4_0.computeDoorKey() == l_4_0.DOOR_KEY then
    l_4_0:getEntity("UnhackableGateDoor (north)").OPEN = true
    l_4_0:getEntity("UnhackableGateDoor (south)").OPEN = true
    l_4_0.locked = false
  end
end

return CodePuzzle2

