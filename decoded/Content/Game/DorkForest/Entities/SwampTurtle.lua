-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\SwampTurtle.lua 

local Class = require("Class")
local Entity = require("Entity")
local Action = require("Action")
local Delegate = require("DFMoai.Delegate")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
local SwimmingComponent = require("Components.SwimmingComponent")
local SoundComponent = require("Components.SoundComponent")
local LogoComponent = require("Components.LogoComponent")
local ShadowComponent = require("Components.ShadowComponent")
local FactionComponent = require("Components.FactionComponent")
local CommonActions = require("CommonActions")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local SwampTurtle = Class.create(Entity, "SwampTurtle")
local BurrowAction = Class.create(CommonActions.PlayAnimation, "BurrowAction")
BurrowAction.init = function(l_1_0)
  CommonActions.PlayAnimation.init(l_1_0, "Tuck")
end

BurrowAction.stop = function(l_2_0)
  l_2_0.entity:destroy()
end

local ScaredAction = Class.create(Action, "ScaredAction")
ScaredAction.SCARED_ANIMATION = "Tuck"
ScaredAction.SUBMERGED_DURATION = 2
ScaredAction.init = function(l_3_0)
  Action.init(l_3_0)
end

ScaredAction.start = function(l_4_0, l_4_1)
  Action.start(l_4_0, l_4_1)
  local animator = l_4_0.entity:get(AnimatorComponent)
  local scaredAnimation = l_4_0.SCARED_ANIMATION
  l_4_0.scaredSequence = animator:playOnce(scaredAnimation, l_4_0.SCARED_FRAMES_PER_SECOND)
  animator:registerEventCallback(l_4_0, "Sink", l_4_0.onTurtleSink)
  l_4_0.submergedElapsed = 0
  if l_4_0.entity:get(SwimmingComponent):inWater() then
    l_4_0.entity:get(PlatformComponent):setActive(false)
  end
end

ScaredAction.onTurtleSink = function(l_5_0)
  if l_5_0.entity:get(SwimmingComponent):inWater() and not l_5_0.submerged then
    l_5_0.entity:get(SpriteComponent).prop:setVisible(false)
    local posX, posY = l_5_0.entity:getPosition()
    local drownRipples = Entity.create("Content/Game/Global/Entities/DrownRipples", l_5_0.entity.layer, posX, posY, "DrownRipples")
    l_5_0.entity:get(SoundComponent):playCue("SFX/Characters/Turtle/Turtle_BackFlop", nil, 0.5)
    l_5_0.submerged = true
  end
  l_5_0.entity:get(AnimatorComponent):unregisterEventCallback(l_5_0, "Sink", l_5_0.onTurtleSink)
end

ScaredAction.tick = function(l_6_0)
  Action.tick(l_6_0)
  if l_6_0.submerged then
    l_6_0.submergedElapsed = l_6_0.submergedElapsed + MOAISim.getStep()
    return (l_6_0.submergedElapsed >= l_6_0.SUBMERGED_DURATION and l_6_0.entity:isScared())
  else
    return l_6_0.entity:get(AnimatorComponent):isPlaying(l_6_0.scaredSequence)
  end
end

ScaredAction.pause = function(l_7_0)
  l_7_0:helperPauseAnimation()
end

ScaredAction.resume = function(l_8_0)
  l_8_0:helperResumeAnimation()
end

ScaredAction.stop = function(l_9_0)
  l_9_0.entity:get(PlatformComponent):setActive(true)
  l_9_0.entity:get(SoundComponent):playCue("SFX/Characters/Turtle/Turtle_Surface", nil, 0.5)
  l_9_0.entity:get(SpriteComponent).prop:setVisible(true)
  Action.stop(l_9_0)
end

local UnflipAction = Class.create(Action, "UnflipAction")
UnflipAction.ANIM_NAME = "Startle"
UnflipAction.FRAMES_PER_SECOND = 15
UnflipAction.start = function(l_10_0, l_10_1)
  Action.start(l_10_0, l_10_1)
  l_10_0.sequence = l_10_0.entity:get(AnimatorComponent):playOnce(l_10_0.ANIM_NAME, l_10_0.FRAMES_PER_SECOND)
end

UnflipAction.tick = function(l_11_0)
  Action.tick(l_11_0)
  return l_11_0.entity:get(AnimatorComponent):isPlaying(l_11_0.sequence)
end

UnflipAction.pause = function(l_12_0)
  l_12_0:helperPauseAnimation()
end

UnflipAction.resume = function(l_13_0)
  l_13_0:helperResumeAnimation()
end

local FlippedAction = Class.create(Action, "FlippedAction")
FlippedAction.ANIM_NAME = "FlipOver"
FlippedAction.FRAMES_PER_SECOND = 15
FlippedAction.start = function(l_14_0, l_14_1)
  Action.start(l_14_0, l_14_1)
  l_14_0.elapsed = 0
  l_14_0.sequence = l_14_0.entity:get(AnimatorComponent):playOnce(l_14_0.ANIM_NAME, l_14_0.FRAMES_PER_SECOND)
  l_14_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
end

FlippedAction.tick = function(l_15_0)
  Action.tick(l_15_0)
  return l_15_0.entity:get(AnimatorComponent):isPlaying(l_15_0.sequence)
end

FlippedAction.stop = function(l_16_0)
  l_16_0.entity:queueAction(UnflipAction.new())
  Action.stop(l_16_0)
end

local DiveAction = Class.create(Action, "DiveAction")
DiveAction.JUMP_ANIM_NAME = "BackFlop"
DiveAction.FLIP_ANIM_NAME = "FlipBackOver"
DiveAction.FLIPPED_WAIT_TIME = 1.5
DiveAction.FRAMES_PER_SECOND = 15
DiveAction.JUMP_SPEED = 40
DiveAction.init = function(l_17_0, l_17_1)
  Action.init(l_17_0)
  if not l_17_1 then
    l_17_0.speed = l_17_0.JUMP_SPEED
  end
end

DiveAction.start = function(l_18_0, l_18_1)
  Action.start(l_18_0, l_18_1)
  l_18_0.entity:get(AnimatorComponent):registerEventCallback(l_18_0, "Hit", l_18_0.onHitBottom)
  l_18_0.entity:get(AnimatorComponent):setSuffix()
  l_18_0.entity:get(ShadowComponent):setEnabled(false)
  l_18_0.jumpSequence = l_18_0.entity:get(AnimatorComponent):playOnce(l_18_0.JUMP_ANIM_NAME, l_18_0.FRAMES_PER_SECOND)
  l_18_0.dirX, l_18_0.dirY = l_18_0.entity:get(AnimatorComponent):getDirVector(), l_18_0.entity:get(AnimatorComponent)
  l_18_0.entity:get(SoundComponent):playCue("SFX/Characters/Turtle/Turtle_BackFlop", false)
  l_18_0.hitBottom = false
  l_18_0.flipped = false
  l_18_0.landed = false
  l_18_0.flippedTimeElapsed = 0
end

DiveAction.onHitBottom = function(l_19_0)
  l_19_0.hitBottom = true
end

DiveAction.onFlipped = function(l_20_0)
  l_20_0.flipped = true
end

DiveAction.onLanded = function(l_21_0)
  l_21_0.landed = true
end

DiveAction.tick = function(l_22_0)
  Action.tick(l_22_0)
  if not l_22_0.hitBottom then
    l_22_0.entity:get(PhysicsComponent):setLinearVelocity(l_22_0.dirX * l_22_0.speed, l_22_0.dirY * l_22_0.speed)
    return true
  else
    l_22_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
    local animator = l_22_0.entity:get(AnimatorComponent)
    if animator:isPlaying(l_22_0.jumpSequence) then
      return true
    elseif not l_22_0.flipSequence then
      l_22_0.flippedTimeElapsed = l_22_0.flippedTimeElapsed + MOAISim.getStep()
      if l_22_0.FLIPPED_WAIT_TIME <= l_22_0.flippedTimeElapsed then
        l_22_0.entity:get(AnimatorComponent):unregisterEventCallback(l_22_0, "Hit", l_22_0.onHitBottom)
        l_22_0.entity:get(AnimatorComponent):registerEventCallback(l_22_0, "Flipped", l_22_0.onFlipped)
        l_22_0.entity:get(AnimatorComponent):registerEventCallback(l_22_0, "Landed", l_22_0.onLanded)
        local flipAnimName = l_22_0.FLIP_ANIM_NAME
        l_22_0.flipSequence = animator:playOnce(flipAnimName, l_22_0.FRAMES_PER_SECOND)
      end
      return true
    else
      if animator:isPlaying(l_22_0.flipSequence) then
        return not l_22_0.landed
      end
    end
  end
end

DiveAction.pause = function(l_23_0)
  l_23_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_23_0:helperPauseAnimation()
end

DiveAction.resume = function(l_24_0)
  l_24_0:helperResumeAnimation()
end

DiveAction.stop = function(l_25_0)
  local animator = l_25_0.entity:get(AnimatorComponent)
  animator:unregisterEventCallback(l_25_0, "Flipped", l_25_0.onFlipped)
  animator:unregisterEventCallback(l_25_0, "Flipped", l_25_0.onLanded)
  l_25_0.entity:resetSuffix()
  Action.stop(l_25_0)
end

local ExitWaterAction = Class.create(Action, "ExitWaterAction")
ExitWaterAction.ANIM_NAME = "MoveGround"
ExitWaterAction.FRAMES_PER_SECOND = 15
ExitWaterAction.EXIT_TIME = 2
ExitWaterAction.EXIT_SPEED = 40
ExitWaterAction.start = function(l_26_0, l_26_1)
  Action.start(l_26_0, l_26_1)
  l_26_0.elapsed = 0
  l_26_0.entity:get(AnimatorComponent):setSuffix()
  l_26_0.entity:get(ShadowComponent):setEnabled(false)
  l_26_0.sequence = l_26_0.entity:get(AnimatorComponent):play(l_26_0.ANIM_NAME, l_26_0.FRAMES_PER_SECOND)
  l_26_0.dirX, l_26_0.dirY = l_26_0.entity:get(AnimatorComponent):getDirVector(), l_26_0.entity:get(AnimatorComponent)
end

ExitWaterAction.tick = function(l_27_0)
  Action.tick(l_27_0)
  l_27_0.elapsed = l_27_0.elapsed + MOAISim.getStep()
  if l_27_0.elapsed < l_27_0.EXIT_TIME then
    l_27_0.entity:get(PhysicsComponent):setLinearVelocity(l_27_0.dirX * l_27_0.EXIT_SPEED, l_27_0.dirY * l_27_0.EXIT_SPEED)
    return true
  end
end

ExitWaterAction.pause = function(l_28_0)
  l_28_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_28_0:helperPauseAnimation()
end

ExitWaterAction.resume = function(l_29_0)
  l_29_0:helperResumeAnimation()
end

ExitWaterAction.stop = function(l_30_0)
  l_30_0.entity:get(SpriteComponent).prop:setPriority(0)
  local physics = l_30_0.entity:get(PhysicsComponent)
  physics:destroy()
  physics:init(l_30_0.entity, {category = l_30_0.entity.GROUND_CATEGORY, collidesWithCategories = l_30_0.entity.GROUND_COLLIDES_WITH})
  l_30_0.entity:get(PlatformComponent):setActive(false)
  l_30_0.entity:get(ShadowComponent).prop:setVisible(true)
  l_30_0.entity:resetSuffix()
  Action.stop(l_30_0)
end

local SleepAction = Class.create(Action, "SleepAction")
SleepAction.FRAMES_PER_SECOND = 15
SleepAction.ACTION_NAME_SLEEP = "sleep"
SleepAction.init = function(l_31_0, l_31_1)
  Action.init(l_31_0)
  l_31_0.data = l_31_1
end

SleepAction.start = function(l_32_0, l_32_1)
  Action.start(l_32_0, l_32_1)
  l_32_0.elapsed = 0
  l_32_0.entity:get(AnimatorComponent):play("Sleep", l_32_0.FRAMES_PER_SECOND)
  if math.random() > 0.9 then
    l_32_0.effect = Entity.create("Content/Game/Global/Entities/Effects/Sleep_VFX", l_32_0.entity.layer, l_32_0.entity:getPosition())
  end
end

SleepAction.tick = function(l_33_0)
  Action.tick(l_33_0)
  l_33_0.elapsed = l_33_0.elapsed + MOAISim.getStep()
  return l_33_0.elapsed < l_33_0.data.SECONDS
end

SleepAction.stop = function(l_34_0)
  Action.stop(l_34_0)
  l_34_0.entity:get(LogoComponent):queueNextInstruction()
end

local GrabGrassAction = Class.create(CommonActions.PlayAnimation, "GrabGrassAction")
GrabGrassAction.init = function(l_35_0)
  CommonActions.PlayAnimation.init(l_35_0, "GrabGrass")
end

GrabGrassAction.stop = function(l_36_0)
  CommonActions.PlayAnimation.stop(l_36_0)
  l_36_0.entity:get(LogoComponent):queueNextInstruction()
end

local ChewGrassAction = Class.create(CommonActions.PlayAnimation, "ChewGrassAction")
ChewGrassAction.init = function(l_37_0)
  CommonActions.PlayAnimation.init(l_37_0, "ChewGrass")
end

ChewGrassAction.stop = function(l_38_0)
  CommonActions.PlayAnimation.stop(l_38_0)
  l_38_0.entity:get(LogoComponent):queueNextInstruction()
end

SwampTurtle.CorruptAction = Class.create(Action, "CorruptAction")
SwampTurtle.CorruptAction.stop = function(l_39_0)
  Action.stop(l_39_0)
  local entityPosX, entityPosY = l_39_0.entity:getPosition()
  local entityDir = l_39_0.entity:get(AnimatorComponent):getDirection()
  local corruptedVersion = Entity.create("Content/Game/DorkForest/Entities/SpikeyTurtle", l_39_0.entity.layer, entityPosX, entityPosY, l_39_0.entity.name .. " (corrupted)", entityDir)
  l_39_0.entity.corruptedEvent:dispatch(corruptedVersion)
  l_39_0.entity:destroy()
end

SwampTurtle.IDLE_ANIMATION = "Breathe"
SwampTurtle.GROUND_CATEGORY = PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY
SwampTurtle.SWIM_CATEGORY = PhysicsComponent.WATER_CATEGORY
SwampTurtle.GROUND_COLLIDES_WITH = PhysicsComponent.ALL_CATEGORY
SwampTurtle.SWIM_COLLIDES_WITH = PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.LOW_CATEGORY + PhysicsComponent.SENSOR_CATEGORY + PhysicsComponent.WATER_CATEGORY
SwampTurtle.addIntegerField("MOVE_SPEED", 64)
SwampTurtle.addEditableField("IDLE_BEHAVIOR", LogoComponent.createBehaviorSchema({SLEEP = {SECONDS = Class.IntegerSchema.new(1, 0)}, GRABGRASS = {}, CHEWGRASS = {}, BURROW = {}}))
SwampTurtle.init = function(l_40_0, l_40_1, l_40_2, l_40_3, l_40_4, l_40_5)
  Entity.init(l_40_0, l_40_1, l_40_2, l_40_3, l_40_4)
  SpriteComponent.new(l_40_0, "Characters/Turtle/Turtle")
  AnimatorComponent.new(l_40_0, false, l_40_5)
  PhysicsComponent.new(l_40_0, 62, 62, l_40_0.GROUND_CATEGORY, l_40_0.GROUND_COLLIDES_WITH, MOAIBox2DBody.DYNAMIC, false)
  SoundComponent.new(l_40_0, {SFX/Characters/Alice/Alice_SwordAttack = true, SFX/Characters/Bob/Bob_Song = true}, SoundComponent.MIN_AUDIBLE_VOLUME * 2)
  LogoComponent.new(l_40_0, {SLEEP = SleepAction, GRABGRASS = GrabGrassAction, CHEWGRASS = ChewGrassAction, BURROW = BurrowAction})
  SwimmingComponent.new(l_40_0, false)
  PlatformComponent.new(l_40_0, l_40_0:get(PhysicsComponent), false, true, nil, nil, nil, PlatformComponent.SOUND_MAT_WET)
  ShadowComponent.new(l_40_0, 0, -32)
  FactionComponent.new(l_40_0, "GOOD")
  l_40_0.IDLE_BEHAVIOR = {{TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "random"}, {TYPE = "MOVE", TILES = 1}}
  local animator = l_40_0:get(AnimatorComponent)
  animator:setSuffix("Ground")
  animator:enableRootMotion()
  animator:play("Breathe")
  animator:registerEventCallback(l_40_0, "footstep", l_40_0.onFootstep)
  local physics = l_40_0:get(PhysicsComponent)
  physics:setReceivesPlatformVel(false)
  physics:setCollisionHandler(PhysicsComponent.LOW_CATEGORY, l_40_0.onHitLow, l_40_0, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  physics.outlineVelFactor = 0
  l_40_0.waterEdgeSet = {}
  l_40_0:get(SwimmingComponent).enterWaterEvent:register(l_40_0.onEnterWater, l_40_0)
  l_40_0:get(SwimmingComponent).leaveWaterEvent:register(l_40_0.onLeaveWater, l_40_0)
  l_40_0:get(SoundComponent).startHearSoundEvent:register(l_40_0.onStartHearSound, l_40_0)
  l_40_0:get(SoundComponent).stopHearSoundEvent:register(l_40_0.onStopHearSound, l_40_0)
  l_40_0.scaredSoundCount = 0
  l_40_0.wasScared = false
  l_40_0.corruptedEvent = Delegate.new()
  l_40_0.totalTicks = 0
  l_40_0.prop:setScl(0.65)
end

SwampTurtle.resetSuffix = function(l_41_0)
  local animator = l_41_0:get(AnimatorComponent)
  local shadow = l_41_0:get(ShadowComponent)
  if l_41_0:get(SwimmingComponent):inWater() then
    animator:setSuffix("Swim")
    shadow:setEnabled(false)
  else
    animator:setSuffix("Ground")
    shadow:setEnabled(true)
  end
end

SwampTurtle.onFootstep = function(l_42_0)
  local sound = l_42_0:get(SoundComponent)
  if l_42_0:get(SwimmingComponent):inWater() then
    sound:playCue("SFX/Characters/Turtle/Turtle_Swim", false)
  else
    sound:playCue("SFX/Characters/Turtle/Turtle_Walk", false)
  end
end

SwampTurtle.onHitLow = function(l_43_0, l_43_1, l_43_2, l_43_3, l_43_4, l_43_5)
  if l_43_4.outlineNorm then
    if l_43_2 == MOAIBox2DArbiter.BEGIN then
      l_43_0.waterEdgeSet[l_43_4] = l_43_4
    else
      if l_43_2 == MOAIBox2DArbiter.END then
        l_43_0.waterEdgeSet[l_43_4] = nil
      end
    end
  end
end

SwampTurtle.onEnterWater = function(l_44_0)
  l_44_0:get(SpriteComponent).prop:setPriority(-16)
  local physics = l_44_0:get(PhysicsComponent)
  physics:destroy()
  physics:init(l_44_0, {category = l_44_0.SWIM_CATEGORY, collidesWithCategories = l_44_0.SWIM_COLLIDES_WITH})
  l_44_0:get(PlatformComponent):setActive(true)
  l_44_0:get(ShadowComponent):setEnabled(false)
  local animator = l_44_0:get(AnimatorComponent)
  if animator.suffix then
    animator:setSuffix("Swim")
  end
end

SwampTurtle.onLeaveWater = function(l_45_0)
  l_45_0:insertAction(ExitWaterAction.new())
  local animator = l_45_0:get(AnimatorComponent)
  if animator.suffix then
    animator:setSuffix("Ground")
  end
end

SwampTurtle.isScared = function(l_46_0)
  return l_46_0.scaredSoundCount > 0
end

SwampTurtle.onStartHearSound = function(l_47_0, l_47_1)
  l_47_0.scaredSoundCount = l_47_0.scaredSoundCount + 1
end

SwampTurtle.onStopHearSound = function(l_48_0, l_48_1)
  l_48_0.scaredSoundCount = l_48_0.scaredSoundCount - 1
end

SwampTurtle.tick = function(l_49_0)
  Entity.tick(l_49_0)
  l_49_0.totalTicks = l_49_0.totalTicks + 1
  if l_49_0:isScared() ~= l_49_0.wasScared and (not l_49_0.action or l_49_0.action:is(DiveAction) or l_49_0.action:is(FlippedAction) or not l_49_0.action:is(UnflipAction)) then
    if l_49_0:isScared() then
      l_49_0:insertAction(ScaredAction.new())
    end
    l_49_0.wasScared = l_49_0:isScared()
  end
  if next(l_49_0.waterEdgeSet) and not l_49_0:get(SwimmingComponent):inWater() and not l_49_0:isDoing(DiveAction) then
    local curFacingDir = l_49_0:get(AnimatorComponent):getDirection()
    local normSumX, normSumY = 0, 0
    for _,waterEdgeFixture in pairs(l_49_0.waterEdgeSet) do
      normSumX, normSumY = normSumX + waterEdgeFixture.outlineNorm[1], normSumY + waterEdgeFixture.outlineNorm[2]
    end
    if normSumX ~= 0 or normSumY ~= 0 then
      local normDir = Direction.vectorToDir(normSumX, normSumY, false)
      if normDir == curFacingDir then
        l_49_0:insertAction(DiveAction.new())
      end
    end
  end
  if not l_49_0.action then
    l_49_0:get(LogoComponent):setBehavior(l_49_0.IDLE_BEHAVIOR)
  end
end

SwampTurtle.isHackable = function(l_50_0)
  local diveAction = l_50_0:isDoing(DiveAction)
  if diveAction and diveAction.hitBottom then
    return not diveAction.flipped
  end
end

SwampTurtle.getTurnAnim = function(l_51_0, l_51_1)
  if not l_51_0:get(SwimmingComponent):inWater() then
    local animator = l_51_0:get(AnimatorComponent)
    local curDir = animator:getDirection()
    local deltaToAnim = {-2 = "Lft", 2 = "Rt"}
    if math.abs(l_51_1) == 2 then
      if animator.directionMode ~= AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS and (curDir == Direction.DIR_W or curDir == Direction.DIR_E) and curDir ~= animator.nativeSide then
        l_51_1 = -l_51_1
      end
      return "Turn_" .. deltaToAnim[l_51_1]
    end
  end
end

return SwampTurtle

