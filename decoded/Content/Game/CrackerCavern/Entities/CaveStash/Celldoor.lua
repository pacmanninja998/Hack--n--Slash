-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveStash\Celldoor.lua 

local Entity = require("Entity")
local PasswordGate = Entity.cache:load("Content/Game/CrackerCavern/Entities/PasswordGate")
local LayoutEntity = require("Class").create(PasswordGate, "Celldoor")
local SpriteComponent = require("Components.SpriteComponent")
LayoutEntity.OFFSET_X = -55
LayoutEntity.OFFSET_Y = -9
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  PasswordGate.init(l_1_0, l_1_1, l_1_2 + LayoutEntity.OFFSET_X, l_1_3 + LayoutEntity.OFFSET_Y, l_1_4, l_1_5, false, true)
end

return LayoutEntity

