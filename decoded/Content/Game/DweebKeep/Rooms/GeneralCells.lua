-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\GeneralCells.lua 

local Math = require("DFCommon.Math")
local Class = require("Class")
local GeneralCells = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/GeneralCells", "GeneralCells", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local Direction = require("Direction")
local Item = require("Item")
local Delegate = require("DFMoai.Delegate")
local SceneComponent = require("Components.SceneComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local LogoComponent = require("Components.LogoComponent")
local InventoryComponent = require("Components.InventoryComponent")
local InteractionComponent = require("Components.InteractionComponent")
local HealthComponent = require("Components.HealthComponent")
local SoundComponent = require("Components.SoundComponent")
local CommonActions = require("CommonActions")
local SpriteSheet = require("SpriteSheet")
local Music = require("Music")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
GeneralCells.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("DungeonLobby exit", "Content/Game/DweebKeep/Rooms/DungeonLobby", "GeneralCells exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 4 do
    local name = "Abyss " .. i
    Entity.create("Content/Game/Global/Entities/Abyss", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  for i = 1, 19 do
    local name = "Platform " .. i
    Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 1", l_1_0.collisionAreasByName["Stairs 1"], Direction.DIR_W, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 2", l_1_0.collisionAreasByName["Stairs 2"], Direction.DIR_N, 0.8)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs 3", l_1_0.collisionAreasByName["Stairs 3"], Direction.DIR_E, 0.8)
  l_1_0:getEntity("MovingPlatform2x2 (first)").ROUTINE = {{TYPE = "MOVE", TILES = 4, SPEED = 2}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 5, SPEED = 2}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "MOVE", TILES = 5, SPEED = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 4, SPEED = 2}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "around"}}
  l_1_0:getEntity("MovingPlatform2x2 (second)").ROUTINE = {{TYPE = "MOVE", TILES = 12, SPEED = 6}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4.75, SPEED = 1.9}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "MOVE", TILES = 4.75, SPEED = 1.9}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 12, SPEED = 6}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "around"}}
  l_1_0:getEntity("MovingPlatform2x2 (third)").ROUTINE = {{TYPE = "IDLE", SECONDS = 1}, {TYPE = "MOVE", TILES = 1, SPEED = 1}, {TYPE = "MOVE", TILES = 1, SPEED = 2}, {TYPE = "MOVE", TILES = 1, SPEED = 3}, {TYPE = "MOVE", TILES = 1, SPEED = 4}, {TYPE = "MOVE", TILES = 1, SPEED = 5}, {TYPE = "MOVE", TILES = 1, SPEED = 6}, {TYPE = "MOVE", TILES = 1, SPEED = 7}, {TYPE = "MOVE", TILES = 1, SPEED = 8}, {TYPE = "MOVE", TILES = 1, SPEED = 9}, {TYPE = "MOVE", TILES = 1, SPEED = 10}, {TYPE = "MOVE", TILES = 2, SPEED = 11}, {TYPE = "MOVE", TILES = 2, SPEED = 12}, {TYPE = "MOVE", TILES = 2, SPEED = 13}, {TYPE = "MOVE", TILES = 2, SPEED = 14}, {TYPE = "MOVE", TILES = 2, SPEED = 15}, {TYPE = "MOVE", TILES = 4, SPEED = 16}, {TYPE = "MOVE", TILES = 4, SPEED = 17}, {TYPE = "MOVE", TILES = 4, SPEED = 18}, {TYPE = "MOVE", TILES = 4, SPEED = 19}, {TYPE = "MOVE", TILES = 6, SPEED = 20}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "TURN", DIRECTION = "right"}}
  l_1_0.sleepEvent1 = Delegate.new()
  l_1_0.sleepEvent1:register(l_1_0.onSleepEvent1, l_1_0)
  local cellBed = l_1_0:getEntity("CellBed")
  if cellBed then
    cellBed:get(InteractionComponent).interactEvent:register(l_1_0.onInteractCellBed, l_1_0)
  end
  local hayBale = l_1_0:getEntity("HayBale")
  if hayBale then
    hayBale:get(InteractionComponent).interactEvent:register(l_1_0.onInteractHayBale, l_1_0)
  end
  l_1_0.cachedHairSpriteSheet = SpriteSheet.load("Characters/Hero_Hair/Hero_Hair")
  Music:playMusic(nil)
  Music:playAmbient("Ambience/Ambience/GeneralCells_Ambience")
  Music:setReverb("Reflective")
  l_1_0.hsvTint = {0.083, -0.111, 0}
  l_1_0.fadeEvent:register(l_1_0.onFade, l_1_0)
  l_1_0:enableWater()
end

GeneralCells.onFade = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == l_2_0.FADE_IN and not l_2_2 then
    local alice = l_2_0:getAlice()
    do
      local bob = l_2_0:getBob()
      if alice.state.trapped then
        local sceneComponent = alice:get(SceneComponent)
        alice:halt(true)
        sceneComponent:play(function(l_1_0)
          local alicePortrait = l_1_0:addAlicePortrait()
          local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
          local evePortrait = l_1_0:addCharacter("Portraits/Eve/Eve")
          local wizardPortrait = l_1_0:addCharacter("Portraits/Wizard/Wizard")
          local locator = self:getEntity("Wizard locator")
          local x, y = locator:getPosition()
          local christo = Entity.create("Content/Game/Global/Entities/Christo", self:getLayerByOrder(0), x, y, "Christo")
          local eve = Entity.create("Content/Game/Global/Entities/RedSprite", self:getLayerByOrder(0), x, y, "Eve")
          christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear", nil, 0.5)
          l_1_0:playAnimation(christo, "Appear")
          christo:get(AnimatorComponent):setFacing(Direction.DIR_N)
          l_1_0:sleep(0.1)
          local globalState = self:universe().state.state
          globalState.forestHealAmount = -1000000000
          globalState.hidePasswordFeedback = true
          l_1_0:speakLineRight(wizardPortrait, "RE-ENTRANCE!", "Angry")
          l_1_0:speakLineRight(evePortrait, "That one needs work...", "Bored")
          l_1_0:speakLineLeft(alicePortrait, "Yeah, really.", "NonPlussed")
          l_1_0:speakLineRight(wizardPortrait, "Silence!  I just spent 30 seconds undoing all that damage you did.", "Angry")
          l_1_0:speakLineLeft(alicePortrait, "And I'll spend 15 doing it all over again.", "Talk")
          l_1_0:speakLineRight(wizardPortrait, "...", "Frown")
          l_1_0:speakLineRight(wizardPortrait, "Let's examine the reasons why you are WRONG.", "Angelic")
          l_1_0:speakLineRight(wizardPortrait, "First.  I changed the password.  Nyah nyah nyah.", "Default")
          l_1_0:speakLineRight(wizardPortrait, "Second. I disabled the blinky lights.  Those were for the guards, by the way.  It's hard to type in gauntlets and a visor.", "Happy")
          l_1_0:speakLineRight(wizardPortrait, "So congratulations!  All the guards hate you.  Or they will, because I'm telling.", "Frown")
          l_1_0:speakLineLeft(alicePortrait, "...", "DopeySmile")
          l_1_0:speakLineRight(wizardPortrait, "Third. You're never getting out of here.", "Angry")
          l_1_0:speakLineLeft(alicePortrait, "Oh, is this cell as secure as your cave traps and password walls?", "SidewaysGlance")
          l_1_0:speakLineRight(wizardPortrait, "Do you see a door, little girl? This is your permanent residence.", "Angry")
          christo:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear", nil, 0.5)
          christo:get(AnimatorComponent):setFacing(Direction.DIR_S)
          l_1_0:playAnimation(christo, "Disappear")
          christo.prop:setVisible(false)
          eve.prop:setVisible(false)
          christo:destroy()
          eve:destroy()
          l_1_0:speakLineRight(bobPortrait, "Who does that guy think he is?", "Talk")
          l_1_0:speakLineLeft(alicePortrait, "He's the wizard who runs the entire kingdom.", "Angry")
          l_1_0:speakLineRight(bobPortrait, "Oh.", "Talk3")
          local index = alice:get(InventoryComponent):findItemIndex("Content/Game/Global/Items/HackItem")
          if index then
            alice:get(InventoryComponent):removeItem(index)
          end
          local heroName = alice.state.name
          table.insert(self:universe().state.state.prisoners, heroName)
          alice:halt(false)
            end)
      end
    end
  end
end

GeneralCells.onInteractHayBale = function(l_3_0, l_3_1)
  local alice = l_3_0:getAlice()
  local hayBale = l_3_0.entitiesByName.HayBale
  local sceneComponent = alice:get(SceneComponent)
  if l_3_0:getState().MadeDummy then
    sceneComponent:play(function(l_1_0)
    alice:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    l_1_0:speakLineRight(bobPortrait, "<c:8>Let's make another one!</c>", "Sing")
    l_1_0:speakLineLeft(alicePortrait, "<c:8>We should really be going.</c>", "Talk2")
    l_1_0:speakLineRight(bobPortrait, "<c:8>But I don't have a dummy!</c>", "Excited")
    l_1_0:speakLineLeft(alicePortrait, "<c:8>I don't think the guards will notice if you're gone.</c>", "HappyLaugh")
    l_1_0:speakLineRight(bobPortrait, "<c:8>...</c>", "Hrmm")
    hayBale:get(InteractionComponent):stopInteract(entity)
    alice:halt(false)
   end)
  else
    if l_3_0:getState().ChiccoWhisper1 then
      if not l_3_0:getState()["Took hay"] then
        sceneComponent:play(function(l_2_0)
    alice:halt(true)
    local alicePortrait = l_2_0:addAlicePortrait()
    local bobPortrait = l_2_0:addCharacter("Portraits/Bob/Bob")
    l_2_0:speakLineRight(bobPortrait, "Don't eat that!", "OMG")
    l_2_0:speakLineLeft(alicePortrait, "<c:8>I wasn't going to. But I will take some.</c>", "Snobby")
    l_2_0:speakLineRight(bobPortrait, "<c:8>Why?</c>", "Talk3")
    l_2_0:speakLineLeft(alicePortrait, "<c:8>When life gives you hay...use it for something devious.</c>", "Talk")
    alice:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_GrabHay", nil, 0.5)
    alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/HayItem")
    self:getState()["Took hay"] = true
    alice:halt(false)
   end)
      else
        sceneComponent:play(function(l_3_0)
        alice:halt(true)
        local alicePortrait = l_3_0:addAlicePortrait()
        l_3_0:speakLineLeft(alicePortrait, "<c:8>I probably shouldn't take more.  The guards will notice.</c>", "Default")
        alice:halt(false)
         end)
      end
    else
      sceneComponent:play(function(l_4_0)
      alice:halt(true)
      local alicePortrait = l_4_0:addAlicePortrait()
      local bobPortrait = l_4_0:addCharacter("Portraits/Bob/Bob")
      l_4_0:speakLineRight(bobPortrait, "I hope they don't expect us to eat that.", "Sly")
      l_4_0:speakLineLeft(alicePortrait, "Do sprites eat?", "Spooked")
      l_4_0:speakLineRight(bobPortrait, "No. Do humans?", "Talk2")
      alice:halt(false)
      end)
    end
  end
end

GeneralCells.onInteractCellBed = function(l_4_0, l_4_1)
  local cellBed = l_4_0.entitiesByName.CellBed
  local alice = l_4_0:getAlice()
  local sceneComponent = alice:get(SceneComponent)
  if l_4_0:getState()["Got disguise goal"] then
    if l_4_0:getState()["Took hay"] then
      if not l_4_0:getState()["Made dummy"] then
        sceneComponent:play(function(l_1_0)
    alice:halt(true)
    local aliceHoodPortrait = l_1_0:addCharacter("Portraits/Alice/Alice")
    local aliceHairPortrait = l_1_0:addCharacter("Portraits/Alice_Hair/Alice_Hair")
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    l_1_0:speakLineRight(bobPortrait, "<c:8>Ooh!  I get it!  You're going to stuff the bed.</c>", "Sing")
    l_1_0:speakLineLeft(aliceHoodPortrait, "<c:8>Yep...</c>", "HappyLaugh")
    l_1_0:speakLineRight(bobPortrait, "<c:8>That's looking pretty good...but it's not quite right.</c>", "Sly")
    l_1_0:speakLineLeft(aliceHoodPortrait, "<c:8>Hay's not really my medium.</c>", "NonPlussed")
    l_1_0:speakLineRight(bobPortrait, "<c:8>You should stuff your hood and put it under the sheets too.</c>", "Excited")
    l_1_0:speakLineLeft(aliceHoodPortrait, "<c:8>That's actually a good idea...</c>", "Spooked")
    l_1_0:destroyDialog()
    local index = alice:get(InventoryComponent):findItemIndex("Content/Game/Global/Items/HayItem")
    alice:get(InventoryComponent):removeItem(index)
    alice:removeHoodAndStuffBed(0.3, cellBed)
    l_1_0:sleepWhile(function()
      return alice.action
      end)
    l_1_0:speakLineRight(bobPortrait, "<c:8>See?  Looks just like you.</c>", "Excited")
    l_1_0:speakLineLeft(aliceHairPortrait, "<c:8>...uh, you sure?</c>", "Talk2")
    l_1_0:speakLineRight(bobPortrait, "<c:8>Human-shaped with a hood.  We're solid.  Let's get out of here.</c>", "Happy")
    cellBed:get(InteractionComponent):stopInteract(entity)
    self:getState()["Made dummy"] = true
    alice:halt(false)
   end)
      else
        sceneComponent:play(function(l_2_0)
        alice:halt(true)
        local alicePortrait = l_2_0:addAlicePortrait()
        local bobPortrait = l_2_0:addCharacter("Portraits/Bob/Bob")
        l_2_0:speakLineLeft(alicePortrait, "<c:8>...huh.  Yeah, the hood sells it.</c>", "Spooked")
        l_2_0:speakLineRight(bobPortrait, "...", "Cute")
        cellBed:get(InteractionComponent):stopInteract(entity)
        alice:halt(false)
         end)
      end
    else
      if not l_4_0:getState()["Tried bunching sheets"] then
        sceneComponent:play(function(l_3_0)
      alice:halt(true)
      local alicePortrait = l_3_0:addAlicePortrait()
      local bobPortrait = l_3_0:addCharacter("Portraits/Bob/Bob")
      l_3_0:speakLineLeft(alicePortrait, "<c:8>Maybe I can bunch up the sheets so it looks like I'm still sleeping.</c>", "Snobby")
      l_3_0:speakLineRight(bobPortrait, "<c:8>It doesn't look like you're sleeping... It just looks like you bunched up the sheets.</c>", "Default")
      l_3_0:speakLineLeft(alicePortrait, "<c:8>Yeah.</c>", "Talk2")
      l_3_0:speakLineRight(bobPortrait, "<c:8>Honestly, it doesn't sound like you're sleeping either.</c>", "Talk")
      l_3_0:speakLineLeft(alicePortrait, "...", "StinkEye")
      cellBed:get(InteractionComponent):stopInteract(entity)
      alice:halt(false)
      self:getState()["Tried bunching sheets"] = true
      end)
      else
        sceneComponent:play(function(l_4_0)
        alice:halt(true)
        local alicePortrait = l_4_0:addAlicePortrait()
        local bobPortrait = l_4_0:addCharacter("Portraits/Bob/Bob")
        l_4_0:speakLineLeft(alicePortrait, "<c:8>Maybe if I arrange the sheets like this.</c>", "Default")
        l_4_0:speakLineRight(bobPortrait, "<c:8>...Nope, not working.  It just seems...empty.</c>", "Judgemental")
        alice:halt(false)
         end)
      end
    else
      l_4_1:startSleep(cellBed, l_4_0.sleepEvent1, 2)
    end
  end
end

GeneralCells.onSleepEvent1 = function(l_5_0)
  if not l_5_0:getState().ChiccoWhisper1 then
    local alice = l_5_0:getAlice()
    do
      local bob = l_5_0:getBob()
      local sceneComponent = alice:get(SceneComponent)
      sceneComponent:play(function(l_1_0)
        local chicco = self.entitiesByName.OldRed
        local chiccoInteractionSensor = self.entitiesByName.OldRedInteractionSensor
        if chicco and chiccoInteractionSensor then
          local posX, posY = chiccoInteractionSensor:getPosition()
          chicco:enableInteractionSensor(true, posX, posY, 50, 50)
          chicco:get(InteractionComponent).interactEvent:register(self.onInteractChicco, self)
        end
        alice:disableInput()
        local chiccoPortrait = l_1_0:addCharacter("Portraits/Chicco/Chicco")
        local alicePortrait = l_1_0:addAlicePortrait()
        local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
        l_1_0:speakLineRight(bobPortrait, "I don't want to go to sleep.  This place is spooky.", "Sad")
        l_1_0:speakLineLeft(alicePortrait, "I don't know what else to do.  Anyway, it'll give me a chance to think about how we're getting out of here.", "Spooked")
        l_1_0:speakLineRight(bobPortrait, "...okay.  I hope you don't snore.", "Judgemental")
        MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/ScreenFade_In")
        self:insertPostEffect(self.fadeOutShader)
        l_1_0:animate(1, function(l_1_0)
          self.fadeOutShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0, 1, l_1_0))
            end)
        l_1_0:sleep(0.5)
        local health = alice:get(HealthComponent)
        health:damage(health.curHealth - health.maxHealth)
        l_1_0:sleep(0.5)
        l_1_0:speakLineLeft(alicePortrait, "...", "Snobby")
        l_1_0:speakLineLeft(alicePortrait, "snrrrrrrRRRKT", "Laughing")
        l_1_0:sleep(0.5)
        l_1_0:speakLineRight(chiccoPortrait, "<c:8>Do you seek rest?  Or do you seek freedom?</c>", "Mystery")
        MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/ScreenFade_Out")
        l_1_0:animate(1, function(l_2_0)
          self.fadeOutShader:setFragmentUniformFloat("shaderDuration", Math.lerp(1, 0, l_2_0))
            end)
        require("Music"):playMusic("Music/Music/InnerPrison_Cue1", false)
        l_1_0:speakLineLeft(alicePortrait, "... Is someone there?", "Spooked")
        l_1_0:speakLineRight(chiccoPortrait, "<c:8>No matter your goal, approach it delicately.</c>", "Mystery")
        l_1_0:speakLineLeft(alicePortrait, "<c:8>... are you telling me to whisper?</c>", "Surprised")
        l_1_0:speakLineRight(chiccoPortrait, "<c:8>Even a whisper can pass through this wall, but you may do as you wish.</c>", "Mystery")
        l_1_0:speakLineLeft(alicePortrait, "...", "Surprised")
        l_1_0:speakLineLeft(alicePortrait, "<c:8>Hm.  $BOB, should we trust the mysterious voice?</c>", "Spooked")
        l_1_0:speakLineRight(bobPortrait, "Yeah!  Better that than listening to you snore all night.", "Happy")
        l_1_0:speakLineLeft(alicePortrait, "Snor--! <c:8>...$BOB...he said to whisper...</c>", "StinkEye")
        l_1_0:speakLineRight(bobPortrait, "Yeah! Oh.", "Talk")
        l_1_0:speakLineRight(bobPortrait, "<c:8>Yeah.</c>", "Cute")
        l_1_0:speakLineRight(bobPortrait, "<c:8>I'm pretty sure his voice came from over here.</c>", "Sly")
        bob:beExcited(chiccoInteractionSensor)
        self:getState().ChiccoWhisper1 = true
        alice:enableInput()
         end)
    end
  end
end

GeneralCells.onInteractChicco = function(l_6_0, l_6_1)
  local alice = l_6_0:getAlice()
  local bob = l_6_0:getBob()
  local chicco = l_6_0.entitiesByName.OldRed
  local sceneComponent = alice:get(SceneComponent)
  if l_6_0:getState().ChiccoWhisper1 then
    if l_6_0:getState()["Got hat"] then
      sceneComponent:play(function(l_1_0)
    alice:halt(true)
    local chiccoPortrait = l_1_0:addCharacter("Portraits/Chicco/Chicco")
    local alicePortrait = l_1_0:addAlicePortrait()
    do
      local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
      repeat
        repeat
          repeat
            repeat
              repeat
                repeat
                  local menu = l_1_0:createMenu(self:getState(), "Chicco conversation tree", alicePortrait)
                  menu:addOption("hat", "This hat is incredible.")
                  menu:addOption("wizard", "What would the wizard be afraid of?")
                  menu:addOption("info", "Who are you, exactly?")
                  menu:addRepeatOption("exit", "Well, we're off.")
                  do
                    local option = menu:choose()
                    if option == "hat" then
                      l_1_0:speakLineLeft(alicePortrait, "This hat is incredible.  ...is it actually a hat?", "HappyLaugh")
                      l_1_0:speakLineRight(chiccoPortrait, "Probably.  My haberdashery terminology is inexact.", "Hmm")
                      l_1_0:speakLineLeft(bobPortrait, "Let's just call it a hat.  What's so incredible?", "Hrmm")
                      l_1_0:speakLineLeft(alicePortrait, "I saw...", "Snobby")
                      l_1_0:speakLineRight(chiccoPortrait, "You saw reality stripped of its unreality.", "FreakedOut")
                      l_1_0:speakLineLeft(bobPortrait, "Do you always speak in riddles?", "Talk2")
                      l_1_0:speakLineRight(chiccoPortrait, "I speak of things as they are.", "NoReaction")
                      l_1_0:speakLineLeft(alicePortrait, "...what is reality, then?", "Default4")
                      l_1_0:speakLineRight(chiccoPortrait, "That I cannot answer.  But the third eye shows the simplicity under the complexity.", "Talking")
                      l_1_0:speakLineLeft(bobPortrait, "Third eye?  Like some weird mystical magic?", "Happy")
                      l_1_0:speakLineRight(chiccoPortrait, "Merely a tool to help you think and see correctly, but one with an evocative name.", "Default")
                      l_1_0:speakLineLeft(bobPortrait, "aw.", "Sly")
                      l_1_0:speakLineRight(chiccoPortrait, "There may be a picture of an eye on the hat.  Invisible knitting has its downfalls.", "Well")
                      l_1_0:speakLineLeft(alicePortrait, "...makes sense.", "EyeRoll")
                      repeat
                        repeat
                          local infoMenu = l_1_0:createMenu(self:getState(), "Hat info menu", alicePortrait)
                          infoMenu:addOption("origin", "You just had the hat sitting around?")
                          infoMenu:addRepeatOption("thanks", "Thanks.")
                          do
                            local infoOption = infoMenu:choose()
                            if infoOption == "origin" then
                              l_1_0:speakLineLeft(alicePortrait, "You just had the hat sitting around?", "Spooked")
                              l_1_0:speakLineRight(chiccoPortrait, "Knitting helps pass the time.", "Default")
                              l_1_0:speakLineLeft(alicePortrait, "Huh.  Any other useful hobbies?", "Default")
                              l_1_0:speakLineRight(chiccoPortrait, "I enjoyed walks in the woods.  The stillness of nature.", "Talking")
                              l_1_0:speakLineLeft(bobPortrait, "Ooh!  We should take the hats in the Infinite Woods!", "Sing")
                              l_1_0:speakLineRight(chiccoPortrait, "There are many things to find there.", "FreakedOut")
                              l_1_0:speakLineLeft(alicePortrait, "...useful things?", "Spooked")
                              l_1_0:speakLineRight(chiccoPortrait, "That depends on the use you find for them.", "Default")
                              l_1_0:speakLineLeft(bobPortrait, "It's going to be awesome!  You haven't given me my hat yet, by the way.", "NoWay")
                              l_1_0:speakLineRight(chiccoPortrait, "There is only the one hat.", "Talking")
                              l_1_0:speakLineLeft(bobPortrait, "...", "StinkEye")
                            else
                              l_1_0:speakLineLeft(alicePortrait, "Thanks.")
                              do return end
                            end
                            do return end
                          end
                        elseif option == "wizard" then
                          l_1_0:speakLineLeft(alicePortrait, "What would the wizard be afraid of?", "Spooked")
                          l_1_0:speakLineLeft(bobPortrait, "Me.  Or us.  Us.", "Default")
                        elseif option == "info" then
                          l_1_0:speakLineLeft(alicePortrait, "Who are you, exactly?", "Snobby")
                          l_1_0:speakLineRight(chiccoPortrait, "You may call me Chicco.", "Default")
                          repeat
                            repeat
                              repeat
                                repeat
                                  local infoMenu = l_1_0:createMenu(self:getState(), "Chicco info menu", alicePortrait)
                                  infoMenu:addOption("invisible", "Why are you invisible?")
                                  infoMenu:addOption("power", "What did you do to that wall?")
                                  infoMenu:addOption("escape", "Why don't you escape?")
                                  infoMenu:addRepeatOption("thanks", "Thanks.")
                                  do
                                    local infoOption = infoMenu:choose()
                                    if infoOption == "invisible" then
                                      l_1_0:speakLineLeft(alicePortrait, "Why are you invisible?", "Spooked")
                                      l_1_0:speakLineRight(chiccoPortrait, "I prefer to remain unseen.", "FreakedOut")
                                      l_1_0:speakLineLeft(alicePortrait, "I saw you just now, with the hat.", "Snobby")
                                      l_1_0:speakLineRight(chiccoPortrait, "I am real.  Though that is not the only way to see me.", "Well")
                                      l_1_0:speakLineLeft(alicePortrait, "... The wizard can see you.", "Talk2")
                                      l_1_0:speakLineRight(chiccoPortrait, "Yes.  He is smarter, and more dangerous, than he first appears.  I am now his prisoner.", "Default")
                                      l_1_0:speakLineLeft(alicePortrait, "But why?", "Snobby")
                                      l_1_0:speakLineRight(chiccoPortrait, "Every prisoner here is someone the wizard fears.", "FreakedOut")
                                      l_1_0:speakLineLeft(bobPortrait, "...", "Sly")
                                      l_1_0:speakLineLeft(alicePortrait, "He's locked up everyone he's afraid of?", "Talk2")
                                      l_1_0:speakLineRight(chiccoPortrait, "No.  But he tried.", "Ornery")
                                    elseif infoOption == "power" then
                                      l_1_0:speakLineLeft(alicePortrait, "What did you to the wall?", "Spooked")
                                      l_1_0:speakLineLeft(bobPortrait, "What did you do to us?", "Talk2")
                                      l_1_0:speakLineRight(chiccoPortrait, "I have much knowledge of barriers, and spend my time finding cracks in them.  In my presence, you simply ignore that the barriers exist.", "FreakedOut")
                                      l_1_0:speakLineLeft(bobPortrait, "...so, technically speaking, that blue glow was an ignorance field?", "Talk3")
                                      l_1_0:speakLineLeft(alicePortrait, "hee!", "HappyLaugh")
                                      l_1_0:speakLineLeft(alicePortrait, "...sorry.", "Default3")
                                      l_1_0:speakLineRight(chiccoPortrait, "The field is, like the hat, a tool to help correct thinking.", "NoReaction")
                                      l_1_0:speakLineLeft(bobPortrait, "That sort of makes sense, but why didn't we fall in the pit?", "Talk")
                                      l_1_0:speakLineLeft(alicePortrait, "You can fly.", "Default2")
                                      l_1_0:speakLineLeft(bobPortrait, "...why didn't SHE fall in the pit?", "Hrmm")
                                      l_1_0:speakLineRight(chiccoPortrait, "A--", "FreakedOut")
                                      l_1_0:speakLineLeft(alicePortrait, "A pit is just a barrier of another kind.  I ignored it.", "Snobby")
                                      l_1_0:speakLineRight(chiccoPortrait, "Astute.  I could not have said so better myself.", "Default")
                                      l_1_0:speakLineLeft(alicePortrait, "<c:8>I could see them with the hat.</c>", "Default2")
                                      l_1_0:speakLineLeft(bobPortrait, "Please don't start talking like him.", "Judgemental")
                                    elseif infoOption == "escape" then
                                      l_1_0:speakLineLeft(alicePortrait, "Why don't you escape?", "Spooked")
                                      l_1_0:speakLineRight(chiccoPortrait, "I spoke before of the Zen way.  To sit and ponder.  That is my way.", "Talking")
                                      l_1_0:speakLineLeft(alicePortrait, "You mean to stay here, then?", "Talk2")
                                      l_1_0:speakLineLeft(bobPortrait, "He can't move while he's cracking the walls.", "Judgemental")
                                      l_1_0:speakLineLeft(alicePortrait, "...", "Surprised")
                                      l_1_0:speakLineRight(chiccoPortrait, "That is my way.  The way I was made.", "Default")
                                    else
                                      l_1_0:speakLineLeft(alicePortrait, "Thanks.")
                                      do return end
                                    end
                                    do return end
                                  end
                                else
                                  l_1_0:speakLineLeft(alicePortrait, "Well, we're off.", "Snobby")
                                  l_1_0:speakLineLeft(bobPortrait, "Wait! How do we escape?", "Excited")
                                  l_1_0:speakLineRight(chiccoPortrait, "Decide on the right action.  Then act.", "FreakedOut")
                                  l_1_0:speakLineLeft(bobPortrait, "Sure, but can you give us any more specific hints?", "Talk")
                                  l_1_0:speakLineRight(chiccoPortrait, "...the warden of this dungeon also understands stillness.  He has learned part of correct sight, and can see true names.  The name <c:72FEFDFF>$ALICE</c> will have meaning to him.", "YeeHaw")
                                  l_1_0:speakLineLeft(bobPortrait, "Wow.  Uh, thanks.", "Talk2")
                                  l_1_0:speakLineLeft(alicePortrait, "Couldn't we just find an exit and sneak out?", "Spooked")
                                  l_1_0:speakLineRight(chiccoPortrait, "You can certainly try.", "FreakedOut")
                                  l_1_0:sleep(0.25)
                                  l_1_0:animate(1, function(l_1_0)
                                chicco:enableField(true)
                                chicco:setFieldIntensity(Math.lerp(0, 1, l_1_0))
                                             end)
                                  l_1_0:sleep(0.5)
                                  l_1_0:speakLineRight(chiccoPortrait, "I will help set you upon your path.", "Default")
                                  do return end
                                end
                                do return end
                                alice:halt(false)
                              end
                               -- Warning: missing end command somewhere! Added here
                            end
                             -- Warning: missing end command somewhere! Added here
                          end
                           -- Warning: missing end command somewhere! Added here
                        end
                         -- Warning: missing end command somewhere! Added here
                      end
                       -- Warning: missing end command somewhere! Added here
                    end
                     -- Warning: missing end command somewhere! Added here
                  end
                   -- Warning: missing end command somewhere! Added here
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
    else
      if l_6_0:getState()["Snuck out"] then
        sceneComponent:play(function(l_2_0)
      alice:halt(true)
      local chiccoPortrait = l_2_0:addCharacter("Portraits/Chicco/Chicco")
      local alicePortrait = l_2_0:addAlicePortrait()
      local bobPortrait = l_2_0:addCharacter("Portraits/Bob/Bob")
      l_2_0:speakLineRight(bobPortrait, "He said the central platform...", "Judgemental")
      l_2_0:sleep(0.2)
      l_2_0:animate(1, function(l_1_0)
        chicco:setFieldIntensity(Math.lerp(1, 0, l_1_0))
        chicco:enableField(false)
         end)
      l_2_0:sleep(1)
      l_2_0:speakLineRight(chiccoPortrait, "Yes.  This is my cell.  Welcome.", "Mystery")
      l_2_0:speakLineLeft(alicePortrait, "Thank you...", "Talk2")
      l_2_0:sleep(0.5)
      alice:get(AnimatorComponent):setFacing(Direction.DIR_E)
      l_2_0:sleep(0.5)
      alice:get(AnimatorComponent):setFacing(Direction.DIR_W)
      l_2_0:sleep(0.5)
      alice:get(AnimatorComponent):setFacing(Direction.DIR_N)
      l_2_0:speakLineLeft(alicePortrait, "...ah, I don't know if I'm facing you.", "Talk")
      l_2_0:speakLineRight(chiccoPortrait, "I am behind you.", "Mystery")
      l_2_0:sleep(0.25)
      alice:get(AnimatorComponent):setFacing(Direction.DIR_S)
      l_2_0:sleep(0.5)
      l_2_0:speakLineRight(chiccoPortrait, "My invisibility is not intended to discomfort you...actually, I have something that will help.  Hold out your hands.", "Mystery")
      local hat = alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/ThirdEyeHat")
      alice:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
      l_2_0:speakLineLeft(alicePortrait, "I can feel it...but what is it?", "Surprised")
      l_2_0:speakLineRight(chiccoPortrait, "Many things, but all of them are for your head.", "Mystery")
      l_2_0:speakLineLeft(alicePortrait, "Some kind of hat? I'll try it on.", "Spooked")
      l_2_0:speakLineRight(bobPortrait, "I don't see what good an invisible hat does.  ...literally.", "Talk3")
      local action = hat:getAction()
      alice:forceAction(action)
      l_2_0.skipping = false
      l_2_0:sleepWhile(function()
        return alice.action == action
         end)
      l_2_0:sleep(1)
      l_2_0:speakLineLeft(alicePortrait, "OH BITS!!!", "Surprised")
      l_2_0:speakLineRight(bobPortrait, "What is it?  Are you okay?", "Sad")
      alice.action.forceTakeOff = true
      l_2_0.skipping = false
      l_2_0:sleepWhile(function()
        return alice.action == action
         end)
      l_2_0:sleep(0.5)
      l_2_0:speakLineLeft(alicePortrait, "Yeah...I'm fine.", "Excited")
      self:getState()["Got hat"] = true
      chicco:get(InteractionComponent):stopInteract(entity)
      alice:halt(false)
      end)
      else
        if l_6_0:getState()["Made dummy"] then
          sceneComponent:play(function(l_3_0)
        alice:halt(true)
        local chiccoPortrait = l_3_0:addCharacter("Portraits/Chicco/Chicco")
        local alicePortrait = l_3_0:addAlicePortrait()
        local bobPortrait = l_3_0:addCharacter("Portraits/Bob/Bob")
        l_3_0:speakLineLeft(alicePortrait, "<c:8>I made a dummy.</c>", "Default")
        l_3_0:speakLineLeft(bobPortrait, "<c:8>I helped!</c>", "Excited")
        l_3_0:speakLineLeft(alicePortrait, "<c:8>It won't fool them forever, but it will last long enough.</c>", "HappyLaugh")
        l_3_0:speakLineRight(chiccoPortrait, "<c:8>You're learning. I will deal with the walls.</c>", "Mystery")
        l_3_0:sleep(0.2)
        l_3_0:animate(1, function(l_1_0)
          chicco:enableField(true)
          chicco:setFieldIntensity(Math.lerp(0, 1, l_1_0))
            end)
        l_3_0:sleep(1)
        l_3_0:speakLineLeft(bobPortrait, "<c:8>I feel weird.</c>", "Talk3")
        l_3_0:speakLineRight(chiccoPortrait, "<c:8>I am skilled at avoiding barriers.  In my presence, they need not trouble you.</c>", "Mystery")
        l_3_0:speakLineRight(chiccoPortrait, "<c:8>You can find me on the center platform.  I have something you now need.</c>", "Mystery")
        l_3_0:speakLineLeft(alicePortrait, "<c:8>I can't see you.</c>")
        l_3_0:speakLineRight(chiccoPortrait, "<c:8>There are many things you do not see that you might, in time.</c>", "Mystery")
        self:getState()["Snuck out"] = true
        chicco:get(InteractionComponent):stopInteract(entity)
        alice:halt(false)
         end)
        else
          if l_6_0:getState()["Got disguise goal"] then
            sceneComponent:play(function(l_4_0)
          alice:halt(true)
          local chiccoPortrait = l_4_0:addCharacter("Portraits/Chicco/Chicco")
          local alicePortrait = l_4_0:addAlicePortrait()
          local bobPortrait = l_4_0:addCharacter("Portraits/Bob/Bob")
          l_4_0:speakLineLeft(alicePortrait, "<c:8>I guess I need to fool the guards, but how am I supposed to that?</c>", "Snobby")
          l_4_0:speakLineRight(chiccoPortrait, "<c:8>When you don't see a path forward, you should sit and ponder.</c>", "Mystery")
          l_4_0:speakLineRight(chiccoPortrait, "<c:8>That's the zen way, the only way that really works.</c>", "Mystery")
          l_4_0:speakLineLeft(alicePortrait, "...uh.", "SidewaysGlance")
          l_4_0:speakLineRight(bobPortrait, "<c:8>We'll just...do that. Thanks.</c>", "Talk3")
          chicco:get(InteractionComponent):stopInteract(entity)
          alice:halt(false)
            end)
          else
            sceneComponent:play(function(l_5_0)
            alice:halt(true)
            local chiccoPortrait = l_5_0:addCharacter("Portraits/Chicco/Chicco")
            local alicePortrait = l_5_0:addAlicePortrait()
            local bobPortrait = l_5_0:addCharacter("Portraits/Bob/Bob")
            bob:forceAction()
            l_5_0:speakLineLeft(alicePortrait, "<c:8>We're here.</c>", "Snobby")
            l_5_0:speakLineRight(chiccoPortrait, "<c:8>Do you mean to reveal so much?  Who is the one who doesn't snore?</c>", "Mystery")
            l_5_0:speakLineLeft(alicePortrait, "<c:8>Wait a minute--</c>", "Angry")
            l_5_0:speakLineLeft(bobPortrait, "<c:8>I'm $BOB.  She's my human.  Didn't know she snored, but red is hard to--</c>", "Excited")
            l_5_0:speakLineLeft(alicePortrait, "<c:8>Hey!</c>", "Laughing")
            l_5_0:speakLineRight(chiccoPortrait, "<c:8>Red...mind your words, as you would another's. The reason for the wizard's personal interest in you is clear now.</c>", "Mystery")
            l_5_0:speakLineRight(chiccoPortrait, "<c:8>You may not have the perspective to see the danger you are in.  You must escape.</c>", "Mystery")
            l_5_0:speakLineLeft(alicePortrait, "<c:8>I'm working on it.</c>", "Talk")
            l_5_0:speakLineLeft(bobPortrait, "<c:8>But if you've got some ideas, we'd love to hear them.</c>", "Excited")
            l_5_0:speakLineLeft(alicePortrait, "<c:8>Well, yeah.</c>", "Talk2")
            l_5_0:speakLineRight(chiccoPortrait, "<c:8>I spoke of the walls before.  Leave those to me.  But there is more to escape than this cell, or even this dungeon.</c>", "Mystery")
            l_5_0:speakLineRight(chiccoPortrait, "<c:8>If your cell is found empty, you will certainly come to the wizard's attention once more.</c>", "Mystery")
            l_5_0:speakLineRight(chiccoPortrait, "<c:8>Find your way around that.  The way out will seem simple in comparison.</c>", "Mystery")
            self:getState()["Got disguise goal"] = true
            chicco:get(InteractionComponent):stopInteract(entity)
            alice:halt(false)
               end)
          end
        end
      end
    end
  end
end

return GeneralCells

