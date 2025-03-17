-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Spark.lua 

local Entity = require("Entity")
local Spark = require("Class").create(Entity, "Spark")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local FlammableComponent = require("Components.FlammableComponent")
Spark.FRAMES_PER_SECOND = 15
Spark.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX")
  AnimatorComponent.new(l_1_0, true)
  PhysicsComponent.new(l_1_0, 32, 32, PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.NONE_CATEGORY, MOAIBox2DBody.DYNAMIC, true)
  FlammableComponent.new(l_1_0, 0, 64, 1000)
  local flammable = l_1_0:get(FlammableComponent)
  flammable:light()
  l_1_0.prop:setScl(1)
end

Spark.activate = function(l_2_0)
  Entity.activate(l_2_0)
  l_2_0.sequence = l_2_0:get(AnimatorComponent):playOnce("Dust_Poof", l_2_0.FRAMES_PER_SECOND)
end

Spark.tick = function(l_3_0)
  Entity.tick(l_3_0)
  local animator = l_3_0:get(AnimatorComponent)
  if not animator:isPlaying(l_3_0.sequence) then
    l_3_0:destroy()
  end
end

return Spark

