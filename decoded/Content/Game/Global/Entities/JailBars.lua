-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\JailBars.lua 

local Entity = require("Entity")
local JailBars = require("Class").create(Entity, "JailBars")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
JailBars.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/JailGate/JailGate")
  AnimatorComponent.new(l_1_0, false, l_1_5)
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:get(AnimatorComponent):play("Wall")
  local physics = l_1_0:get(PhysicsComponent)
  if l_1_5 == Direction.DIR_N or l_1_5 == Direction.DIR_S then
    physics.fixture = physics:addRect(-32, -32, 32, -16)
    l_1_0:get(SpriteComponent).prop:setPriority(24)
  else
    physics.fixture = physics:addRect(-8, -32, 8, 32)
  end
  l_1_0:setLabelText("")
end

JailBars.setCorner = function(l_2_0)
  local physics = l_2_0:get(PhysicsComponent)
  physics.fixture:destroy()
  physics.fixture = physics:addRect(-8, -32, 8, -16)
end

return JailBars

