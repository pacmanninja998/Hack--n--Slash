-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\TowerLevel1\Panel.lua 

local Class = require("Class")
local Entity = require("Entity")
local Panel = Class.create(Entity, "Panel")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
Panel.MOVE_SPEED = 150
Panel.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Layouts/Game/DourTower/TowerLevel1/TowerLevel1", l_1_4)
  local sizeX, sizeY = sprite:getSize()
  PhysicsComponent.new(l_1_0, {rect = {-sizeX * 0.5, 0, sizeX * 0.5, sizeY}, category = PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY, bodyType = MOAIBox2DBody.KINEMATIC, layer = l_1_0:room():getLayerByOrder(0)})
  l_1_0:setLabelText("")
  l_1_0.originX, l_1_0.originY = l_1_2, l_1_3
end

Panel.setOpeningOverride = function(l_2_0, l_2_1)
  l_2_0.openingOverride = l_2_1
end

Panel.snapToOverride = function(l_3_0)
  l_3_0.snap = true
end

Panel.tick = function(l_4_0)
  Class.super(Panel).tick(l_4_0)
  if l_4_0.action then
    return 
  end
  local openAmount = 0
  if l_4_0.openingOverride then
    openAmount = l_4_0.openingOverride
  end
  l_4_0:open(openAmount)
end

Panel.open = function(l_5_0, l_5_1)
  local x, y = l_5_0:getPosition()
  local currentOpening = y - l_5_0.originY
  local delta = l_5_1 - currentOpening
  local velocity = delta / MOAISim.getStep()
  if l_5_0.snap then
    l_5_0.snap = false
  else
    if l_5_0.MOVE_SPEED < math.abs(velocity) then
      if velocity > 0 then
        velocity = l_5_0.MOVE_SPEED
      else
        velocity = -l_5_0.MOVE_SPEED
      end
    end
  end
  l_5_0:get(PhysicsComponent):setLinearVelocity(0, velocity)
end

return Panel

