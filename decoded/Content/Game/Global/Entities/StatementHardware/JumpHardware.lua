-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\JumpHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local JumpHardware = Class.create(StatementHardware, "JumpHardware")
JumpHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/CodeRoomHardware/JumpHardware/JumpHardware")
  l_1_0:setEnd(Direction.DIR_E, l_1_2 + 32, l_1_3)
end

JumpHardware.startOffset = function(l_2_0, l_2_1)
  assert(l_2_1 == Direction.DIR_E)
  return 32, 0
end

return JumpHardware

