-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\HackBlock.lua 

local Delegate = require("DFMoai.Delegate")
local Entity = require("Entity")
local PushableBlock = Entity.cache:load("Content/Game/Global/Entities/PushableBlock")
local HackBlock = require("Class").create(PushableBlock, "HackBlock")
local SpriteSheet = require("SpriteSheet")
local AnimatorComponent = require("Components.AnimatorComponent")
HackBlock.addIntegerField("REMAINING_PUSHES", 0)
HackBlock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PushableBlock.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, true)
  l_1_0:get(AnimatorComponent):play("Block_Port")
  l_1_0:setLabelText("")
  l_1_0.pushEvent = Delegate.new()
  l_1_0.pushableAnim = "Block_Hieros"
  l_1_0.staticAnim = "Block_Port"
end

HackBlock.canPush = function(l_2_0)
  return not PushableBlock.canPush(l_2_0) or l_2_0.REMAINING_PUSHES > 0
end

HackBlock.isHackable = function(l_3_0)
  return not l_3_0.action
end

HackBlock.onPushed = function(l_4_0)
  l_4_0.REMAINING_PUSHES = l_4_0.REMAINING_PUSHES - 1
  l_4_0.pushEvent:dispatch()
end

HackBlock.onRemainingPushesSet = function(l_5_0, l_5_1)
  if l_5_1 <= 0 then
    l_5_0:get(AnimatorComponent):play(l_5_0.staticAnim)
  else
    l_5_0:get(AnimatorComponent):play(l_5_0.pushableAnim)
  end
end

HackBlock.onFieldSet = function(l_6_0, l_6_1, l_6_2)
  if l_6_1 == "REMAINING_PUSHES" then
    l_6_0:onRemainingPushesSet(l_6_2)
  end
end

return HackBlock

