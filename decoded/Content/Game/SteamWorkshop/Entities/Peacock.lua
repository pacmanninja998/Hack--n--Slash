-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\SteamWorkshop\Entities\Peacock.lua 

local Entity = require("Entity")
local Peacock = require("Class").create(Entity, "Peacock")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
Peacock.FRAMES_PER_SECOND = 15
Peacock.ANIM_NAME = "Peacock"
Peacock.DEFAULT_SCALE = 0.8
Peacock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  SoundComponent.new(l_1_0, {})
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  local animator = l_1_0:get(AnimatorComponent)
  animator:play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  animator:randomize()
  l_1_0.prop:setScl(l_1_0.DEFAULT_SCALE)
end

return Peacock

