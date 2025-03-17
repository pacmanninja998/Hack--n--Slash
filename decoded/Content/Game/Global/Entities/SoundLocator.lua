-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\SoundLocator.lua 

local Entity = require("Entity")
local Locator = Entity.cache:load("Content/Game/Global/Entities/Locator")
local SoundLocator = require("Class").create(Locator, "SoundLocator")
local SoundComponent = require("Components.SoundComponent")
SoundLocator.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Locator.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SoundComponent.new(l_1_0)
  l_1_0.volume = l_1_4:match("<([%d.]+)>")
  if l_1_0.volume then
    l_1_0.volume = tonumber(l_1_0.volume)
  end
  l_1_0.cuePath, _ = l_1_4:gsub(" .*", ""), l_1_4
  if l_1_0.cuePath then
    l_1_0.cue = l_1_0:get(SoundComponent):playCue(l_1_0.cuePath, true, l_1_0.volume)
  end
end

SoundLocator.restartSound = function(l_2_0)
  if l_2_0.cue then
    l_2_0.cue:stop()
  end
  if l_2_0.cuePath then
    l_2_0.cue = l_2_0:get(SoundComponent):playCue(l_2_0.cuePath, true, l_2_0.volume)
  end
end

return SoundLocator

