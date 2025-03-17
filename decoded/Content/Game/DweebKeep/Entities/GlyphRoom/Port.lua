-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\GlyphRoom\Port.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Port")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local Delegate = require("DFMoai.Delegate")
LayoutEntity.addIntegerField("OFFSET", 0)
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DweebKeep/GlyphRoom/GlyphRoom", l_1_4)
  AnimatorComponent.new(l_1_0, true)
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.STATIC)
  local animator = l_1_0:get(AnimatorComponent)
  animator:enableHitboxBody()
  animator:play(l_1_4, 0)
  local x0, y0, x1, y1 = animator:getHitboxPoints("body")
  l_1_0.label:setOffset((x0 + x1) / 2, (y0 + y1) / 2)
  l_1_0.fieldSetEvent = Delegate.new()
end

LayoutEntity.isHackable = function(l_2_0)
  return true
end

LayoutEntity.onFieldSet = function(l_3_0, l_3_1, l_3_2)
  l_3_0.fieldSetEvent:dispatch(l_3_1, l_3_2, l_3_0)
end

return LayoutEntity

