-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\Effects\TowerLevel4_RipplesR2.lua 

local Entity = require("Entity")
local TowerLevel4_RipplesR2 = require("Class").create(Entity, "TowerLevel4_RipplesR2")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
TowerLevel4_RipplesR2.FRAMES_PER_SECOND = 15
TowerLevel4_RipplesR2.ANIM_NAME = "TowerLevel4_RipplesR2"
TowerLevel4_RipplesR2.DEFAULT_SCALE = 0.8
TowerLevel4_RipplesR2.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX", l_1_0.ANIM_NAME)
  SoundComponent.new(l_1_0, {})
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  local animator = l_1_0:get(AnimatorComponent)
  animator:play(l_1_0.ANIM_NAME, l_1_0.FRAMES_PER_SECOND)
  animator:randomize()
  l_1_0.prop:setScl(l_1_0.DEFAULT_SCALE)
  l_1_0:get(SoundComponent):playCue("SFX/Objects/TowerLevel4_RipplesR2", nil, 0.5)
end

return TowerLevel4_RipplesR2

