-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Effect.lua 

local Entity = require("Entity")
local Effect = require("Class").create(Entity, "Effect")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
Effect.createSubclass = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local class = require("Class").create(Effect, l_1_0)
  class.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
    Effect.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, effectName, loop, frameRate, (l_1_5 or 1) * (scaleX or 1), (l_1_5 or 1) * (scaleY or scaleX or 1))
   end
  return class
end

Effect.init = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5, l_2_6, l_2_7, l_2_8, l_2_9)
  Entity.init(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_0.effect, l_2_0.loop, l_2_0.frameRate = l_2_5, l_2_6, l_2_7
  l_2_0.prop:setScl(l_2_8 or 1, l_2_9 or 1)
  SpriteComponent.new(l_2_0, "FX/FX")
  AnimatorComponent.new(l_2_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  l_2_0:setLabelText("")
end

Effect.activate = function(l_3_0)
  Entity.activate(l_3_0)
  if not l_3_0.loop then
    l_3_0.sequence = l_3_0:get(AnimatorComponent):playOnce(l_3_0.effect, l_3_0.frameRate)
  else
    l_3_0.sequence = l_3_0:get(AnimatorComponent):play(l_3_0.effect, l_3_0.frameRate)
  end
end

Effect.tick = function(l_4_0)
  Entity.tick(l_4_0)
  if not l_4_0.loop then
    local animator = l_4_0:get(AnimatorComponent)
    if not animator:isPlaying(l_4_0.sequence) then
      l_4_0:destroy()
    end
  end
end

return Effect

