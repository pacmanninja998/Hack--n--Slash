-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\SensorSpikes.lua 

local Entity = require("Entity")
local Action = require("Action")
local EntitySet = require("EntitySet")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local RevealSpikesAction = require("Class").create(Action, "RevealSpikesAction")
RevealSpikesAction.DELAY_TIME = 0.7
RevealSpikesAction.HOLD_TIME = 0.3
RevealSpikesAction.REVEAL_ANIMATION = "Reveal"
RevealSpikesAction.HOLD_ANIMATION = "Revealed"
RevealSpikesAction.HIDE_ANIMATION = "Hide"
RevealSpikesAction.HIDDEN_ANIMATION = "Hidden"
RevealSpikesAction.REVEAL_FRAMES_PER_SECOND = 30
RevealSpikesAction.HOLD_FRAMES_PER_SECOND = 30
RevealSpikesAction.HIDE_FRAMES_PER_SECOND = 40
RevealSpikesAction.HIDDEN_FRAMES_PER_SECOND = 30
RevealSpikesAction.init = function(l_1_0, l_1_1, l_1_2)
  if not l_1_1 then
    l_1_0.delay = l_1_0.DELAY_TIME
  end
  if not l_1_2 then
    l_1_0.hold = l_1_0.HOLD_TIME
  end
  Action.init(l_1_0)
end

RevealSpikesAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.elapsed = 0
  l_2_0.revealSequence = nil
  l_2_0.holdSequence = nil
  l_2_0.hideSequence = nil
  l_2_0.hidden = true
end

RevealSpikesAction.damageSensed = function(l_3_0)
  local numCanDamage = 0
  for _,entity in pairs(l_3_0.entity.sensedEntities.entities) do
    local health = entity:get(HealthComponent)
    local animator = entity:get(AnimatorComponent)
    if health and not health.invincible and animator then
      local dirX, dirY = animator:getDirVector()
      local knockBackMag = 512
      health:damage(1, l_3_0.entity, -knockBackMag * dirX, -knockBackMag * dirY, 0.05, 0.3, 1)
      numCanDamage = numCanDamage + 1
    end
  end
  return numCanDamage
end

RevealSpikesAction.tick = function(l_4_0)
  Action.tick(l_4_0)
  local numCanDamage = 0
  if not l_4_0.hidden then
    numCanDamage = l_4_0:damageSensed()
  end
  if not l_4_0.revealSequence and not l_4_0.holdSequence and not l_4_0.hideSequence then
    l_4_0.elapsed = l_4_0.elapsed + MOAISim.getStep()
    if l_4_0.delay < l_4_0.elapsed then
      l_4_0.hidden = false
      l_4_0.revealSequence = l_4_0.entity:get(AnimatorComponent):playOnce(l_4_0.REVEAL_ANIMATION, l_4_0.REVEAL_FRAMES_PER_SECOND)
    elseif l_4_0.revealSequence and not l_4_0.entity:get(AnimatorComponent):isPlaying(l_4_0.revealSequence) then
      l_4_0.elapsed = 0
      l_4_0.revealSequence = nil
      l_4_0.holdSequence = l_4_0.entity:get(AnimatorComponent):playOnce(l_4_0.HOLD_ANIMATION, l_4_0.HOLD_FRAMES_PER_SECOND)
     -- DECOMPILER ERROR: unhandled construct in 'if'

    elseif l_4_0.holdSequence and numCanDamage == 0 then
      l_4_0.elapsed = l_4_0.elapsed + MOAISim.getStep()
      if l_4_0.hold < l_4_0.elapsed then
        l_4_0.holdSequence = nil
        l_4_0.hideSequence = l_4_0.entity:get(AnimatorComponent):playOnce(l_4_0.HIDE_ANIMATION, l_4_0.HIDE_FRAMES_PER_SECOND)
      end
    end
  end
  return true
end

RevealSpikesAction.stop = function(l_5_0)
  l_5_0.entity:get(AnimatorComponent):play(l_5_0.HIDDEN_ANIMATION, l_5_0.HIDDEN_FRAMES_PER_SECOND)
  l_5_0.hidden = true
  Action.stop(l_5_0)
end

local SensorSpikes = require("Class").create(Entity, "SensorSpikes")
SensorSpikes.HIDDEN_ANIM = "Hidden"
SensorSpikes.FRAMES_PER_SECOND = 4
SensorSpikes.init = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  Entity.init(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  SpriteComponent.new(l_6_0, "Interactions/Props/Placeholder/SensorSpikes/SensorSpikes")
  l_6_0:get(SpriteComponent).prop:setPriority(-64)
  AnimatorComponent.new(l_6_0, true)
  l_6_0:get(AnimatorComponent):play(l_6_0.HIDDEN_ANIM, l_6_0.FRAMES_PER_SECOND)
  PhysicsComponent.new(l_6_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  l_6_0:get(PhysicsComponent):setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY, l_6_0.onHitDynamic, l_6_0, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  l_6_0.sensedEntities = EntitySet.new()
end

SensorSpikes.onHitDynamic = function(l_7_0, l_7_1, l_7_2)
  if l_7_2 == MOAIBox2DArbiter.BEGIN then
    l_7_0.sensedEntities:addEntity(l_7_1)
    if l_7_1 and l_7_1:get(HealthComponent) and not l_7_0.action then
      l_7_0:forceAction(RevealSpikesAction.new())
    else
      if l_7_2 == MOAIBox2DArbiter.END then
        l_7_0.sensedEntities:removeEntity(l_7_1)
      end
    end
  end
end

return SensorSpikes

