-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\UnhackableGate.lua 

local Entity = require("Entity")
local LockedGate = Entity.cache:load("Content/Game/Global/Entities/LockedGate")
local SpriteComponent = require("Components.SpriteComponent")
local InteractionComponent = require("Components.InteractionComponent")
local UnhackableGate = require("Class").create(LockedGate, "UnhackableGate")
UnhackableGate.addBooleanField("OPEN", false)
UnhackableGate.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9)
  LockedGate.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9)
  l_1_0:get(SpriteComponent):setSpriteSheet("Interactions/Props/Placeholder/UnhackableGate/UnhackableGate")
  l_1_0:get(InteractionComponent):setEnabled(false)
end

UnhackableGate.onFieldSet = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == "OPEN" then
    l_2_0:updateLightColors()
    l_2_0:setOpen(l_2_2)
  end
end

UnhackableGate.setLocked = function(l_3_0, l_3_1)
end

UnhackableGate.locked = function(l_4_0)
  return false
end

UnhackableGate.isHackable = function(l_5_0)
  return false
end

return UnhackableGate

