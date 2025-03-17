-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\InnerPrisonLock\Pillar.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Pillar")
local SpriteComponent = require("Components.SpriteComponent")
local PlatformComponent = require("Components.PlatformComponent")
local CollisionArea = require("CollisionArea")
LayoutEntity.addIntegerField("OFFSET", 0)
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DweebKeep/InnerPrisonLock/InnerPrisonLock", l_1_4)
  l_1_0.area = l_1_1.room:getCollisionArea(l_1_4)
  PlatformComponent.new(l_1_0, l_1_0.area, true)
  l_1_0.area:setSensor(true)
  l_1_0:setLabelText("")
end

LayoutEntity.tick = function(l_2_0)
  Entity.tick(l_2_0)
  l_2_0.area.body:setTransform(0, l_2_0.OFFSET)
  l_2_0:get(SpriteComponent).prop:setLoc(0, l_2_0.OFFSET)
end

return LayoutEntity

