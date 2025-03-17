-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\LOADBOOLMachine.lua 

local Class = require("Class")
local Entity = require("Entity")
local ExpressionMachine = Entity.cache:load("Content/Game/MachineRooms/Entities/ExpressionMachine")
local LOADBOOLMachine = Class.create(ExpressionMachine, "LOADBOOLMachine")
LOADBOOLMachine.addBooleanField("VALUE")
LOADBOOLMachine.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(LOADBOOLMachine).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.schemas.VALUE:registerValueSetHandler(l_1_0, l_1_0.onValueSet, l_1_0)
end

LOADBOOLMachine.isHackable = function(l_2_0)
  return true
end

LOADBOOLMachine.setExpressionLayout = function(l_3_0, l_3_1)
  Class.super(LOADBOOLMachine).setExpressionLayout(l_3_0, l_3_1)
  if l_3_0.expressionLayout.expression.instruction:GETARG_B() == 0 then
    l_3_0.VALUE = false
  else
    l_3_0.VALUE = true
  end
end

LOADBOOLMachine.onValueSet = function(l_4_0, l_4_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if not l_4_1 then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  l_4_0.expressionLayout.expression.instruction:SETARG_B(0)
  l_4_0:updateLabelText()
  l_4_0.display:setText(tostring(l_4_1))
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

return LOADBOOLMachine

