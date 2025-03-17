-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\WireStart.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local WireStart = Class.create(StatementHardware, "WireStart")
WireStart.BOUNDS_OFFSET = 12
WireStart.ARROW_PERIOD = 1.5
WireStart.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, nil, nil)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/Outlet/Outlet")
  AnimatorComponent.new(l_1_0)
  l_1_0:get(SpriteComponent).prop:setPriority(-64)
  l_1_0:get(AnimatorComponent):play("Floor", 0)
  l_1_0.timeSinceLastArrow = 0
end

WireStart.getBounds = function(l_2_0)
  local minX, minY, maxX, maxY = StatementHardware.getBounds(l_2_0)
  return minX, minY - WireStart.BOUNDS_OFFSET, maxX, maxY - WireStart.BOUNDS_OFFSET
end

WireStart.tick = function(l_3_0)
  Entity.tick(l_3_0)
  if l_3_0.ARROW_PERIOD <= l_3_0.timeSinceLastArrow then
    local wire = l_3_0:getNextHardware(Direction.DIR_S)
    if wire then
      local posX, posY = l_3_0:getPosition()
      StatementHardware.createHardware("WireArrow", l_3_0.layer, posX, posY, nil, wire)
    end
    l_3_0.timeSinceLastArrow = 0
  else
    l_3_0.timeSinceLastArrow = l_3_0.timeSinceLastArrow + MOAISim.getStep()
  end
end

return WireStart

