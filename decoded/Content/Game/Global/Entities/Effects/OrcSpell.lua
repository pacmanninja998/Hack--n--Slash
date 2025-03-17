-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Effects\OrcSpell.lua 

local Entity = require("Entity")
local Effect = Entity.cache:load("Content/Game/Global/Entities/Effect")
local OrcSpell = Effect.createSubclass("OrcSpell", true)
local SpriteComponent = require("Components.SpriteComponent")
OrcSpell.setRadius = function(l_1_0, l_1_1)
  local sx, sy = l_1_0:get(SpriteComponent):getSize()
  local scale = l_1_1 / (math.min(sx, sy) * 0.5)
  l_1_0.prop:setScl(scale)
end

return OrcSpell

