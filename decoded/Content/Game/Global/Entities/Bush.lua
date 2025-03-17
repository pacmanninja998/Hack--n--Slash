-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Bush.lua 

local Entity = require("Entity")
local Shader = require("Shader")
local CommonActions = require("CommonActions")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local FlammableComponent = require("Components.FlammableComponent")
local DestroyAction = require("Class").create(CommonActions.PlayAnimation, "DestroyAction")
DestroyAction.DROP_LOOT_TIME = 0.1
DestroyAction.start = function(l_1_0, l_1_1)
  CommonActions.PlayAnimation.start(l_1_0, l_1_1)
  l_1_0.elapsed = 0
  l_1_0.droppedLoot = false
  l_1_0.entity:room():queueUpdate(function()
    self.entity:get(SoundComponent):playCue("SFX/Objects/Destroy_Brush", nil, 0.5)
   end)
  l_1_0.glitchDuration = 0.3
  l_1_0.glitchOutShader = Shader.load("Content/Game/Global/Shaders/GlitchOut")
  l_1_0.origScaleX, l_1_0.origScaleY = l_1_0.entity.prop:getScl(), l_1_0.entity.prop
  local sprite = l_1_0.entity:get(SpriteComponent)
  local deck, index = sprite.sheet:getDeck(sprite.name, sprite.frame, sprite.looping)
  local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
  local u0, v0, u1, v1 = x0, y0, x2, y2
  local uScale = u1 - u0
  local vScale = v1 - v0
  l_1_0.entity:setCurrentShader(l_1_0.glitchOutShader)
  sprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
end

DestroyAction.tick = function(l_2_0)
  l_2_0.elapsed = l_2_0.elapsed + MOAISim.getStep()
  if not l_2_0.droppedLoot and l_2_0.DROP_LOOT_TIME < l_2_0.elapsed then
    l_2_0.entity:dropLoot()
    l_2_0.droppedLoot = true
  end
  l_2_0.entity:get(SpriteComponent).material:setShaderValue("deathTime", MOAIMaterial.VALUETYPE_FLOAT, 0)
  if l_2_0.glitchDuration < l_2_0.elapsed then
    if l_2_0.destroyWhenDone then
      l_2_0.entity:get(SpriteComponent).prop:setVisible(false)
      l_2_0.entity:destroy()
    else
      l_2_0.entity:get(SpriteComponent).prop:setVisible(true)
    end
    return false
  else
    local deathAmount = l_2_0.elapsed / l_2_0.glitchDuration
    local currentSprite = l_2_0.entity:get(SpriteComponent)
    currentSprite.material:setShaderValue("deathTime", MOAIMaterial.VALUETYPE_FLOAT, deathAmount)
    l_2_0.entity.prop:setScl(l_2_0.origScaleX + l_2_0.origScaleX * 0.05 * deathAmount, l_2_0.origScaleY + l_2_0.origScaleY * 15 * deathAmount)
  end
  return CommonActions.PlayAnimation.tick(l_2_0)
end

DestroyAction.stop = function(l_3_0)
  CommonActions.PlayAnimation.stop(l_3_0)
  if not l_3_0.droppedLoot then
    l_3_0.entity:dropLoot()
    l_3_0.droppedLoot = true
  end
  l_3_0.entity:get(SpriteComponent).prop:setVisible(false)
  l_3_0.entity:destroy()
end

local Bush = require("Class").create(Entity, "Bush")
Bush.addIntegerField("HEARTS_TO_DROP", 0, 0, 100)
Bush.addBooleanField("ON_FIRE", false)
Bush.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  Entity.init(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  math.randomseed(l_4_2 + l_4_3)
  local spriteName = math.random() > 0.5 and "Bush" or "Bush_B"
  SpriteComponent.new(l_4_0, "Interactions/Props/" .. spriteName .. "/" .. spriteName, spriteName)
  AnimatorComponent.new(l_4_0, true)
  PhysicsComponent.new(l_4_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_4_0.prop:setScl(0.5)
  SoundComponent.new(l_4_0, {})
  FlammableComponent.new(l_4_0, 0.75, 64, 1.5)
  local flammable = l_4_0:get(FlammableComponent)
  flammable:registerOnLit(l_4_0.onLit, l_4_0)
  flammable:registerOnUnlit(l_4_0.onUnlit, l_4_0)
  flammable:registerOnDone(l_4_0.onDone, l_4_0, 2)
end

Bush.dropLoot = function(l_5_0)
  for i = 1, l_5_0.HEARTS_TO_DROP do
    local posX, posY = l_5_0:getPosition()
    local angle = 2 * math.pi * math.random()
    local speed = math.random(50, 100)
    local velX, velY = speed * math.cos(angle), speed * math.sin(angle)
    Entity.create("Content/Game/Global/Entities/HealthPickup", l_5_0.layer, posX, posY, nil, nil, 1, velX, velY)
  end
end

Bush.onLit = function(l_6_0)
  l_6_0.prop:setColor(1, 0, 0, 1)
  l_6_0.fireEffect = Entity.create("Content/Game/Global/Entities/Effects/Fire", l_6_0.layer, l_6_0:getPosition())
end

Bush.onUnlit = function(l_7_0)
  l_7_0.prop:setColor(1, 1, 1, 1)
  if l_7_0.fireEffect then
    l_7_0.fireEffect:destroy()
  end
end

Bush.onDone = function(l_8_0)
  if l_8_0.fireEffect then
    l_8_0.fireEffect:destroy()
  end
  if l_8_0.cue then
    l_8_0:get(SoundComponent):stopCue(l_8_0.cue)
  end
  local x, y = l_8_0:getPosition()
  Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_8_0.layer, x, y)
  l_8_0:forceAction(DestroyAction.new("Destroy", 1, 30))
end

Bush.isHackable = function(l_9_0)
  return true
end

Bush.onFieldSet = function(l_10_0, l_10_1, l_10_2)
  if l_10_1 == "ON_FIRE" then
    if l_10_2 then
      l_10_0:get(FlammableComponent):light()
      l_10_0:room():queueUpdate(function()
        self.cue = self:get(SoundComponent):playCue("SFX/Objects/Bush_Burn", nil, 0.5)
         end)
    else
      l_10_0:get(FlammableComponent):putOut()
      if l_10_0.cue then
        l_10_0:get(SoundComponent):stopCue(l_10_0.cue)
      end
    end
  end
end

Bush.onSwordHit = function(l_11_0, l_11_1)
  l_11_0:forceAction(DestroyAction.new("Destroy", 1, 30))
end

return Bush

