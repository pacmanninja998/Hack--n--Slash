-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\Effects\PrincessChamber_Waterfall_Lft.lua 

local Entity = require("Entity")
local PrincessChamber_Waterfall_Lft = require("Class").create(Entity, "PrincessChamber_Waterfall_Lft")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
PrincessChamber_Waterfall_Lft.FRAMES_PER_SECOND = 15
PrincessChamber_Waterfall_Lft.ANIM_NAME = "PrincessChamber_Waterfall_Lft"
PrincessChamber_Waterfall_Lft.DEFAULT_SCALE = 0.8
PrincessChamber_Waterfall_Lft.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  SoundComponent.new(l_1_0, {})
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  local animator = l_1_0:get(AnimatorComponent)
  animator:play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  animator:randomize()
end

return PrincessChamber_Waterfall_Lft

