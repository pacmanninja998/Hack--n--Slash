-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\IdasCell\SecondRing.lua 

local Entity = require("Entity")
local Ring = Entity.cache:load("Content/Game/DweebKeep/Entities/IdasCell/Ring")
local LayoutEntity = require("Class").create(Ring, "SecondRing")
local PhysicsComponent = require("Components.PhysicsComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Ring.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, 255, 335, 18, 12, 3, 20)
end

return LayoutEntity

