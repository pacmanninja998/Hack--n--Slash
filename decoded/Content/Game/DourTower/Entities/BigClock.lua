-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\BigClock.lua 

local Entity = require("Entity")
local BigClock = require("Class").create(Entity, "BigClock")
local Delegate = require("DFMoai.Delegate")
local SpriteSheet = require("SpriteSheet")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
BigClock.DEFAULT_TIME_FACTOR = 1000
BigClock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/BigClockFace/BigClockFace")
  PhysicsComponent.new(l_1_0, 100, 100, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  local handSheet = SpriteSheet.load("Interactions/Props/Placeholder/BigClockHand/BigClockHand")
  l_1_0.handProp = MOAIProp.new()
  local deck, index = handSheet:getDeck("BigHand", 1, false)
  if deck then
    l_1_0.handProp:setPriority(0)
    l_1_0.handProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
    l_1_0.handProp:setDeck(deck)
    l_1_0.handProp:setIndex(index)
    l_1_0:attachProp(l_1_0.handProp)
  end
  l_1_0.hours = 0
  l_1_0.timeFactor = 1
  l_1_0.ticking = false
end

BigClock.tick = function(l_2_0)
  local prevTime = l_2_0.hours
  if l_2_0.ticking then
    l_2_0.hours = l_2_0.hours + MOAISim.getStep() * l_2_0.timeFactor
    if l_2_0.hours >= 12 then
      prevTime = prevTime - 12
      l_2_0.hours = l_2_0.hours - 12
    end
  end
  if l_2_0.timerHours and prevTime <= l_2_0.timerHours and l_2_0.timerHours < l_2_0.hours then
    l_2_0.timerEvent:dispatch()
  end
  local angle = -30 * l_2_0.hours
  local minuteAngle = 6 * math.ceil(angle / 6)
  l_2_0.handProp:setRot(0, 0, minuteAngle)
  Entity.tick(l_2_0)
end

BigClock.setTime = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_0.hours = l_3_1 or 0
  l_3_0.timeFactor = l_3_2 or 1
  l_3_0.ticking = not l_3_3
end

BigClock.setTimer = function(l_4_0, l_4_1, l_4_2, l_4_3)
  l_4_0.timerHours = l_4_1
  l_4_0.timerEvent = Delegate.new()
  l_4_0.timerEvent:register(l_4_2, l_4_3)
end

return BigClock

