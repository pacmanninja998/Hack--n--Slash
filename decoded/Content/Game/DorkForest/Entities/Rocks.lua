-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Rocks.lua 

local Entity = require("Entity")
local Rocks = require("Class").create(Entity, "Rocks")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local LogoComponent = require("Components.LogoComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local CommonLogoInstructions = require("CommonLogoInstructions")
local CommonActions = require("CommonActions")
Rocks.StandAction = require("Class").create(CommonActions.PlayAnimation, "Rocks.StandAction")
Rocks.StandAction.init = function(l_1_0)
  CommonActions.PlayAnimation.init(l_1_0, "Stand")
end

Rocks.StandAction.stop = function(l_2_0)
  CommonActions.PlayAnimation.stop(l_2_0)
  l_2_0.entity:get(LogoComponent):queueNextInstruction()
end

Rocks.SitAction = require("Class").create(CommonActions.PlayAnimation, "Rocks.SitAction")
Rocks.SitAction.init = function(l_3_0)
  CommonActions.PlayAnimation.init(l_3_0, "OpenEyes")
end

Rocks.SitAction.stop = function(l_4_0)
  CommonActions.PlayAnimation.stop(l_4_0)
  l_4_0.entity:get(LogoComponent):queueNextInstruction()
end

Rocks.MoveAction = require("Class").create(CommonLogoInstructions.Move, "Rocks.MoveAction")
Rocks.MoveAction.init = function(l_5_0, l_5_1)
  CommonLogoInstructions.Move.init(l_5_0, l_5_1)
end

Rocks.MoveAction.start = function(l_6_0, l_6_1)
  CommonLogoInstructions.Move.start(l_6_0, l_6_1)
end

Rocks.MoveAction.stop = function(l_7_0)
  CommonLogoInstructions.Move.stop(l_7_0)
end

Rocks.SCARE_DURATION = 3
Rocks.MOVE_SPEED = 64
Rocks.init = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  Entity.init(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4)
  SpriteComponent.new(l_8_0, "Characters/Animals/Rocks/Rocks")
  AnimatorComponent.new(l_8_0, AnimatorComponent.DIRECTION_MODE_SIDE, l_8_5)
  InteractionComponent.new(l_8_0)
  SoundComponent.new(l_8_0, {})
  LogoComponent.new(l_8_0, {STAND = Rocks.StandAction, SIT = Rocks.SitAction, MOVE = Rocks.MoveAction})
  PhysicsComponent.new(l_8_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, nil, MOAIBox2DBody.KINEMATIC)
  l_8_0:get(AnimatorComponent):play("OpenEyes")
  l_8_0:setAllowInteract(false)
end

Rocks.setAllowInteract = function(l_9_0, l_9_1)
  l_9_0.allowInteract = l_9_1
  if l_9_0.allowInteract then
    l_9_0:get(InteractionComponent):setEnabled(not l_9_0.remainingScaredSeconds)
  end
end

Rocks.onSwordHit = function(l_10_0, l_10_1)
  l_10_0:scare()
  l_10_1.action:interrupt()
end

Rocks.scare = function(l_11_0)
  l_11_0.remainingScaredSeconds = l_11_0.SCARE_DURATION
  l_11_0:get(AnimatorComponent):play("DefaultPose")
  l_11_0:get(InteractionComponent):setEnabled(false)
end

Rocks.tick = function(l_12_0)
  Entity.tick(l_12_0)
  if l_12_0.action then
    return 
  end
  if l_12_0.remainingScaredSeconds then
    l_12_0.remainingScaredSeconds = l_12_0.remainingScaredSeconds - MOAISim.getStep()
    if l_12_0.remainingScaredSeconds < 0 then
      l_12_0.remainingScaredSeconds = nil
      l_12_0:get(AnimatorComponent):play("OpenEyes")
      l_12_0:get(InteractionComponent):setEnabled(l_12_0.allowInteract)
    end
  end
end

return Rocks

