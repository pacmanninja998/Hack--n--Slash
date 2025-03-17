-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CaveLab.lua 

local CaveLab = require("Room").classFromLayout("Content/Game/CrackerCavern/Layouts/CaveLab", "CaveLab", "Content/Game/Global/Rooms/GameRoom")
local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local InventoryComponent = require("Components.InventoryComponent")
local LogoComponent = require("Components.LogoComponent")
local SoundComponent = require("Components.SoundComponent")
local Music = require("Music")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
CaveLab.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("CaveEntrance exit", "Content/Game/CrackerCavern/Rooms/CaveEntrance", "CaveLab exit")
  l_1_0:defineCollisionExit("CaveStash exit", "Content/Game/CrackerCavern/Rooms/CodePuzzle1", "West exit")
  require("Music"):playMusic("Music/Music/CaveLab_Cue1", false)
  Music:playAmbient("Ambience/Ambience/CaveTrap_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  l_1_0:getEntity("Isis"):get(InteractionComponent).interactEvent:register(l_1_0.onIsisInteract, l_1_0)
  l_1_0:enableWater()
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0.fadeEvent:register(l_1_0.onFade, l_1_0)
end

CaveLab.fade = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  if l_2_1 == l_2_0.FADE_IN then
    local alice = l_2_0:getAlice()
    do
      if not l_2_0:getState()["Visited before"] then
        alice:get(SceneComponent):play(function(l_1_0)
        alice:halt(true)
        l_1_0:displayTitleCard(2, "ACT 4")
        l_1_0:displayTitleCard(4, "IN WHICH I\nMAKE ANOTHER NEW FRIEND\nAND HAVE NEW INSIGHTS")
        alice:halt(false)
        Class.super(CaveLab).fade(self, type, duration, host, exitArgs)
         end)
        return 
      end
    end
  end
  Class.super(CaveLab).fade(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
end

CaveLab.onFade = function(l_3_0, l_3_1, l_3_2)
  if l_3_1 == l_3_0.FADE_IN and not l_3_2 then
    local alice = l_3_0:getAlice()
    do
      if alice.state.entryArea == "Completion entrance" then
        local sceneComponent = alice:get(SceneComponent)
        sceneComponent:play(function(l_1_0)
          alice:halt(true)
          self:getState()["Passed trials"] = true
          local alicePortrait = l_1_0:addAlicePortrait()
          l_1_0:speakLineLeft(alicePortrait, "...What? We're back here?", "Surprised")
          alice:halt(false)
            end)
      else
        if not l_3_0:getState()["Visited before"] then
          l_3_0:getState()["Visited before"] = true
          alice:get(SceneComponent):play(function(l_2_0)
            local isis, script = self:getEntity("Isis"), self:getEntity("Script")
            l_2_0:floatText(isis, "Script!  Off the counter!")
            l_2_0:floatText(script, "Mruh ruh ruh ruh", 2)
            script:sit()
            l_2_0:floatText(isis, "Good kitty.  Finally.", 2)
               end)
        end
      end
    end
  end
end

CaveLab.onIsisInteract = function(l_4_0, l_4_1, l_4_2)
  local sceneComponent = l_4_1:get(SceneComponent)
  local inventory = l_4_1:get(InventoryComponent)
  for index,item in ipairs(inventory.state.inventory) do
    if item.path == "Content/Game/Global/Items/LibraryBookItem" and item.state.filePath == "Data/Content/Game/DourTower/Rooms/PrincessChambersCopy.lua" then
      inventory:removeItem(index)
      l_4_0:playSecretEnding()
      return 
    end
  end
  sceneComponent:play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local isisPortrait = l_1_0:addCharacter("Portraits/Isis/Isis")
    local scriptPortrait = l_1_0:addCharacter("Portraits/ScriptKitty/ScriptKitty")
    if self:getState()["Gave bombs"] then
      l_1_0:speakLineRight(isisPortrait, "Best of luck to you, $ALICE and $BOB.", "Laughing")
      isis:get(InteractionComponent):stopInteract(interactor)
    else
      if self:getState()["Passed trials"] then
        l_1_0:speakLineRight(isisPortrait, "Congratulations!", "Laughing")
        l_1_0:speakLineLeft(bobPortrait, "Didn't you say the exit was through those caves?", "Hrmm")
        l_1_0:speakLineRight(isisPortrait, "It was, in a way. You passed the trials. You might be capable of facing Christo.", "Huh")
        l_1_0:speakLineLeft(alicePortrait, "We can't face him if we're stuck in here.", "MildlyConcerned")
        l_1_0:speakLineRight(isisPortrait, "I have something else for you that will help. Take these.", "Happy")
        self:getAlice():get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
        self:getAlice():get(InventoryComponent):insertItem("Content/Game/Global/Items/BombItem")
        self:getState()["Gave bombs"] = true
        l_1_0:speakLineLeft(alicePortrait, "Bombs?", "Bomb")
        l_1_0:speakLineRight(isisPortrait, "They're my latest and most powerful invention. The loupe allows you to see algorithms that are already exposed to the world, but these bombs will expose algorithms that can't normally be accessed.", "WTF")
        l_1_0:speakLineLeft(bobPortrait, "I still don't really understand what you two are talking about, but these bombs will help us escape?", "Talk3")
        l_1_0:speakLineRight(isisPortrait, "Certainly. The entrance was not built to open once closed. But you can change that.", "Laughing")
        l_1_0:speakLineLeft(alicePortrait, "You said leaving that way was dangerous.", "Default4")
        l_1_0:speakLineRight(isisPortrait, "Absolutely. But you are clever. And brave. I think you may be able to face the danger that awaits you.", "Huh")
        l_1_0:speakLineLeft(bobPortrait, "Are you sure?", "Sad")
        l_1_0:speakLineRight(isisPortrait, "Nothing is certain. But you have brought back a hope I have not felt in a long time. Good luck.", "Huh")
        l_1_0:speakLineRight(scriptPortrait, "Mrow.")
        isis:get(InteractionComponent):stopInteract(interactor)
      else
        if not self:getState()["Started conversation"] then
          self:getState()["Started conversation"] = true
          l_1_0:speakLineRight(isisPortrait, "Oh good, you escaped.  You took a bit longer than I expected.", "Laughing")
          l_1_0:speakLineLeft(alicePortrait, "We thought you'd need the extra time to catch the cat.", "Snobby")
          l_1_0:speakLineRight(isisPortrait, "Ah.  Yes, please don't rile Script up.  My lab arrangements are delicate.", "Whatever")
          l_1_0:speakLineLeft(bobPortrait, "Then why do you have a cat in the first place?", "Talk3")
          l_1_0:speakLineRight(isisPortrait, "Hm.  I suppose I needed to have someone.  Something.", "Queasy")
          l_1_0:speakLineLeft(alicePortrait, "...", "Surprised")
          l_1_0:speakLineRight(isisPortrait, "Oh, the oven needs tending... please do keep talking.", "Huh")
          isis:get(InteractionComponent):stopInteract(interactor)
          isis:get(InteractionComponent):setEnabled(false)
          isis:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 4}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}})
          l_1_0:sleepWhile(function()
            isis:get(LogoComponent):isRunning()
               end)
          isis:get(InteractionComponent):setEnabled(true)
        else
          if not self:getState()["Made introductions"] then
            self:getState()["Made introductions"] = true
            l_1_0:speakLineLeft(alicePortrait, "So who are you?", "Spooked")
            l_1_0:speakLineRight(isisPortrait, "You didn't seek me out?", "Huh")
            l_1_0:speakLineLeft(alicePortrait, "...no.  Chi--uh.  Someone pointed us toward the woods.", "Default4")
            l_1_0:speakLineRight(isisPortrait, "Ah. And you stumbled around for an infinite amount of time?", "WTF")
            l_1_0:speakLineLeft(bobPortrait, "Nope!  Magic hat.", "Talk")
            l_1_0:speakLineLeft(alicePortrait, "$BOB!", "Laughing")
            l_1_0:speakLineRight(isisPortrait, "A hat?  Oh my, Chicco sent you!", "Happy")
            l_1_0:speakLineLeft(bobPortrait, "Well, not as such.", "Talk3")
            l_1_0:speakLineRight(isisPortrait, "Yes!  That's just how he would do it.  To think I was worried you might be here to kill me.", "Laughing")
            l_1_0:speakLineLeft(alicePortrait, "Whoa!  No, not at all.", "Surprised")
            l_1_0:speakLineRight(isisPortrait, "Pardon me then; I thought you had known who I was.", "Default")
            l_1_0:speakLineRight(isisPortrait, "My name is Isis.  I'm an algorithmicist.", "Laughing")
            l_1_0:speakLineLeft(alicePortrait, "..?", "Talk2")
            l_1_0:speakLineRight(isisPortrait, "You've already met Script.", "Sneaky")
            l_1_0:speakLineRight(scriptPortrait, "Mrow!", "Meow")
            l_1_0:speakLineLeft(bobPortrait, "Kitty!", "Excited")
            l_1_0:speakLineLeft(alicePortrait, "So you know Chicco?  We only just met him.", "Default4")
            l_1_0:speakLineRight(isisPortrait, "We crossed paths.  But that's been long ago, now...", "Huh")
            l_1_0:speakLineRight(isisPortrait, "Oh, my solution is precipitating.  Excuse me.  But do keep talking.", "Queasy")
            isis:get(InteractionComponent):stopInteract(interactor)
            isis:get(InteractionComponent):setEnabled(false)
            isis:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}})
            l_1_0:sleepWhile(function()
              isis:get(LogoComponent):isRunning()
                  end)
            isis:get(InteractionComponent):setEnabled(true)
          else
            local menu = l_1_0:createMenu(self:getState(), "Isis conversation tree", alicePortrait)
            menu:addOption("place", "What is this place?")
            menu:addOption("room", self:getState()["Mentioned algorithms"] and "What is the algorithm room?" or "What was the secret room?")
            menu:addOption("kill", "Who would want to kill you?")
            if self:getState()["Discuss loupe"] then
              menu:addOption("loupe", "What does the loupe do?")
            end
            if self:getState()["Discuss experts"] then
              menu:addOption("expert", "Who's the expert on algorithm rooms now?")
            end
            if self:getState()["Discuss wizard"] then
              menu:addOption("wizard", "What's the wizard's problem?")
            end
            if self:getState()["Discuss wizard"] then
              menu:addRepeatOption("exit", "Well, it's been nice but...")
            end
            local option = menu:choose()
            if option == "place" then
              l_1_0:speakLineLeft(alicePortrait, "What is this place?", "Spooked")
              l_1_0:speakLineLeft(bobPortrait, "Interesting decor.", "Happy")
              l_1_0:speakLineRight(isisPortrait, "This is my home and lab.", "Default")
              l_1_0:speakLineLeft(alicePortrait, "And the jail cells?", "Talk")
              l_1_0:speakLineRight(isisPortrait, "Partly for my protection.  And partly...a test.", "Huh")
              l_1_0:speakLineLeft(bobPortrait, "A test for what?", "Talk3")
              l_1_0:speakLineRight(isisPortrait, "Not just anyone has the natural aptitude to use the loupe properly.  Or the algorithm rooms.", "Laughing")
              self:getState()["Mentioned algorithms"] = true
              l_1_0:speakLineLeft(bobPortrait, "Is that why I couldn't use the loupe?", "Sly")
              l_1_0:speakLineRight(isisPortrait, "You could learn.  It requires a certain way of thinking. But also a certain size of head.", "Default")
              l_1_0:speakLineLeft(alicePortrait, "We passed your test?", "Default4")
              l_1_0:speakLineRight(isisPortrait, "Yes. It would appear so.", "Laughing")
              l_1_0:speakLineLeft(alicePortrait, "Would the people you want protection from pass the test?", "Talk2")
              l_1_0:speakLineRight(isisPortrait, "...yes.  Of course. But it might afford me some time.", "Queasy")
              l_1_0:speakLineRight(isisPortrait, "My dinner might be burning.  I'll check.  But please keep talking.", "Huh")
              self:getState()["Discuss loupe"] = true
              isis:get(InteractionComponent):stopInteract(interactor)
              isis:get(InteractionComponent):setEnabled(false)
              isis:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}})
              l_1_0:sleepWhile(function()
                isis:get(LogoComponent):isRunning()
                     end)
              isis:get(InteractionComponent):setEnabled(true)
            elseif option == "room" then
              if not self:getState()["Mentioned algorithms"] then
                l_1_0:speakLineLeft(alicePortrait, "What was the secret room?", "Talk2")
                l_1_0:speakLineRight(isisPortrait, "The room you found with the loupe?  An algorithm room.", "Huh")
                l_1_0:speakLineLeft(bobPortrait, "I think you made that word up.", "Talk")
              else
                l_1_0:speakLineLeft(alicePortrait, "What is the al--alg--", "Snobby")
                l_1_0:speakLineLeft(bobPortrait, "Algorithm.", "Judgemental")
                l_1_0:speakLineLeft(alicePortrait, "Algorithm room?", "SidwaysGlance")
              end
              l_1_0:speakLineRight(isisPortrait, "An algorithm is just a series of steps.  The room you saw contains the steps that make the lock work.  Or kept it locked.", "Laughing")
              l_1_0:speakLineLeft(alicePortrait, "Wow.  Why did the lock have that?", "Spooked")
              l_1_0:speakLineRight(isisPortrait, "Everything does.  The lock.  This room.  Script.  You, me.  The very world.", "Default")
              l_1_0:speakLineLeft(bobPortrait, "...whoa.  Me too?", "Happy")
              l_1_0:speakLineRight(isisPortrait, "Yes.  I've studied them for most of my life...I was the foremost expert on them, once.", "Huh")
              l_1_0:speakLineRight(isisPortrait, "Oh my, the time...I should make another observation.  You should keep talking.", "Queasy")
              self:getState()["Discuss experts"] = true
              isis:get(InteractionComponent):stopInteract(interactor)
              isis:get(InteractionComponent):setEnabled(false)
              isis:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}})
              l_1_0:sleepWhile(function()
                isis:get(LogoComponent):isRunning()
                     end)
              isis:get(InteractionComponent):setEnabled(true)
            elseif option == "kill" then
              l_1_0:speakLineLeft(alicePortrait, "Who would want to kill you?", "Spooked")
              l_1_0:speakLineRight(isisPortrait, "Uh...", "Queasy")
              l_1_0:speakLineLeft(bobPortrait, "What she means is...that.  But nicer.", "Judgemental")
              l_1_0:speakLineRight(isisPortrait, "I...that's fine. I suspect Christo--the \"wizard\"--has been trying to kill me. He destroyed my old lab.", "Huh")
              l_1_0:speakLineLeft(alicePortrait, "I wouldn't put it past him.  He got pretty mad when he found us in the swamp.", "Angry")
              l_1_0:speakLineRight(isisPortrait, "You saw the wizard?  And he saw you?", "WTF")
              l_1_0:speakLineLeft(bobPortrait, "Big jerk? No hat? Yeah. Threw us in a dungeon and everything.", "Talk")
              l_1_0:speakLineRight(isisPortrait, "He saw you together?", "Huh")
              l_1_0:speakLineLeft(alicePortrait, "Yes.", "Talk2")
              l_1_0:speakLineRight(isisPortrait, "Then both of you are in danger too.", "Huh")
              l_1_0:speakLineRight(isisPortrait, "...I should wash my hands.  You can keep talking.", "Queasy")
              self:getState()["Discuss wizard"] = true
              isis:get(InteractionComponent):stopInteract(interactor)
              isis:get(InteractionComponent):setEnabled(false)
              isis:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}})
              l_1_0:sleepWhile(function()
                isis:get(LogoComponent):isRunning()
                     end)
              isis:get(InteractionComponent):setEnabled(true)
            elseif option == "loupe" then
              l_1_0:speakLineLeft(alicePortrait, "What does the loupe do?", "Talk2")
              l_1_0:speakLineRight(isisPortrait, "Some of the algorithm rooms are better-exposed than others.  The loupe lets you see them, making them almost accessible.", "Default")
              l_1_0:speakLineLeft(alicePortrait, "I'm pretty sure I just accessed one.", "Talk")
              l_1_0:speakLineRight(isisPortrait, "The loupe gets you most of the way, but to enter the algorithm room you have to be bonded to a red sprite.", "Huh")
              l_1_0:speakLineLeft(bobPortrait, "...huh.", "Sly")
              l_1_0:speakLineLeft(alicePortrait, "The wizard has a red sprite.", "StinkEye")
              l_1_0:speakLineRight(isisPortrait, "Yes, he does.  The algorithm rooms are at the root of his power...", "Angry")
              l_1_0:speakLineRight(isisPortrait, "He...I...I need to feed Script.  But keep talking.  Script!  Nom noms!", "Queasy")
              l_1_0:speakLineRight(scriptPortrait, "Mrowl!", "Scared")
              self:getState()["Discuss wizard"] = true
              isis:get(InteractionComponent):stopInteract(interactor)
            elseif option == "expert" then
              l_1_0:speakLineLeft(alicePortrait, "If you were the foremost expert...", "Snobby")
              l_1_0:speakLineLeft(bobPortrait, "<c:8>Please be sensitive.</>", "Talk3")
              l_1_0:speakLineLeft(alicePortrait, "...who's the expert on algorithm rooms now?", "Spooked")
              l_1_0:speakLineRight(isisPortrait, "...", "Queasy")
              l_1_0:speakLineRight(isisPortrait, "...The wizard. He locked out everyone who doesn't have a red sprite.", "Huh")
              l_1_0:speakLineRight(isisPortrait, "The red bond is rare, so he has a near-monopoly on the algorithm rooms.", "WTF")
              l_1_0:speakLineRight(isisPortrait, "I still study them as best I can, indirectly, but I've made little progress.  A loupe and some bombs...", "Whatever")
              l_1_0:speakLineLeft(bobPortrait, "Bombs?", "Talk2")
              l_1_0:speakLineRight(isisPortrait, "Oh right!  I should check on the next batch...but you can keep talking.", "WTF")
              self:getState()["Discuss wizard"] = true
              isis:get(InteractionComponent):stopInteract(interactor)
              isis:get(InteractionComponent):setEnabled(false)
              isis:get(LogoComponent):setBehavior({{TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}})
              l_1_0:sleepWhile(function()
                isis:get(LogoComponent):isRunning()
                     end)
              isis:get(InteractionComponent):setEnabled(true)
            elseif option == "wizard" then
              l_1_0:speakLineLeft(alicePortrait, "What's the wizard's problem?", "Suspicious")
              l_1_0:speakLineLeft(bobPortrait, "Yeah.  That guy is maladjusted.", "Talk3")
              l_1_0:speakLineRight(isisPortrait, "Christo--the wizard--studied the algorithm rooms as my apprentice.  He didn't have many other friends...", "Default")
              l_1_0:speakLineRight(isisPortrait, "The other children were cruel to him, because he couldn't find a sprite to bond with.", "Huh")
              l_1_0:speakLineLeft(alicePortrait, "He has a red sprite now, though.", "Default4")
              l_1_0:speakLineRight(isisPortrait, "...yes.  Christo used what we discovered to... create the red sprites. Once he returned to the village bonded to a kind of sprite no one had ever seen before, he became quite popular.", "Huh")
              l_1_0:speakLineRight(isisPortrait, "He discredited my research--our research--and began presenting himself as a wizard. People loved him and his powers.", "Whatever")
              l_1_0:speakLineLeft(bobPortrait, "What a jerk.", "Judgemental")
              l_1_0:speakLineRight(isisPortrait, "No--or well...I was bothered by this, yes. I tried convincing him to help me share the truth of our work.", "Huh")
              l_1_0:speakLineRight(isisPortrait, "But he wouldn't. He had become obsessed with the power his secret knowledge gave him. So I said I would expose the knowledge myself...", "Queasy")
              l_1_0:speakLineLeft(alicePortrait, "...And he locked you out so you couldn't.", "StinkEye")
              l_1_0:speakLineRight(isisPortrait, "I eventually realized there were other ways...but so did he.  He destroyed my lab, perverted some of my other work...", "Huh")
              l_1_0:speakLineLeft(bobPortrait, "The vat in the swamp?  We turned that back.  Up until the wizard ruined it again, anyway.", "Talk3")
              l_1_0:speakLineRight(isisPortrait, "Good.  He is clever...but he's not the only one.  I set up this backup lab before he torched the main one.  And I was right.  I finished my work.", "Default")
              l_1_0:speakLineLeft(alicePortrait, "The loupe.", "Loupe")
              l_1_0:speakLineRight(isisPortrait, "You can keep it, by the way.  You passed the test.", "Laughing")
              l_1_0:speakLineLeft(alicePortrait, "...thank you.  This will be super helpful in our quest to topple the wizard.", "Default4")
              l_1_0:speakLineRight(isisPortrait, "You're going to--", "Queasy")
              l_1_0:face(self:getEntity("Script"), Direction.DIR_W)
              l_1_0:speakLineRight(scriptPortrait, "Mmmmrrrrrowwwwwr!!", "Scared")
              l_1_0:speakLineRight(isisPortrait, "Oh...it's best to keep him occupied, so he stays off the counter.  But keep talking.  Come see mommy, Script.", "Laughing")
              self:getState()["Discuss exit"] = true
              isis:get(InteractionComponent):stopInteract(interactor)
            elseif option == "exit" then
              l_1_0:speakLineLeft(alicePortrait, "Well, it's been nice, but I think it's time we headed out.", "Default3")
              l_1_0:speakLineLeft(bobPortrait, "We know where the door is.", "Judgemental")
              l_1_0:speakLineLeft(alicePortrait, "If you'd just open the outer gate...", "Talk2")
              l_1_0:speakLineRight(isisPortrait, "Oh, no.  That's much too dangerous.  You may have been followed.", "Huh")
              l_1_0:speakLineLeft(alicePortrait, "I don't think so.", "Default4")
              l_1_0:speakLineRight(isisPortrait, "Please leave through the back exit instead.  It's better-concealed--I didn't need to be able to move lab equipment through it.", "Sneaky")
              l_1_0:speakLineLeft(bobPortrait, "Okay.  Where is it?", "Default")
              l_1_0:speakLineRight(isisPortrait, "Deeper in the caves, but it is beyond a series of trials.", "WTF")
              l_1_0:speakLineLeft(alicePortrait, "...Really?!", "Surprised")
              l_1_0:speakLineRight(isisPortrait, "They serve a dual purpose.  The first was to delay Christo if he was pursuing me as I fled.", "Huh")
              l_1_0:speakLineRight(isisPortrait, "I suspect his pride would keep him from avoiding the puzzles, which he is capable of. He would solve them quickly, but not before I could escape.", "Default")
              l_1_0:speakLineLeft(alicePortrait, "And the second purpose?", "Spooked")
              l_1_0:speakLineLeft(bobPortrait, "Ooh!  It will make us better adventurers!", "Silly")
              l_1_0:speakLineRight(isisPortrait, "Well...yes.  You mentioned taking down the wizard, and I don't think you're ready.", "Huh")
              l_1_0:speakLineRight(isisPortrait, "I've thought long and hard about how to remove him from power...and I made the trials to train the person who might.", "WTF")
              l_1_0:speakLineLeft(alicePortrait, "Please just let us out.", "Talk2")
              l_1_0:speakLineRight(isisPortrait, "Umm...actually, it's too late.  The rooms aren't built to allow that.  But if you go to the deepest cave--", "Laughing")
              l_1_0:speakLineLeft(bobPortrait, "Say no more!  We go to the deepest cave!", "Sing")
              isis:get(InteractionComponent):stopInteract(interactor)
            else
              isis:get(InteractionComponent):stopInteract(interactor)
            end
          end
        end
      end
    end
   end)
end

CaveLab.playSecretEnding = function(l_5_0)
  local alice = l_5_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local isisPortrait = l_1_0:addCharacter("Portraits/Isis/Isis")
    local scriptPortrait = l_1_0:addCharacter("Portraits/ScriptKitty/ScriptKitty")
    alice:halt(true)
    l_1_0:displayTitleCard(2, "ACT 6")
    l_1_0:displayTitleCard(4, "IN WHICH WE\nREUNITE OLD FRIENDS")
    l_1_0:speakLineLeft(bobPortrait, "Hi!")
    l_1_0:speakLineRight(scriptPortrait, "Mrow!", "Meow")
    l_1_0:speakLineRight(isisPortrait, "Oh, it's you!  What can I do for you?", "Laughing")
    l_1_0:speakLineLeft(alicePortrait, "Actually, we've brought you--", "Talk2")
    l_1_0:speakLineLeft(bobPortrait, "<c:8>Please be sensitive.</>", "Talk3")
    l_1_0:speakLineLeft(alicePortrait, "<c:8>I am!</>", "StinkEye")
    l_1_0:speakLineLeft(alicePortrait, "We brought you the book that we trapped Christo in.", "Default4")
    l_1_0:speakLineRight(isisPortrait, "Oh my.", "Queasy")
    l_1_0:speakLineRight(isisPortrait, "...is he okay?", "Huh")
    l_1_0:speakLineLeft(alicePortrait, "Yes. Just locked away.", "Snobby")
    l_1_0:speakLineRight(isisPortrait, "...well, that's a relief.", "Huh")
    l_1_0:speakLineLeft(bobPortrait, "We thought that if anyone could handle him, it would be you.", "Judgemental")
    l_1_0:speakLineRight(isisPortrait, "But what should I do?  How can I get him out of the book?", "WTF")
    l_1_0:speakLineLeft(alicePortrait, "I'm sorry... We don't know.", "Default4")
    l_1_0:speakLineRight(isisPortrait, "...", "Queasy")
    l_1_0:speakLineLeft(alicePortrait, "But if anyone can find out how, it's you.", "Talk2")
    l_1_0:speakLineRight(isisPortrait, "Like a test.", "Laughing")
    l_1_0:speakLineRight(isisPortrait, "...okay.  Thank you.", "Huh")
    l_1_0:speakLineLeft(alicePortrait, "While he's contained, though, would you like to come back out of the Infinite Woods?", "Talk")
    l_1_0:speakLineLeft(bobPortrait, "Maybe set your old lab back up?  The sprites will help!", "Excited")
    l_1_0:speakLineRight(isisPortrait, "I don't think I'm ready.  Maybe Christo will help me set it back up.", "Default")
    l_1_0:speakLineRight(isisPortrait, "Thank you again.", "Huh")
    l_1_0:speakLineLeft(alicePortrait, "...", "Talk2")
    l_1_0:speakLineLeft(bobPortrait, "You're welcome!", "Judgemental")
    alice:halt(false)
   end)
end

return CaveLab

