-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\FireballSpawner.lua 

local Entity = require("Entity")
local PortBlock = Entity.cache:load("Content/Game/Global/Entities/PortBlock")
local FireballSpawner = require("Class").create(PortBlock, "FireballSpawner")
local AnimatorComponent = require("Components.AnimatorComponent")
FireballSpawner.SECONDS_BETWEEN_SPAWNS = -1
FireballSpawner.DELAY = 0
FireballSpawner.FIREBALL_SPEED = 256
FireballSpawner.FIREBALL_SIZE = 1
FireballSpawner.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  PortBlock.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0.secondsSinceSpawn = 0
end

FireballSpawner.tick = function(l_2_0)
  if l_2_0.DELAY > 0 then
    l_2_0.DELAY = math.max(0, l_2_0.DELAY - MOAISim.getStep())
  elseif l_2_0.SECONDS_BETWEEN_SPAWNS >= 0 then
    l_2_0.secondsSinceSpawn = l_2_0.secondsSinceSpawn + MOAISim.getStep()
    if l_2_0.SECONDS_BETWEEN_SPAWNS < l_2_0.secondsSinceSpawn then
      local posX, posY = l_2_0:getPosition()
      local animator = l_2_0:get(AnimatorComponent)
      local direction = animator:getDirection()
      local dirX, dirY = animator:getDirVector()
      local velX, velY = l_2_0.FIREBALL_SPEED * dirX, l_2_0.FIREBALL_SPEED * dirY
      Entity.create("Content/Game/DweebKeep/Entities/Fireball", l_2_0.layer, posX, posY, nil, direction, velX, velY, l_2_0.FIREBALL_SIZE, l_2_0)
      l_2_0.secondsSinceSpawn = 0
    end
  end
  Entity.tick(l_2_0)
end

return FireballSpawner

