-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Effects\CloudA.lua 

local Entity = require("Entity")
local CloudA = require("Class").create(Entity, "CloudA")
local Shader = require("Shader")
local SpriteComponent = require("Components.SpriteComponent")
local CloudParticle = require("Class").create(Entity, "CloudParticle")
CloudParticle.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Entity.init(l_1_0, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0.lifetime = 1
  l_1_0.currentLife = 0
  l_1_0.scale = 1
  l_1_0.velocity = 1
  l_1_0.valid = true
  l_1_0.alpha = 0
  l_1_0.sprite = SpriteComponent.new(l_1_0, l_1_1)
  l_1_0.sprite.prop:setPriority(l_1_6)
end

CloudParticle.update = function(l_2_0)
  if l_2_0.lifetime <= l_2_0.currentLife then
    l_2_0.valid = false
    l_2_0.prop:setVisible(false)
  end
  l_2_0:setAlpha(1 - math.abs(l_2_0.currentLife / l_2_0.lifetime - 0.5) * 2)
  l_2_0.sprite.prop:setScl(l_2_0.scale, l_2_0.scale, l_2_0.scale)
end

CloudA.init = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5, l_3_6, l_3_7, l_3_8, l_3_9, l_3_10, l_3_11, l_3_12, l_3_13, l_3_14, l_3_15, l_3_16)
  Entity.init(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  l_3_0.particles = {}
  l_3_0.texturePath = l_3_6
  l_3_0.layer = l_3_1
  l_3_0.elapsed = 0
  l_3_0.rateElapsed = 0
  l_3_0.rate = 1 / l_3_9
  l_3_0.emitterScale = {l_3_7, l_3_8}
  l_3_0.sortBias = l_3_16
  l_3_0.pos = {l_3_2, l_3_3}
  l_3_0.velocity = l_3_10
  l_3_0.velocityVariance = l_3_11
  l_3_0.particleLifetime = l_3_12
  l_3_0.particleLifetimeVariance = l_3_13
  l_3_0.particleScale = l_3_14
  l_3_0.particleScaleVariance = l_3_15
end

CloudA.spawnNewParticle = function(l_4_0)
  local newPosX = l_4_0.pos[1] + l_4_0.emitterScale[1] * (math.random() - 1)
  local newPosY = l_4_0.pos[2] + l_4_0.emitterScale[2] * (math.random() - 1)
  local particle = CloudParticle.new(l_4_0.texturePath, l_4_0.layer, newPosX, newPosY, l_4_0.layer:uniqueNameForEntity("CloudA"), l_4_0.sortBias)
  particle.velocity = l_4_0.velocity + l_4_0.velocityVariance * (math.random() - 1)
  particle.scale = l_4_0.particleScale + l_4_0.particleScaleVariance * (math.random() - 1)
  particle.lifetime = l_4_0.particleLifetime + l_4_0.particleLifetimeVariance * (math.random() - 1)
  table.insert(l_4_0.particles, particle)
end

CloudA.tick = function(l_5_0)
  local simStep = MOAISim.getStep()
  l_5_0.elapsed = l_5_0.elapsed + simStep
  l_5_0.rateElapsed = l_5_0.rateElapsed + simStep
  if l_5_0.rate <= l_5_0.rateElapsed then
    l_5_0.rateElapsed = 0
    l_5_0:spawnNewParticle()
  end
  for _,particle in ipairs(l_5_0.particles) do
    local posX, posY = particle:getPosition()
    particle:setPosition(posX + simStep * l_5_0.velocity, posY, true)
    particle.currentLife = particle.currentLife + simStep
    particle:update()
  end
  for index,value in ipairs(l_5_0.particles) do
    if not value.valid then
      table.remove(l_5_0.particles, index)
    end
  end
  Entity.tick(l_5_0)
end

return CloudA

