-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\OldRed.lua 

local Entity = require("Entity")
local Shader = require("Shader")
local Graphics = require("DFCommon.Graphics")
local OldRed = require("Class").create(Entity, "OldRed")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
OldRed.PERCEPTIBLE_RADIUS = 450
OldRed.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/ORC/ORC")
  l_1_0.oldRedShader = Shader.load("Content/Game/Global/Shaders/OldRed")
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_1_0)
  SoundComponent.new(l_1_0, {})
  l_1_0:get(InteractionComponent):setEnabled(false)
  l_1_0:enableField(false)
  l_1_0.interactionSensor = nil
  l_1_0.prop:setScl(0.75)
  l_1_0:get(AnimatorComponent):play("Breathe")
  l_1_0.renderAsPhysics = true
  l_1_0.aliceAuraShader = Shader.load("Content/Game/Global/Shaders/AliceAura")
  l_1_0.origAliceShader = nil
  l_1_0:setDefaultShader(l_1_0.oldRedShader)
end

OldRed.enableInteractionSensor = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  l_2_0:get(InteractionComponent):setEnabled(l_2_1)
  if l_2_1 and not l_2_0.interactionSensor then
    local entPosX, entPosY = l_2_0:getPosition()
    local relX, relY = l_2_2 - entPosX, l_2_3 - entPosY
    local minX, minY, maxX, maxY = relX - l_2_4 / 2, relY - l_2_5 / 2, relX + l_2_4 / 2, relY + l_2_5 / 2
    l_2_0.interactionSensor = l_2_0:get(PhysicsComponent):addRectSensor(minX, minY, maxX, maxY, PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.DYNAMIC_CATEGORY)
  elseif not l_2_1 and l_2_0.interactionSensor then
    l_2_0.interactionSensor.fixture:destroy()
    l_2_0.interactionSensor = nil
  end
end

OldRed.enableField = function(l_3_0, l_3_1)
  if l_3_1 and not l_3_0.sensor then
    l_3_0.sensor = l_3_0:get(PhysicsComponent):addCircleSensor(l_3_0.PERCEPTIBLE_RADIUS, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.GHOST_CATEGORY, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.GHOST_CATEGORY)
    l_3_0.sensor.entityEnterEvent:register(l_3_0.onEntityEnter, l_3_0)
    l_3_0.sensor.entityLeaveEvent:register(l_3_0.onEntityLeave, l_3_0)
    if not l_3_0.auraGlow then
      l_3_0.auraShader = Shader.create("Content/Game/Global/Shaders/OldRedAura")
      l_3_0.auraGlow = Entity.create("Content/Game/Global/Entities/Effects/OldRedAura", l_3_0.layer, l_3_0:getPosition())
      l_3_0.auraGlow:setDefaultShader(l_3_0.auraShader)
      l_3_0.auraShader:setFragmentUniformFloat("ShaderIntensity", 0)
      l_3_0.auraGlow:setRadius(l_3_0.PERCEPTIBLE_RADIUS - l_3_0.PERCEPTIBLE_RADIUS * 0.5)
      local auraTexture = Graphics.loadTexture("Particles/Textures/RedAura")
      local auraSprite = l_3_0.auraGlow:get(SpriteComponent)
      auraSprite.prop:setPriority(500)
      auraSprite.material:setTexture(auraTexture)
      auraSprite.material:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE)
    end
    l_3_0.auraCue = l_3_0:get(SoundComponent):playCue("SFX/Objects/Chicco_ForceField", nil, 0.5)
    l_3_0.auraCue = l_3_0:get(SoundComponent):playCue("SFX/Objects/Chicco_ForceField_Activate", nil, 0.5)
  elseif not l_3_1 and l_3_0.sensor then
    l_3_0.sensor.fixture:destroy()
    l_3_0.sensor = nil
    if l_3_0.auraShader and l_3_0.auraGlow then
      l_3_0.auraShader:setFragmentUniformFloat("ShaderIntensity", 0)
      l_3_0.auraGlow:setRadius(l_3_0.PERCEPTIBLE_RADIUS - l_3_0.PERCEPTIBLE_RADIUS * 0.5)
    end
    if l_3_0.auraCue then
      l_3_0.auraCue:stop()
    end
  end
end

OldRed.setFieldIntensity = function(l_4_0, l_4_1)
  if l_4_0.auraShader then
    l_4_0.auraShader:setFragmentUniformFloat("ShaderIntensity", l_4_1)
  end
  if l_4_0.auraGlow then
    l_4_0.auraGlow:setRadius(l_4_0.PERCEPTIBLE_RADIUS - l_4_0.PERCEPTIBLE_RADIUS * 0.5 * (1 - l_4_1))
  end
end

OldRed.onEntityEnter = function(l_5_0, l_5_1)
  if l_5_1:is(Alice) and not l_5_1:isGhost() then
    l_5_1:toggleGhost()
    l_5_0.origAliceShader = l_5_0:room():getAlice().shader
    l_5_0:room():getAlice():setDefaultShader(l_5_0.aliceAuraShader)
    local targetSprite = l_5_0:room():getAlice():get(SpriteComponent)
    local deck, index = targetSprite.sheet:getDeck(targetSprite.name, targetSprite.frame, targetSprite.looping)
    if deck then
      local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
      local u0, v0, u1, v1 = x0, y0, x2, y2
      local uScale = u1 - u0
      local vScale = v1 - v0
      targetSprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
    end
  end
end

OldRed.onEntityLeave = function(l_6_0, l_6_1)
  if l_6_1:is(Alice) and l_6_1:isGhost() then
    l_6_1:toggleGhost()
    if l_6_0.origAliceShader then
      l_6_0:room():getAlice():setDefaultShader(l_6_0.origAliceShader)
    end
  end
end

return OldRed

