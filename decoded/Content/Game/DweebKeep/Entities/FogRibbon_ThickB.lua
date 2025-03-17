-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\FogRibbon_ThickB.lua 

local Entity = require("Entity")
local FogRibbon_Thick = require("Class").create(Entity, "FogRibbon_Thick")
local SpriteComponent = require("Components.SpriteComponent")
local Shader = require("Shader")
FogRibbon_Thick.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/FogRibbonA/FogRibbonA")
  l_1_0.scrollShader = Shader.load("Content/Game/Global/Shaders/FogRibbon")
  l_1_0.prop:setScl(2, 0.35)
  local sprite = l_1_0:get(SpriteComponent)
  l_1_0:setDefaultShader(l_1_0.scrollShader)
  sprite.material:setShaderValue("FogAlpha", MOAIMaterial.VALUETYPE_FLOAT, 0.3)
  sprite.material:setShaderValue("FogStartOffset", MOAIMaterial.VALUETYPE_VEC2, {0.5, 0})
  sprite.material:setShaderValue("DiffuseTile", MOAIMaterial.VALUETYPE_VEC2, {3, 1})
  sprite.material:setShaderValue("DiffuseScroll", MOAIMaterial.VALUETYPE_VEC2, {0.03, 0.02})
  sprite.material:setShaderValue("FogColorA", MOAIMaterial.VALUETYPE_VEC3, {0.7, 0.8, 1})
  sprite.material:setShaderValue("FogColorB", MOAIMaterial.VALUETYPE_VEC3, {0.7, 0.8, 1})
end

FogRibbon_Thick.setDefaultShader = function(l_2_0, l_2_1)
  if l_2_0.shader then
    return 
  end
  Entity.setDefaultShader(l_2_0, l_2_1)
end

return FogRibbon_Thick

