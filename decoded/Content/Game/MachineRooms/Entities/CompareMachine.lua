-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\CompareMachine.lua 

local Class = require("Class")
local Entity = require("Entity")
local ExpressionMachine = Entity.cache:load("Content/Game/MachineRooms/Entities/ExpressionMachine")
local CompareMachine = Class.create(ExpressionMachine, "CompareMachine")
CompareMachine.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(CompareMachine).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.schemas.COMPARISON:registerValueSetHandler(l_1_0, l_1_0.onComparisonSet, l_1_0)
end

CompareMachine.isHackable = function(l_2_0)
  return true
end

CompareMachine.setExpressionLayout = function(l_3_0, l_3_1)
  Class.super(CompareMachine).setExpressionLayout(l_3_0, l_3_1)
  if l_3_0.expressionLayout.expression.instruction:GETARG_A() == 0 then
    l_3_0.COMPARISON = l_3_0.schemas.COMPARISON.values[1]
  else
    l_3_0.COMPARISON = l_3_0.schemas.COMPARISON.values[2]
  end
end

CompareMachine.onComparisonSet = function(l_4_0, l_4_1)
  local comparator = nil
  if l_4_1 == l_4_0.schemas.COMPARISON.values[1] then
    comparator = 0
  else
    comparator = 1
  end
  l_4_0.expressionLayout.expression.instruction:SETARG_A(comparator)
  l_4_0:updateLabelText()
  l_4_0.display:setText(l_4_1)
end

return CompareMachine

