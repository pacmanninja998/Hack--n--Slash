-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Effects\Torch_Frnt_FlippedNS60.lua 

local Entity = require("Entity")
local Shader = require("Shader")
local Torch_Frnt_FlippedNS = require("Class").create(Entity, "Torch_Frnt_FlippedNS")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
Torch_Frnt_FlippedNS.FRAMES_PER_SECOND = 15
Torch_Frnt_FlippedNS.ANIM_NAME = "Torch_Frnt_FlippedNS"
Torch_Frnt_FlippedNS.DEFAULT_SCALE = 1
Torch_Frnt_FlippedNS.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  local animator = l_1_0:get(AnimatorComponent)
  animator:play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  animator:randomize()
  l_1_0.prop:setScl(l_1_0.DEFAULT_SCALE)
  l_1_0.additiveShader = Shader.create("Content/Game/Global/Shaders/Additive")
  l_1_0:setDefaultShader(l_1_0.additiveShader)
  l_1_0:setAlpha(0.6)
end

return Torch_Frnt_FlippedNS

