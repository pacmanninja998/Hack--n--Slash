-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\ClosureHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local Room = require("Room")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local FunctionComponent = require("Components.FunctionComponent")
local ClosureHardware = Class.create(StatementHardware, "ClosureHardware")
ClosureHardware.addIntegerField("FUNCTION_INDEX", 0)
ClosureHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.CodeRoom = Room.cache:load("Content/Game/Global/Rooms/CodeRoom")
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine03", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0:placeEndWires(-wireDiffX)
  FunctionComponent.new(l_1_0, l_1_0.statement.decompiler.disassembly.protos, l_1_0.statement.functionIndex + 1, l_1_0.CodeRoom.TYPE_KEYVAL_DIS)
  l_1_0.FUNCTION_INDEX = l_1_0.statement.functionIndex
  l_1_0:attachOutput()
end

ClosureHardware.setFnName = function(l_2_0, l_2_1)
  l_2_0:get(FunctionComponent).fnName = l_2_1
end

ClosureHardware.onFieldSet = function(l_3_0, l_3_1, l_3_2)
  if l_3_1 == "FUNCTION_INDEX" and l_3_0.statement.functionIndex ~= l_3_2 then
    l_3_0.statement.functionIndex = l_3_2
    l_3_0:get(FunctionComponent):setFunction(l_3_0.statement.decompiler.disassembly.protos, l_3_0.statement.functionIndex + 1, l_3_0.CodeRoom.TYPE_KEYVAL_DIS)
    l_3_0.codeRoom:onStatementChanged(l_3_0)
  end
end

return ClosureHardware

