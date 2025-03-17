-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Fireball.lua 

local Entity = require("Entity")
local Fireball = require("Class").create(Entity, "Fireball")
local Direction = require("Direction")
local Shooter = Entity.cache:load("Content/Game/DweebKeep/Entities/Shooter")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
local SoundComponent = require("Components.SoundComponent")
Fireball.addIntegerField("DAMAGE", 1)
Fireball.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.sourceEntity = l_1_8
  local sprite = SpriteComponent.new(l_1_0, "FX/FX")
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  SoundComponent.new(l_1_0, {})
  local halfSize = 32 * l_1_6
  local physics = PhysicsComponent.new(l_1_0, {rect = {-halfSize, -halfSize, halfSize, halfSize}, category = PhysicsComponent.DYNAMIC_CATEGORY, collidesWithCategories = PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.DYNAMIC, isSensor = true})
  l_1_0:get(PhysicsComponent):setCollisionHandler(nil, l_1_0.onFireHit, l_1_0)
  if l_1_5 == Direction.DIR_N then
    sprite.prop:setRot(0, 0, 180)
    physics:setLinearVelocity(0, l_1_7)
  else
    if l_1_5 == Direction.DIR_E then
      sprite.prop:setRot(0, 0, 90)
      physics:setLinearVelocity(l_1_7, 0)
    else
      if l_1_5 == Direction.DIR_W then
        sprite.prop:setRot(0, 0, 270)
        physics:setLinearVelocity(-l_1_7, 0)
      else
        physics:setLinearVelocity(0, -l_1_7)
      end
    end
  end
  l_1_0.prop:setScl(l_1_6)
  l_1_0:get(AnimatorComponent):play("Fire")
  l_1_0.cue = l_1_0:get(SoundComponent):playCue("SFX/Objects/Fireball_Loop", nil, 0.5)
end

Fireball.onFireHit = function(l_2_0, l_2_1)
  if l_2_1 then
    if l_2_1 == l_2_0.sourceEntity or l_2_1:is(Fireball) or l_2_1:is(Shooter) then
      return 
    end
    local health = l_2_1:get(HealthComponent)
    if health then
      health:damageKnockback(l_2_0.DAMAGE, l_2_0, 1000)
    end
  end
  if l_2_0.cue then
    l_2_0.cue:stop()
  end
  l_2_0:destroy()
end

return Fireball

