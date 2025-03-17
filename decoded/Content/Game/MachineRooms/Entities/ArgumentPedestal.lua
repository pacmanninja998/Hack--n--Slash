-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\ArgumentPedestal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Pedestal = Entity.cache:load("Content/Game/MachineRooms/Entities/Pedestal")
local ArgumentPedestal = Class.create(Pedestal, "ArgumentPedestal")
local Disassembly = require("Disassembly")
ArgumentPedestal.setIndex = function(l_1_0, l_1_1, l_1_2)
  l_1_0:setLabelText("arg: " .. l_1_1:formatRegister(l_1_2, 0, 0))
  l_1_0.crystal:setCrystalColor(l_1_1, l_1_1:getRegisterColorIndex(l_1_2, 0), true)
  l_1_0.expression = Disassembly.Register.new(l_1_1.prototype, l_1_2)
end

return ArgumentPedestal

