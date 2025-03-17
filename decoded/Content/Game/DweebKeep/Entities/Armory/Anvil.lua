-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Armory\Anvil.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Anvil")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DweebKeep/Armory/Armory", l_1_4)
  AnimatorComponent.new(l_1_0, true)
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:setLabelText("")
  local animator = l_1_0:get(AnimatorComponent)
  animator:enableHitboxBody()
  animator:play(l_1_4, 0)
end

return LayoutEntity

