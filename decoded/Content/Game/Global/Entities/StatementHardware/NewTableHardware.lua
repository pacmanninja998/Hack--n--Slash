-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\NewTableHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local NewTableHardware = Class.create(StatementHardware, "NewTableHardware")
NewTableHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine03", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0:placeEndWires(-wireDiffX)
  l_1_0:attachOutput("output")
  local wireExtension = l_1_0:append("Wire", Direction.DIR_S, l_1_0, l_1_0.name .. " Wire Extension", Direction.DIR_N, Direction.DIR_S)
  local nextEnd = lastHardware:getEnd(Direction.DIR_S)
  l_1_0.assignmentHardware = {wireExtension}
  l_1_0.lastHardware = l_1_0.codeRoom:appendSequence(l_1_0.assignmentHardware, l_1_0.statement.orderedStatements, l_1_0)
  l_1_0:setEnd(Direction.DIR_S, l_1_0.lastHardware:getEnd(Direction.DIR_S))
end

NewTableHardware.getEndHardware = function(l_2_0)
  if not l_2_0.lastHardware or not l_2_0.lastHardware:getEndHardware() then
    return StatementHardware.getEndHardware(l_2_0)
  end
end

return NewTableHardware

