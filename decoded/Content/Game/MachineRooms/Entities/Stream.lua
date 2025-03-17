-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Stream.lua 

local Class = require("Class")
local Entity = require("Entity")
local Stream = Class.create(Entity, "Stream")
local Math = require("DFCommon.Math")
local EntityRef = require("EntityRef")
local EntitySet = require("EntitySet")
Stream.PERIOD = 0.75
Stream.SPEED = 96
Stream.MAX_DISTANCE = 128
Stream.FADE_DURATION = 1
Stream.FINAL_OPACITY = 0.75
Stream.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Stream).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.interactorProximity = false
  l_1_0.threads = {}
  l_1_0.interactor = EntityRef.new()
  l_1_0.arrows = EntitySet.new()
  l_1_0.elapsedSinceArrow = 0
end

Stream.fade = function(l_2_0)
  local r, g, b = l_2_0.prop:getColor()
  l_2_0.fadeDriver = l_2_0.prop:seekColor(r, g, b, 0, l_2_0.FADE_DURATION)
end

Stream.setCrystals = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  l_3_0.colorIndex = l_3_2
  local r, g, b = unpack(l_3_1.colors[l_3_2])
  r, g, b = r / 255, g / 255, b / 255
  l_3_0.prop:setColor(r, g, b, 0)
  l_3_0.prop:forceUpdate()
  l_3_0.prop:seekColor(r, g, b, l_3_0.FINAL_OPACITY, l_3_0.FADE_DURATION)
  l_3_0.interactor:setEntity(l_3_5)
  for i,origin in ipairs(l_3_3) do
    local originX, originY = origin:getPosition()
    for j,target in ipairs(l_3_4) do
      local targetX, targetY = target:getPosition()
      local dx, dy = targetX - originX, targetY - originY
      local length = math.sqrt(dx * dx + dy * dy)
      if length > 0 then
        local nx, ny = dx / length, dy / length
        local thread = {source = {originX, originY}, target = {targetX, targetY}, normal = {nx, ny}, length = length}
        table.insert(l_3_0.threads, thread)
        local arrowGap = l_3_0.SPEED * l_3_0.PERIOD
        local numArrows = math.floor(length / arrowGap)
        for i = 0, numArrows - 1 do
          local distance = arrowGap * i
          local arrowPosX, arrowPosY = originX + nx * distance, originY + ny * distance
          local arrow = Entity.create("Content/Game/MachineRooms/Entities/Arrow", l_3_0.layer, arrowPosX, arrowPosY)
          arrow:start(l_3_0, nx * l_3_0.SPEED, ny * l_3_0.SPEED, (thread.length - distance) / l_3_0.SPEED)
          l_3_0.arrows:addEntity(arrow)
        end
      end
    end
  end
end

Stream.tick = function(l_4_0)
  local interactorProximity = false
  if l_4_0.interactor:isValid() then
    local interactorX, interactorY = l_4_0.interactor.entity:getPosition()
    for i,thread in ipairs(l_4_0.threads) do
      local sourceX, sourceY = unpack(thread.source)
      local targetX, targetY = unpack(thread.target)
      local ratio, lineDist, projX, projY = Math.projectAndDist(sourceX, sourceY, targetX, targetY, interactorX, interactorY)
      if ratio < 0 then
        lineDist = Math.distance2D(sourceX, sourceY, interactorX, interactorY)
      elseif ratio > 1 then
        lineDist = Math.distance2D(targetX, targetY, interactorX, interactorY)
      end
      if lineDist <= l_4_0.MAX_DISTANCE then
        interactorProximity = true
    else
      end
    end
    if interactorProximity ~= l_4_0.interactorProximity then
      l_4_0:room():activateStreams(l_4_0.interactor.entity, l_4_0.colorIndex, interactorProximity)
      l_4_0.interactorProximity = interactorProximity
    end
    l_4_0.elapsedSinceArrow = l_4_0.elapsedSinceArrow + MOAISim.getStep()
    if l_4_0.PERIOD <= l_4_0.elapsedSinceArrow then
      for i,thread in ipairs(l_4_0.threads) do
        local arrowPosX, arrowPosY = unpack(thread.source)
        local nx, ny = unpack(thread.normal)
        local arrow = Entity.create("Content/Game/MachineRooms/Entities/Arrow", l_4_0.layer, arrowPosX, arrowPosY)
        arrow:start(l_4_0, nx * l_4_0.SPEED, ny * l_4_0.SPEED, thread.length / l_4_0.SPEED)
        l_4_0.arrows:addEntity(arrow)
      end
      l_4_0.elapsedSinceArrow = 0
    end
    if l_4_0.fadeDriver and l_4_0.fadeDriver:getTimesExecuted() >= 1 then
      l_4_0:destroy()
      l_4_0.fadeDriver = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Stream.preDestroy = function(l_5_0)
  for arrow in pairs(l_5_0.arrows.entities) do
    arrow:destroy()
  end
  Class.super(Stream).preDestroy(l_5_0)
end

return Stream

