-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\Staircase3.lua 

local Class = require("Class")
local Room = require("Room")
local Staircase3 = Room.classFromLayout("Content/Game/DourTower/Layouts/Staircase", "Staircase3", "Content/Game/DourTower/Rooms/Staircase")
local Entity = require("Entity")
local Math = require("DFCommon.Math")
local Music = require("Music")
local Shader = require("Shader")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
Staircase3.onInit = function(l_1_0)
  Class.super(Staircase3).onInit(l_1_0)
  l_1_0:defineCollisionExit("Exit_Lft", "Content/Game/DourTower/Rooms/TowerLevel3", "Staircase3 exit")
  l_1_0:defineCollisionExit("Exit_Rt", "Content/Game/DourTower/Rooms/TowerLevel4", "Staircase3 exit")
end

Staircase3.onEntranceTrigger = function(l_2_0)
  local alice = l_2_0:getAlice()
  if not alice.state.escapedRoof then
    l_2_0:playWizardScene()
  else
    l_2_0:playAscent()
  end
end

Staircase3.playAscent = function(l_3_0)
  if l_3_0:getState().sawAscent then
    return 
  end
  l_3_0:getState().sawAscent = true
  local alice = l_3_0:getAlice()
  local bob = l_3_0:getBob()
  alice:get(SceneComponent):play(function(l_1_0)
    l_1_0:sleep(0.25)
    l_1_0:floatText(bob, "The wizard's not going to taunt us?", nil, {floatAbove = false})
    l_1_0:sleep(0.5)
    l_1_0:floatText(alice, "I think he's busy working on his next trap.", nil, {floatAbove = false})
    l_1_0:sleep(0.5)
    l_1_0:floatText(bob, "Do you think this one will be any better?", nil, {floatAbove = false})
    l_1_0:sleep(0.25)
    l_1_0:floatText(bob, "He doesn't have the best track record with traps.", nil, {floatAbove = false})
    l_1_0:sleep(0.5)
    l_1_0:floatText(alice, "He said it was the same way he banished the princess.", nil, {floatAbove = false})
    l_1_0:sleep(0.5)
    l_1_0:floatText(bob, "Why didn't he just try that on us to begin with?", nil, {floatAbove = false})
   end)
end

Staircase3.playWizardScene = function(l_4_0)
  if l_4_0:getState().sawMonologue then
    return 
  end
  l_4_0:getState().sawMonologue = true
  local alice = l_4_0:getAlice()
  local bob = l_4_0:getBob()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local head = Entity.create("Content/Game/DourTower/Entities/WizardHead", self:getLayerByOrder(0), alice:getPosition())
    head.prop:setScl(1.75)
    head:trackEntity(alice)
    head:appear()
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.6)
    self:insertPostEffect(cameraShake)
    l_1_0:animate(0.5, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.6, 0, l_1_0))
      end)
    self:removePostEffect()
    Music:playMusic("Music/Music/WizardTower_Level5_Layer3")
    head:setFace("Shocked")
    l_1_0:floatText(head, "You got past the crash cannon?!?", nil, {floatAbove = false})
    l_1_0:sleep(0.2)
    l_1_0:floatText(alice, "I don't think it was working.", nil, {floatAbove = false})
    l_1_0:sleep(0.5)
    head:setFace("Angry")
    l_1_0:floatText(head, "What?! It's one of my most nefarious traps!", nil, {floatAbove = false})
    l_1_0:sleep(0.5)
    l_1_0:floatText(bob, "It wasn't doing anything.", nil, {floatAbove = false})
    l_1_0:sleep(0.5)
    head:setFace("Skeptical")
    l_1_0:floatText(head, "It was working when I built it!", nil, {floatAbove = false})
    l_1_0:sleep(0.2)
    head:setFace("Angry")
    l_1_0:floatText(head, "You broke it!", nil, {floatAbove = false})
    self:insertPostEffect(cameraShake)
    local cue = alice:get(SoundComponent):playCue("SFX/Cutscenes/WizardTower_Earthquake")
    l_1_0:animate(0.3, function(l_2_0)
      head.prop:setScl(Math.lerp(1.75, 2, l_2_0))
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0, 0.4, l_2_0))
      end)
    l_1_0:floatText(head, "WHY DO YOU RUIN EVERYTHING?", nil, {floatAbove = false})
    alice:get(SoundComponent):stopCue(cue)
    l_1_0:animate(0.2, function(l_3_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.4, 0, l_3_0))
      end)
    self:removePostEffect()
    head:disappear()
    l_1_0:sleep(1)
   end)
end

return Staircase3

