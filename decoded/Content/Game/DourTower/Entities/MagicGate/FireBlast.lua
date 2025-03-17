-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\MagicGate\FireBlast.lua 

local Class = require("Class")
local Entity = require("Entity")
local FireBlast = Class.create(Entity, "FireBlast")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
FireBlast.addIntegerField("DAMAGE", 1)
FireBlast.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(FireBlast).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX")
  local physics = PhysicsComponent.new(l_1_0, {rect = {-128, -32, 128, 256}, category = PhysicsComponent.DYNAMIC_CATEGORY, collidesWithCategories = PhysicsComponent.HITTABLE_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.DYNAMIC, isSensor = true})
  l_1_0:get(PhysicsComponent):setCollisionHandler(nil, l_1_0.onFireHit, l_1_0, MOAIBox2DArbiter.BEGIN)
  local animator = AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  l_1_0.sequence = animator:playOnce("FireBlast", 10)
  l_1_0.prop:setPiv(42, -350)
  l_1_0.prop:setScl(0.65)
  local sound = SoundComponent.new(l_1_0)
  sound:playCue("SFX/Characters/Wizard/Wizard_Fireball")
end

FireBlast.tick = function(l_2_0)
  Class.super(FireBlast).tick(l_2_0)
  if not l_2_0:get(AnimatorComponent):isPlaying(l_2_0.sequence) then
    l_2_0:destroy()
  end
end

FireBlast.onFireHit = function(l_3_0, l_3_1)
  if l_3_1 then
    local health = l_3_1:get(HealthComponent)
    if health then
      health:damage(l_3_0.DAMAGE, l_3_0, 0, -2000)
    end
  end
end

return FireBlast

