-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\WizardBat_Roof_Back.lua 

local Class = require("Class")
local Entity = require("Entity")
local WizardBat_Roof_Back = Class.create(Entity, "WizardBat_Roof_Back")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
WizardBat_Roof_Back.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(WizardBat_Roof_Back).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Characters/WizardBat_Roof/WizardBat_Roof", "BreatheRoof_Back")
  sprite.prop:setPriority(-2000)
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_SIDE)
end

return WizardBat_Roof_Back

