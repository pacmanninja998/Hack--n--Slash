-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\ConditionalHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local ConditionalHardware = Class.create(StatementHardware, "ConditionalHardware")
ConditionalHardware.addIntegerField("CONDITIONAL", 0, 0, 1)
ConditionalHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine05", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0.comparatorName0, l_1_0.comparatorName1 = l_1_8, l_1_9
  if #l_1_0.statement.targetRegisters == 1 then
    l_1_0:attachInput("input 1", nil, l_1_0.statement, "left")
    l_1_0:attachInput("input 3", nil, l_1_0.statement, "right")
    l_1_0:attachOutput()
    l_1_0:placeEndWires(-wireDiffX)
  else
    if l_1_0.statement.left and l_1_0.statement.right and not l_1_0.statement.argument then
      l_1_0:attachInput("input 1", nil, l_1_0.statement, "left")
      l_1_0:attachInput("input 3", nil, l_1_0.statement, "right")
    else
      if not l_1_0.statement.left and not l_1_0.statement.right and l_1_0.statement.argument then
        l_1_0:attachInput("input 2", nil, l_1_0.statement, "argument")
      else
        assert(false)
      end
    end
    l_1_0:placeEndWires(-wireDiffX, -64)
    local elseEnd = l_1_0:getEnd(Direction.DIR_E)
    local elseStartWire1 = l_1_0:addChild(StatementHardware.createHardware("Wire", l_1_0.layer, elseEnd.x, elseEnd.y, l_1_0.name .. " else body start 1", Direction.DIR_W, Direction.DIR_E, 1, {0, 1, 0, 1}))
    local elseStartWire2 = elseStartWire1:append("Wire", Direction.DIR_S, l_1_0, l_1_0.name .. " else body start 2", Direction.DIR_N, Direction.DIR_S, 1, {0, 1, 0, 1})
    l_1_0.ifBlockHardware = {l_1_0.horizontalEndWire, l_1_0.verticalEndWire}
    local _, ifMinX, ifMinY, ifMaxX, ifMaxY = l_1_0.codeRoom:appendSequence(l_1_0.ifBlockHardware, l_1_0.statement.ifBlock, l_1_0, true)
    l_1_0.elseBlockHardware = {elseStartWire1, elseStartWire2}
    local _, elseMinX, elseMinY, elseMaxX, elseMaxY = l_1_0.codeRoom:appendSequence(l_1_0.elseBlockHardware, l_1_0.statement.elseBlock, l_1_0, true)
    if elseMinX <= ifMaxX then
      local shiftDist = 32 + (ifMaxX - elseMinX)
      local elseWireScale = (shiftDist + 64) / 64
      elseStartWire1:setLengthScale(elseWireScale)
      for i = 2, #l_1_0.elseBlockHardware do
        local hardware = l_1_0.elseBlockHardware[i]
        hardware:move(shiftDist, 0)
      end
      elseMinX, elseMinY, elseMaxX, elseMaxY = l_1_0.elseBlockHardware[1]:getBounds()
      for _,hardware in ipairs(l_1_0.elseBlockHardware) do
        local childMinX, childMinY, childMaxX, childMaxY = hardware:getBounds()
        elseMinX, elseMinY, elseMaxX, elseMaxY = math.min(elseMinX, childMinX), math.min(elseMinY, childMinY), math.max(elseMaxX, ifMaxX), math.max(elseMaxY, childMaxY)
      end
    end
    local branchHardwares = {l_1_0.ifBlockHardware, l_1_0.elseBlockHardware}
    local branchNames = {"if", "else"}
    local branchEndDirections = {Direction.DIR_E, Direction.DIR_W}
    local branchReturns = {false, false}
    local branchBounds = {{ifMinX, ifMinY, ifMaxX, ifMaxY}, {elseMinX, elseMinY, elseMaxX, elseMaxY}}
    local branchColors = {{1, 0, 0, 1}, {0, 1, 0, 1}}
    for i = 1, 2 do
      local hardwareList = branchHardwares[i]
      local branchEnding = hardwareList[#hardwareList]
      branchReturns[i] = not branchEnding:getEnd(Direction.DIR_S)
      if branchReturns[i] then
        branchBounds[i][2] = branchBounds[i][2] - 32
      end
    end
    local branchesMinX, branchesMinY = math.min(branchBounds[1][1], branchBounds[2][1]), math.min(branchBounds[1][2], branchBounds[2][2])
    local branchesMaxX, branchesMaxY = math.max(branchBounds[1][3], branchBounds[2][3]), math.max(branchBounds[1][4], branchBounds[2][4])
    for i = 1, 2 do
      if not branchReturns[i] then
        local hardwareList = branchHardwares[i]
        local branchEnding = hardwareList[#hardwareList]
        local distToBottom = branchBounds[i][2] - branchesMinY
        if distToBottom > 0 then
          branchEnding = branchEnding:append("Wire", Direction.DIR_S, l_1_0, l_1_0.name .. " " .. branchNames[i] .. " | Wire", Direction.DIR_N, Direction.DIR_S, distToBottom / 64, branchColors[i])
          table.insert(branchHardwares[i], branchEnding)
        end
        local branchEndingEnd = branchEnding:getEnd(branchEndDirections[i])
        if branchEndingEnd then
          local distToCenter = math.abs(l_1_2 - branchEndingEnd.x)
          if distToCenter > 0 then
            branchEnding = branchEnding:append("Wire", branchEndDirections[i], l_1_0, l_1_0.name .. " " .. branchNames[i] .. " Bottom - Wire", Direction.rotate(branchEndDirections[i], 4), branchEndDirections[i], distToCenter / 64, branchColors[i])
            table.insert(branchHardwares[i], branchEnding)
          end
        end
      end
    end
    if branchReturns[1] and branchReturns[2] then
      l_1_0:setEnd(Direction.DIR_S, false)
    elseif branchReturns[1] then
      local lastElse = l_1_0.elseBlockHardware[#l_1_0.elseBlockHardware]
      l_1_0.endWire = lastElse:append("Wire", Direction.DIR_S, l_1_0, l_1_0.name .. " Last Wire", Direction.DIR_N, Direction.DIR_S, 1, {0, 0, 1, 1})
      l_1_0:setEnd(Direction.DIR_S, l_1_0.endWire:getEnd(Direction.DIR_S))
    elseif branchReturns[2] then
      local lastIf = l_1_0.ifBlockHardware[#l_1_0.ifBlockHardware]
      l_1_0.endWire = lastIf:append("Wire", Direction.DIR_S, l_1_0, l_1_0.name .. " Last Wire", Direction.DIR_N, Direction.DIR_S, 1, {0, 0, 1, 1})
      l_1_0:setEnd(Direction.DIR_S, lastIf:getEnd(Direction.DIR_S))
    else
      local lastIf = l_1_0.ifBlockHardware[#l_1_0.ifBlockHardware]
      l_1_0.endWire = lastIf:append("Wire", Direction.DIR_S, l_1_0, l_1_0.name .. " Last Wire", Direction.DIR_N, Direction.DIR_S, 1, {0, 0, 1, 1})
      l_1_0:setEnd(Direction.DIR_S, l_1_0.endWire:getEnd(Direction.DIR_S))
      local lastElse = l_1_0.elseBlockHardware[#l_1_0.elseBlockHardware]
      lastElse:setNextHardware(Direction.DIR_W, l_1_0.endWire, true)
    end
  end
  l_1_0.CONDITIONAL = l_1_0.statement.comparator
  l_1_0:attachHackPort()
  if l_1_0.statement.comparator ~= 0 or not l_1_0.comparatorName0 then
    local operatorName = l_1_0.comparatorName1
  end
  l_1_0:attachFloatingText(operatorName)
  l_1_0.wireArrowLeft = true
end

ConditionalHardware.onFieldSet = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == "CONDITIONAL" and type(l_2_2) == "number" then
    local newComparator = l_2_2
    if l_2_0.statement.comparator ~= newComparator then
      l_2_0.statement.comparator = newComparator
      if l_2_0.statement.comparator ~= 0 or not l_2_0.comparatorName0 then
        local operatorName = l_2_0.comparatorName1
      end
      l_2_0.floatingText:setFrame(operatorName)
      l_2_0.codeRoom:onStatementChanged(l_2_0)
    end
  end
end

ConditionalHardware.getEndHardware = function(l_3_0)
  if l_3_0.endWire then
    return l_3_0.endWire
  elseif not l_3_0.verticalEndWire then
     -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

  end
  return l_3_0
end

ConditionalHardware.giveWireArrow = function(l_4_0, l_4_1, l_4_2)
  if l_4_0.elseBlockHardware then
    if l_4_0.wireArrowLeft then
      l_4_1:setParent(l_4_0.ifBlockHardware[1])
    else
      l_4_1:setParent(l_4_0.elseBlockHardware[1])
    end
    l_4_0.wireArrowLeft = not l_4_0.wireArrowLeft
  else
    StatementHardware.giveWireArrow(l_4_0, l_4_1, l_4_2)
  end
end

return ConditionalHardware

