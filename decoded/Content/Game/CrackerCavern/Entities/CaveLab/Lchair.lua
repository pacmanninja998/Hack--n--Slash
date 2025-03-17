-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveLab\Lchair.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Lchair")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/CrackerCavern/CaveLab/CaveLab", "Lchair")
  PhysicsComponent.new(l_1_0, 48, 48, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.DYNAMIC)
  l_1_0:setLabelText("")
end

LayoutEntity.tick = function(l_2_0)
  l_2_0:get(PhysicsComponent):setLinearVelocity(0, 0)
end

return LayoutEntity

