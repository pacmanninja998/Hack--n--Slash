-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Prisoner.lua 

local Entity = require("Entity")
local Prisoner = require("Class").create(Entity, "Prisoner")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
Prisoner.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/Prisoners/Prisoners")
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  local variant = "PrisonerA_Breathe_Blink"
  if l_1_5 == Direction.DIR_N then
    variant = "PrisonerB_Breathe_Blink"
  else
    if l_1_5 == Direction.DIR_E then
      variant = "PrisonerC"
    else
      if l_1_5 == Direction.DIR_W then
        variant = "PrisonerD"
      end
    end
  end
  l_1_0:get(AnimatorComponent):play(variant)
  l_1_0.prop:setScl(0.5)
end

return Prisoner

