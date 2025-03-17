-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\PoisonPond.lua 

local Entity = require("Entity")
local Action = require("Action")
local Math = require("DFCommon.Math")
local SpriteComponent = require("Components.SpriteComponent")
local ColorTransition = require("Class").create(Action, "ColorTransition")
ColorTransition.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.srcColor = l_1_1
  l_1_0.dstColor = l_1_2
  l_1_0.duration = l_1_3
  l_1_0.progress = l_1_4 or 0
  l_1_0.elapsed = l_1_0.progress * l_1_0.duration
end

ColorTransition.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
   -- DECOMPILER ERROR: No list found. Setlist fails

  if not l_2_0.srcColor then
     -- Warning: undefined locals caused missing assignments!
     -- Warning: missing end command somewhere! Added here
  end
end

ColorTransition.tick = function(l_3_0)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  l_3_0.progress = Math.pinPct(l_3_0.elapsed / l_3_0.duration)
  local lerpR = Math.lerp(l_3_0.srcColor[1], l_3_0.dstColor[1], l_3_0.progress)
  local lerpG = Math.lerp(l_3_0.srcColor[2], l_3_0.dstColor[2], l_3_0.progress)
  local lerpB = Math.lerp(l_3_0.srcColor[3], l_3_0.dstColor[3], l_3_0.progress)
  l_3_0.entity.prop:setColor(lerpR, lerpG, lerpB)
  return l_3_0.elapsed < l_3_0.duration
end

ColorTransition.getProgress = function(l_4_0, l_4_1, l_4_2)
  local totalProgress = 0
  local changingChannels = 0
  for channel = 1, 3 do
    local delta = l_4_1[channel] - l_4_0[channel]
    if delta ~= 0 then
      totalProgress = totalProgress + (l_4_2[channel] - l_4_0[channel]) / delta
      changingChannels = changingChannels + 1
    end
  end
  if changingChannels ~= 0 then
    return (totalProgress) / (changingChannels)
  else
    return 1
  end
end

local PoisonPond = require("Class").create(Entity, "PoisonPond")
PoisonPond.TRANSITION_TIME = 2
PoisonPond.CLEAN_COLOR = {0, 0.8, 1}
PoisonPond.DIRTY_COLOR = {0.6, 0, 1}
PoisonPond.POISONOUS_THRESHHOLD = 0.1
PoisonPond.init = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  Entity.init(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  SpriteComponent.new(l_5_0, "Interactions/Props/Placeholder/PoisonPond/PoisonPond")
  l_5_0.healAmount = -3
  l_5_0.prop:setColor(l_5_0.DIRTY_COLOR[1], l_5_0.DIRTY_COLOR[2], l_5_0.DIRTY_COLOR[3])
  l_5_0.authoritative = false
end

PoisonPond.setAuthoritative = function(l_6_0, l_6_1)
  l_6_0.authoritative = l_6_1
end

PoisonPond.colorEqual = function(l_7_0, l_7_1, l_7_2)
  return l_7_1[1] == l_7_2[1] and l_7_1[2] == l_7_2[2] and l_7_1[3] == l_7_2[3]
end

PoisonPond.setHealAmount = function(l_8_0, l_8_1, l_8_2)
  l_8_0.healAmount = l_8_1
   -- DECOMPILER ERROR: No list found. Setlist fails

  local curColor = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  if not l_8_2 or not l_8_0.prop:getColor() then
    local transitionTime = l_8_0.TRANSITION_TIME
  end
  do
    if l_8_0.healAmount < l_8_0.POISONOUS_THRESHHOLD and not l_8_0:colorEqual(curColor, l_8_0.DIRTY_COLOR) and (not l_8_0.action or not l_8_0:colorEqual(l_8_0.action.dstColor, l_8_0.DIRTY_COLOR)) then
      local progress = ColorTransition.getProgress(l_8_0.CLEAN_COLOR, l_8_0.DIRTY_COLOR, curColor)
      l_8_0:forceAction(ColorTransition.new(l_8_0.CLEAN_COLOR, l_8_0.DIRTY_COLOR, transitionTime, progress))
      if l_8_0.authoritative then
        l_8_0.layer.room:getState().SwampHealAmount = l_8_1
      end
      do return end
      if l_8_0.POISONOUS_THRESHHOLD <= l_8_0.healAmount and not l_8_0:colorEqual(curColor, l_8_0.CLEAN_COLOR) and (not l_8_0.action or not l_8_0:colorEqual(l_8_0.action.dstColor, l_8_0.CLEAN_COLOR)) then
        local progress = ColorTransition.getProgress(l_8_0.DIRTY_COLOR, l_8_0.CLEAN_COLOR, curColor)
        l_8_0:forceAction(ColorTransition.new(l_8_0.DIRTY_COLOR, l_8_0.CLEAN_COLOR, transitionTime, progress))
        if l_8_0.authoritative then
          l_8_0.layer.room:getState().SwampHealAmount = l_8_1
        end
      end
    end
  end
end

return PoisonPond

