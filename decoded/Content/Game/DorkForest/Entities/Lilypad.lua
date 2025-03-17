-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Lilypad.lua 

local Entity = require("Entity")
local Lilypad = require("Class").create(Entity, "Lilypad")
local Direction = require("Direction")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
local SpriteComponent = require("Components.SpriteComponent")
Lilypad.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  PlatformComponent.new(l_1_0, l_1_0:get(PhysicsComponent), true, nil, nil, nil, nil, PlatformComponent.SOUND_MAT_WET)
  SpriteComponent.new(l_1_0, "Interactions/Props/Lilypads/Lilypads")
  if l_1_5 == Direction.DIR_W then
    l_1_0:get(SpriteComponent):setSprite("LilypadA")
  else
    if l_1_5 == Direction.DIR_E then
      l_1_0:get(SpriteComponent):setSprite("LilypadB")
    else
      l_1_0:get(SpriteComponent):setSprite("LilypadC")
    end
  end
  l_1_0.prop:setScl(0.35)
  l_1_0:get(SpriteComponent).prop:setPriority(-32)
end

return Lilypad

