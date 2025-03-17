-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveStash\Long Bridge.lua 

local Entity = require("Entity")
local Shader = require("Shader")
local MovingPlatform = Entity.cache:load("Content/Game/Global/Entities/MovingPlatform")
local LongBridge = require("Class").create(MovingPlatform, "LongBridge")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local PlatformComponent = require("Components.PlatformComponent")
LongBridge.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  MovingPlatform.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, true, 0, 0, "Layouts/Game/CrackerCavern/CaveStash/CaveStash", "Long Bridge 1")
  l_1_0.prop:setScl(1, 1)
  l_1_0:get(SpriteComponent).prop:setPriority(-128)
  SoundComponent.new(l_1_0, {})
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.DYNAMIC, true)
  local physics = l_1_0:get(PhysicsComponent)
  l_1_0.fixtureCoords = {{-52.5, 364, 59.5, 316, 83.5, 364, 67.5, 444, -60.5, 436}, {-92.5, 276, -44.5, 172, 43.5, 100, 83.5, 276, 59.5, 316, -52.5, 364}, {-44.5, 172, -76.5, 92, -68.5, 20, 51.5, 28, 43.5, 100}}
  physics.fixture = physics.body:addPolygon(l_1_0.fixtureCoords[1])
  local fixture2 = physics.body:addPolygon(l_1_0.fixtureCoords[2])
  local fixture3 = physics.body:addPolygon(l_1_0.fixtureCoords[3])
  l_1_0.fixtures = {physics.fixture, fixture2, fixture3}
  for i,fixture in ipairs(l_1_0.fixtures) do
    fixture:setFilter(physics.category, physics.collidesWithCategories)
    fixture:setSensor(physics.isSensor)
  end
  PlatformComponent.new(l_1_0, l_1_0:get(PhysicsComponent), false, false, false, l_1_0.fixtures)
  l_1_0:get(PhysicsComponent):setReceivesPlatformVel(false)
  l_1_0.platformShader = Shader.load("Content/Game/Global/Shaders/GlowyPlatform")
  l_1_0:setDefaultShader(l_1_0.platformShader)
  l_1_0:get(SpriteComponent).material:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE)
end

return LongBridge

