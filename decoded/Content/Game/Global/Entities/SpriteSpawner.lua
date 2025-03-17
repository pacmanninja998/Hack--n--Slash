-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\SpriteSpawner.lua 

local Entity = require("Entity")
local SpriteSpawner = require("Class").create(Entity, "SpriteSpawner")
local EntitySet = require("EntitySet")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteSheet = require("SpriteSheet")
SpriteSpawner.TARGET_SPRITE_COUNT = 5
SpriteSpawner.SECONDS_BETWEEN_SPAWNS = 20
SpriteSpawner.SPAWN_RADIUS = 200
SpriteSpawner.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PhysicsComponent.new(l_1_0, 32, 16, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0.sprites = EntitySet.new()
  l_1_0.secondsSinceNeedingSpawn = 0
  l_1_0.exposed = false
end

SpriteSpawner.activate = function(l_2_0)
  Entity.activate(l_2_0)
  for i = 1, l_2_0.TARGET_SPRITE_COUNT do
    l_2_0:spawnSprite()
  end
end

SpriteSpawner.isHackable = function(l_3_0)
  return l_3_0.exposed
end

SpriteSpawner.expose = function(l_4_0)
  l_4_0.portProp = MOAIProp.new()
  l_4_0.portProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  l_4_0.portSheet = SpriteSheet.load("Interactions/Props/Placeholder/Port/Port")
  local firstName = next(l_4_0.portSheet.data.animations, nil)
  local deck, index = l_4_0.portSheet:getDeck(firstName, 1, false)
  l_4_0.portProp:setDeck(deck)
  l_4_0.portProp:setIndex(index)
  l_4_0:attachProp(l_4_0.portProp)
  l_4_0.portProp:setScl(4)
  l_4_0.exposed = true
end

SpriteSpawner.spawnSprite = function(l_5_0)
  local x, y = l_5_0:getPosition()
  local dist = math.random(0, l_5_0.SPAWN_RADIUS)
  local theta = math.random(0, 2 * math.pi)
  x, y = x + dist * math.cos(theta), y + dist * math.sin(theta)
  local sprite = Entity.create("Content/Game/Global/Entities/Sprite", l_5_0:room():getLayerByOrder(0), x, y)
  l_5_0.sprites:addEntity(sprite)
end

SpriteSpawner.tick = function(l_6_0)
  Entity.tick(l_6_0)
  if l_6_0.sprites.count < l_6_0.TARGET_SPRITE_COUNT then
    l_6_0.secondsSinceNeedingSpawn = l_6_0.secondsSinceNeedingSpawn + MOAISim.getStep()
    if l_6_0.SECONDS_BETWEEN_SPAWNS < l_6_0.secondsSinceNeedingSpawn then
      l_6_0:spawnSprite()
      l_6_0.secondsSinceNeedingSpawn = 0
    end
  end
end

return SpriteSpawner

