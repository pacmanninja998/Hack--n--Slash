-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\HealthPickup.lua 

local Entity = require("Entity")
local HealthPickup = require("Class").create(Entity, "HealthPickup")
local Action = require("Action")
local CommonActions = require("CommonActions")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
local SoundComponent = require("Components.SoundComponent")
HealthPickup.addIntegerField("HEAL_AMOUNT", 1)
HealthPickup.SpawnAction = require("Class").create(Action, "HealthPickup.SpawnAction")
HealthPickup.SpawnAction.ANIMATION = "HeartSpawn"
HealthPickup.SpawnAction.FRAMES_PER_SECOND = 15
HealthPickup.SpawnAction.END_ANIM = "Heart_Spawn"
HealthPickup.SpawnAction.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0.velX, l_1_0.velY = l_1_1 or 0, l_1_2 or 0
end

HealthPickup.SpawnAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  local frameCount = l_2_0.entity:get(SpriteComponent):getFrameCount(l_2_0.ANIMATION)
  l_2_0.duration = 0.75 * (frameCount / l_2_0.FRAMES_PER_SECOND)
  l_2_0.elapsed = 0
  l_2_0.entity:get(SoundComponent):playCue("SFX/Objects/Heart_Spawn", false)
  l_2_0.sequence = l_2_0.entity:get(AnimatorComponent):playOnce(l_2_0.ANIMATION)
end

HealthPickup.SpawnAction.tick = function(l_3_0)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  local velFactor = 1 - math.min(l_3_0.elapsed / l_3_0.duration, 1)
  l_3_0.entity:get(PhysicsComponent):setLinearVelocity(velFactor * l_3_0.velX, velFactor * l_3_0.velY)
  return l_3_0.entity:get(AnimatorComponent):isPlaying(l_3_0.sequence) or l_3_0.elapsed <= l_3_0.duration
end

HealthPickup.SpawnAction.stop = function(l_4_0)
  l_4_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_4_0.entity:get(AnimatorComponent):play("Heart_Spawn", 0)
  l_4_0.entity:queueAction(CommonActions.FadeOut.new(2, 1, 0.04, true))
end

HealthPickup.init = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5, l_5_6, l_5_7, l_5_8)
  Entity.init(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  SpriteComponent.new(l_5_0, "FX/FX", "HeartSpawn")
  AnimatorComponent.new(l_5_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  SoundComponent.new(l_5_0, {})
  l_5_0.prop:setScl(0.65)
  PhysicsComponent.new(l_5_0, 32, 32, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.DYNAMIC, true)
  l_5_0:get(PhysicsComponent):setCollisionHandler(PhysicsComponent.ALL_CATEGORY, l_5_0.onHit, l_5_0)
  if healAmount then
    l_5_0.HEAL_AMOUNT = healAmount
  end
  l_5_0:forceAction(HealthPickup.SpawnAction.new(l_5_7, l_5_8))
end

HealthPickup.onHit = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4, l_6_5)
  local category, mask, group = l_6_4:getFilter()
  if category == PhysicsComponent.DYNAMIC_CATEGORY then
    local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
    if l_6_1 and l_6_1:is(Alice) then
      local health = l_6_1:get(HealthComponent)
      if health then
        health:damage(-l_6_0.HEAL_AMOUNT, l_6_0)
        l_6_0:destroy()
      else
        if (category == PhysicsComponent.HIGH_CATEGORY or category == PhysicsComponent.LOW_CATEGORY) and l_6_0.action:is(HealthPickup.SpawnAction) then
          l_6_0.action.elapsed = l_6_0.action.duration
        end
      end
    end
  end
end

return HealthPickup

