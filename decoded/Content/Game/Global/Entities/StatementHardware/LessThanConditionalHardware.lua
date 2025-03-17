-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\LessThanConditionalHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local ConditionalHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware/ConditionalHardware")
LessThanConditionalHardware = Class.create(ConditionalHardware, "LessThanConditionalHardware")
LessThanConditionalHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  ConditionalHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, "LessThan", "GreaterThan")
end

return LessThanConditionalHardware

