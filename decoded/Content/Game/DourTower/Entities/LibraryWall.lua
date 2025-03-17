-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryWall.lua 

local Entity = require("Entity")
local LibraryWall = require("Class").create(Entity, "LibraryDoor")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
LibraryWall.OFFSET = 247
LibraryWall.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.rotation = l_1_5 or 0
  l_1_2, l_1_3 = l_1_2 + l_1_0.OFFSET * math.cos(math.rad(l_1_0.rotation + 90)), l_1_3 + l_1_0.OFFSET * math.sin(math.rad(l_1_0.rotation + 90))
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.spriteName = l_1_7
  SpriteComponent.new(l_1_0, l_1_6, l_1_7)
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:get(PhysicsComponent).body:setTransform(l_1_2, l_1_3, l_1_0.rotation)
  l_1_0:get(SpriteComponent).prop:setPriority(-128)
end

LibraryWall.setShade = function(l_2_0, l_2_1)
  l_2_0:get(SpriteComponent):setSprite(l_2_0.spriteName, l_2_1)
end

return LibraryWall

