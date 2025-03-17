-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Effects\Armory_WaterDripLft.lua 

local Entity = require("Entity")
local Shader = require("Shader")
local Armory_WaterDripLft = require("Class").create(Entity, "Armory_WaterDripLft")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
Armory_WaterDripLft.FRAMES_PER_SECOND = 15
Armory_WaterDripLft.ANIM_NAME = "Armory_WaterDripLft"
Armory_WaterDripLft.DEFAULT_SCALE = 1
Armory_WaterDripLft.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  l_1_0.prop:setScl(l_1_0.DEFAULT_SCALE)
  l_1_0.additiveShader = Shader.create("Content/Game/Global/Shaders/Additive")
  l_1_0:setDefaultShader(l_1_0.additiveShader)
  l_1_0:setAlpha(1)
end

return Armory_WaterDripLft

