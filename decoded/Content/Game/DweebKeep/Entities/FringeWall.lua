-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\FringeWall.lua 

local Entity = require("Entity")
local FringeWall = require("Class").create(Entity, "FringeWall")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
local Math = require("DFCommon.Math")
local Direction = require("Direction")
FringeWall.DEFAULT_MAX_POINTS = 64
FringeWall.FIXTURE_DEBUG_WIDTH = 4
FringeWall.RAYCAST_EPSILON = 0.1
FringeWall.START_MAX_DISTANCE = 128
FringeWall.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10, l_1_11)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0:setLabelText("")
  l_1_0.minX, l_1_0.maxX = l_1_0.layer.room.originX, l_1_0.layer.room.originX + l_1_0.layer.room.sizeX
  l_1_0.minY, l_1_0.maxY = l_1_0.layer.room.originY, l_1_0.layer.room.originY + l_1_0.layer.room.sizeY
  l_1_0.refX, l_1_0.refY = l_1_2, l_1_3
  l_1_0.offset = l_1_7
  if not l_1_8 then
    l_1_0.maxPoints = l_1_0.DEFAULT_MAX_POINTS
  end
  l_1_0.dirty = false
  l_1_0.fringePoints = {}
  l_1_0:updatePoints(l_1_5, l_1_6, l_1_9 or 1, l_1_10 or 1, l_1_11 or 1)
end

FringeWall.tick = function(l_2_0)
  if l_2_0.dirty then
    local physics = l_2_0:get(PhysicsComponent)
    if not physics then
      PhysicsComponent.new(l_2_0, 0, 0, PhysicsComponent.HITTABLE_CATEGORY, nil, MOAIBox2DBody.STATIC)
      physics = l_2_0:get(PhysicsComponent)
    end
    if physics.fixture then
      physics.fixture:destroy()
    end
    local coordList = {}
    local prevPoint = nil
    for i,point in ipairs(l_2_0.points) do
      local hitWall = false
      if i > 1 then
        local hitX, hitY = l_2_0.layer.world:getRayCast(prevPoint[1], prevPoint[2], point[1], point[2], PhysicsComponent.HIGH_CATEGORY)
        if l_2_0.RAYCAST_EPSILON < math.abs(hitX - point[1]) or l_2_0.RAYCAST_EPSILON < math.abs(hitY - point[2]) then
          point[1], point[2] = hitX, hitY
          hitWall = true
        end
      end
      table.insert(coordList, point[1] - l_2_0.refX)
      table.insert(coordList, point[2] - l_2_0.refY)
      if hitWall then
        for j = #l_2_0.points, i, -1 do
          table.remove(l_2_0.points, j)
        end
      else
        l_2_0:setPoint(i, point[1], point[2])
        prevPoint = point
      end
    end
    local destroyIndex = #l_2_0.points + 1
    repeat
      if l_2_0.fringePoints[destroyIndex] then
        l_2_0.fringePoints[destroyIndex]:destroy()
        l_2_0.fringePoints[destroyIndex] = nil
        destroyIndex = destroyIndex + 1
      else
        if #l_2_0.points > 1 then
          local firstPoint = l_2_0.points[1]
          local firstDirX, firstDirY = Math.normalize(firstPoint[1] - l_2_0.points[2][1], firstPoint[2] - l_2_0.points[2][2])
          local extrapolatedX, extrapolatedY = firstPoint[1] + l_2_0.START_MAX_DISTANCE * firstDirX, firstPoint[2] + l_2_0.START_MAX_DISTANCE * firstDirY
          local hitX, hitY = l_2_0.layer.world:getRayCast(firstPoint[1], firstPoint[2], extrapolatedX, extrapolatedY, PhysicsComponent.HIGH_CATEGORY)
          table.insert(l_2_0.points, 1, {hitX, hitY})
          table.insert(coordList, 1, hitY - l_2_0.refY)
          table.insert(coordList, 1, hitX - l_2_0.refX)
        end
        physics.fixture = physics.body:addChain(coordList)
        physics.fixture:setSensor(false)
        physics.fixture:setFilter(physics.category, physics.mask)
        physics.fixture:setDebugPenWidth(l_2_0.FIXTURE_DEBUG_WIDTH)
        physics.fixture:setDebugColor(l_2_0.r, l_2_0.g, l_2_0.b)
        physics.fixture:setCollisionHandler(function(l_1_0, l_1_1, l_1_2, l_1_3)
          local hitBody = l_1_2:getBody()
          if hitBody.entity then
            self:onCollisionEvent(hitBody.entity, l_1_0, l_1_1, l_1_2, l_1_3)
          end
            end, MOAIBox2DArbiter.POST_SOLVE, PhysicsComponent.DYNAMIC_CATEGORY)
        l_2_0.dirty = false
      end
      Entity.tick(l_2_0)
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

FringeWall.onCollisionEvent = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  if l_3_1 then
    local health = l_3_1:get(HealthComponent)
    if health then
      local dirX, dirY = l_3_5:getContactNormal()
      local knockBackMag = 512
      health:damage(1, l_3_0.entity, knockBackMag * dirX, knockBackMag * dirY, 0.1, 0.3, 1)
    end
  end
end

FringeWall.setPoint = function(l_4_0, l_4_1, l_4_2, l_4_3)
  local fringePoint = l_4_0.fringePoints[l_4_1]
  if fringePoint then
    fringePoint:setPosition(l_4_2, l_4_3)
  else
    fringePoint = Entity.create("Content/Game/DweebKeep/Entities/FringePoint", l_4_0.layer, l_4_2, l_4_3, l_4_0.name .. " point " .. l_4_1)
    l_4_0.fringePoints[l_4_1] = fringePoint
  end
  local prevDiffX, prevDiffY, nextDiffX, nextDiffY = 0, 0, 0, 0
  local point = l_4_0.points[l_4_1]
  local prevPoint = l_4_0.points[l_4_1 - 1]
  if prevPoint then
    prevDiffX, prevDiffY = point[1] - prevPoint[1], point[2] - prevPoint[2]
  end
  local nextPoint = l_4_0.points[l_4_1 + 1]
  if nextPoint then
    nextDiffX, nextDiffY = nextPoint[1] - point[1], nextPoint[2] - point[2]
  end
  local avgDiffX, avgDiffY = (nextDiffX + (prevDiffX)) / 2, (nextDiffY + (prevDiffY)) / 2
  local normX, normY = Math.normalize(avgDiffX, avgDiffY)
  local angle = math.deg(math.atan2(normY, normX))
  fringePoint.prop:setRot(0, 0, angle)
  fringePoint.prop:setColor(l_4_0.r, l_4_0.g, l_4_0.b)
end

FringeWall.updatePoints = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  if l_5_0.wavelength ~= l_5_1 or l_5_0.slitWidth ~= l_5_2 then
    l_5_0.wavelength = l_5_1
    l_5_0.slitWidth = l_5_2
    if l_5_3 and l_5_4 and l_5_5 then
      l_5_0.r, l_5_0.g, l_5_0.b = l_5_3, l_5_4, l_5_5
    end
    l_5_0.points = {}
    if l_5_0.slitWidth < math.abs(l_5_0.offset) * l_5_0.wavelength then
      return 0
    end
    local n, r1, r2, d = 1, 1, 1, l_5_2
    local r1Offset, r2Offset = 0, 0
    if l_5_0.offset >= 0 then
      r1Offset = l_5_0.offset
    else
      r2Offset = -l_5_0.offset
    end
    local insideBounds = true
    repeat
      if insideBounds and #l_5_0.points < l_5_0.maxPoints then
        r1 = (n + r1Offset) * l_5_0.wavelength
        r2 = (n + r2Offset) * l_5_0.wavelength
        if d <= r1 + r2 then
          local num, dem = r1 * (r1) - r2 * (r2), 2 * d
          local x_r1 = (num + d * d) / dem
          local x_rel = num / dem
          local y_rel = math.sqrt(r1 * (r1) - x_r1 * x_r1)
          local roomX, roomY = l_5_0.refX + y_rel, l_5_0.refY - x_rel
          insideBounds = Math.pointIn(roomX, roomY, l_5_0.minX, l_5_0.minY, l_5_0.maxX, l_5_0.maxY)
          if insideBounds then
            table.insert(l_5_0.points, {roomX, roomY})
          end
        end
        n = n + 1
      else
        l_5_0.dirty = true
      end
      return #l_5_0.points
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

FringeWall.destroy = function(l_6_0)
  for i,point in pairs(l_6_0.fringePoints) do
    point:destroy()
  end
  Entity.destroy(l_6_0)
end

return FringeWall

