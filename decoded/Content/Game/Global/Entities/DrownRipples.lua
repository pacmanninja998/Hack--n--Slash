-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\DrownRipples.lua 

local Entity = require("Entity")
local DrownRipples = require("Class").create(Entity, "DrownRipples")
local Delegate = require("DFMoai.Delegate")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
DrownRipples.FRAMES_PER_SECOND = 10
DrownRipples.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX")
  AnimatorComponent.new(l_1_0, true)
  l_1_0.prop:setScl(1)
  l_1_0.prop:setPriority(-1)
  if l_1_5 and l_1_6 then
    l_1_0.onDone = Delegate.new()
    l_1_0.onDone:register(l_1_5, l_1_6)
  end
end

DrownRipples.activate = function(l_2_0)
  Entity.activate(l_2_0)
  l_2_0.sequence = l_2_0:get(AnimatorComponent):playOnce("Drown_Ripples", l_2_0.FRAMES_PER_SECOND)
end

DrownRipples.tick = function(l_3_0)
  Entity.tick(l_3_0)
  local animator = l_3_0:get(AnimatorComponent)
  if not animator:isPlaying(l_3_0.sequence) then
    l_3_0:destroy()
    if l_3_0.onDone then
      l_3_0.onDone:dispatch()
    end
  end
end

return DrownRipples

