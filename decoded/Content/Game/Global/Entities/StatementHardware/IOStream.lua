-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\IOStream.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local EntityRef = require("EntityRef")
local EntitySet = require("EntitySet")
local Math = require("DFCommon.Math")
local IOStream = Class.create(Entity, "IOStream")
IOStream.DEFAULT_COLOR = {0, 0, 0}
IOStream.DEFAULT_PERIOD = 0.75
IOStream.DEFAULT_SPEED = 96
IOStream.DEFAULT_MAX_DIST = 128
IOStream.DEFAULT_FADE_DURATION = 1
IOStream.FINAL_OPACITY = 0.75
IOStream.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10, l_1_11)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.sourceRef = EntityRef.new(l_1_5)
  l_1_0.destRef = EntityRef.new(l_1_6)
  l_1_0.viewerRef = EntityRef.new(l_1_7)
  if not l_1_8 then
    l_1_0.color = IOStream.DEFAULT_COLOR
  end
  if not l_1_9 then
    l_1_0.period = IOStream.DEFAULT_PERIOD
  end
  if not l_1_10 then
    l_1_0.speed = IOStream.DEFAULT_SPEED
  end
  if not l_1_11 then
    l_1_0.maxViewerLineDist = IOStream.DEFAULT_MAX_DIST
  end
  local r, g, b = unpack(l_1_0.color)
  l_1_0.prop:setColor(r, g, b, 0)
  l_1_0.prop:forceUpdate()
  l_1_0.arrows = EntitySet.new()
  l_1_0.timeSinceAddedArrow = 0
  local sourceX, sourceY = l_1_5:getPosition()
  local destX, destY = l_1_6:getPosition()
  local diffX, diffY = destX - sourceX, destY - sourceY
  local length = Math.length(diffX, diffY)
  if length > 0 then
    local normX, normY = diffX / length, diffY / length
    local arrowGap = l_1_0.speed * l_1_0.period
    local numArrows = math.floor(length / arrowGap)
    for i = 0, numArrows - 1 do
      local arrowPosX, arrowPosY = sourceX + normX * arrowGap * i, sourceY + normY * arrowGap * i
      local arrow = Entity.create("Content/Game/Global/Entities/StatementHardware/IOArrow", l_1_0.layer, arrowPosX, arrowPosY, nil, l_1_0)
      l_1_0.arrows:addEntity(arrow)
    end
  else
    l_1_0:destroy()
  end
  l_1_0.inRange = true
  l_1_0.fadingIn = false
  l_1_0.fadingOut = false
  l_1_0:fade(true)
  l_1_0:setLabelText("")
end

IOStream.tick = function(l_2_0)
  Entity.tick(l_2_0)
  if l_2_0.sourceRef:isValid() and l_2_0.destRef:isValid() and l_2_0.viewerRef:isValid() then
    if not l_2_0.sourceRef.entity.inSensor then
      l_2_0.inRange = l_2_0.destRef.entity.inSensor
    end
    if not l_2_0.inRange then
      local sourceX, sourceY = l_2_0.sourceRef.entity:getPosition()
      local destX, destY = l_2_0.destRef.entity:getPosition()
      local viewerX, viewerY = l_2_0.viewerRef.entity:getPosition()
      local ratio, lineDist, projX, projY = Math.projectAndDist(sourceX, sourceY, destX, destY, viewerX, viewerY)
      if ratio < 0 then
        lineDist = Math.distance2D(sourceX, sourceY, viewerX, viewerY)
      elseif ratio > 1 then
        lineDist = Math.distance2D(destX, destY, viewerX, viewerY)
      end
      l_2_0.inRange = lineDist <= l_2_0.maxViewerLineDist
    end
    local anyInRange = l_2_0.inRange
    if not anyInRange then
      for _,ioStream in pairs(l_2_0.sourceRef.entity.ioStreams.entities) do
        if ioStream.inRange then
          anyInRange = true
      else
        end
      end
      l_2_0:fade(anyInRange)
    else
      l_2_0:fade(false)
      return 
    end
    if l_2_0.period <= l_2_0.timeSinceAddedArrow then
      local sourceX, sourceY = l_2_0.sourceRef.entity:getPosition()
      l_2_0.arrows:addEntity(Entity.create("Content/Game/Global/Entities/StatementHardware/IOArrow", l_2_0.layer, sourceX, sourceY, nil, l_2_0))
      l_2_0.timeSinceAddedArrow = 0
    else
      l_2_0.timeSinceAddedArrow = l_2_0.timeSinceAddedArrow + MOAISim.getStep()
    end
    if l_2_0.easeDriver and l_2_0.easeDriver:getTimesExecuted() >= 1 then
      if l_2_0.fadingOut then
        l_2_0:destroy()
      end
      l_2_0.easeDriver = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IOStream.fade = function(l_3_0, l_3_1, l_3_2)
  do
    if l_3_1 and not l_3_0.fadingIn then
      local r, g, b = l_3_0.prop:getColor()
      if not l_3_2 then
        l_3_0.easeDriver = l_3_0.prop:seekColor(r, g, b, IOStream.FINAL_OPACITY, IOStream.DEFAULT_FADE_DURATION)
        l_3_0.fadingIn = true
        l_3_0.fadingOut = false
      end
      do return end
      if not l_3_0.fadingOut then
        local r, g, b = l_3_0.prop:getColor()
        if not l_3_2 then
          l_3_0.easeDriver = l_3_0.prop:seekColor(r, g, b, 0, IOStream.DEFAULT_FADE_DURATION)
          l_3_0.fadingIn = false
          l_3_0.fadingOut = true
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IOStream.preDestroy = function(l_4_0)
  for _,ioArrow in pairs(l_4_0.arrows.entities) do
    ioArrow:destroy()
  end
  Entity.preDestroy(l_4_0)
end

return IOStream

