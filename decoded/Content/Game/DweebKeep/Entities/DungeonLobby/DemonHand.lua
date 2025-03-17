-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\DungeonLobby\DemonHand.lua 

local Class = require("Class")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local DemonHand = Class.create(Entity, "DemonHand")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local SoundComponent = require("Components.SoundComponent")
DemonHand.MOVE_SPEED = 1200
DemonHand.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/DemonHand/DemonHand")
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  SoundComponent.new(l_1_0, {})
  l_1_0:get(AnimatorComponent):play("Open")
  l_1_0.target = EntityRef.new()
  l_1_0.grabbed = EntityRef.new()
  l_1_0.startX, l_1_0.startY = l_1_2, l_1_3
end

DemonHand.tick = function(l_2_0)
  Entity.tick(l_2_0)
  if l_2_0.target:isValid() then
    local x, y = l_2_0:getPosition()
    local targetX, targetY = l_2_0.target.entity:getPosition()
    local dx, dy = targetX - x, targetY - y
    local distance = math.sqrt(dx * dx + dy * dy)
    if distance < 20 then
      l_2_0:grab(l_2_0.target.entity)
    else
      local speed = math.min(distance, l_2_0.MOVE_SPEED * MOAISim.getStep())
      local nx, ny = dx / distance, dy / distance
      l_2_0:setPosition(x + nx * speed, y + ny * speed)
    end
  else
    if l_2_0.grabbed:isValid() then
      local x, y = l_2_0:getPosition()
      local dx, dy = l_2_0.startX - x, l_2_0.startY - y
      local distance = math.sqrt(dx * dx + dy * dy)
      if distance < 20 then
        l_2_0:kill(l_2_0.grabbed.entity)
      else
        local speed = math.min(distance, l_2_0.MOVE_SPEED * MOAISim.getStep())
        local nx, ny = dx / distance, dy / distance
        local newX, newY = x + nx * speed, y + ny * speed
        l_2_0:setPosition(newX, newY)
        l_2_0.grabbed.entity:setPosition(newX, newY)
      end
    end
  end
end
end

DemonHand.grab = function(l_3_0, l_3_1)
  l_3_0.target:setEntity()
  l_3_0.grabbed:setEntity(l_3_1)
  l_3_0:get(AnimatorComponent):play("Closed")
end

DemonHand.kill = function(l_4_0, l_4_1)
  local health = l_4_1:get(HealthComponent)
  if health then
    health:setHealth(0)
  else
    l_4_1:destroy()
  end
  l_4_0:destroy()
end

return DemonHand

