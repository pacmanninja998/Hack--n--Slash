-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\DRMRoof\Pedestal.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Pedestal")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Layouts/Game/DourTower/DRMRoof/DRMRoof", l_1_4)
  local x0, y0, x1, y1 = sprite.sheet:getHitbox("body", l_1_4)
  PhysicsComponent.new(l_1_0, {rect = {x0, y0, x1, y1}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  InteractionComponent.new(l_1_0)
  l_1_0:setLabelText("")
  l_1_0:room():markShadowedEntity(l_1_0)
end

return LayoutEntity

