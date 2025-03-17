-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveStash\Text.lua 

local Entity = require("Entity")
local Action = require("Action")
local Text = require("Class").create(Entity, "Text")
local SpriteComponent = require("Components.SpriteComponent")
local Math = require("DFCommon.Math")
local Shader = require("Shader")
FadeAction = require("Class").create(Action, "FadeAction")
FadeAction.TRANSITION_TIME = 0.5
FadeAction.init = function(l_1_0, l_1_1, l_1_2)
  Action.init(l_1_0)
  l_1_0.fadeIn = l_1_1
  if not l_1_2 then
    l_1_0.duration = l_1_0.TRANSITION_TIME
  end
  l_1_0.endOpacity = l_1_0.fadeIn and 1 or 0
  l_1_0.startOpacity = 1 - l_1_0.endOpacity
  l_1_0.elapsed = 0
end

FadeAction.tick = function(l_2_0)
  l_2_0.elapsed = l_2_0.elapsed + MOAISim.getStep()
  if l_2_0.elapsed < l_2_0.duration then
    local progress = Math.pinPct(l_2_0.elapsed / l_2_0.duration)
    l_2_0.entity:setAlpha(Math.lerp(l_2_0.startOpacity, l_2_0.endOpacity, progress))
    return true
  else
    l_2_0.entity:setAlpha(l_2_0.endOpacity)
  end
end

Text.init = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  Entity.init(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  SpriteComponent.new(l_3_0, "Layouts/Game/CrackerCavern/CaveStash/CaveStash", l_3_4)
  l_3_0:setLabelText("")
end

Text.fade = function(l_4_0, l_4_1, l_4_2)
  l_4_0:forceAction(FadeAction.new(l_4_1, l_4_2))
end

return Text

