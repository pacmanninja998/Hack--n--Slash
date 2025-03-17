-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\ForLoopHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local ForLoopHardware = Class.create(StatementHardware, "ForLoopHardware")
ForLoopHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine02", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0:attachInput("crystal 1", nil, l_1_0.statement, "step", nil, true, 90)
  l_1_0:attachInput("crystal 2", nil, l_1_0.statement, "limit", nil, true, -90)
  l_1_0:placeEndWires(-wireDiffX, -128)
  l_1_0.wireArrowLeft = true
end

ForLoopHardware.labelHardware = function(l_2_0, l_2_1)
  StatementHardware.labelHardware(l_2_0, l_2_1)
  local text = l_2_0.statement:printLabel(l_2_1, true)
  if text then
    l_2_0:setLabelText(text)
  end
end

ForLoopHardware.giveWireArrow = function(l_3_0, l_3_1, l_3_2)
  if l_3_0.wireArrowLeft then
    l_3_1:setParent(l_3_0.horizontalEndWire)
  else
    local returnWire = l_3_0:getNextHardware(Direction.DIR_E)
    l_3_1:setParent(returnWire)
  end
  l_3_0.wireArrowLeft = not l_3_0.wireArrowLeft
end

return ForLoopHardware

