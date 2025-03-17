-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Log.lua 

local Entity = require("Entity")
local Log = require("Class").create(Entity, "Log")
local Direction = require("Direction")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
local SpriteComponent = require("Components.SpriteComponent")
Log.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local width, height = 64, 128
  local rot = 10
  if l_1_5 == Direction.DIR_W or l_1_5 == Direction.DIR_E then
    width, height = height, width
    rot = rot + 90
  end
  l_1_0.prop:setScl(0.5)
  l_1_0.prop:setRot(0, 0, rot)
  PhysicsComponent.new(l_1_0, width, height, PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  PlatformComponent.new(l_1_0, l_1_0:get(PhysicsComponent), true, nil, nil, nil, nil, PlatformComponent.SOUND_MAT_WET)
  SpriteComponent.new(l_1_0, "Interactions/Props/Logs/Logs")
  l_1_0:get(SpriteComponent):setSprite("LogB")
  l_1_0:get(SpriteComponent).prop:setPriority(-height * 0.5)
end

return Log

