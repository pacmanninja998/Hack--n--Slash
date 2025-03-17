-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\ThirdEyeHat.lua 

local Item = require("Item")
local Action = require("Action")
local Music = require("Music")
local Direction = require("Direction")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local CommonActions = require("CommonActions")
local ThirdEyeHat = require("Class").create(Item, "ThirdEyeHat")
ThirdEyeHat.PutOnHatAction = require("Class").create(CommonActions.PlayAnimation, "ThirdEyeHat.PutOnHatAction")
ThirdEyeHat.TakeOffHatAction = require("Class").create(CommonActions.PlayAnimation, "ThirdEyeHat.TakeOffHatAction")
ThirdEyeHat.WearHatAction = require("Class").create(Action, "ThirdEyeHat.WearHatAction")
ThirdEyeHat.PutOnHatAction.init = function(l_1_0, l_1_1)
  CommonActions.PlayAnimation.init(l_1_0, "Hat_PutOn_Frnt")
  l_1_0.motive = l_1_1
end

ThirdEyeHat.PutOnHatAction.start = function(l_2_0, l_2_1)
  CommonActions.PlayAnimation.start(l_2_0, l_2_1)
  l_2_0.queuedTakeOff = false
end

ThirdEyeHat.PutOnHatAction.stop = function(l_3_0)
  CommonActions.PlayAnimation.stop(l_3_0)
  l_3_0.entity.host.INFO_OPACITY = 0
end

ThirdEyeHat.PutOnHatAction.tick = function(l_4_0)
  local running = CommonActions.PlayAnimation.tick(l_4_0)
  local opacity = 1 - l_4_0.remaining / l_4_0.totalTime
  l_4_0.entity.host.INFO_OPACITY = opacity
  local controller = l_4_0.entity:get(ControllerComponent)
  if controller:hasNewMotive(l_4_0.motive) then
    controller:consumeNewMotive(l_4_0.motive)
    l_4_0.queuedTakeOff = true
  end
  if not running then
    if l_4_0.queuedTakeOff then
      l_4_0.entity:queueAction(ThirdEyeHat.TakeOffHatAction.new(l_4_0.motive))
    else
      l_4_0.entity:queueAction(ThirdEyeHat.WearHatAction.new(l_4_0.motive))
    end
  end
  return running
end

ThirdEyeHat.TakeOffHatAction.init = function(l_5_0, l_5_1)
  CommonActions.PlayAnimation.init(l_5_0, "Hat_TakeOff_Frnt")
  l_5_0.motive = l_5_1
end

ThirdEyeHat.TakeOffHatAction.start = function(l_6_0, l_6_1)
  CommonActions.PlayAnimation.start(l_6_0, l_6_1)
  l_6_0.queuedPutOn = false
end

ThirdEyeHat.TakeOffHatAction.stop = function(l_7_0)
  CommonActions.PlayAnimation.stop(l_7_0)
  l_7_0.entity.host.INFO_OPACITY = 0
end

ThirdEyeHat.TakeOffHatAction.tick = function(l_8_0)
  local running = CommonActions.PlayAnimation.tick(l_8_0)
  local opacity = l_8_0.remaining / l_8_0.totalTime
  l_8_0.entity.host.INFO_OPACITY = opacity
  local controller = l_8_0.entity:get(ControllerComponent)
  if controller:hasNewMotive(l_8_0.motive) then
    controller:consumeNewMotive(l_8_0.motive)
    l_8_0.queuedPutOn = true
  end
  if not running and l_8_0.queuedPutOn then
    l_8_0.entity:queueAction(ThirdEyeHat.PutOnHatAction.new(l_8_0.motive))
  end
  return running
end

ThirdEyeHat.WearHatAction.MOVE_FACTOR = 0.66666666666667
ThirdEyeHat.WearHatAction.init = function(l_9_0, l_9_1)
  Action.init(l_9_0)
  l_9_0.motive = l_9_1
end

ThirdEyeHat.WearHatAction.start = function(l_10_0, l_10_1)
  Action.start(l_10_0, l_10_1)
  if l_10_0.entity.host then
    l_10_0.entity.host.INFO_OPACITY = 1
  end
  l_10_0.previousAmbientCue = Music:getAmbientCue()
  Music:playAmbient("Ambience/Ambience/3rdEyeHat_Drone")
end

ThirdEyeHat.WearHatAction.stop = function(l_11_0)
  Action.stop(l_11_0)
  if l_11_0.entity.host then
    l_11_0.entity.host.INFO_OPACITY = 0
  end
  Music:playAmbient(l_11_0.previousAmbientCue)
end

ThirdEyeHat.WearHatAction.tick = function(l_12_0)
  local controller = l_12_0.entity:get(ControllerComponent)
  local animator = l_12_0.entity:get(AnimatorComponent)
  if l_12_0.entity:move(l_12_0.MOVE_FACTOR * l_12_0.entity.MOVE_SPEED * l_12_0.entity.scaleFactor, true) then
    animator:play("Hat_Walk")
  else
    animator:play("Hat_Breathe")
  end
  if controller:hasNewMotive(l_12_0.motive) or l_12_0.forceTakeOff then
    controller:consumeNewMotive(l_12_0.motive)
    l_12_0.entity:queueAction(ThirdEyeHat.TakeOffHatAction.new(l_12_0.motive))
    return false
  end
  return true
end

ThirdEyeHat.init = function(l_13_0)
  Item.init(l_13_0)
  l_13_0.playUseSound = false
end

ThirdEyeHat.getAction = function(l_14_0, l_14_1)
  return ThirdEyeHat.PutOnHatAction.new(l_14_1)
end

ThirdEyeHat.getDescription = function(l_15_0)
  return "Third eye hat"
end

ThirdEyeHat.getSprite = function(l_16_0)
  return "UI/Placeholder/ItemIcons/DebugHat/DebugHat", "DebugHat"
end

return ThirdEyeHat

