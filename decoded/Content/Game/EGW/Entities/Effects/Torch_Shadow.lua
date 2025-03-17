-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Entities\Effects\Torch_Shadow.lua 

local Entity = require("Entity")
local Torch_Shadow = require("Class").create(Entity, "Torch_Shadow")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
Torch_Shadow.FRAMES_PER_SECOND = 15
Torch_Shadow.ANIM_NAME = "Torch_Shadow"
Torch_Shadow.DEFAULT_SCALE = 1
Torch_Shadow.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  l_1_0.prop:setScl(l_1_0.DEFAULT_SCALE)
end

return Torch_Shadow

