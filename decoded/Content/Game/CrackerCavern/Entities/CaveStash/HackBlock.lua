-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveStash\HackBlock.lua 

local Entity = require("Entity")
local HackBlock = Entity.cache:load("Content/Game/Global/Entities/HackBlock")
local LayoutEntity = require("Class").create(HackBlock, "HackBlock")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  HackBlock.init(l_1_0, l_1_1, l_1_2, l_1_3 + 56, l_1_4)
  local sprite = l_1_0:get(SpriteComponent)
  sprite:setSpriteSheet("Layouts/Game/CrackerCavern/CaveStash/CaveStash")
  sprite:setSprite(l_1_4)
  l_1_0.pushableAnim = l_1_4
  l_1_0.staticAnim = l_1_4
  l_1_0.SECONDS_PER_PUSH = 1
  l_1_0.REMAINING_PUSHES = 0
  l_1_0.physicsScale = 2
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture:destroy()
  physics.fixture = physics:addRect(-64, -64, 64, 64)
  physics:setCollisionHandler(l_1_0.COLLIDE_MASK, l_1_0.onHitSolid, l_1_0, MOAIBox2DArbiter.POST_SOLVE)
  l_1_0.prop:setScl(1)
end

return LayoutEntity

