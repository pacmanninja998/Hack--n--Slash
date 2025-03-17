-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\GenericForLoopHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local GenericForLoopHardware = Class.create(StatementHardware, "GenericForLoopHardware")
GenericForLoopHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine03", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  local branchPoint = l_1_0:getEnd(Direction.DIR_E)
  local bodyWireStart = l_1_0:placeEndWires(-wireDiffX, -64)
  for i,iterator in ipairs(l_1_0.statement.iterators) do
    l_1_0:attachInput("input " .. tostring(i), nil, l_1_0.statement.iterators, i)
  end
  local numOutputs = #l_1_0.statement.externalVariables
  if numOutputs > 0 then
    local lastMonitor = nil
    for i = 1, numOutputs do
      _, lastMonitor = l_1_0:attachOutput(lastMonitor or "output", nil, l_1_0.statement.externalVariables, i)
    end
  end
  l_1_0.bodyHardware = {bodyWireStart}
  local lastHardware, bodyMinX, bodyMinY, bodyMaxX, bodyMaxY = l_1_0.codeRoom:appendSequence(l_1_0.bodyHardware, l_1_0.statement.body, l_1_0, true)
  if not lastHardware:getEnd(Direction.DIR_S) then
    lastHardware = StatementHardware.createHardware("EmptySpacer", l_1_0.layer, l_1_2, bodyMinY, l_1_0.name .. " body end spacer", Direction.DIR_S)
    l_1_0:addChild(lastHardware)
  end
  l_1_0.loopHardware = lastHardware:append("GenericForLoopEndHardware", Direction.DIR_S, l_1_0, nil, Direction.DIR_S, l_1_6, l_1_7)
  l_1_0:setEnd(Direction.DIR_S, l_1_0.loopHardware:getEnd(Direction.DIR_S))
  local loopHardwareReturnPoint = l_1_0.loopHardware:getEnd(Direction.DIR_E)
  local wireDiffX1 = 64 + bodyMaxX - loopHardwareReturnPoint.x
  local returnWire = l_1_0.loopHardware:appendRaw(true, "Wire", Direction.DIR_E, l_1_0, l_1_0.name .. " return wire 1", Direction.DIR_W, Direction.DIR_E, wireDiffX1 / 64, {0.5, 0.5, 0.5, 1})
  local returnWireEndPoint = returnWire:getEnd(Direction.DIR_N)
  local wireDiffY = branchPoint.y - returnWireEndPoint.y
  returnWire = returnWire:append("Wire", Direction.DIR_N, l_1_0, l_1_0.name .. " return wire 2", Direction.DIR_S, Direction.DIR_N, wireDiffY / 64, {0.5, 0.5, 0.5, 1})
  returnWireEndPoint = returnWire:getEnd(Direction.DIR_W)
  local wireDiffX2 = returnWireEndPoint.x - branchPoint.x
  returnWire = returnWire:append("Wire", Direction.DIR_W, l_1_0, l_1_0.name .. " return wire 3", Direction.DIR_E, Direction.DIR_W, wireDiffX2 / 64, {0.5, 0.5, 0.5, 1})
  returnWire:setNextHardware(Direction.DIR_W, l_1_0, true)
end

return GenericForLoopHardware

