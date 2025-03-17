-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\SevenSegmentClock.lua 

local Entity = require("Entity")
local SevenSegmentClock = require("Class").create(Entity, "SevenSegmentClock")
local Delegate = require("DFMoai.Delegate")
local SpriteSheet = require("SpriteSheet")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
SevenSegmentClock.DEFAULT_TIME_FACTOR = 1000
SevenSegmentClock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PhysicsComponent.new(l_1_0, 100, 100, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SoundComponent.new(l_1_0)
  local digitSheet = SpriteSheet.load("Interactions/Props/SevenSegment/SevenSegment")
  l_1_0.hour1Prop = MOAIProp.new()
  l_1_0.hour2Prop = MOAIProp.new()
  l_1_0.min1Prop = MOAIProp.new()
  l_1_0.min2Prop = MOAIProp.new()
  l_1_0.sec1Prop = MOAIProp.new()
  l_1_0.sec2Prop = MOAIProp.new()
  l_1_0.digitProps = {l_1_0.hour1Prop, l_1_0.hour2Prop, l_1_0.min1Prop, l_1_0.min2Prop, l_1_0.sec1Prop, l_1_0.sec2Prop}
  local offsets = {0, 0, 74, 0, 163, 0, 236, 0, 300, -34, 353, -34}
  local scales = {1, 1, 1, 1, 0.64, 0.64}
  l_1_0.sec1, l_1_0.sec2, l_1_0.min1, l_1_0.min2, l_1_0.hour1, l_1_0.hour2 = 8, 8, 8, 8, 8, 8
  local deck, index = digitSheet:getDeck("SevenSegment", 8, false)
  if deck then
    for i,prop in ipairs(l_1_0.digitProps) do
      prop:setPriority(0)
      prop:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
      prop:setDeck(deck)
      prop:setIndex(8)
      prop:setLoc(offsets[2 * (i - 1) + 1], offsets[2 * (i - 1) + 2])
      prop:setScl(scales[i])
      l_1_0:attachProp(prop)
    end
  end
  l_1_0.hours = 0
  l_1_0.timeFactor = 1
  l_1_0.ticking = false
end

SevenSegmentClock.tick = function(l_2_0)
  local prevTime = l_2_0.hours
  if l_2_0.ticking then
    l_2_0.hours = l_2_0.hours + MOAISim.getStep() * l_2_0.timeFactor / 3600
    if l_2_0.hours >= 12 then
      prevTime = prevTime - 12
      l_2_0.hours = l_2_0.hours - 12
    end
    l_2_0:updateClock()
  end
  Entity.tick(l_2_0)
end

SevenSegmentClock.updateClock = function(l_3_0)
  local hours = math.floor(l_3_0.hours)
  local exactMinutes = 60 * (l_3_0.hours - hours)
  local minutes = math.floor(exactMinutes)
  local exactSeconds = 60 * (exactMinutes - minutes)
  local seconds = math.floor(exactSeconds)
  local sec2, min2, hour2 = seconds % 10, minutes % 10, hours % 10
  local sec1, min1, hour1 = (seconds - sec2) / 10, (minutes - min2) / 10, (hours - hour2) / 10
  if sec1 ~= l_3_0.sec1 or sec2 ~= l_3_0.sec2 or min1 ~= l_3_0.min1 or min2 ~= l_3_0.min2 or hour1 ~= l_3_0.hour1 or hour2 ~= l_3_0.hour2 then
    l_3_0:get(SoundComponent):playCue("SFX/Objects/ClockTick")
    l_3_0.sec1, l_3_0.sec2, l_3_0.min1, l_3_0.min2, l_3_0.hour1, l_3_0.hour2 = sec1, sec2, min1, min2, hour1, hour2
    l_3_0.sec1Prop:setIndex(sec1 == 0 and 10 or sec1)
    l_3_0.sec2Prop:setIndex(sec2 == 0 and 10 or sec2)
    l_3_0.min1Prop:setIndex(min1 == 0 and 10 or min1)
    l_3_0.min2Prop:setIndex(min2 == 0 and 10 or min2)
    l_3_0.hour1Prop:setIndex(hour1 == 0 and 10 or hour1)
    l_3_0.hour2Prop:setIndex(hour2 == 0 and 10 or hour2)
  end
end

SevenSegmentClock.alarm = function(l_4_0)
  l_4_0:get(SoundComponent):playCue("SFX/Objects/ClockCrash", false, 2, SoundComponent.PLAY_MODE_DUPLICATE)
end

SevenSegmentClock.setTime = function(l_5_0, l_5_1, l_5_2, l_5_3)
  l_5_0.hours = l_5_1 or 0
  l_5_0.timeFactor = l_5_2 or 1
  l_5_0.ticking = not l_5_3
  l_5_0:updateClock()
end

return SevenSegmentClock

