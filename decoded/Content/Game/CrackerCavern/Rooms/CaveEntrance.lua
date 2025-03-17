-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CaveEntrance.lua 

local Class = require("Class")
local Class = require("Class")
local Room = require("Room")
local CaveEntrance = Room.classFromLayout("Content/Game/CrackerCavern/Layouts/CaveEntrance", "CaveEntrance", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local Direction = require("Direction")
local PhysicsComponent = require("Components.PhysicsComponent")
local FunctionComponent = require("Components.FunctionComponent")
local SceneComponent = require("Components.SceneComponent")
local LogoComponent = require("Components.LogoComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local InventoryComponent = require("Components.InventoryComponent")
local InteractionComponent = require("Components.InteractionComponent")
local CommonActions = require("CommonActions")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local Music = require("Music")
CaveEntrance.onInit = function(l_1_0)
  l_1_0.CodeRoom = Room.cache:load("Content/Game/Global/Rooms/CodeRoom")
  local InfiniteWoods = Room.cache:load("Content/Game/CrackerCavern/Rooms/InfiniteWoods")
  local infiniteWoodsExitName = InfiniteWoods.CORRECT_PATH .. InfiniteWoods.PREFIX_SEPARATOR .. "Exit"
  l_1_0:defineCollisionExit("CaveLab exit", "Content/Game/CrackerCavern/Rooms/CaveLab", "CaveEntrance exit")
  l_1_0:defineCollisionExit("InfiniteWoods exit", "Content/Game/CrackerCavern/Rooms/InfiniteWoods", infiniteWoodsExitName)
  l_1_0.hsvTint = {0, 0, 0}
  Music:playMusic(nil)
  Music:playAmbient("Ambience/Ambience/CaveTrap_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  l_1_0:enableWater()
  local northDoor = l_1_0:getEntity("UnhackableGateDoor")
  northDoor:get(SoundComponent):enablePlaying(false)
  northDoor.schemas.OPEN:registerValueSetHandler(northDoor, l_1_0.onNorthDoorOpen, l_1_0)
  l_1_0:persistValue("UnhackableGateDoor", "OPEN", true)
  northDoor:get(SoundComponent):enablePlaying(true)
  l_1_0.protectDoor = true
  l_1_0.doorSign = l_1_0:getEntity("Signpost")
  l_1_0.doorSign:setFunction(l_1_0.allowLockHack, "allowLockHack")
  local southDoor = l_1_0:getEntity("GateDoor")
  southDoor:get(SoundComponent):enablePlaying(false)
  southDoor.schemas.OPEN:registerValueSetHandler(southDoor, l_1_0.onSouthDoorOpen, l_1_0)
  l_1_0:persistValue("GateDoor", "OPEN", false)
  southDoor:get(SoundComponent):enablePlaying(true)
  if not l_1_0:getState()["Triggered trap"] then
    l_1_0:defineLogicTrigger("Trap trigger", l_1_0.onTrapTrigger, l_1_0)
  else
    l_1_0:getCollisionArea("Trap trigger"):destroy()
  end
  l_1_0.fadeEvent:register(l_1_0.onFade, l_1_0)
end

CaveEntrance.allowLockHack = function(l_2_0)
  return false
end

CaveEntrance.onFade = function(l_3_0, l_3_1, l_3_2)
  if l_3_1 == l_3_0.FADE_IN and not l_3_2 then
    local alice = l_3_0:getAlice()
    do
      if alice.state.entryArea == "CaveLab exit" then
        l_3_0.protectDoor = false
      end
      if not l_3_0:getState()["Triggered trap"] then
        alice:get(SceneComponent):play(function(l_1_0)
        local alicePortrait = l_1_0:addAlicePortrait()
        local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
        alice:halt(true)
        l_1_0:speakLineRight(bobPortrait, "Hey look!  Someone put in a secure door!  I bet there's something good in here!", "Happy")
        l_1_0:speakLineLeft(alicePortrait, "Like what?", "Spooked")
        l_1_0:speakLineRight(bobPortrait, "Who knows? Let's investigate. New adventure!", "Excited")
        alice:halt(false)
         end)
      else
        if alice.state.sawEntrapment and not l_3_0:getState().Returned then
          alice:get(SceneComponent):play(function(l_2_0)
        local alicePortrait = l_2_0:addAlicePortrait()
        local bobPortrait = l_2_0:addCharacter("Portraits/Bob/Bob")
        alice:halt(true)
        l_2_0:speakLineLeft(alicePortrait, "She won't need these traps anymore.", "Snobby")
        l_2_0:speakLineRight(bobPortrait, "Remodeling is so expensive, though.", "Talk2")
        alice:halt(false)
        self:getState().Returned = true
         end)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CaveEntrance.onTrapTrigger = function(l_4_0)
  l_4_0:getState()["Triggered trap"] = true
  l_4_0:getEntity("UnhackableGateDoor").OPEN = false
  l_4_0:getEntity("GateDoor").OPEN = false
  l_4_0:registerHackEvents(true)
  local alice = l_4_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    alice:halt(true)
    l_1_0:sleep(1)
    l_1_0:speakLineRight(bobPortrait, "$ALICE!", "Sing")
    l_1_0:speakLineLeft(alicePortrait, "What?", "MildlyConcerned")
    l_1_0:speakLineRight(bobPortrait, "Are you getting us stuck in cages on purpose?", "Hrmm")
    l_1_0:speakLineLeft(alicePortrait, "No!", "Angry")
    l_1_0:speakLineRight(bobPortrait, "Liking cages is perfectly fine... but we're on an adventure.", "Judgemental")
    l_1_0:speakLineLeft(alicePortrait, "$BOB... coming in here was your idea.", "Talk2")
    l_1_0:speakLineRight(bobPortrait, "Yeah, but listening to me was your idea.", "Talk2")
    alice:halt(false)
   end)
end

CaveEntrance.registerHackEvents = function(l_5_0, l_5_1)
  local alice = l_5_0:getAlice()
  local inventory = alice:get(InventoryComponent)
  local index = inventory:findItemIndex("Content/Game/Global/Items/HackItem")
  local hackItem = inventory.items[index]
  if l_5_1 then
    hackItem.hackBeginEvent:register(l_5_0.onHackBegin, l_5_0)
    hackItem.hackEndEvent:register(l_5_0.onHackEnd, l_5_0)
  else
    hackItem.hackBeginEvent:unregister(l_5_0.onHackBegin, l_5_0)
    hackItem.hackEndEvent:unregister(l_5_0.onHackEnd, l_5_0)
  end
end

CaveEntrance.onHackBegin = function(l_6_0)
  l_6_0.hacking = true
  l_6_0.triedOpening = false
end

CaveEntrance.onHackEnd = function(l_7_0)
  l_7_0.hacking = false
  if l_7_0.triedOpening then
    l_7_0:registerHackEvents(false)
    local alice = l_7_0:getAlice()
    do
      local bob = l_7_0:getBob()
      alice:get(SceneComponent):play(function(l_1_0)
        local alicePortrait = l_1_0:addAlicePortrait()
        local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
        local isisPortrait = l_1_0:addCharacter("Portraits/Isis/Isis")
        local scriptPortrait = l_1_0:addCharacter("Portraits/ScriptKitty/ScriptKitty")
        alice:halt(true)
        l_1_0:speakLineLeft(alicePortrait, "...", "Angry")
        l_1_0:speakLineRight(bobPortrait, "$ALICE, just hack the door open!", "Talk2")
        l_1_0:speakLineLeft(alicePortrait, "I just did! It didn't work.", "Talk2")
        l_1_0:speakLineRight(bobPortrait, "Maybe you did it wrong.", "Talk3")
        l_1_0:speakLineLeft(alicePortrait, "...", "NonPlussed")
        alice:halt(false)
        self:getEntity("Signpost"):get(InteractionComponent):setEnabled(false)
        l_1_0.skipping = false
        l_1_0:sleep(1)
        local x, y = self:getEntity("Script spawner"):getPosition()
        local script = Entity.create("Content/Game/CrackerCavern/Entities/Script", self:getLayerByOrder(0), x, y, "Script", Direction.DIR_N)
        script:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 2.5}})
        l_1_0:sleepWhile(function()
          return script:get(LogoComponent):isRunning()
            end)
        script:get(AnimatorComponent):setFacing(Direction.DIR_E)
        script:sit()
        l_1_0:sleep(0.5)
        script:get(SoundComponent):playCue("SFX/Characters/ScriptCat/ScriptCat_Meow", nil, 0.5)
        l_1_0:floatText(script, "Mraowr!", 1)
        l_1_0:sleep(0.5)
        l_1_0:floatText(self:getBob(), "Kitty!", 1)
        l_1_0:sleep(1)
        x, y = self:getEntity("Isis spawner"):getPosition()
        local isis = Entity.create("Content/Game/Global/Entities/Isis", self:getLayerByOrder(0), x, y, "Isis", Direction.DIR_W)
        l_1_0:floatText(isis, "Script!  You are not an outdoor kitty.  No matter what you think.", 4)
        isis:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 7.5}})
        l_1_0:sleep(0.25)
        script:get(SoundComponent):playCue("SFX/Characters/ScriptCat/ScriptCat_Meow", nil, 0.5)
        l_1_0:floatText(script, "Muh-row!  Mrrrroooooow.")
        l_1_0:floatText(isis, "Script, please!  What is it?")
        l_1_0:sleepWhile(function()
          return isis:get(LogoComponent):isRunning()
            end)
        isis:get(LogoComponent):setBehavior({{TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2.25}})
        l_1_0:floatText(isis, "...oh bits.")
        l_1_0:sleepWhile(function()
          return isis:get(LogoComponent):isRunning()
            end)
        alice:halt(true)
        l_1_0:sleep(0.5)
        l_1_0:speakLineLeft(alicePortrait, "Hi.", "Talk2")
        l_1_0:speakLineLeft(bobPortrait, "Nice cat.", "Default")
        l_1_0:speakLineRight(isisPortrait, "Ah... who dares to enter my cave?", "WTF")
        l_1_0:speakLineLeft(bobPortrait, "$BOB and $ALICE.  Adventurers.", "Talk")
        l_1_0:speakLineLeft(alicePortrait, "Honestly, we were thinking of exiting.", "Default4")
        l_1_0:speakLineRight(isisPortrait, "A girl and a red sprite... interesting. Here to steal my scientific instruments?", "Whatever")
        l_1_0:speakLineLeft(bobPortrait, "There's more to me than just my color.", "StinkEye")
        l_1_0:speakLineRight(isisPortrait, "Oh.  I didn't mean to--", "Huh")
        l_1_0:speakLineRight(scriptPortrait, "Mrow?")
        l_1_0:speakLineRight(isisPortrait, "Script, mommy is interrogating the--", "Laughing")
        l_1_0:speakLineLeft(bobPortrait, "I'm a complex individual. For instance, I'm a talented singer.", "Talk2")
        l_1_0:speakLineRight(isisPortrait, "Er.  Yes, I'm sure--", "Queasy")
        l_1_0:speakLineLeft(bobPortrait, "Check this out.", "Sing")
        bob:forceAction(CommonActions.LoopAnimation.new("Sing"))
        local cue = bob:get(SoundComponent):playCue("SFX/Characters/Bob/Bob_Song", true, 0.5, nil, true)
        l_1_0:sleepWhile(function()
          if cue:getTime() < 1 then
            return true
          end
            end)
        l_1_0:face(script, Direction.DIR_S)
        script:get(SoundComponent):playCue("SFX/Characters/ScriptCat/ScriptCat_Frightened", nil, 0.5)
        l_1_0:playAnimation(script, "Scared")
        bob:forceAction()
        bob:get(SoundComponent):stopCue(cue)
        l_1_0:speakLineRight(scriptPortrait, "Rowl!!!!!!!")
        script:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 3, SPEED = 2, ANIMATION = "Run"}})
        l_1_0:playAnimation(isis, "Drop_Loupe")
        local loupeLocator = self:getEntity("LoupePickup Locator")
        local loupePickupX, loupePickupY = loupeLocator:getPosition()
        local loupe = Entity.create("Content/Game/CrackerCavern/Entities/LoupePickup", self:getLayerByOrder(0), loupePickupX, loupePickupY)
        loupe:get(InteractionComponent).interactEvent:register(self.onLoupeInteract, self)
        l_1_0:sleepWhile(function()
          if script:get(LogoComponent):isRunning() then
            return true
          end
            end)
        script:destroy()
        l_1_0:speakLineRight(isisPortrait, "Oh dear.  Script breaks things when he's excited.  Please excuse me.  Make yourselves at home.", "Huh")
        self:getEntity("GateDoor"):get(InteractionComponent):setEnabled(false)
        isis:get(LogoComponent):setBehavior({{TYPE = "TURN", DIRECTION = "right"}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2.25}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 8}})
        l_1_0:sleep(2)
        l_1_0:speakLineRight(bobPortrait, "That was weird.", "Hrmm")
        l_1_0:speakLineLeft(alicePortrait, "She seems nice enough, though.", "HappyLaugh")
        alice:halt(false)
        self:getEntity("Signpost"):get(InteractionComponent):setEnabled(true)
        l_1_0:sleepWhile(function()
          if isis:get(LogoComponent):isRunning() then
            return true
          end
            end)
        isis:destroy()
         end)
    end
  end
end

CaveEntrance.onLoupeInteract = function(l_8_0, l_8_1, l_8_2)
  local alice = l_8_0:getAlice()
  local bob = l_8_0:getBob()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    alice:halt(true)
    l_1_0:speakLineLeft(alicePortrait, "$BOB, can you grab that?", "Talk2")
    bob:beExcited(loupe)
    l_1_0:speakLineRight(bobPortrait, "Finally, some gear!", "Silly")
    loupe:destroy()
    alice:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
    l_1_0:speakLineLeft(alicePortrait, "Oh.  I guess it is your turn.  Try it out.", "HappyLaugh")
    l_1_0:speakLineRight(bobPortrait, "This is heavy.  How does it look?", "Loupe")
    l_1_0:speakLineLeft(alicePortrait, "Er.  Can you see anything?", "Surprised")
    l_1_0:speakLineRight(bobPortrait, "No!  Nothing!", "Loupe")
    l_1_0:speakLineLeft(alicePortrait, "Maybe I should wear this.", "Default3")
    alice:halt(false)
    alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/MagicLoupe", {})
   end)
end

CaveEntrance.onNorthDoorOpen = function(l_9_0, l_9_1)
  l_9_0:getCollisionArea("North door collision"):setActive(not l_9_1)
end

CaveEntrance.onSouthDoorOpen = function(l_10_0, l_10_1)
  l_10_0:getCollisionArea("South door collision"):setActive(not l_10_1)
  if l_10_1 and l_10_0.protectDoor and not l_10_0.doorSign:get(FunctionComponent):exec() then
    local alice = l_10_0:getAlice()
    if alice then
      l_10_0:getAlice():get(SoundComponent):playCue("SFX/Hackable_Objects/Password_Red", nil, 0.5)
    end
    if l_10_0.hacking then
      l_10_0.triedOpening = true
    end
    local x, y = l_10_0:getEntity("Lock locator"):getPosition()
    local gateDoor = l_10_0:getEntity("GateDoor")
    gateDoor:get(SoundComponent):enablePlaying(false)
    l_10_0:closeDoor(gateDoor)
    gateDoor:get(SoundComponent):enablePlaying(true)
    gateDoor:rattle()
  end
end

CaveEntrance.closeDoor = function(l_11_0, l_11_1)
  l_11_1.OPEN = false
end

return CaveEntrance

