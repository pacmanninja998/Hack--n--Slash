-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\JailGate.lua 

local Entity = require("Entity")
local LockedGate = Entity.cache:load("Content/Game/Global/Entities/LockedGate")
local JailGate = require("Class").create(LockedGate, "JailGate")
JailGate.addBooleanField("LOCKED", true)
JailGate.onFieldSet = function(l_1_0, l_1_1, l_1_2)
  if l_1_1 == "LOCKED" then
    l_1_0:updateLightColors()
  end
end

return JailGate

