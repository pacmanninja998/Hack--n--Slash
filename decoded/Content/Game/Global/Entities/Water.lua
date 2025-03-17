-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Water.lua 

local Entity = require("Entity")
local Water = require("Class").create(Entity, "Water")
local EntitySet = require("EntitySet")
local PhysicsComponent = require("Components.PhysicsComponent")
local SwimmingComponent = require("Components.SwimmingComponent")
local PlatformComponent = require("Components.PlatformComponent")
Water.LEDGE_PUSH_FORCE = 30
Water.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  if not l_1_2 or not l_1_3 then
    l_1_2, l_1_3 = l_1_5.body:getWorldCenter()
  end
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.waterArea = l_1_5
  l_1_0.waterArea.body.entity = l_1_0
  l_1_0.waterArea:setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.WATER_CATEGORY, l_1_0.onHit, l_1_0, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  l_1_0.waterArea:setSensor(true)
  l_1_0.waterArea.fixture:setFilter(PhysicsComponent.LOW_CATEGORY, PhysicsComponent.ALL_CATEGORY)
  l_1_0.ledgeFixtures = l_1_0.waterArea:createOutlineCollision(nil, nil, l_1_6)
  PlatformComponent.new(l_1_0, nil, false, false, nil, l_1_0.ledgeFixtures, true)
  l_1_0:get(PlatformComponent).velFactor = l_1_0.LEDGE_PUSH_FORCE
  l_1_0:setLabelText("")
end

Water.onHit = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  if l_2_1 then
    local swimming = l_2_1:get(SwimmingComponent)
    if swimming then
      if l_2_2 == MOAIBox2DArbiter.BEGIN then
        swimming:onHitWater(l_2_0, true)
      else
        if l_2_2 == MOAIBox2DArbiter.END then
          swimming:onHitWater(l_2_0, false)
        end
      end
    end
  end
end

return Water

