-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\SoundOrb.lua 

local Entity = require("Entity")
local Action = require("Action")
local Delegate = require("DFMoai.Delegate")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local ReactAction = require("Class").create(Action, "ReactAction")
ReactAction.init = function(l_1_0, l_1_1)
  Action.init(l_1_0)
  l_1_0.cuePath = l_1_1
end

ReactAction.tick = function(l_2_0)
  if l_2_0.cuePath then
    l_2_0.entity:get(SoundComponent):playCue(l_2_0.cuePath, nil, 1)
  end
  return false
end

local SoundOrb = require("Class").create(Entity, "SoundOrb")
SoundOrb.init = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  Entity.init(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  SpriteComponent.new(l_3_0, "Layouts/Game/CodeRoom/Pedestal_Crystal/Pedestal_Crystal")
  SoundComponent.new(l_3_0, nil, 0)
  PhysicsComponent.new(l_3_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_3_0.prop:setLoc(0, 64)
  l_3_0:get(SpriteComponent).prop:setPriority(64)
  l_3_0.hitEvent = Delegate.new()
  l_3_0.label:setOffset(0, -64)
end

SoundOrb.setCue = function(l_4_0, l_4_1)
  l_4_0.cuePath = l_4_1
end

SoundOrb.onSwordHit = function(l_5_0, l_5_1)
  l_5_0:forceAction(ReactAction.new(l_5_0.cuePath))
  l_5_0.hitEvent:dispatch(l_5_0)
end

return SoundOrb

