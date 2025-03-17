-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\SetClassTableHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SetClassTableHardware = Class.create(StatementHardware, "SetClassTableHardware")
SetClassTableHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/VariablePedestal/VariablePedestal")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("NoPort", 0)
  l_1_0:setHitboxBody()
  l_1_0.keyConstant = l_1_0.statement.key:getConstant()
  local constantIndex = l_1_0.statement.value.constantIndex
  local constantValue = l_1_0.statement.decompiler.disassembly.constants[constantIndex + 1]
  l_1_0[l_1_0.keyConstant] = constantValue
  if l_1_0.codeRoom.constantHardwares[constantIndex] then
    local newConstantIndex = #l_1_0.statement.decompiler.disassembly.constants
    l_1_0.statement.decompiler.disassembly.constants[newConstantIndex + 1] = constantValue
    l_1_0.statement.value.constantIndex = newConstantIndex
    constantIndex = newConstantIndex
  end
  l_1_0.codeRoom.constantHardwares[constantIndex] = l_1_0
end

SetClassTableHardware.onFieldSet = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == l_2_0.keyConstant and l_2_0.statement.decompiler.disassembly.constants[l_2_0.statement.value.constantIndex + 1] ~= l_2_2 then
    l_2_0.statement.decompiler.disassembly.constants[l_2_0.statement.value.constantIndex + 1] = l_2_2
    l_2_0.codeRoom:onStatementChanged(l_2_0)
  end
end

SetClassTableHardware.labelHardware = function(l_3_0, l_3_1)
  StatementHardware.labelHardware(l_3_0, l_3_1)
  l_3_0:setLabelText(tostring(l_3_0.keyConstant))
end

return SetClassTableHardware

