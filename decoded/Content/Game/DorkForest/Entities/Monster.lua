-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Monster.lua 

local Action = require("Action")
local Entity = require("Entity")
local Monster = require("Class").create(Entity, "Monster")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local SoundComponent = require("Components.SoundComponent")
Monster.ACTION_WAIT_SECONDS = 3
Monster.STOMP_PROBABILITY = 0.5
Monster.BREATHEGAS_PROBABILITY = 0.5
Monster.FLEE_THRESHOLD = 10
local Class = require("Class")
local Attack = Class.create(Action, "Attack")
local Wait = Class.create(Action, "Wait")
local Flee = Class.create(Action, "Flee")
local Bite = Class.create(Attack, "Bite")
local BreatheGas = Class.create(Attack, "BreatheGas")
local Stomp = Class.create(Attack, "Stomp")
Attack.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0.name = l_1_1
  l_1_0.cue = l_1_3
  l_1_0.framesPerSecond = l_1_2
end

Attack.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  local animDir = l_2_0.entity:getAttackDirection()
  if not l_2_0.entity.hasShell or not l_2_0.name .. animDir .. "_Shell" then
    local animName = l_2_0.name .. animDir
  end
  if l_2_0.cue then
    l_2_0.entity:room():queueUpdate(function()
    self.entity:get(SoundComponent):playCue(self.cue, nil, 0.5)
   end)
  end
  local animator = l_2_0.entity:get(AnimatorComponent)
  l_2_0.sequence = animator:playOnce(animName, l_2_0.framesPerSecond)
  animator:registerHitboxFilter(l_2_0.name .. animDir, PhysicsComponent.DYNAMIC_CATEGORY, l_2_0.onHit, l_2_0)
end

Attack.tick = function(l_3_0)
  Action.tick(l_3_0)
  return l_3_0.entity:get(AnimatorComponent):isPlaying(l_3_0.sequence)
end

Attack.stop = function(l_4_0)
  Action.stop(l_4_0)
  if l_4_0.cue then
    l_4_0.entity:get(SoundComponent):stopCue(l_4_0.cue)
  end
  l_4_0.entity:get(AnimatorComponent):clearHitboxFilter(l_4_0.name)
end

Attack.onHit = function(l_5_0, l_5_1)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  local SwampTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/SwampTurtle")
  local CorruptedTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/CorruptedTurtle")
  if l_5_1:is(SwampTurtle) or l_5_1:is(CorruptedTurtle) then
    if l_5_0:is(Bite) or l_5_0:is(Stomp) then
      l_5_1:destroy()
    else
      if l_5_0:is(BreatheGas) and l_5_1:is(SwampTurtle) and not l_5_1.action:is(SwampTurtle.CorruptAction) then
        l_5_1:forceAction(SwampTurtle.CorruptAction.new())
      else
        if l_5_1:is(Alice) then
          local damage = 0
          local knockBackX, knockBackY = 0, 0
          if l_5_0:is(Bite) or l_5_0:is(Stomp) then
            damage = 2
            knockBackX, knockBackY = 0, -100
          else
            if l_5_0:is(BreatheGas) then
              damage = 1
            end
          end
          l_5_1:get(HealthComponent):damage(damage, l_5_0.entity, knockBackX, knockBackY)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Wait.init = function(l_6_0, l_6_1)
  l_6_0.seconds = l_6_1
end

Wait.start = function(l_7_0, l_7_1)
  Action.start(l_7_0, l_7_1)
  l_7_0.elapsed = 0
  local idleAnim = l_7_0.entity.hasShell and "Breathe_Frnt_Shell" or "Breathe_Frnt"
  l_7_1:get(AnimatorComponent):play(idleAnim)
end

Wait.tick = function(l_8_0)
  l_8_0.elapsed = l_8_0.elapsed + MOAISim.getStep()
  return l_8_0.elapsed < l_8_0.seconds
end

Flee.FRAMES_PER_SECOND = 10
Flee.start = function(l_9_0, l_9_1)
  Action.start(l_9_0, l_9_1)
  l_9_0.sequence = l_9_0.entity:get(AnimatorComponent):playOnce("Flee", l_9_0.FRAMES_PER_SECOND)
end

Flee.tick = function(l_10_0)
  Action.tick(l_10_0)
  return l_10_0.entity:get(AnimatorComponent):isPlaying(l_10_0.sequence)
end

Flee.stop = function(l_11_0)
  Action.stop(l_11_0)
  l_11_0.entity:destroy()
end

Bite.FRAMES_PER_SECOND = 10
Bite.init = function(l_12_0)
  Attack.init(l_12_0, "Bite", l_12_0.FRAMES_PER_SECOND)
end

Bite.onHit = function(l_13_0, l_13_1)
end

BreatheGas.FRAMES_PER_SECOND = 10
BreatheGas.init = function(l_14_0)
  Attack.init(l_14_0, "BreatheGas", l_14_0.FRAMES_PER_SECOND)
end

Stomp.FRAMES_PER_SECOND = 10
Stomp.init = function(l_15_0)
  Attack.init(l_15_0, "Stomp", l_15_0.FRAMES_PER_SECOND)
end

Monster.init = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4)
  Entity.init(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4)
  AnimatorComponent.new(l_16_0, true)
  PhysicsComponent.new(l_16_0, 128, 128, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.SENSOR_CATEGORY, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_16_0, "Characters/Behemoth/Behemoth")
  HealthComponent.new(l_16_0, 3, 3, 1, 0, 0.05)
  SoundComponent.new(l_16_0, {})
  l_16_0.prop:setScl(1.4)
  l_16_0:get(HealthComponent).onKilled:register(l_16_0.onKilled, l_16_0)
  l_16_0.frontWall = l_16_0:get(PhysicsComponent):addRect(-200, 0, 200, 32)
  l_16_0.frontWall:setFilter(PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.SENSOR_CATEGORY)
  l_16_0.frontWall:setSensor(false)
  l_16_0.faceSensor = l_16_0:get(PhysicsComponent):addCircleSensor(190)
  l_16_0.hasShell = true
end

Monster.tick = function(l_17_0)
  Entity.tick(l_17_0)
  if not l_17_0.action then
    local annoyingSpriteCount = 0
    if annoyingSpriteCount == 0 then
      local probability = math.random()
      probability = probability - l_17_0.STOMP_PROBABILITY
      if probability <= 0 then
        l_17_0:queueAction(Stomp.new())
        l_17_0:queueAction(Wait.new(l_17_0.ACTION_WAIT_SECONDS))
      end
      probability = probability - l_17_0.BREATHEGAS_PROBABILITY
      if probability <= 0 then
        l_17_0:queueAction(BreatheGas.new())
        l_17_0:queueAction(Wait.new(l_17_0.ACTION_WAIT_SECONDS))
      elseif annoyingSpriteCount < l_17_0.FLEE_THRESHOLD then
        l_17_0:queueAction(Bite.new())
        l_17_0:queueAction(Wait.new(l_17_0.ACTION_WAIT_SECONDS))
      else
        l_17_0:queueAction(Flee.new())
      end
    end
  end
end

Monster.getAttackDirection = function(l_18_0)
  local animDir = "_Frnt"
  if l_18_0.player then
    local playerPosX, playerPosY = l_18_0.player:getPosition()
    local posX, posY = l_18_0:getPosition()
    if math.abs(posY - playerPosY) < 200 then
      if posX + 64 < playerPosX then
        animDir = "_Lft"
      elseif playerPosX < posX - 64 then
        animDir = "_Rt"
      end
    end
  end
  return animDir
end

Monster.onKilled = function(l_19_0)
  l_19_0.hasShell = false
end

Monster.isHackable = function(l_20_0)
  return l_20_0.hasShell
end

return Monster

