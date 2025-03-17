-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Effects\Portal.lua 

local Entity = require("Entity")
local Portal = require("Class").create(Entity, "Portal")
local Shader = require("Shader")
local SpriteComponent = require("Components.SpriteComponent")
Portal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.sprite = SpriteComponent.new(l_1_0, "Particles/Textures/SwirlCore/SwirlCore")
  l_1_0.portalShader = Shader.load("Content/Game/Global/Shaders/Portal")
  l_1_0:setDefaultShader(l_1_0.portalShader)
  l_1_0.sprite.prop:setPriority(-200)
  l_1_0.sprite.prop:setScl(l_1_5 or 1)
end

return Portal

