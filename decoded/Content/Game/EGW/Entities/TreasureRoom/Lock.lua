-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Entities\TreasureRoom\Lock.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Lock")
local SpriteComponent = require("Components.SpriteComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/EGW/TreasureRoom/TreasureRoom", "Lock")
  InteractionComponent.new(l_1_0)
  PhysicsComponent.new(l_1_0, {category = PhysicsComponent.HIGH_CATEGORY, bodyType = MOAIBox2DBody.STATIC, rect = {-128, 0, 128, 320}})
  l_1_0:setLabelText("BOSS DOOR")
  l_1_0:get(SpriteComponent).prop:setPriority(-64)
end

return LayoutEntity

