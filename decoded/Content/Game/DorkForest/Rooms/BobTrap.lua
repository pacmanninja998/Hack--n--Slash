-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Rooms\BobTrap.lua 

local BobTrap = require("Room").classFromLayout("Content/Game/DorkForest/Layouts/BobTrap", "BobTrap", "Content/Game/Global/Rooms/GameRoom")
local Class = require("Class")
local Music = require("Music")
local Entity = require("Entity")
local Shader = require("Shader")
local Graphics = require("DFCommon.Graphics")
local Math = require("DFCommon.Math")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
BobTrap.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("CaveTrap exit", "Content/Game/DorkForest/Rooms/CaveTrap", "BobTrap exit")
  l_1_0:defineCollisionExit("SpookyPath exit", "Content/Game/DorkForest/Rooms/SpookyPath", "BobTrap exit")
  l_1_0.hsvTint = {0, 0, 0}
  Music:playMusic(nil)
  Music:playAmbient("Ambience/Ambience/CaveTrap_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  l_1_0:getEntity("NoHackBlock").REMAINING_PUSHES = 1
  l_1_0:enableWater()
end

BobTrap.onAliceCreated = function(l_2_0, l_2_1)
  Class.super(BobTrap).onAliceCreated(l_2_0, l_2_1)
  if not l_2_1.state.bondedSprite then
    l_2_0:getEntity("HackBlock").pushEvent:register(l_2_0.onHackBlockPush, l_2_0)
    l_2_1:get(SceneComponent):play(function(l_1_0)
      self:playMumbles(l_1_0)
      end)
  end
end

BobTrap.onHackBlockPush = function(l_3_0)
  l_3_0.blockPushed = true
  l_3_0:getAlice():get(SceneComponent).scene:onSkip()
  l_3_0:getEntity("HackBlock").pushEvent:unregister(l_3_0.onHackBlockPush, l_3_0)
end

BobTrap.playMumbles = function(l_4_0, l_4_1)
  local mumbleLines = {"This hole is actually kinda comfortable.", "Hey there little bug. Do you know a way out?", "At least it's warm down here.", "Wait, how did I get trapped in here in the first place?", "Is anybody out there?", "Can you hear me?", "Open sesame!  ... Dangit!"}
  local charsPerSecond = 10
  repeat
    if not l_4_0.blockPushed then
      local lineIndex = math.random(#mumbleLines)
      local line = mumbleLines[lineIndex]
      local mumbleLine = l_4_0:makeMumbly(line)
      l_4_1:sleep(math.random(1, 2))
      l_4_1:floatText(l_4_0:getEntity("HackBlock"), mumbleLine, #mumbleLine / charsPerSecond)
    else
      l_4_1.skipping = false
      local x, y = l_4_0:getEntity("HackBlock"):getPosition()
      local alice = l_4_0:getAlice()
      alice:halt(true)
      local bob = Entity.create("Content/Game/Global/Entities/RedSprite", l_4_0:getLayerByOrder(0), x, y, "Bob")
      bob:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
      l_4_1:sleep(0.5)
      local alicePortrait = l_4_1:addAlicePortrait()
      local bobPortrait = l_4_1:addCharacter("Portraits/Bob/Bob")
      l_4_1:speakLineLeft(alicePortrait, "Hey down there.  Are you okay?", "Spooked")
      l_4_1:speakLineRight(bobPortrait, "Phew! I got free!", "Sing")
      l_4_1:speakLineRight(bobPortrait, "Oh hi. Be careful, that hole is tricky.", "Excited")
      l_4_1:speakLineLeft(alicePortrait, "Hey! You're a sprite, right?", "Default3")
      l_4_1:speakLineRight(bobPortrait, "Yeah, obv-- HEY! You're a human! A RED human!", "NoWay")
      l_4_1:speakLineLeft(alicePortrait, "Red?", "Talk2")
      local posX, posY = alice:getPosition()
      l_4_0.bondShader = Shader.create("Content/Game/Global/Shaders/BondingGlowParticle")
      local bondTexture = Graphics.loadTexture("Particles/Textures/BondingGlow")
      l_4_0.bondGlow = Entity.create("Content/Game/Global/Entities/Effects/BondingGlow", l_4_0:getLayerByName("Overlay"), posX, posY + 20)
      l_4_0.bondGlow:setDefaultShader(l_4_0.bondShader)
      local targetSprite = l_4_0.bondGlow:get(SpriteComponent)
      targetSprite.prop:setPriority(300)
      if targetSprite then
        targetSprite.material:setTexture(bondTexture)
        targetSprite.material:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE)
        local deck, index = targetSprite.sheet:getDeck(targetSprite.name, targetSprite.frame, targetSprite.looping)
        local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
        local u0, v0, u1, v1 = x0, y0, x2, y2
        local uScale = u1 - u0
        local vScale = v1 - v0
        targetSprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
      end
      l_4_0.bondShader:setFragmentUniformFloat("shaderDuration", 0.1)
      l_4_1:speakLineRight(bobPortrait, "OH BITS WE FOUND EACH OTHER.", "OMG")
      local bondCue = alice:get(SoundComponent):playCue("SFX/Cutscenes/Bonding", nil, 0.5)
      alice:get(SoundComponent):setParameter(bondCue, "Pitch", 0)
      bob:bond(alice)
      l_4_1:animate(1, function(l_1_0)
        self.bondGlow.prop:setScl(Math.lerp(1e-005, 60, l_1_0))
        self.bondShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0.1, 0.5, l_1_0))
         end)
      l_4_1:speakLineLeft(alicePortrait, "I think we're a match!", "HappyLaugh")
      alice:get(SoundComponent):setParameter(bondCue, "Pitch", 0.3)
      do
        local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
        cameraShake:setFragmentUniformFloat("shaderDuration", 0.05)
        l_4_0:insertPostEffect(cameraShake)
        l_4_1:animate(0.5, function(l_2_0)
        self.bondShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0.5, 0.7, l_2_0))
         end)
        l_4_1:speakLineRight(bobPortrait, "Yeah! We're going to be...", "Excited")
        alice:get(SoundComponent):setParameter(bondCue, "Pitch", 0.6)
        l_4_1:animate(1, function(l_3_0)
        self.bondGlow.prop:setScl(Math.lerp(60, 150, l_3_0))
        self.bondShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0.7, 0.8, l_3_0))
        self.bondShader:setFragmentUniformFloat("rotationSpeed", Math.lerp(0.4, 0.8, l_3_0))
        self.bondShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0.05, 0.3, l_3_0))
         end)
        l_4_1:speakLineRight(bobPortrait, "BEST FRIENNNNNNDS!", "BestFriends")
        alice:get(SoundComponent):setParameter(bondCue, "Pitch", 0.9)
        l_4_1:animate(3, function(l_4_0)
        self.bondGlow.prop:setScl(Math.lerp(150, 300, l_4_0))
        self.bondShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0.8, 1, l_4_0))
        self.bondShader:setFragmentUniformFloat("rotationSpeed", Math.lerp(0.8, 2, l_4_0))
        self.bondShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0.3, 0.8, l_4_0))
         end)
        Music:playMusic(nil)
        Music:playAmbient(nil)
        alice:get(SoundComponent):stopCue(bondCue)
        l_4_0:removePostEffect()
        l_4_1:displayTitleCard(2, "Nearby...")
        alice.host:cutToWizard("Bonding ritual")
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BobTrap.startScene = function(l_5_0, l_5_1)
  if l_5_1 == "Bonding ritual" then
    l_5_0:finishBondingRitual()
  end
end

BobTrap.finishBondingRitual = function(l_6_0)
  Music:playMusic(nil)
  Music:playAmbient("Ambience/Ambience/CaveTrap_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  local alice = l_6_0:getAlice()
  alice:get(SoundComponent):playCue("SFX/Cutscenes/Bonding_End", nil, 0.5)
  alice:get(SceneComponent):play(function(l_1_0)
    self.bondShader:setFragmentUniformFloat("shaderDuration", 0.8)
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.3)
    self:insertPostEffect(cameraShake)
    l_1_0:animate(1, function(l_1_0)
      self.bondGlow.prop:setScl(Math.lerp(100, 1e-006, l_1_0))
      self.bondShader:setFragmentUniformFloat("shaderDuration", Math.lerp(0.8, 0, l_1_0))
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.3, 0, l_1_0))
      end)
    self.bondGlow:destroy()
    self:removePostEffect()
    l_1_0:sleep(0.3)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    l_1_0:speakLineRight(bobPortrait, "Yes!! Best friends forever. Oh yeah, what's my name?", "Excited")
    l_1_0:speakLineLeft(alicePortrait, "I don't know!", "Default3")
    l_1_0:speakLineRight(bobPortrait, "Oh come ooooooon!  You bond with a sprite, you pick a name.  You know the rules.", "Judgemental")
    l_1_0:speakLineLeft(alicePortrait, "Wait, what rules? Who made the rules?", "Talk")
    l_1_0:speakLineRight(bobPortrait, "...I don't know. They're just the rules!", "Talk3")
    l_1_0:speakLineLeft(alicePortrait, "Hmm... how about we call you...", "Snobby")
    alice.state.bondedSprite = l_1_0:getPlayerText("Bob")
    alice:get(SceneComponent):mapString("$BOB", alice.state.bondedSprite)
    l_1_0:speakLineRight(bobPortrait, "$BOB.  ...$BOB.  Awesome!  Ooh, ooh, and your name can be...uh, uh, Wenlasriel!", "Excited")
    l_1_0:speakLineLeft(alicePortrait, "My name is $ALICE.", "HappyLaugh")
    l_1_0:speakLineRight(bobPortrait, "Whoa!  You can break the rules!  Cool.", "Default")
    l_1_0:speakLineLeft(alicePortrait, "Let's get out of here. That was bound to draw some attention.", "Talk2")
    l_1_0:speakLineRight(bobPortrait, "Yeah, let's go on an adventure!", "Sing")
    alice:halt(false)
   end)
end

BobTrap.makeMumbly = function(l_7_0, l_7_1)
  local mumbles = ""
  for word in string.gmatch(l_7_1, "%S+") do
    if #mumbles ~= 0 then
      mumbles = mumbles .. " "
    end
    for i = 1, #word do
      local char = word:sub(i, i)
      if not char:match("%a") then
        mumbles = mumbles .. char
      else
        local mumbleStart = "mmpf"
        local mumbleChar = nil
        if i <= #mumbleStart then
          mumbleChar = mumbleStart:sub(i, i)
        else
          mumbleChar = "m"
        end
        if char:upper() == char then
          mumbles = mumbles .. mumbleChar:upper()
        else
          mumbles = mumbles .. mumbleChar
        end
      end
    end
  end
  return mumbles
end

return BobTrap

