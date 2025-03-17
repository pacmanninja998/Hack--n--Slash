-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\IOArrow.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local EntityRef = require("EntityRef")
local Math = require("DFCommon.Math")
local SpriteComponent = require("Components.SpriteComponent")
local IOArrow = Class.create(Entity, "IOArrow")
IOArrow.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/WireArrow/WireArrow", "E")
  l_1_0.ioStream = l_1_5
  l_1_0.prop:setAttrLink(MOAIProp.INHERIT_COLOR, l_1_0.ioStream.prop, MOAIProp.COLOR_TRAIT)
  l_1_0.prop:forceUpdate()
  local sourcePriority = l_1_0.ioStream.sourceRef.entity:get(SpriteComponent).prop:getPriority()
  local destPriority = l_1_0.ioStream.destRef.entity:get(SpriteComponent).prop:getPriority()
  l_1_0:get(SpriteComponent).prop:setPriority(math.max(sourcePriority, destPriority))
  local destPosX, destPosY = l_1_0.ioStream.destRef.entity:getPosition()
  local diffX, diffY = destPosX - l_1_2, destPosY - l_1_3
  local length = Math.length(diffX, diffY)
  if length > 0 then
    local normX, normY = diffX / length, diffY / length
    l_1_0.velX, l_1_0.velY = l_1_0.ioStream.speed * normX, l_1_0.ioStream.speed * normY
    l_1_0.duration = length / l_1_0.ioStream.speed
    l_1_0.elapsed = 0
  else
    l_1_0:destroy()
  end
  l_1_0:setLabelText("")
end

IOArrow.tick = function(l_2_0)
  Entity.tick(l_2_0)
  local dt = MOAISim.getStep()
  l_2_0.elapsed = l_2_0.elapsed + dt
  if l_2_0.elapsed < l_2_0.duration and (l_2_0.velX ~= 0 or l_2_0.velY ~= 0) then
    local angle = math.atan2(l_2_0.velY, l_2_0.velX)
    l_2_0.prop:setRot(0, 0, math.deg(angle))
    local curX, curY = l_2_0:getPosition()
    local newX, newY = curX + dt * l_2_0.velX, curY + dt * l_2_0.velY
    l_2_0:setPosition(newX, newY)
  else
    l_2_0:destroy()
  end
end

return IOArrow

