-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CodePuzzle4.lua 

local Class = require("Class")
local CodeTrap = require("Room").cache:load("Content/Game/CrackerCavern/Rooms/CodeTrap")
local CodePuzzle4 = Class.create(CodeTrap, "CodePuzzle4")
CodePuzzle4.DOOR_KEY = "hahahaha"
CodePuzzle4.onInit = function(l_1_0)
  Class.super(CodePuzzle4).onInit(l_1_0)
  l_1_0:defineCollisionExit("West exit", "Content/Game/CrackerCavern/Rooms/CodePuzzle3", "East exit")
  l_1_0:defineCollisionExit("East exit", "Content/Game/CrackerCavern/Rooms/CaveStash", "CaveLab exit")
  l_1_0:getEntity("Port 1"):destroy()
  l_1_0:getEntity("Port 2"):destroy()
  l_1_0:getEntity("Port 3"):destroy()
  l_1_0:getEntity("Port 4"):destroy()
  l_1_0:getEntity("UnhackableGateDoor (north)"):setLabelText(l_1_0.DOOR_KEY)
  l_1_0:getEntity("Signpost"):setFunction(l_1_0.computeDoorKey, "computeDoorKey")
  l_1_0:getEntity("Signpost").interactEndEvent:register(l_1_0.onSignpostInteractEnd, l_1_0)
end

CodePuzzle4.computeDoorKey = function(l_2_0)
  local key = ""
  for i = 1, 3 do
    key = key .. "ha"
  end
  return key
end

CodePuzzle4.onSignpostInteractEnd = function(l_3_0, l_3_1)
  local alice = l_3_0:getAlice()
  local alicePortrait = l_3_1:addAlicePortrait()
  local bobPortrait = l_3_1:addCharacter("Portraits/Bob/Bob")
  alice:halt(true)
  l_3_1:speakLineLeft(alicePortrait, "I see some text combining in there, but I don't know what that FOR stuff is all about.")
  l_3_1:speakLineRight(bobPortrait, "Let's go visit the machines. Loupe time!")
  alice:halt(false)
end

CodePuzzle4.tick = function(l_4_0)
  Class.super(CodePuzzle4).tick(l_4_0)
  if l_4_0.locked and l_4_0.computeDoorKey() == l_4_0.DOOR_KEY then
    l_4_0:getEntity("UnhackableGateDoor (north)").OPEN = true
    l_4_0:getEntity("UnhackableGateDoor (south)").OPEN = true
    l_4_0.locked = false
  end
end

return CodePuzzle4

