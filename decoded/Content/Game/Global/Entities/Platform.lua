-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Platform.lua 

local Entity = require("Entity")
local Platform = require("Class").create(Entity, "Platform")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
local CollisionArea = require("CollisionArea")
Platform.LEDGE_PUSH_FORCE = -30
Platform.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  if (l_1_5 and not l_1_2) or not l_1_3 then
    l_1_2, l_1_3 = l_1_5.body:getWorldCenter()
  end
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  if l_1_6 then
    l_1_0.ledgeFixtures = l_1_5:createOutlineCollision()
    PlatformComponent.new(l_1_0, nil, false, false, nil, l_1_0.ledgeFixtures, true)
    l_1_0:get(PlatformComponent).velFactor = l_1_0.LEDGE_PUSH_FORCE
  else
    if l_1_5:is(CollisionArea) then
      PlatformComponent.new(l_1_0, l_1_5, true, nil, nil, nil, nil, l_1_8)
      l_1_5:setSensor(true)
      l_1_5.fixture:setFilter(PhysicsComponent.LOW_CATEGORY, PhysicsComponent.ALL_CATEGORY)
      if not l_1_7 then
        Entity.create("Content/Game/Global/Entities/Platform", l_1_1, l_1_2, l_1_3, l_1_4 .. " ledges", l_1_5, true)
      end
    end
  end
  l_1_0:setLabelText("")
end

return Platform

