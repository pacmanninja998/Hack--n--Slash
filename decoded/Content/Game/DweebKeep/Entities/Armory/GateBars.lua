-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\Armory\GateBars.lua 

local Entity = require("Entity")
local UnhackableGate = Entity.cache:load("Content/Game/CrackerCavern/Entities/UnhackableGate")
local LayoutEntity = require("Class").create(UnhackableGate, "GateBars")
local SpriteComponent = require("Components.SpriteComponent")
local Direction = require("Direction")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  UnhackableGate.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, Direction.DIR_W, true, true, {-115, 0, 115, 32}, {})
  l_1_0:get(SpriteComponent):setSpriteSheet("Interactions/Props/Portcullis/Portcullis")
  l_1_0.hackFixture:destroy()
  l_1_0.openSound = "SFX/Hackable_Objects/ArmoryGate_Open"
  l_1_0.closeSound = "SFX/Hackable_Objects/ArmoryGate_Close"
end

return LayoutEntity

