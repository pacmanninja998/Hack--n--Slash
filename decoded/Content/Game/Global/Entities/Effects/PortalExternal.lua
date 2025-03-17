-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Effects\PortalExternal.lua 

local Entity = require("Entity")
local PortalExternal = require("Class").create(Entity, "PortalExternal")
local Shader = require("Shader")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
PortalExternal.FADE_IN_TYPE = 0
PortalExternal.FADE_OUT_TYPE = 1
PortalExternal.FADE_DURATION = 0.5
PortalExternal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.sprite = SpriteComponent.new(l_1_0, "Particles/Textures/SwirlCore/SwirlCore")
  l_1_0.portalShader = Shader.load("Content/Game/Global/Shaders/PortalExternal")
  SoundComponent.new(l_1_0)
  l_1_0:setDefaultShader(l_1_0.portalShader)
  l_1_0.fadeType = PortalExternal.FADE_IN_TYPE
  l_1_0.elapsed = 0
  l_1_0.maxScale = l_1_5
  l_1_0.sprite.prop:setPriority(256 * l_1_0.maxScale)
  l_1_0.sprite.prop:setScl(0, 0, 0)
  l_1_0.sprite.material:setShaderValue("ShaderIntensity", MOAIMaterial.VALUETYPE_FLOAT, 0)
  l_1_0:get(SoundComponent):playCue("SFX/Objects/CodePortal_Loop", true)
end

PortalExternal.tick = function(l_2_0)
  Entity.tick(l_2_0)
  l_2_0.elapsed = l_2_0.elapsed + MOAISim.getStep()
  local fadeAmt = l_2_0.elapsed / PortalExternal.FADE_DURATION
  if fadeAmt <= 1 then
    if l_2_0.fadeType == PortalExternal.FADE_IN_TYPE then
      l_2_0.sprite.material:setShaderValue("ShaderIntensity", MOAIMaterial.VALUETYPE_FLOAT, fadeAmt)
      local currentScale = l_2_0.maxScale * fadeAmt
      l_2_0.sprite.prop:setScl(currentScale, currentScale, currentScale)
    else
      if l_2_0.fadeType == PortalExternal.FADE_OUT_TYPE then
        l_2_0.sprite.material:setShaderValue("ShaderIntensity", MOAIMaterial.VALUETYPE_FLOAT, 1 - fadeAmt)
        local currentScale = l_2_0.maxScale * (1 - fadeAmt)
        l_2_0.sprite.prop:setScl(currentScale, currentScale, currentScale)
      else
        if l_2_0.fadeType == PortalExternal.FADE_OUT_TYPE then
          l_2_0:destroy()
        end
      end
    end
  end
end

PortalExternal.fadeOut = function(l_3_0)
  l_3_0.fadeType = PortalExternal.FADE_OUT_TYPE
  l_3_0.elapsed = 0
end

return PortalExternal

