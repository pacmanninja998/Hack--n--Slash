-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\WireArrow.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local Wire = Entity.cache:load("Content/Game/Global/Entities/StatementHardware/Wire")
local WireArrow = Class.create(StatementHardware, "WireArrow")
WireArrow.SPEED = 64
WireArrow.STOP_DIST = 10
WireArrow.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, nil, nil, nil)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/WireArrow/WireArrow")
  AnimatorComponent.new(l_1_0, true)
  l_1_0:setParent(l_1_5)
end

WireArrow.setParent = function(l_2_0, l_2_1)
  if l_2_1 and l_2_1:is(Wire) and l_2_1.startDir then
    assert(l_2_1.endDir)
  end
  l_2_0.parent = l_2_1
  local facingDir = Direction.rotate(l_2_0.parent.startDir, 4)
  local animName = Direction.dirToName(facingDir)
  l_2_0:get(AnimatorComponent):play(animName, 0)
  local posX, posY = l_2_0.parent:getPosition()
  l_2_0:setPosition(posX, posY, true)
  local parentEnd = l_2_0.parent:getEnd(l_2_0.parent.endDir)
  local endX, endY = parentEnd.x, parentEnd.y
  local diffX, diffY = endX - posX, endY - posY
  local dist = math.sqrt(diffX ^ 2 + diffY ^ 2)
  l_2_0.moveElapsed = 0
  if dist > 0 then
    local dirX, dirY = diffX / dist, diffY / dist
    l_2_0.velX, l_2_0.velY = l_2_0.SPEED * dirX, l_2_0.SPEED * dirY
    l_2_0.moveDuration = dist / l_2_0.SPEED
  else
    l_2_0.moveDuration = 0
  end
end

WireArrow.tick = function(l_3_0)
  do
    local posX, posY = l_3_0:getPosition()
    if l_3_0.moveElapsed < l_3_0.moveDuration then
      local dt = MOAISim.getStep()
      l_3_0.moveElapsed = l_3_0.moveElapsed + dt
      local posX, posY = l_3_0:getPosition()
      local stepX, stepY = l_3_0.velX * dt, l_3_0.velY * dt
      local newX, newY = posX + stepX, posY + stepY
      l_3_0:setPosition(newX, newY)
    else
      local oldParent = l_3_0.parent
      for _,dir in ipairs(Direction.CARDINALS) do
        local nextHardware = l_3_0.parent:getNextHardware(dir)
        if nextHardware then
          if nextHardware:is(Wire) then
            l_3_0:setParent(nextHardware)
            do return end
            for _,dir in (for generator) do
            end
            nextHardware:giveWireArrow(l_3_0, dir)
        else
          end
        end
        if l_3_0.parent == oldParent then
          l_3_0:destroy()
        end
      end
      Entity.tick(l_3_0)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return WireArrow

