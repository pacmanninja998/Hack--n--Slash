-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\ReflectionBlock.lua 

local Entity = require("Entity")
local ReflectionBlock = require("Class").create(Entity, "ReflectionBlock")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local ReflectionComponent = require("Components.ReflectionComponent")
local Direction = require("Direction")
ReflectionBlock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.width, l_1_0.height = l_1_6 or 1, l_1_7 or 1
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/ReflectionBlock/ReflectionBlock")
  l_1_0.prop:setScl(l_1_0.width, l_1_0.height)
  if l_1_5 and l_1_5 % 2 == 0 then
    AnimatorComponent.new(l_1_0, false, Direction.reduceToAxes(l_1_5, false), Direction.DIR_E)
    l_1_0:get(AnimatorComponent):play("Diagonal")
    local coords = nil
    if l_1_5 == Direction.DIR_NE then
      coords = {-32 * l_1_0.width, -32 * l_1_0.height, 32 * l_1_0.width, -32 * l_1_0.height, -32 * l_1_0.width, 32 * l_1_0.height}
    else
      if l_1_5 == Direction.DIR_SE then
        coords = {-32 * l_1_0.width, -32 * l_1_0.height, 32 * l_1_0.width, 32 * l_1_0.height, -32 * l_1_0.width, 32 * l_1_0.height}
      else
        if l_1_5 == Direction.DIR_SW then
          coords = {-32 * l_1_0.width, 32 * l_1_0.height, 32 * l_1_0.width, -32 * l_1_0.height, 32 * l_1_0.width, 32 * l_1_0.height}
        else
          if l_1_5 == Direction.DIR_NW then
            coords = {-32 * l_1_0.width, -32 * l_1_0.height, 32 * l_1_0.width, -32 * l_1_0.height, 32 * l_1_0.width, 32 * l_1_0.height}
          end
        end
      end
    end
    if coords then
      PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
      local physics = l_1_0:get(PhysicsComponent)
      physics.fixture = physics.body:addPolygon(coords)
    else
      AnimatorComponent.new(l_1_0, true)
      l_1_0:get(AnimatorComponent):play("Axes")
      PhysicsComponent.new(l_1_0, 64 * l_1_0.width, 64 * l_1_0.height, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
    end
  end
  l_1_0.direction = l_1_5
  ReflectionComponent.new(l_1_0, l_1_0.direction, 1)
end

return ReflectionBlock

