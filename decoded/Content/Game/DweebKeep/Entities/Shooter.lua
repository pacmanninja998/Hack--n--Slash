-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Shooter.lua 

local Class = require("Class")
local Action = require("Action")
local Entity = require("Entity")
local Shooter = require("Class").create(Entity, "Shooter")
local AnimatorComponent = require("Components.AnimatorComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local LogoComponent = require("Components.LogoComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local CommonLogoInstructions = require("CommonLogoInstructions")
Shooter.addEditableField("PATTERN", Class.ArraySchema.new(Class.PolymorphicSchema.new("TYPE", Class.EnumSchema.new("FIRE", "WAIT"), {FIRE = {SCALE = Class.IntegerSchema.new(1, 1), SPEED = Class.IntegerSchema.new(200, 1)}, WAIT = {FRAMES = Class.IntegerSchema.new(1, 0)}})))
Shooter.Fire = Class.create(CommonLogoInstructions.Base, "Shooter.Fire")
Shooter.Fire.start = function(l_1_0, l_1_1)
  CommonLogoInstructions.Base.start(l_1_0, l_1_1)
  local x, y = l_1_0.entity:get(AnimatorComponent):getJointLoc("Emitter")
  local wx, wy = l_1_0.entity.prop:modelToWorld(x, y)
  l_1_0.entity:get(SoundComponent):playCue("SFX/Objects/Fireball", nil, 0.5)
  Entity.create("Content/Game/Global/Entities/Fireball", l_1_0.entity.layer, wx, wy, nil, l_1_0.entity:get(AnimatorComponent):getDirection(), l_1_0.data.SCALE, l_1_0.data.SPEED, l_1_0.entity)
end

Shooter.Wait = Class.create(CommonLogoInstructions.Base, "Shooter.Wait")
Shooter.Wait.start = function(l_2_0, l_2_1)
  CommonLogoInstructions.Base.start(l_2_0, l_2_1)
  l_2_0.elapsedFrames = 0
end

Shooter.Wait.tick = function(l_3_0)
  l_3_0.elapsedFrames = l_3_0.elapsedFrames + 1
  return l_3_0.elapsedFrames <= l_3_0.data.FRAMES
end

Shooter.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  Entity.init(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  PhysicsComponent.new(l_4_0, {rect = {-64, -32, 64, 32}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  SpriteComponent.new(l_4_0, "Interactions/Props/Shooter/Shooter")
  LogoComponent.new(l_4_0, {FIRE = Shooter.Fire, WAIT = Shooter.Wait})
  SoundComponent.new(l_4_0, {})
  local animator = AnimatorComponent.new(l_4_0, AnimatorComponent.DIRECTION_MODE_SIDE, l_4_5)
  l_4_0.PATTERN = {{TYPE = "WAIT", FRAMES = 30}, {TYPE = "FIRE", SCALE = 1, SPEED = 200}}
  animator:play("Default")
end

Shooter.isHackable = function(l_5_0)
  return true
end

Shooter.tick = function(l_6_0)
  Entity.tick(l_6_0)
  if not l_6_0.action then
    l_6_0:get(LogoComponent):setBehavior(l_6_0.PATTERN)
  end
end

return Shooter

