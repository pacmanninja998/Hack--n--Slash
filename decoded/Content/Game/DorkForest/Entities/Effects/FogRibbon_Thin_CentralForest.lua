-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Effects\FogRibbon_Thin_CentralForest.lua 

local Entity = require("Entity")
local FogRibbon_Thin_SS = require("Class").create(Entity, "FogRibbon_Thin_SS")
local SpriteComponent = require("Components.SpriteComponent")
local Shader = require("Shader")
FogRibbon_Thin_SS.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/FogRibbonB/FogRibbonB")
  l_1_0.scrollShader = Shader.load("Content/Game/Global/Shaders/FogRibbon")
  l_1_0.prop:setScl(3, 0.7)
  local sprite = l_1_0:get(SpriteComponent)
  l_1_0:setDefaultShader(l_1_0.scrollShader)
  sprite.material:setShaderValue("FogAlpha", MOAIMaterial.VALUETYPE_FLOAT, 0.5)
  sprite.material:setShaderValue("FogStartOffset", MOAIMaterial.VALUETYPE_VEC2, {0.2, 0})
  sprite.material:setShaderValue("DiffuseTile", MOAIMaterial.VALUETYPE_VEC2, {3, 1})
  sprite.material:setShaderValue("DiffuseScroll", MOAIMaterial.VALUETYPE_VEC2, {0.03, 0.02})
  sprite.material:setShaderValue("FogColorA", MOAIMaterial.VALUETYPE_VEC3, {1, 1, 0.6})
  sprite.material:setShaderValue("FogColorB", MOAIMaterial.VALUETYPE_VEC3, {1, 1, 0.6})
  sprite.prop:setPriority(100)
end

FogRibbon_Thin_SS.setDefaultShader = function(l_2_0, l_2_1)
  if l_2_0.shader then
    return 
  end
  Entity.setDefaultShader(l_2_0, l_2_1)
end

return FogRibbon_Thin_SS

