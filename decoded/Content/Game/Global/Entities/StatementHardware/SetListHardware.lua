-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\SetListHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SetListHardware = Class.create(StatementHardware, "SetListHardware")
SetListHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  local lastHardware = l_1_0:addChild(StatementHardware.createHardware("EmptySpacer", l_1_1, l_1_2, l_1_3, "IOEmptySpacer", Direction.DIR_S))
  l_1_0.startSpacer = lastHardware
  l_1_0.assignmentHardware = {l_1_0.startSpacer}
  for i,value in ipairs(l_1_0.statement.values) do
    lastHardware = lastHardware:append("SetListItemHardware", Direction.DIR_S, l_1_0, l_1_0.name .. " value " .. tostring(i), l_1_5, l_1_0.statement, l_1_0.codeRoom, i)
  end
  l_1_0.lastHardware = lastHardware
  l_1_0:setEnd(Direction.DIR_S, l_1_0.lastHardware:getEnd(Direction.DIR_S))
end

SetListHardware.labelHardware = function(l_2_0, l_2_1)
  StatementHardware.labelHardware(l_2_0, l_2_1)
  l_2_0:setLabelText("")
end

SetListHardware.getStartHardware = function(l_3_0)
  return l_3_0.startSpacer
end

SetListHardware.getEndHardware = function(l_4_0)
  if not l_4_0.lastHardware or not l_4_0.lastHardware:getEndHardware() then
    return l_4_0.startSpacer
  end
end

return SetListHardware

