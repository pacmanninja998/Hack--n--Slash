-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\WizardBat.lua 

local Class = require("Class")
local Entity = require("Entity")
local WizardBat = Class.create(Entity, "WizardBat")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
WizardBat.TEXT_COLOR = {0.96862745098039, 0.31372549019608, 0.3843137254902}
WizardBat.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(WizardBat).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Characters/WizardBat/WizardBat")
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_SIDE)
  SoundComponent.new(l_1_0)
end

WizardBat.tick = function(l_2_0)
  Class.super(WizardBat).tick(l_2_0)
  if not l_2_0.action then
    l_2_0:get(AnimatorComponent):play("Breathe")
  end
end

return WizardBat

