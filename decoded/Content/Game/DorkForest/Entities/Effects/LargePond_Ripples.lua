-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Effects\LargePond_Ripples.lua 

local Entity = require("Entity")
local LargePond_Ripples = require("Class").create(Entity, "LargePond_Ripples")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
LargePond_Ripples.FRAMES_PER_SECOND = 15
LargePond_Ripples.ANIM_NAME = "LargePond_Ripples"
LargePond_Ripples.DEFAULT_SCALE = 2
LargePond_Ripples.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  local animator = l_1_0:get(AnimatorComponent)
  animator:play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  animator:randomize()
  l_1_0.prop:setScl(l_1_0.DEFAULT_SCALE)
end

return LargePond_Ripples

