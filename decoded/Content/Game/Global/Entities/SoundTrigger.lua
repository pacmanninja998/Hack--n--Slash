-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\SoundTrigger.lua 

local Entity = require("Entity")
local SoundTrigger = require("Class").create(Entity, "SoundTrigger")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local Math = require("DFCommon.Math")
SoundTrigger.DEFAULT_VOLUME_MULTIPLIER = 5000
SoundTrigger.STOP_SECONDS = 0.5
SoundTrigger.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.audioEvent = l_1_5
  l_1_0.cueName = l_1_5.cue
  l_1_0.soundMaker = l_1_6
  l_1_0.volume = l_1_5.volume * l_1_0.DEFAULT_VOLUME_MULTIPLIER
  l_1_0.perceptibleRadius = math.sqrt(l_1_0.volume / SoundComponent.MIN_AUDIBLE_VOLUME)
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.SOUND_CATEGORY, PhysicsComponent.SOUND_CATEGORY, MOAIBox2DBody.DYNAMIC, true)
  l_1_0.sensor = l_1_0:get(PhysicsComponent):addCircleSensor(l_1_0.perceptibleRadius, PhysicsComponent.SOUND_CATEGORY, PhysicsComponent.SOUND_CATEGORY)
  l_1_0.sensor.entityEnterEvent:register(l_1_0.onEntityEnterSound, l_1_0)
  l_1_0.sensor.entityLeaveEvent:register(l_1_0.onEntityLeaveSound, l_1_0)
  l_1_0.timeStopped = 0
end

SoundTrigger.getVolumeAtPos = function(l_2_0, l_2_1, l_2_2)
  local posX, posY = l_2_0:getPosition()
  local distSq = Math.distance2DSquared(posX, posY, l_2_1, l_2_2)
  return l_2_0.volume / distSq
end

SoundTrigger.onEntityEnterSound = function(l_3_0, l_3_1)
  local sound = l_3_1:get(SoundComponent)
  if sound then
    sound:onStartHearSound(l_3_0)
  end
end

SoundTrigger.onEntityLeaveSound = function(l_4_0, l_4_1)
  local sound = l_4_1:get(SoundComponent)
  if sound then
    sound:onStopHearSound(l_4_0)
  end
end

SoundTrigger.tick = function(l_5_0)
  if l_5_0.audioEvent:isValid() then
    l_5_0.timeStopped = 0
  else
    l_5_0.timeStopped = l_5_0.timeStopped + MOAISim.getStep()
  end
  if l_5_0.STOP_SECONDS < l_5_0.timeStopped then
    l_5_0:destroy()
  end
  Entity.tick(l_5_0)
end

SoundTrigger.setVolume = function(l_6_0, l_6_1)
  l_6_0.volume = l_6_1 * l_6_0.DEFAULT_VOLUME_MULTIPLIER
  l_6_0.perceptibleRadius = math.sqrt(l_6_0.volume / SoundComponent.MIN_AUDIBLE_VOLUME)
  l_6_0.sensor.fixture:destroy()
  l_6_0.sensor = l_6_0:get(PhysicsComponent):addCircleSensor(l_6_0.perceptibleRadius, PhysicsComponent.SOUND_CATEGORY, PhysicsComponent.SOUND_CATEGORY)
  l_6_0.sensor.entityEnterEvent:register(l_6_0.onEntityEnterSound, l_6_0)
  l_6_0.sensor.entityLeaveEvent:register(l_6_0.onEntityLeaveSound, l_6_0)
end

return SoundTrigger

