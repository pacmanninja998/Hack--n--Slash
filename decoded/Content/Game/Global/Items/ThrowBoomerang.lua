-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\ThrowBoomerang.lua 

local Item = require("Item")
local Action = require("Action")
local Entity = require("Entity")
local PhysicsComponent = require("Components.PhysicsComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local ThrowBoomerangAction = require("Class").create(Action, "ThrowBoomerangAction")
ThrowBoomerangAction.ANIM_NAME = "ThrowBoomerang"
ThrowBoomerangAction.ANIM_FRAME_RATE = 15
ThrowBoomerangAction.BOOMERANG_INIT_SPEED = 600
ThrowBoomerangAction.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0.motive = l_1_1
  l_1_0.item = l_1_2
  l_1_0.spawnedBoomerang = false
  l_1_0.done = false
end

ThrowBoomerangAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  local physics = l_2_0.entity:get(PhysicsComponent)
  physics:setLinearVelocity(0, 0)
  if not l_2_0.item.releasedBoomerang then
    local animator = l_2_0.entity:get(AnimatorComponent)
    animator:registerEventCallback(l_2_0, "appear", l_2_0.onAppear)
    animator:registerEventCallback(l_2_0, "done", l_2_0.onDone)
    l_2_0.sequence = animator:playOnce(l_2_0.ANIM_NAME, l_2_0.ANIM_FRAME_RATE)
  end
end

ThrowBoomerangAction.tick = function(l_3_0)
  l_3_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  if l_3_0.entity:get(AnimatorComponent):isPlaying(l_3_0.sequence) then
    return not l_3_0.done
  end
end

ThrowBoomerangAction.onAppear = function(l_4_0)
  local animator = l_4_0.entity:get(AnimatorComponent)
  local dirX, dirY = animator:getDirVector()
  local velX, velY = dirX * l_4_0.BOOMERANG_INIT_SPEED, dirY * l_4_0.BOOMERANG_INIT_SPEED
  local spawnPosX, spawnPosY = animator:getJointLoc("appear")
  if spawnPosX and spawnPosY then
    spawnPosX, spawnPosY = l_4_0.entity.prop:modelToWorld(spawnPosX * dirX, spawnPosY * dirY, 0)
  else
    spawnPosX, spawnPosY = l_4_0.entity:getPosition()
  end
  local projectile = Entity.create("Content/Game/Global/Entities/BoomerangProjectile", l_4_0.entity.layer, spawnPosX, spawnPosY, nil, nil, l_4_0.entity, l_4_0.item, velX, velY)
  l_4_0.item.releasedBoomerang = true
  l_4_0.spawnedBoomerang = true
end

ThrowBoomerangAction.onDone = function(l_5_0)
  l_5_0.done = true
end

ThrowBoomerangAction.stop = function(l_6_0)
  local animator = l_6_0.entity:get(AnimatorComponent)
  animator:unregisterEventCallback(l_6_0, "appear", l_6_0.onAppear)
  animator:unregisterEventCallback(l_6_0, "done", l_6_0.onDone)
  Action.stop(l_6_0)
end

local Boomerang = require("Class").create(Item, "Boomerang")
Boomerang.init = function(l_7_0, l_7_1)
  Item.init(l_7_0, l_7_1)
  l_7_0.releasedBoomerang = false
  l_7_0.playUseSound = false
end

Boomerang.getAction = function(l_8_0, l_8_1)
  if l_8_0.releasedBoomerang then
    return nil
  else
    return ThrowBoomerangAction.new(l_8_1, l_8_0)
  end
end

Boomerang.getDescription = function(l_9_0)
  return "Boomerang"
end

Boomerang.getSprite = function(l_10_0)
  return "UI/Placeholder/ItemIcons/Boomerang/Boomerang", "Boomerang"
end

return Boomerang

