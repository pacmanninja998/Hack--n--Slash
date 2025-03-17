-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Effects\Waterfall_Small.lua 

local Entity = require("Entity")
local Waterfall_Small = require("Class").create(Entity, "Waterfall_Small")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
Waterfall_Small.FRAMES_PER_SECOND = 15
Waterfall_Small.ANIM_NAME = "Waterfall_Small"
Waterfall_Small.DEFAULT_SCALE = 2
Waterfall_Small.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  AnimatorComponent.new(l_1_0, true)
  SoundComponent.new(l_1_0)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  l_1_0.prop:setScl(l_1_0.DEFAULT_SCALE)
  l_1_0.effectCue = l_1_0:get(SoundComponent):playCue("SFX/SourcePoints/SpookyPath_SmallWaterfall", true, 0.5)
end

return Waterfall_Small

