-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\TESTMachine.lua 

local Class = require("Class")
local Entity = require("Entity")
local ExpressionMachine = Entity.cache:load("Content/Game/MachineRooms/Entities/ExpressionMachine")
local TESTMachine = Class.create(ExpressionMachine, "TESTMachine")
TESTMachine.addEditableField("MODE", Class.EnumSchema.new("is not", "is"))
TESTMachine.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(TESTMachine).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.schemas.MODE:registerValueSetHandler(l_1_0, l_1_0.onModeSet, l_1_0)
end

TESTMachine.isHackable = function(l_2_0)
  return true
end

TESTMachine.setExpressionLayout = function(l_3_0, l_3_1)
  Class.super(TESTMachine).setExpressionLayout(l_3_0, l_3_1)
  if l_3_0.expressionLayout.expression.instruction:GETARG_C() == 0 then
    l_3_0.MODE = "is not"
  else
    l_3_0.MODE = "is"
  end
end

TESTMachine.onModeSet = function(l_4_0, l_4_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_4_1 == "is not" then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  l_4_0.expressionLayout.expression.instruction:SETARG_C(0)
  l_4_0:updateLabelText()
  l_4_0.display:setText(l_4_1)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

return TESTMachine

