-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\FloatingPlatform.lua 

local Entity = require("Entity")
local FloatingPlatform = require("Class").create(Entity, "SolidBlock")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
FloatingPlatform.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/FloatingPlatform/FloatingPlatform")
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  PlatformComponent.new(l_1_0, l_1_0:get(PhysicsComponent), false)
  l_1_0:get(SpriteComponent).prop:setPriority(-64)
end

return FloatingPlatform

