-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\GetUpvalueHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local Decompiler = require("Decompiler")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local GetUpvalueHardware = Class.create(StatementHardware, "GetUpvalueHardware")
GetUpvalueHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/VariablePedestal/VariablePedestal")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("NoPort", 0)
  l_1_0:setHitboxBody()
  if not l_1_6:is(Decompiler.Upvalue) or not l_1_6 then
    l_1_0.upvalueStatement = l_1_6.upvalue
  end
  local upvalueIndex = l_1_0.upvalueStatement.upvalueIndex
  local upvalueValue = l_1_0.statement.decompiler.disassembly.debug.upvalues[upvalueIndex + 1]
  l_1_0:attachOutput("crystal", nil, nil, nil, nil, true, nil, 2)
end

return GetUpvalueHardware

