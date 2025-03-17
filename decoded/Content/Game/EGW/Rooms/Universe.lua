-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Rooms\Universe.lua 

local Music = require("Music")
local Universe = require("Room").classFromLayout("Content/Game/EGW/Layouts/Universe", "Universe", "Content/Game/Global/Rooms/GameRoom")
Universe.onInit = function(l_1_0)
  Music:setReverb("ExteriorSlap")
  Music:playAmbient("Ambience/Ambience/SpriteClearing_Ambience")
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/SpriteClearing_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/SpriteClearing_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/SpriteClearing_ShadowGradient"
  l_1_0.timeOfDayRampMagnitude = 1.7
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0:defineTreasureChestScene("TreasureChest", l_1_0.onTreasureChest, l_1_0)
  l_1_0:enableTimeOfDay()
end

Universe.onTreasureChest = function(l_2_0, l_2_1, l_2_2)
  local alicePortrait = l_2_1:addAlicePortrait()
  l_2_1:speakLineLeft(alicePortrait, "It's another artifact. This one's labeled <c:72FEFDFF>completeTheGame</c>.", "Default")
  table.insert(l_2_2.host.state.discoveredValues, "completeTheGame")
end

return Universe

