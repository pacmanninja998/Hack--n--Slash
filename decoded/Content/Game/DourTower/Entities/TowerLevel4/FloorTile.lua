-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\TowerLevel4\FloorTile.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "FloorTile")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Layouts/Game/DourTower/TowerLevel4/TowerLevel4", l_1_4)
  local animation = sprite.sheet.data.animations[l_1_4]
  local track = animation.hitboxTracks.Platform
  local platformRect = track[1].rect
  PhysicsComponent.new(l_1_0, {rect = platformRect, category = PhysicsComponent.SENSOR_CATEGORY, bodyType = MOAIBox2DBody.STATIC, isSensor = true})
  PlatformComponent.new(l_1_0, l_1_0:get(PhysicsComponent), false)
  l_1_0:setLabelText("")
end

return LayoutEntity

