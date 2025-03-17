-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Armory\Port.lua 

local Entity = require("Entity")
local LockPortBlock = Entity.cache:load("Content/Game/DweebKeep/Entities/LockPortBlock")
local LayoutEntity = require("Class").create(LockPortBlock, "Port")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local Direction = require("Direction")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  LockPortBlock.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, Direction.DIR_W)
  local sprite = l_1_0:get(SpriteComponent)
  sprite:setSpriteSheet("Layouts/Game/DweebKeep/Armory/Armory")
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture:destroy()
  physics.fixture = nil
  local animator = l_1_0:get(AnimatorComponent)
  animator:enableHitboxBody()
  animator:play(l_1_4)
end

return LayoutEntity

