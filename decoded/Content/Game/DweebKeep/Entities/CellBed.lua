-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\CellBed.lua 

local Entity = require("Entity")
local Action = require("Action")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local SoundComponent = require("Components.SoundComponent")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local Delegate = require("DFMoai.Delegate")
local StuffBedAction = require("Class").create(Action, "StuffBedAction")
StuffBedAction.start = function(l_1_0, l_1_1)
  Action.start(l_1_0, l_1_1)
  l_1_0.sequence = l_1_0.entity:get(AnimatorComponent):playOnce("MakeBedDummy")
end

StuffBedAction.tick = function(l_2_0, l_2_1)
  Action.tick(l_2_0)
  return l_2_0.entity:get(AnimatorComponent):isPlaying(l_2_0.sequence)
end

StuffBedAction.stop = function(l_3_0)
  l_3_0.entity:get(AnimatorComponent):play("CotDummy")
  Action.stop(l_3_0)
end

local CellBed = require("Class").create(Entity, "CellBed")
CellBed.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  Entity.init(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  SpriteComponent.new(l_4_0, "Interactions/Props/Cot/Cot")
  AnimatorComponent.new(l_4_0)
  PhysicsComponent.new(l_4_0, 96, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_4_0)
  SoundComponent.new(l_4_0, {})
  l_4_0:get(AnimatorComponent):play("DefaultPose", 0)
  l_4_0.sleepEvent = Delegate.new()
  l_4_0.sleepEventTime = nil
  l_4_0.prop:setScl(0.75)
end

CellBed.stuffBed = function(l_5_0)
  l_5_0:forceAction(StuffBedAction.new())
end

return CellBed

