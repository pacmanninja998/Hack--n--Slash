-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\HackItem.lua 

local Delegate = require("DFMoai.Delegate")
local Direction = require("Direction")
local CommonActions = require("CommonActions")
local EntityRef = require("EntityRef")
local EntitySet = require("EntitySet")
local Math = require("DFCommon.Math")
local Item = require("Item")
local BeHackedAction = require("Action").load("Content/Game/Global/Actions/BeHackedAction")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local HackGui = require("Gui").load("Content/Game/Global/Gui/HackGui")
local HackItem = require("Class").create(Item, "HackItem")
HackItem.HackAction = require("Class").create(CommonActions.LoopAnimation, "HackItem.HackAction")
HackItem.HackAction.init = function(l_1_0, l_1_1, l_1_2)
  CommonActions.LoopAnimation.init(l_1_0, "Connected")
  l_1_0.item = l_1_1
  l_1_0.targetEntity = EntityRef.new(l_1_2)
end

HackItem.HackAction.start = function(l_2_0, l_2_1)
  CommonActions.LoopAnimation.start(l_2_0, l_2_1)
  l_2_0.gui = HackGui.new(nil, l_2_0.targetEntity.entity, l_2_1)
  l_2_0.entity:get(InterfaceComponent):pushInterface(l_2_0.gui)
  l_2_0.item.hackBeginEvent:dispatch(l_2_0.targetEntity.entity)
end

HackItem.HackAction.tick = function(l_3_0)
  CommonActions.LoopAnimation.tick(l_3_0)
  if not l_3_0.targetEntity:isValid() then
    return false
  end
  return not l_3_0.gui.dismissed
end

HackItem.HackAction.stop = function(l_4_0)
  l_4_0.entity:get(InterfaceComponent):removeInterface(l_4_0.gui)
  l_4_0.gui = nil
  l_4_0.item.hackEndEvent:dispatch()
end

HackItem.ExposePlugAction = require("Class").create(CommonActions.PlayAnimation, "HackItem.ExposePlugAction")
HackItem.ExposePlugAction.init = function(l_5_0, l_5_1)
  CommonActions.PlayAnimation.init(l_5_0, "SwordBreak_CaveTrap")
  l_5_0.item = l_5_1
end

HackItem.ExposePlugAction.start = function(l_6_0, l_6_1)
  l_6_1:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_BreakSword", nil, 0.5)
  l_6_1:get(AnimatorComponent):setFacing(Direction.DIR_S)
  CommonActions.PlayAnimation.start(l_6_0, l_6_1)
end

HackItem.ExposePlugAction.stop = function(l_7_0)
  CommonActions.PlayAnimation.stop(l_7_0)
  l_7_0.item:expose()
end

HackItem.SwingAction = require("Class").create(CommonActions.Attack, "HackItem.SwingAction")
HackItem.SwingAction.FRAMES_PER_SECOND = 25
HackItem.SwingAction.SWING_AGAIN_FRAME = 3
HackItem.SwingAction.init = function(l_8_0, l_8_1, l_8_2)
  CommonActions.Attack.init(l_8_0, "AttackSword", l_8_0.onHit, l_8_0, {hitboxName = "sword", frameRate = l_8_0.FRAMES_PER_SECOND, hitMask = PhysicsComponent.HIGH_CATEGORY + PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, allowNonEntities = true})
  l_8_0.item = l_8_1
  l_8_0.motive = l_8_2
end

HackItem.SwingAction.start = function(l_9_0, l_9_1)
  l_9_1:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_SwordAttack", nil, 0.5)
  CommonActions.Attack.start(l_9_0, l_9_1)
  l_9_0.hitSomething = false
  l_9_0.swingAgain = false
end

HackItem.SwingAction.tick = function(l_10_0)
  local running = CommonActions.Attack.tick(l_10_0)
  local animator = l_10_0.entity:get(AnimatorComponent)
  local controller = l_10_0.entity:get(ControllerComponent)
  if l_10_0.hitSomething then
    l_10_0.entity:queueAction(HackItem.ExposePlugAction.new(l_10_0.item))
    return false
  end
  if controller:consumeNewMotive(l_10_0.motive) then
    l_10_0.swingAgain = true
  end
  if l_10_0.SWING_AGAIN_FRAME < animator.frame then
    if l_10_0.swingAgain then
      l_10_0.entity:queueAction(l_10_0)
      return false
    end
    if controller:hasMoveMotive() then
      return false
    end
  end
  return running
end

HackItem.SwingAction.onHit = function(l_11_0, l_11_1)
  l_11_0.hitSomething = true
end

HackItem.ThrustAction = require("Class").create(CommonActions.Attack, "HackItem.ThrustAction")
HackItem.ThrustAction.THRUST_AGAIN_FRAME = 3
HackItem.ThrustAction.init = function(l_12_0, l_12_1, l_12_2)
  CommonActions.Attack.init(l_12_0, "AttackHack", l_12_0.onHit, l_12_0)
  l_12_0.item = l_12_1
  l_12_0.motive = l_12_2
end

HackItem.ThrustAction.start = function(l_13_0, l_13_1)
  l_13_1:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_HackAction", nil, 0.5)
  CommonActions.Attack.start(l_13_0, l_13_1)
  l_13_0.thrustAgain = false
  l_13_0.hitEntities = EntitySet.new()
end

HackItem.ThrustAction.tick = function(l_14_0)
  local running = CommonActions.Attack.tick(l_14_0)
  local animator = l_14_0.entity:get(AnimatorComponent)
  local controller = l_14_0.entity:get(ControllerComponent)
  local direction = animator:getDirection()
  local dirX, dirY = Direction.dirToVector(direction)
  local closestEntity, closestDistSq, closestInFront = nil, nil, nil
  for entity in pairs(l_14_0.hitEntities.entities) do
    local x, y = l_14_0.entity:getPosition()
    local ex, ey = entity:getPosition()
    local dx, dy = ex - x, ey - y
    local distSq = dx * dx + dy * dy
    local nx, ny = Math.normalize(dx, dy)
    local inFront = math.acos(nx * dirX + ny * dirY) < math.pi * 0.5
    if closestEntity and ((inFront and not closestInFront) or inFront == closestInFront and distSq < closestDistSq) then
      closestEntity, closestDistSq, closestInFront = entity, distSq, inFront
    end
  end
  if closestEntity then
    l_14_0.item:plugUsed()
    local hackAction = HackItem.HackAction.new(l_14_0.item, closestEntity)
    l_14_0.entity:forceAction(hackAction)
    closestEntity:insertAction(BeHackedAction.new(l_14_0.entity, hackAction))
  end
  if controller:consumeNewMotive(l_14_0.motive) then
    l_14_0.thrustAgain = true
  end
  if l_14_0.THRUST_AGAIN_FRAME < animator.frame then
    if l_14_0.thrustAgain then
      l_14_0.entity:queueAction(l_14_0)
      return false
    end
    if controller:hasMoveMotive() then
      return false
    end
  end
  return running
end

HackItem.ThrustAction.onHit = function(l_15_0, l_15_1)
  local direction = l_15_0.entity:get(AnimatorComponent):getDirection()
  if l_15_1:isHackable(direction) then
    l_15_0.hitEntities:addEntity(l_15_1)
  end
end

HackItem.init = function(l_16_0, l_16_1)
  Item.init(l_16_0, l_16_1)
  l_16_0.exposedEvent = Delegate.new()
  l_16_0.hackBeginEvent = Delegate.new()
  l_16_0.hackEndEvent = Delegate.new()
  l_16_0.playUseSound = false
end

HackItem.expose = function(l_17_0)
  if not l_17_0.state.exposed then
    l_17_0.state.exposed = true
    l_17_0.exposedEvent:dispatch()
    l_17_0:stateUpdated()
  end
end

HackItem.plugUsed = function(l_18_0)
  if not l_18_0.state.plugUsed then
    l_18_0.state.plugUsed = true
    l_18_0:stateUpdated()
  end
end

HackItem.getAction = function(l_19_0, l_19_1)
  if not l_19_0.state.exposed then
    return HackItem.SwingAction.new(l_19_0, l_19_1)
  else
    return HackItem.ThrustAction.new(l_19_0, l_19_1)
  end
end

HackItem.getDescription = function(l_20_0)
  if not l_20_0.state.exposed then
    return "That sword I stole"
  else
    if not l_20_0.state.plugUsed then
      return "Did I break this thing?"
    else
      return "My magic sword"
    end
  end
end

HackItem.getSprite = function(l_21_0)
  if not l_21_0.state.exposed then
    return "UI/ItemIcons/Sword/Sword", "Dull"
  else
    return "UI/ItemIcons/Sword/Sword", "Sharp"
  end
end

return HackItem

