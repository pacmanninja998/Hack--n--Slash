-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\ConstantPedestal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Pedestal = Entity.cache:load("Content/Game/MachineRooms/Entities/Pedestal")
local SpriteComponent = require("Components.SpriteComponent")
local ConstantPedestal = Class.create(Pedestal, "ConstantPedestal")
local Disassembly = require("Disassembly")
ConstantPedestal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(ConstantPedestal).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0:get(SpriteComponent):setSprite("VariablePedestal")
  l_1_0.schemas.VALUE:registerValueSetHandler(l_1_0, l_1_0.onValueSet, l_1_0)
end

ConstantPedestal.setIndex = function(l_2_0, l_2_1, l_2_2)
  l_2_0.prototypeLayout, l_2_0.constantIndex = l_2_1, l_2_2
  l_2_0.crystal:setCrystalColor(l_2_1, l_2_1.constantColorMap[l_2_2], true)
  l_2_0.expression = Disassembly.Constant.new(l_2_1.prototype, l_2_2)
end

ConstantPedestal.onValueSet = function(l_3_0, l_3_1)
  l_3_0.prototypeLayout:setConstant(l_3_0.constantIndex, l_3_1)
  l_3_0:setLabelText(l_3_0.prototypeLayout:formatConstant(l_3_0.constantIndex))
end

ConstantPedestal.isHackable = function(l_4_0)
  return true
end

return ConstantPedestal

