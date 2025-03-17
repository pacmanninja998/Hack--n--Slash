-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Stairs.lua 

local Entity = require("Entity")
local Stairs = require("Class").create(Entity, "Stairs")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
Stairs.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  if (l_1_5 and not l_1_2) or not l_1_3 then
    l_1_2, l_1_3 = l_1_5.body:getWorldCenter()
  end
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.slopeDir, l_1_0.slopeGrade = l_1_6, l_1_7
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  PlatformComponent.new(l_1_0, l_1_5, true)
  l_1_5:setSensor(true)
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture = l_1_5.fixture
  physics:setSlope(l_1_0.slopeDir, l_1_0.slopeGrade, l_1_8)
  physics.fixture:setFilter(PhysicsComponent.LOW_CATEGORY, PhysicsComponent.ALL_CATEGORY)
end

return Stairs

