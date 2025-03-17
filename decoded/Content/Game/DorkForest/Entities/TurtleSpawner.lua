-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\TurtleSpawner.lua 

local Entity = require("Entity")
local EntitySet = require("EntitySet")
local TurtleSpawner = require("Class").create(Entity, "TurtleSpawner")
local SwampTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/SwampTurtle")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local LogoComponent = require("Components.LogoComponent")
TurtleSpawner.addIntegerField("MAX_ACTIVE_TURTLES", 1)
TurtleSpawner.addIntegerField("SECONDS_BETWEEN_SPAWNS", 3)
TurtleSpawner.addEditableField("SPAWN_BEHAVIOR", SwampTurtle.schemas.IDLE_BEHAVIOR)
TurtleSpawner.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/TurtleNest/TurtleNest", "TurtleNest")
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  l_1_0.prop:setScl(1)
  l_1_0.SPAWN_BEHAVIOR = {{TYPE = "MOVE", TILES = 3}}
  l_1_0.turtles = EntitySet.new()
  l_1_0.secondsSinceNeedingSpawn = 0
  l_1_0.spawnDir = l_1_5
  l_1_0.active = true
end

TurtleSpawner.setActive = function(l_2_0, l_2_1)
  l_2_0.active = l_2_1
end

TurtleSpawner.tick = function(l_3_0)
  Entity.tick(l_3_0)
  if not l_3_0.active then
    return 
  end
  if l_3_0.turtles.count < l_3_0.MAX_ACTIVE_TURTLES then
    l_3_0.secondsSinceNeedingSpawn = l_3_0.secondsSinceNeedingSpawn + MOAISim.getStep()
    if l_3_0.SECONDS_BETWEEN_SPAWNS < l_3_0.secondsSinceNeedingSpawn then
      l_3_0:spawnTurtle()
      l_3_0.secondsSinceNeedingSpawn = 0
    end
  end
end

TurtleSpawner.spawnTurtle = function(l_4_0)
  local x, y = l_4_0:getPosition()
  local turtle = Entity.create("Content/Game/DorkForest/Entities/SwampTurtle", l_4_0:room():getLayerByOrder(0), x, y, nil, l_4_0.spawnDir)
  turtle:get(LogoComponent):setBehavior(l_4_0.SPAWN_BEHAVIOR)
  turtle.corruptedEvent:register(l_4_0.onTurtleCorrupted, l_4_0)
  l_4_0.turtles:addEntity(turtle)
end

TurtleSpawner.onTurtleCorrupted = function(l_5_0, l_5_1)
  l_5_0.turtles:addEntity(l_5_1)
end

TurtleSpawner.isHackable = function(l_6_0)
  return l_6_0.active
end

return TurtleSpawner

