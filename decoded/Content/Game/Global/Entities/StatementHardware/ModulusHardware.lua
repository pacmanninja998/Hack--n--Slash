-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\ModulusHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local BinaryOperatorHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware/BinaryOperatorHardware")
local ModulusHardware = Class.create(BinaryOperatorHardware, "ModulusHardware")
ModulusHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  BinaryOperatorHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, "Modulus")
end

return ModulusHardware

