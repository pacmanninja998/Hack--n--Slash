-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\TowerLevel2.lua 

local Class = require("Class")
local Room = require("Room")
local TowerLevel2 = Room.classFromLayout("Content/Game/DourTower/Layouts/TowerLevel2", "TowerLevel2", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local Math = require("DFCommon.Math")
local Music = require("Music")
local Shader = require("Shader")
local Timer = require("Timer")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
TowerLevel2.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("Staircase1 exit", "Content/Game/DourTower/Rooms/Staircase1", "Exit_Rt")
  l_1_0:defineCollisionExit("Staircase2 exit", "Content/Game/DourTower/Rooms/Staircase2", "Exit_Lft")
  l_1_0:defineCollisionExit("Library exit", "Content/Game/DourTower/Rooms/LibraryOfBabble,Content/Game/DourTower/Rooms/TowerLevel2", nil, nil, nil, Direction.DIR_E)
  l_1_0.stairs = Entity.create("Content/Game/Global/Entities/Stairs", (l_1_0:getLayerByOrder(0)), nil, nil, nil, l_1_0.collisionAreasByName.Stairs, Direction.DIR_E, -0.75)
  l_1_0:getEntity("SevenSegmentClock").prop:setVisible(false)
  l_1_0:getEntity("Clock_Bell").prop:setVisible(false)
  l_1_0:getEntity("Clock_Skull").prop:setVisible(false)
  Music:setReverb("Exterior")
  if not l_1_0:getState().timerFired then
    l_1_0:defineLogicTrigger("Entrance trigger", l_1_0.onEntranceTrigger, l_1_0)
  else
    l_1_0:getCollisionArea("Entrance trigger"):setActive(false)
  end
  l_1_0:openDoors(true)
  l_1_0.alarmCount = 0
end

TowerLevel2.openDoors = function(l_2_0, l_2_1)
  l_2_0:getEntity("TrapDoor_Lft").prop:setVisible(not l_2_1)
  l_2_0:getEntity("TrapDoor_Rt").prop:setVisible(not l_2_1)
  l_2_0:getCollisionArea("TrapDoor 1"):setActive(not l_2_1)
  l_2_0:getCollisionArea("TrapDoor 2"):setActive(not l_2_1)
end

TowerLevel2.startTimer = function(l_3_0)
  local clockEntity = l_3_0:getEntity("SevenSegmentClock")
  clockEntity.prop:setVisible(true)
  local crashSeconds = 5
  local crashHours = crashSeconds / 3600
  clockEntity:setTime(crashHours, -1)
  l_3_0.timer = Timer.new(crashSeconds)
  l_3_0.timer.elapsedEvent:register(l_3_0.onCrashTimer, l_3_0)
end

TowerLevel2.onCrashTimer = function(l_4_0)
  local clockEntity = l_4_0:getEntity("SevenSegmentClock")
  clockEntity.ticking = false
  l_4_0:onAlarm()
end

TowerLevel2.onAlarm = function(l_5_0)
  l_5_0.alarmCount = l_5_0.alarmCount + 1
  local clockEntity = l_5_0:getEntity("SevenSegmentClock")
  clockEntity.prop:setVisible(true)
  clockEntity:alarm()
  l_5_0:getEntity("Clock_Skull").prop:setVisible(true)
  l_5_0.timer = Timer.new(0.5)
  l_5_0.timer.elapsedEvent:register(l_5_0.onAlarmOff, l_5_0)
end

TowerLevel2.onAlarmOff = function(l_6_0)
  l_6_0:getEntity("SevenSegmentClock").prop:setVisible(false)
  l_6_0:getEntity("Clock_Skull").prop:setVisible(false)
  l_6_0.timer = Timer.new(0.5)
  if l_6_0.alarmCount < 3 then
    l_6_0.timer.elapsedEvent:register(l_6_0.onAlarm, l_6_0)
  else
    l_6_0:getState().timerFired = true
    l_6_0:crash()
  end
end

TowerLevel2.tick = function(l_7_0)
  Class.super(TowerLevel2).tick(l_7_0)
  if l_7_0.timer then
    l_7_0.timer:tick()
  end
end

TowerLevel2.onEntranceTrigger = function(l_8_0)
  local alice = l_8_0:getAlice()
  local bob = l_8_0:getBob()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    self:openDoors(false)
    alice:get(SoundComponent):playCue("SFX/Hackable_Objects/ArmoryGate_Close")
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.3)
    self:insertPostEffect(cameraShake)
    l_1_0:animate(0.5, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.3, 0, l_1_0))
      end)
    self:removePostEffect()
    alice:halt(false)
    self:startTimer()
    l_1_0:sleep(0.5)
    l_1_0:floatText(bob, "Hey look, a clock!")
   end)
end

TowerLevel2.crash = function(l_9_0)
  error("KEEP OUT.\n\nSINCERELY,\n- ACTING REGENT WIZARD CHRISTO\n")
end

TowerLevel2.dontCrash = function(l_10_0)
  local alice = l_10_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    l_1_0:sleep(2)
    alice:halt(true)
    l_1_0:speakLineLeft(bobPortrait, "Huh. I wonder what that did.", "Talk3")
    l_1_0:speakLineRight(alicePortrait, "Don't worry about it.  Let's go!", "HappyLaugh")
    alice:halt(false)
    alice:get(SoundComponent):playCue("SFX/Hackable_Objects/ArmoryGate_Open")
    self:openDoors(true)
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.3)
    self:insertPostEffect(cameraShake)
    l_1_0:animate(0.5, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.3, 0, l_1_0))
      end)
    self:removePostEffect()
   end)
end

return TowerLevel2

