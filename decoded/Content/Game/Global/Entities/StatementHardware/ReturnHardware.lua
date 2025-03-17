-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\ReturnHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
ReturnHardware = Class.create(StatementHardware, "ReturnHardware")
ReturnHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine04Return", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  local numResults = #l_1_0.statement.results
  for i = 1, numResults do
    l_1_0:attachInput(i, l_1_0.statement.results, i)
  end
end

ReturnHardware.attachInput = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_1 >= 1 and l_2_1 <= 6 then
    inputJoint = "input " .. tostring(l_2_1)
    angle = l_2_1 % 2 == 0 and -90 or 90
    StatementHardware.attachInput(l_2_0, inputJoint, nil, l_2_2, l_2_3, nil, false, angle)
  end
end

return ReturnHardware

