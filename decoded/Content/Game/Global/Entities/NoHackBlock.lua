-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\NoHackBlock.lua 

local Entity = require("Entity")
local PushableBlock = Entity.cache:load("Content/Game/Global/Entities/PushableBlock")
local NoHackBlock = require("Class").create(PushableBlock, "NoHackBlock")
local AnimatorComponent = require("Components.AnimatorComponent")
NoHackBlock.addIntegerField("REMAINING_PUSHES", 0)
NoHackBlock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PushableBlock.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, true)
  l_1_0:get(AnimatorComponent):play("Block_NoPort")
  l_1_0:setLabelText("")
end

NoHackBlock.canPush = function(l_2_0)
  return not PushableBlock.canPush(l_2_0) or l_2_0.REMAINING_PUSHES > 0
end

NoHackBlock.onPushed = function(l_3_0)
  l_3_0.REMAINING_PUSHES = l_3_0.REMAINING_PUSHES - 1
end

NoHackBlock.onRemainingPushesSet = function(l_4_0, l_4_1)
  if l_4_1 <= 0 then
    l_4_0:get(AnimatorComponent):play("Block_NoPort")
  else
    l_4_0:get(AnimatorComponent):play("Block_Hieros_NoPort")
  end
end

NoHackBlock.onFieldSet = function(l_5_0, l_5_1, l_5_2)
  if l_5_1 == "REMAINING_PUSHES" then
    l_5_0:onRemainingPushesSet(l_5_2)
  end
end

return NoHackBlock

