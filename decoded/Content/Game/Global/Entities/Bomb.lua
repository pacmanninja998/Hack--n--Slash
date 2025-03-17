-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Bomb.lua 

local Entity = require("Entity")
local Action = require("Action")
local Room = require("Room")
local EntitySet = require("EntitySet")
local EntityRef = require("EntityRef")
local Shader = require("Shader")
local CommonActions = require("CommonActions")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local Bomb = require("Class").create(Entity, "Bomb")
Bomb.BombStun = require("Class").create(Action, "Bomb.BombStun")
Bomb.BombStun.COUNTDOWN = 4
Bomb.BombStun.FADE_IN_TYPE = 0
Bomb.BombStun.FADE_OUT_TYPE = 1
Bomb.BombStun.FADE_DURATION = 0.5
Bomb.BombStun.init = function(l_1_0, l_1_1)
  Action.init(l_1_0)
  if not l_1_1 then
    l_1_0.COUNTDOWN = l_1_0.COUNTDOWN
  end
end

Bomb.BombStun.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.stunnedShader = Shader.load("Content/Game/Global/Shaders/Stunned")
  l_2_0.entity:setCurrentShader(l_2_0.stunnedShader)
  l_2_0.elapsed = 0
  l_2_0.fadeElapsed = 0
  l_2_0.lifetime = l_2_0.COUNTDOWN
  l_2_0.fadeType = l_2_0.FADE_IN_TYPE
  local x, y = l_2_0.entity:getPosition()
  local x0, y0, x1, y1 = l_2_0.entity:getWorldBounds()
  local portalScale = 1.5 * math.max(x1 - x0, y1 - y0) / 512
  l_2_0.portal = Entity.create("Content/Game/Global/Entities/Effects/PortalExternal", l_2_0.entity:room():getLayerByOrder(0), x, y0 + (y1 - y0) * 0.5, nil, portalScale)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  if l_2_0.entity:is(Alice) then
    l_2_0:onEntityEnterSensor(l_2_0.entity)
  end
end

Bomb.BombStun.tick = function(l_3_0)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  l_3_0.fadeElapsed = l_3_0.fadeElapsed + MOAISim.getStep()
  local fadeAmt = l_3_0.fadeElapsed / l_3_0.FADE_DURATION
  if fadeAmt <= 1 then
    if l_3_0.fadeType == l_3_0.FADE_IN_TYPE then
      l_3_0.stunnedShader:setFragmentUniformFloat("ShaderIntensity", fadeAmt)
    else
      if l_3_0.fadeType == l_3_0.FADE_OUT_TYPE then
        l_3_0.stunnedShader:setFragmentUniformFloat("ShaderIntensity", 1 - fadeAmt)
      else
        if l_3_0.fadeType == l_3_0.FADE_IN_TYPE and l_3_0.COUNTDOWN - l_3_0.FADE_DURATION < l_3_0.elapsed then
          l_3_0.fadeType = l_3_0.FADE_OUT_TYPE
          l_3_0.fadeElapsed = 0
        end
      end
      do
        local targetSprite = l_3_0.entity:get(SpriteComponent)
        if targetSprite and targetSprite.material then
          local deck, index = targetSprite.sheet:getDeck(targetSprite.name, targetSprite.frame, targetSprite.looping)
          if deck then
            local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
            local u0, v0, u1, v1 = x0, y0, x2, y2
            local uScale = u1 - u0
            local vScale = v1 - v0
            targetSprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
            targetSprite.material:setShaderValue("shaderDuration", MOAIMaterial.VALUETYPE_FLOAT, l_3_0.elapsed / l_3_0.lifetime)
          end
        end
        if not l_3_0.sensor then
          local physics = l_3_0.entity:get(PhysicsComponent)
          if not physics then
            return false
          end
          if physics.x0 ~= physics.x1 and physics.y0 ~= physics.y1 then
            local width, height = physics.x1 - physics.x0, physics.y1 - physics.y0
            l_3_0.sensor = physics:addRectSensor(physics.x0 - width * 0.2, physics.y0 - height * 0.2, physics.x1 + width * 0.2, physics.y1 + height * 0.2)
          else
            l_3_0.sensor = physics:addCircleSensor(64)
          end
          l_3_0.sensor.entityEnterEvent:register(l_3_0.onEntityEnterSensor, l_3_0)
        end
        if l_3_0.COUNTDOWN > 0 then
          l_3_0.COUNTDOWN = l_3_0.COUNTDOWN - MOAISim.getStep()
          l_3_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
        else
          l_3_0.COUNTDOWN = 0
        end
        return l_3_0.COUNTDOWN > 0
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Bomb.BombStun.onEntityEnterSensor = function(l_4_0, l_4_1)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  if l_4_1:is(Alice) and not l_4_1:isTeleporting() and not l_4_1:isDoing(CommonActions.Suspend) then
    l_4_1:teleportInClassRoom(l_4_0.entity)
  end
end

Bomb.BombStun.stop = function(l_5_0)
  if l_5_0.sensor then
    l_5_0.sensor.fixture:destroy()
    l_5_0.sensor = nil
  end
  if l_5_0.effect then
    l_5_0.effect:destroy()
  end
  l_5_0.portal:fadeOut()
  l_5_0.entity:resetShader()
  Action.stop(l_5_0)
end

local ExplodeAction = require("Class").create(Action, "ExplodeAction")
ExplodeAction.start = function(l_6_0, l_6_1)
  Action.start(l_6_0, l_6_1)
  local posX, posY = l_6_0.entity:getPosition()
  local radMult = math.pi / 180
  l_6_0.rotationIncrement = 360 / l_6_1.NUM_EXPLOSIONS
  for i = 1, l_6_1.NUM_EXPLOSIONS do
    local cRadA = i * l_6_0.rotationIncrement
    local xOffsetA = math.cos(cRadA) - math.sin(cRadA)
    local yOffsetA = math.cos(cRadA) + math.sin(cRadA)
    Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_6_0.entity.layer, posX + xOffsetA * l_6_1.EXPLODE_RADIUS, posY + yOffsetA * l_6_1.EXPLODE_RADIUS)
  end
  for entity in pairs(l_6_0.entity.targets.entities) do
    entity:insertAction(Bomb.BombStun.new())
  end
  l_6_0.explodeShader = Shader.create("Content/Game/Global/Shaders/BombExplode")
  l_6_0.elapsed = 0
  l_6_0.lifetime = 0.2
  l_6_0.explosionRef = EntityRef.new(Entity.create("Content/Game/Global/Entities/Effects/ExplosionA", l_6_0.entity.layer, posX, posY))
  l_6_0.explosionRef.entity:setDefaultShader(l_6_0.explodeShader)
  l_6_0.entity.audioEvent.persist = true
end

ExplodeAction.tick = function(l_7_0)
  l_7_0.elapsed = l_7_0.elapsed + MOAISim.getStep()
  local duration = l_7_0.elapsed / l_7_0.lifetime
  if l_7_0.lifetime < l_7_0.elapsed then
    l_7_0.entity:get(SpriteComponent).prop:setVisible(false)
  else
    l_7_0.entity:get(SpriteComponent).prop:setVisible(false)
    if l_7_0.explosionRef:isValid() then
      local targetSprite = l_7_0.explosionRef.entity:get(SpriteComponent)
      if targetSprite and targetSprite.material then
        local deck, index = targetSprite.sheet:getDeck(targetSprite.name, targetSprite.frame, targetSprite.looping)
        local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
        local u0, v0, u1, v1 = x0, y0, x2, y2
        local uScale = u1 - u0
        local vScale = v1 - v0
        targetSprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
        targetSprite.material:setShaderValue("shaderDuration", MOAIMaterial.VALUETYPE_FLOAT, l_7_0.elapsed / l_7_0.lifetime)
      end
      local finalScale = math.sqrt(duration) * l_7_0.entity.PIXEL_RADIUS
      l_7_0.explosionRef.entity.prop:setScl(finalScale, finalScale, finalScale)
    end
  end
  return l_7_0.explosionRef:isValid()
end

ExplodeAction.stop = function(l_8_0)
  Action.stop(l_8_0)
  l_8_0.entity:destroy()
end

Bomb.COUNTDOWN = 3
Bomb.EXPLODE_RADIUS = 128
Bomb.NUM_EXPLOSIONS = 24
Bomb.init = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5, l_9_6, l_9_7)
  Entity.init(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4)
  SpriteComponent.new(l_9_0, "Interactions/Props/BreakpointBomb/BreakpointBomb")
  PhysicsComponent.new(l_9_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.DYNAMIC, true)
  SoundComponent.new(l_9_0, {})
  AnimatorComponent.new(l_9_0, true)
  l_9_0:get(PhysicsComponent):addCircle(28)
  l_9_0.placer = l_9_5
  l_9_0.targets = EntitySet.new()
  if not l_9_6 then
    l_9_0.COUNTDOWN = Bomb.COUNTDOWN
  end
  if not l_9_7 then
    l_9_0.EXPLODE_RADIUS = Bomb.EXPLODE_RADIUS
  end
  l_9_0.NUM_EXPLOSIONS = Bomb.NUM_EXPLOSIONS
  l_9_0.PIXEL_RADIUS = l_9_0.EXPLODE_RADIUS / 4
  l_9_0.explodeSensor = l_9_0:get(PhysicsComponent):addCircleSensor(l_9_0.EXPLODE_RADIUS, PhysicsComponent.ALL_CATEGORY)
  l_9_0.explodeSensor.entityEnterEvent:register(l_9_0.onEntityEnterExplosionRadius, l_9_0)
  l_9_0.explodeSensor.entityLeaveEvent:register(l_9_0.onEntityLeaveExplosionRadius, l_9_0)
  l_9_0.audioEvent = l_9_0:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Breakpoint_Bomb", false, 1)
  l_9_0.safeClasses = {Entity.cache:load("Content/Game/Global/Entities/RedSprite") = true, Entity.cache:load("Content/Game/Global/Entities/Alice") = true}
  Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_9_0.layer, l_9_2, l_9_3, nil, l_9_0.scaleFactor)
  l_9_0:get(AnimatorComponent):play("Bomb_fuse", l_9_0.FRAMES_PER_SECOND)
end

Bomb.tick = function(l_10_0)
  if l_10_0.COUNTDOWN > 0 then
    l_10_0.COUNTDOWN = l_10_0.COUNTDOWN - MOAISim.getStep()
  else
    if not l_10_0:isDoing(ExplodeAction) then
      l_10_0.COUNTDOWN = 0
      l_10_0:forceAction(ExplodeAction.new())
    end
  end
  Entity.tick(l_10_0)
end

Bomb.onEntityEnterExplosionRadius = function(l_11_0, l_11_1)
  if not l_11_0.safeClasses[l_11_1:class()] then
    l_11_0.targets:addEntity(l_11_1)
  end
end

Bomb.onEntityLeaveExplosionRadius = function(l_12_0, l_12_1)
  l_12_0.targets:removeEntity(l_12_1)
end

Bomb.isHeavy = function(l_13_0)
  return true
end

return Bomb

