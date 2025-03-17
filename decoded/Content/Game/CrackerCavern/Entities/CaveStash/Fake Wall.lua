-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveStash\Fake Wall.lua 

local Entity = require("Entity")
local FakeWall = Entity.cache:load("Content/Game/Global/Entities/FakeWall")
local CaveStashFakeWall = require("Class").create(FakeWall, "CaveStashFakeWall")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SceneComponent = require("Components.SceneComponent")
CaveStashFakeWall.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  FakeWall.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, "Layouts/Game/CrackerCavern/CaveStash/CaveStash", "Fake Wall")
  l_1_0:setLabelText("")
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.STATIC)
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture = physics.body:addChain({-87.5, 29, 160.5, 61, 128.5, 181, 184.5, 245, 136.5, 317, 176.5, 421, 16.5, 437, -103.5, 429, -111.5, 101, -87.5, 29})
  physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
  SceneComponent.new(l_1_0)
end

return CaveStashFakeWall

