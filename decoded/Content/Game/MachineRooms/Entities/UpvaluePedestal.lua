-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\UpvaluePedestal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Pedestal = Entity.cache:load("Content/Game/MachineRooms/Entities/Pedestal")
local UpvaluePedestal = Class.create(Pedestal, "UpvaluePedestal")
local Disassembly = require("Disassembly")
UpvaluePedestal.setIndex = function(l_1_0, l_1_1, l_1_2)
  l_1_0:setLabelText(l_1_1:formatUpvalue(l_1_2))
  l_1_0.crystal:setCrystalColor(l_1_1, l_1_1.upvalueColorMap[l_1_2], true)
  l_1_0.expression = Disassembly.Upvalue.new(l_1_1.prototype, l_1_2)
end

return UpvaluePedestal

