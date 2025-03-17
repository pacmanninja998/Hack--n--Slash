-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\NumberConstantPedestal.lua 

local Class = require("Class")
local Entity = require("Entity")
local ConstantPedestal = Entity.cache:load("Content/Game/MachineRooms/Entities/ConstantPedestal")
local NumberConstantPedestal = Class.create(ConstantPedestal, "NumberConstantPedestal")
NumberConstantPedestal.addIntegerField("VALUE")
NumberConstantPedestal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(NumberConstantPedestal).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
end

NumberConstantPedestal.setIndex = function(l_2_0, l_2_1, l_2_2)
  Class.super(NumberConstantPedestal).setIndex(l_2_0, l_2_1, l_2_2)
  l_2_0.VALUE = l_2_1.prototype.prototype.constants[l_2_2 + 1]
end

return NumberConstantPedestal

