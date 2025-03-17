-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\LibraryRoof.lua 

local Class = require("Class")
local Room = require("Room")
local Action = require("Action")
local CollisionArea = require("CollisionArea")
local CommonActions = require("CommonActions")
local Direction = require("Direction")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local Math = require("DFCommon.Math")
local Music = require("Music")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
local ShadowComponent = require("Components.ShadowComponent")
local Bomb = Entity.cache:load("Content/Game/Global/Entities/Bomb")
local Item = require("Item")
local BombItem = Item.cache:load("Content/Game/Global/Items/BombItem")
local ThirdEyeHat = Item.cache:load("Content/Game/Global/Items/ThirdEyeHat")
local LibraryRoof = Room.classFromLayout("Content/Game/DourTower/Layouts/LibraryRoof", "LibraryRoof", "Content/Game/Global/Rooms/GameRoom")
LibraryRoof.onInit = function(l_1_0)
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  Music:playMusic("Music/Music/WizardTower_Level5")
  Music:setReverb("Exterior")
  l_1_0.referenceVerticalOffset = 200
  l_1_0:getEntity("BrokenFloor_pieces"):setVisible(false)
  l_1_0:getEntity("BrokenFloor_Back"):setVisible(false)
  l_1_0:getEntity("BrokenFloor_Frnt"):setVisible(false)
  l_1_0:getEntity("BrokenFloor_HIDE"):setVisible(false)
  l_1_0:getEntity("BrokenFloor_Glow"):setVisible(false)
  l_1_0:getEntity("LibraryFire"):setVisible(false)
  l_1_0:getCollisionArea("Crack wall"):setActive(false)
end

LibraryRoof.fade = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  Class.super(LibraryRoof).fade(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  if l_2_1 == LibraryRoof.FADE_IN then
    l_2_0:playFallScene()
  end
end

LibraryRoof.playFallScene = function(l_3_0)
  local alice = l_3_0:getAlice()
  local bob = l_3_0:getBob()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local wizardBatPortrait = l_1_0:addCharacter("Portraits/WizardBat/WizardBat")
    alice:get(ShadowComponent):setEnabled(false)
    alice:get(PhysicsComponent):setActive(false)
    l_1_0:face(alice, Direction.DIR_S)
    alice:forceAction(CommonActions.LoopAnimation.new("Fall"))
    local sourceX, sourceY = self:getEntity("Fall start"):getPosition()
    local targetX, targetY = self:getEntity("Fall end"):getPosition()
    l_1_0:animate(4, function(l_1_0)
      local posX, posY = Math.lerp(sourceX, targetX, l_1_0), Math.lerp(sourceY, targetY, l_1_0)
      alice:setPosition(posX, posY, true)
      end)
    alice:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_TakeDamage", nil, 0.5, SoundComponent.PLAY_MODE_KEEP)
    local effectLayer = self:getLayerByName("MotionEffect")
    effectLayer.partition:clear()
    self:startCameraShake(l_1_0, 0.1, 3)
    alice:get(ShadowComponent):setEnabled(true)
    alice:get(PhysicsComponent):setActive(true)
    alice:forceAction()
    self:stopCameraShake(l_1_0, 0.5, 3)
    alice:halt(true)
    l_1_0:speakLineLeft(alicePortrait, "Ow.", "Angry")
    l_1_0:speakLineRight(wizardBatPortrait, "You have not yet begun to ow!", "Aah")
    l_1_0:sleep(0.2)
    l_1_0:face(alice, Direction.DIR_N)
    l_1_0:sleep(0.5)
    l_1_0:speakLineLeft(alicePortrait, "You're weird.", "SidewaysGlance")
    l_1_0:speakLineRight(wizardBatPortrait, "And you're finished.  No more traps!  You'll finally be gone!", "Laugh")
    l_1_0:speakLineLeft(bobPortrait, "Oh no!", "OMG")
    l_1_0:speakLineLeft(alicePortrait, "Pssh.", "DopeySmile")
    l_1_0:speakLineRight(wizardBatPortrait, "You're part of the world. You're in the library somewhere. If I destroy enough of it, I'll destroy you eventually!", "Default")
    l_1_0:speakLineLeft(alicePortrait, "Huh.  That would actually work.", "FreakedOut")
    l_1_0.skipping = false
    local wizardBat = self:getEntity("WizardBat_Roof")
    local animator = wizardBat:get(AnimatorComponent)
    animator:registerEventCallback(self, "Swipe", self.onSwipe)
    animator:registerEventCallback(self, "Smash 1", self.onFirstSmash)
    animator:registerEventCallback(self, "Smash 2", self.onSecondSmash)
    local tearUp = wizardBat:playAnimation("TearUpRoof")
    l_1_0:sleepWhile(function()
      if self.smashShake then
        self.smashShake = false
        self:stopCameraShake(scene, 0.5, 1)
      end
      return wizardBat.action == tearUp
      end)
    animator:unregisterEventCallback(self, "Swipe", self.onSwipe)
    animator:unregisterEventCallback(self, "Smash 1", self.onFirstSmash)
    animator:unregisterEventCallback(self, "Smash 2", self.onSecondSmash)
    self.destroyingBooks = true
    alice.destroyEvent:register(self.onAliceDestroy, self)
    bob.destroyEvent:register(self.onBobDestroy, self)
    self:fireBeam(l_1_0, wizardBat)
    l_1_0:sleep(2)
    l_1_0:speakLineRight(wizardBatPortrait, "I will vaporize every room in the library until you are gone!", "Aah")
    l_1_0:speakLineLeft(alicePortrait, "You'll destroy everything!", "Angry")
    l_1_0:speakLineRight(wizardBatPortrait, "Ha ha ha ha ha!", "Laugh")
    alice:halt(false)
    l_1_0.skipping = false
    self:universe().state.state.attackedLibrary = true
    self:fireBeam(l_1_0, wizardBat)
    alice:halt(true)
    l_1_0:speakLineLeft(bobPortrait, "There's no way around!", "Sad")
    l_1_0:speakLineRight(wizardBatPortrait, "Hah!", "Aah")
    l_1_0:speakLineLeft(alicePortrait, "$BOB, you can fly.", "Talk")
    l_1_0:speakLineLeft(bobPortrait, "I don't think I can fight him!", "OMG")
    l_1_0:speakLineRight(wizardBatPortrait, "I'LL CHEW YOU UP!", "Laugh3")
    l_1_0:speakLineLeft(alicePortrait, "Can you carry something over there?", "Bomb")
    l_1_0:speakLineLeft(bobPortrait, "I can try!", "NoWay")
    alice:halt(false)
    self.bobReady = true
    alice.actionEvent:register(self.onAliceAction, self)
    repeat
      if self.destroyingBooks then
        if self.bombTooHeavy and not self.bobComplained then
          l_1_0.skipping = false
          alice:halt(true)
          l_1_0:speakLineLeft(bobPortrait, "The bombs are too heavy!", "Sad")
          l_1_0:speakLineRight(alicePortrait, "We need to get a bomb over there.", "FreakedOut")
          l_1_0:speakLineLeft(bobPortrait, "You're gonna have to give me a lighter bomb, then!", "Sing")
          alice:halt(false)
          self.bobComplained = true
        end
        l_1_0.skipping = false
        self:fireBeam(l_1_0, wizardBat)
      else
        if not self.aliceDestroyed then
          l_1_0.skipping = false
          l_1_0:speakLineRight(wizardBatPortrait, "Ha ha ha ha!", "Laugh3")
          alice:halt(true)
          l_1_0:speakLineRight(wizardBatPortrait, "Wait, how are you still here? I thought I destroyed everything!", "Aah")
          l_1_0:speakLineRight(wizardBatPortrait, "...Nevermind! This is all according to plan!", "Hmm")
          l_1_0:speakLineLeft(alicePortrait, "...", "NonPlussed")
          l_1_0:speakLineRight(wizardBatPortrait, "This was all to trap you on this roof! I'll banish you like I banished her.", "EvilGlance2")
          l_1_0:speakLineLeft(alicePortrait, "The princess?", "Talk2")
          l_1_0:speakLineRight(wizardBatPortrait, "Never you mind. I must return to my chambers.", "EvilGlance")
          l_1_0:speakLineLeft(alicePortrait, "We're just going to come up there and defeat you again.", "DopeySmile")
          l_1_0:speakLineRight(wizardBatPortrait, "You're stuck here! I can fly and you can't!", "Aah")
          l_1_0.skipping = false
          local posX, posY = wizardBat:getPosition()
          do
            posY = posY - 150
            local wizardBatFlying = Entity.create("Content/Game/DourTower/Entities/WizardBat", self:getLayerByOrder(0), posX, posY)
            wizardBat:destroy()
            wizardBatFlying:forceAction(CommonActions.LoopAnimation.new("Fly"))
            self:stopCameraShake(l_1_0, 1, 2)
            l_1_0:floatText(wizardBatFlying, "WIZARD AWAY!")
            local offscreenX, offscreenY = posX, posY + 800
            l_1_0:animate(2, function(l_3_0)
              local flyX, flyY = Math.lerp(posX, offscreenX, l_3_0), Math.lerp(posY, offscreenY, l_3_0)
              wizardBatFlying:setPosition(flyX, flyY, true)
                  end)
            l_1_0:floatText(bob, "I can fly too!")
            l_1_0:sleep(0.5)
            bob:beExcited(wizardBat)
            l_1_0:floatText(bob, "I am flying right now, jerk!")
            l_1_0:sleep(1)
            l_1_0:floatText(wizardBatFlying, "Enjoy your time on the rooftop! I shall return with the mechanism of your exile! Ha ha ha ha!")
            l_1_0:sleep(0.5)
            bob:beExcited(self:getEntity("Hole locator"))
            l_1_0:sleep(0.5)
            l_1_0:floatText(bob, "Look, it's not even that far down.")
            l_1_0:sleep(0.5)
            bob:beExcited()
            l_1_0:speakLineLeft(alicePortrait, "I can just climb down the hole?", "NonPlussed")
            l_1_0:speakLineLeft(bobPortrait, "Yep. That guy's not very detail-oriented.", "Talk2")
            alice:halt(false)
            alice.destroyEvent:unregister(self.onAliceDestroy, self)
            bob.destroyEvent:unregister(self.onBobDestroy, self)
            self:defineLogicTrigger("Crack wall", self.onJumpDownHole, self)
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
end

LibraryRoof.destroy = function(l_4_0)
  if l_4_0:getAlice() then
    l_4_0:getAlice().destroyEvent:unregister(l_4_0.onAliceDestroy, l_4_0)
  end
  if l_4_0:getBob() then
    l_4_0:getBob().destroyEvent:unregister(l_4_0.onBobDestroy, l_4_0)
  end
  Class.super(LibraryRoof).destroy(l_4_0)
end

LibraryRoof.onJumpDownHole = function(l_5_0)
  local alice = l_5_0:getAlice()
  alice.state.escapedRoof = true
  alice.host:handleRoomExit(alice, "Content/Game/DourTower/Rooms/LibraryOfBabble,Content/Game/DourTower/Rooms/TowerLevel3")
end

LibraryRoof.onAliceDestroy = function(l_6_0)
  l_6_0.aliceDestroyed = true
  l_6_0.destroyingBooks = false
  error("I FOUND YOU. ENJOY OBLIVION. HA HA HA!")
end

LibraryRoof.onBobDestroy = function(l_7_0)
  l_7_0.bobDestroyed = true
  l_7_0.destroyingBooks = false
end

LibraryRoof.fireBeam = function(l_8_0, l_8_1, l_8_2)
  l_8_0:waitForBatReady(l_8_1, l_8_2)
  l_8_2.prop:setScl(1.5)
  local start = l_8_2:playAnimation("HackBeamRoof_Start")
  l_8_1:sleepWhile(function()
    return wizardBat.action == start
   end)
  l_8_2:get(SoundComponent):playCue("SFX/Characters/Behemoth/Behemoth_RoarAngry")
  l_8_0:getEntity("LibraryFire"):setVisible(true)
  local glow = l_8_0:getEntity("BrokenFloor_Glow")
  glow:setVisible(true)
  glow.prop:setColor(1, 1, 1, 0)
  glow.prop:seekColor(1, 1, 1, 1, 0.1)
  for i = 1, 3 do
    l_8_0:waitForBatReady(l_8_1, l_8_2)
    if i == 2 and not l_8_2:destroyNextFile() then
      l_8_0.destroyingBooks = false
    end
    local loop = l_8_2:playAnimation("HackBeamRoof_Loop")
    do
      l_8_1:sleepWhile(function()
        return wizardBat.action == loop
         end)
    end
  end
  glow.prop:seekColor(1, 1, 1, 0, 0.5)
  l_8_2.prop:setScl(1)
  l_8_1:sleep(0.5)
  l_8_0:getEntity("BrokenFloor_Glow"):setVisible(false)
end

LibraryRoof.waitForBatReady = function(l_9_0, l_9_1, l_9_2)
  repeat
    if l_9_2.action and l_9_2.action.pausedAction then
      local alice = l_9_0:getAlice()
      if l_9_2.action:is(Bomb.BombStun) and l_9_2.action ~= l_9_0.currentStun then
        l_9_0.currentStun = l_9_2.action
        local bob = l_9_0:getBob()
        if not l_9_0.enteredCodeRoom then
          l_9_1:floatText(bob, "What now?", 1)
          l_9_1:sleep(0.25)
          l_9_1:floatText(alice, "Fly in, $BOB! Hurry!", 1)
          bob:beExcited(l_9_2)
          l_9_1:floatText(bob, "Okay!", 0.5)
        else
          bob:beExcited(l_9_2)
          l_9_1:floatText(bob, "I'll fly back in!", 1)
        end
        alice:teleportInClassRoom(l_9_2)
        l_9_0.enteredCodeRoom = true
      end
      coroutine.yield()
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

LibraryRoof.onSwipe = function(l_10_0)
  local alice = l_10_0:getAlice()
  alice:get(HealthComponent):knockBack(0, -600)
  l_10_0:getEntity("WizardBat_Roof"):get(SoundComponent):playCue("SFX/Characters/Wizard_Bat/WizardBat_Destroy_Claw")
end

LibraryRoof.onFirstSmash = function(l_11_0)
  l_11_0.smashShake = true
  l_11_0:getEntity("WizardBat_Roof"):get(SoundComponent):playCue("SFX/Characters/Wizard_Bat/WizardBat_Destroy_Head")
  l_11_0:getEntity("Floor"):setVisible(false)
  l_11_0:getEntity("BrokenFloor_pieces"):setVisible(true)
  l_11_0:getEntity("BrokenFloor_Back"):setVisible(true)
  l_11_0:getEntity("BrokenFloor_Frnt"):setVisible(true)
  l_11_0:getEntity("BrokenFloor_HIDE"):setVisible(true)
  l_11_0:getCollisionArea("Crack wall"):setActive(true)
end

LibraryRoof.onSecondSmash = function(l_12_0)
  l_12_0:getEntity("WizardBat_Roof"):get(SoundComponent):playCue("SFX/Characters/Wizard_Bat/WizardBat_Destroy_Head")
  l_12_0:getEntity("BrokenFloor_pieces"):setVisible(false)
  l_12_0:getEntity("BrokenFloor_HIDE"):setVisible(false)
  l_12_0.smashShake = true
  l_12_0.smashed = true
end

LibraryRoof.onAliceAction = function(l_13_0, l_13_1)
  if l_13_1:is(BombItem.PlaceBombAction) and l_13_0.bobReady then
    l_13_1.bombPlacedEvent:register(l_13_0.onBombPlaced, l_13_0)
  end
end

LibraryRoof.BobAction = Class.create(Action, "LibraryRoof.BobAction")
LibraryRoof.BobAction.init = function(l_14_0, l_14_1)
  l_14_0.target = EntityRef.new(l_14_1)
end

LibraryRoof.BobAction.tick = function(l_15_0)
  if not l_15_0.target:isValid() then
    return false
  end
  local targetX, targetY = l_15_0.target.entity:getPosition()
  local sourceX, sourceY = l_15_0.entity:getPosition()
  local deltaX, deltaY = targetX - sourceX, targetY - sourceY
  local vx, vy = deltaX / MOAISim.getStep(), deltaY / MOAISim.getStep()
  local speedSq = vx * vx + vy * vy
  if speedSq < 1 then
    return false
  end
  local maxSpeed = l_15_0.MOVE_SPEED
  local speed = math.sqrt(speedSq)
  if maxSpeed < speed then
    local scalar = maxSpeed / speed
    vx, vy = vx * scalar, vy * scalar
    speed = maxSpeed
  end
  local physics = l_15_0.entity:get(PhysicsComponent)
  physics:setLinearVelocity(vx, vy)
  local animator = l_15_0.entity:get(AnimatorComponent)
  animator:updateDirection(vx / speed, vy / speed)
  animator:play("Fly")
  return true
end

LibraryRoof.BobGrabBomb = Class.create(LibraryRoof.BobAction, "LibraryRoof.BobGrabBomb")
LibraryRoof.BobGrabBomb.MOVE_SPEED = 2000
LibraryRoof.BobGrabBomb.init = function(l_16_0, l_16_1, l_16_2)
  Class.super(LibraryRoof.BobGrabBomb).init(l_16_0, l_16_1)
  l_16_0.bombTarget = EntityRef.new(l_16_2)
end

LibraryRoof.BobGrabBomb.tick = function(l_17_0)
  if Class.super(LibraryRoof.BobGrabBomb).tick(l_17_0) then
    return true
  end
  if l_17_0.target:isValid() then
    l_17_0.entity:queueAction(LibraryRoof.BobCarryBomb.new(l_17_0.target.entity, l_17_0.bombTarget.entity))
  end
  return false
end

LibraryRoof.BobCarryBomb = Class.create(LibraryRoof.BobAction, "LibraryRoof.BobCarryBomb")
LibraryRoof.BobCarryBomb.MOVE_SPEED = 75
LibraryRoof.BobCarryBomb.init = function(l_18_0, l_18_1, l_18_2)
  Class.super(LibraryRoof.BobCarryBomb).init(l_18_0, l_18_2)
  l_18_0.bomb = EntityRef.new(l_18_1)
  if l_18_1:isHeavy() then
    l_18_0.heavy = true
    l_18_0.MOVE_SPEED = l_18_0.MOVE_SPEED * 0.25
  end
end

LibraryRoof.BobCarryBomb.tick = function(l_19_0)
  if not l_19_0.bomb:isValid() then
    if l_19_0.heavy then
      l_19_0.entity:room().bombTooHeavy = true
    end
    return false
  end
  if Class.super(LibraryRoof.BobCarryBomb).tick(l_19_0) then
    l_19_0.entity:get(AnimatorComponent):setFacing(Direction.DIR_N)
    local vx, vy = l_19_0.entity:get(PhysicsComponent):getLinearVelocity()
    l_19_0.bomb.entity:get(PhysicsComponent):setLinearVelocity(vx, vy)
    return true
  else
    return false
  end
end

LibraryRoof.onBombPlaced = function(l_20_0, l_20_1)
  local bob = l_20_0:getBob()
  local wizardBat = l_20_0:getEntity("WizardBat_Roof")
  if not bob:isDoing(LibraryRoof.BobAction) then
    bob:forceAction(LibraryRoof.BobGrabBomb.new(l_20_1, wizardBat))
  end
end

return LibraryRoof

