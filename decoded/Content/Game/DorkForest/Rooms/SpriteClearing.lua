-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Rooms\SpriteClearing.lua 

local Class = require("Class")
local SpriteClearing = require("Room").classFromLayout("Content/Game/DorkForest/Layouts/SpriteClearing", "SpriteClearing", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local InventoryComponent = require("Components.InventoryComponent")
local SceneComponent = require("Components.SceneComponent")
local Music = require("Music")
SpriteClearing.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("SpookyPathExit", "Content/Game/DorkForest/Rooms/SpookyPath", "SpriteClearingExit")
  if not HackDemo then
    l_1_0:defineCollisionExit("CentralForestExit", "Content/Game/DorkForest/Rooms/CentralForest", "SpriteClearingExit")
  else
    l_1_0:defineLogicTrigger("CentralForestExit", l_1_0.onDemoExit, l_1_0)
  end
  require("Music"):playMusic("Music/Music/RedSpriteClearing_Cue1", false)
  Music:setReverb("ExteriorSlap")
  Music:playAmbient("Ambience/Ambience/SpriteClearing_Ambience")
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/SpriteClearing_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/SpriteClearing_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/SpriteClearing_ShadowGradient"
  l_1_0.timeOfDayRampMagnitude = 1.7
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0.defaultSoundMat = require("Components.PlatformComponent").SOUND_MAT_GRASS
  l_1_0:enableTimeOfDay()
  l_1_0:enableWater()
end

SpriteClearing.onDemoExit = function(l_2_0)
  local alice = l_2_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    l_1_0:displayTitleCard(5, "After $ALICE and $BOB puzzle their way through the forest...")
    if alice.host.extraDemoPuzzle then
      alice.host:handleRoomExit(alice, "Content/Game/DorkForest/Rooms/SleepingSwamp")
    else
      alice.host:handleRoomExit(alice, "Content/Game/DorkForest/Rooms/LabRuins")
    end
   end)
end

SpriteClearing.onBobCreated = function(l_3_0, l_3_1)
  Class.super(SpriteClearing).onBobCreated(l_3_0, l_3_1)
  l_3_1:watchForClass(Entity.cache:load("Content/Game/Global/Entities/ColoredSprite"), l_3_0.onBobSeesSprite, l_3_0)
end

SpriteClearing.onBobSeesSprite = function(l_4_0)
  if not l_4_0:getState()["Gave amulet"] then
    l_4_0:getState()["Gave amulet"] = true
    local alice = l_4_0:getAlice()
    do
      local bob = l_4_0:getBob()
      alice:get(SceneComponent):play(function(l_1_0)
        bob:beExcited(self:getEntity("Sprites locator"))
        alice:halt(true)
        l_1_0:sleep(1)
        local alicePortrait = l_1_0:addAlicePortrait()
        local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
        local sprites = {blue = l_1_0:addCharacter("Portraits/Sprite_Blue/Sprite_Blue"), green = l_1_0:addCharacter("Portraits/Sprite_Green/Sprite_Green"), orange = l_1_0:addCharacter("Portraits/Sprite_Orange/Sprite_Orange"), pink = l_1_0:addCharacter("Portraits/Sprite_Pink/Sprite_Pink"), purple = l_1_0:addCharacter("Portraits/Sprite_Purple/Sprite_Purple")}
        l_1_0:speakLineLeft(bobPortrait, "Hey, what's up, dudes!", "Excited")
        l_1_0:speakLineRight(sprites.orange, "Hey, dude! Where have you been all this time?", "Sing")
        bob:beExcited()
        l_1_0:speakLineLeft(bobPortrait, "Nowhere much. Just going on crazy adventures with my newly bonded human.", "Default")
        l_1_0:speakLineRight(sprites.green, "Rad! None of us thought you'd find a human to bond with.", "Default")
        l_1_0:speakLineLeft(bobPortrait, "Yep, I have pretty high standards. Had to find the right one.", "Default")
        l_1_0:speakLineRight(sprites.blue, "Yeah, and red sprites are super undesirable to most humans!", "Excited")
        l_1_0:speakLineLeft(alicePortrait, "Oh no!  Did I pick wrong?", "Spooked")
        l_1_0:speakLineLeft(bobPortrait, "What?  No!", "Sad")
        l_1_0:speakLineRight(sprites.pink, "You can't do it wrong.  It's just fate.", "Default")
        l_1_0:speakLineLeft(alicePortrait, "Oh good, I was worried!", "Laughing")
        l_1_0:speakLineLeft(bobPortrait, "...", "Sad")
        l_1_0:speakLineRight(sprites.blue, "It is rare, though. Humans just don't bond with red sprites!  It's happened like, twice.", "Excited")
        l_1_0:speakLineLeft(alicePortrait, "Who were the other \"red\" people?", "Excited")
        l_1_0:speakLineRight(sprites.green, "Who knows? Humans all look the same to us.", "Excited")
        l_1_0:speakLineLeft(alicePortrait, "...", "Angry")
        l_1_0:speakLineRight(sprites.blue, "Actually, take this amulet! So we can tell who you are. Please don't take it off.", "NoWay")
        alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/StateAmulet")
        l_1_0:speakLineLeft(bobPortrait, "Oh man, that's a good one. It'll let you hop around timespace. We could go back in time!", "Happy")
        l_1_0:speakLineLeft(alicePortrait, "Cooooooool.  So I use it like this?\n<c:8>To use equipped items:</c>", "Excited", false, "Use1", "Use2", "Use3", "Use4")
        l_1_0:speakLineRight(sprites.blue, "Wait!  Don't go back yet!  We'll just have to have this whole conversation again!", "Sing")
        l_1_0:speakLineLeft(alicePortrait, "Oh, that makes sense.  I hope I haven't done that a bunch of times!", "Laughing")
        l_1_0:speakLineLeft(bobPortrait, "Humans!  So silly.  But great!  Like when they cleaned up all that toxic waste, that stuff was a drag.", "Excited")
        l_1_0:speakLineRight(sprites.purple, "What?  No, toxic waste is still everywhere over by that lab that blew up!  I was just there.  Everything is still...weird.  And bitey.", "Sing")
        l_1_0:speakLineLeft(bobPortrait, "Really?  Oh no!", "Sad")
        l_1_0:speakLineRight(sprites.purple, "But since you two are going on such crazy adventures, maybe you could help us out?", "Excited")
        l_1_0:speakLineLeft(bobPortrait, "Oh boy oh boy oh boy!!!", "Sing")
        l_1_0:speakLineLeft(alicePortrait, "Cleaning up a spill doesn't sound very... adventurous...", "FreakedOut")
        l_1_0:speakLineLeft(bobPortrait, "...", "Sad")
        l_1_0:speakLineLeft(alicePortrait, "Okay, fine.  We're on it. We'll figure out how to clean up that lab spill.  It'll be an adventure!", "Default")
        l_1_0:speakLineLeft(bobPortrait, "Yeah!", "BestFriends")
        alice:halt(false)
         end)
    end
  end
end

return SpriteClearing

