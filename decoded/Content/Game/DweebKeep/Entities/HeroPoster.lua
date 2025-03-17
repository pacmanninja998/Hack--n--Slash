-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\HeroPoster.lua 

local Entity = require("Entity")
local WantedPoster = Entity.cache:load("Content/Game/DweebKeep/Entities/WantedPoster")
local HeroPoster = require("Class").create(WantedPoster, "HeroPoster")
HeroPoster.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local universeState = l_1_1.room:universe().state.state
  local heroName = "Alice"
  if universeState and universeState.prisoners then
    heroName = universeState.prisoners[4]
  end
  WantedPoster.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, "Hero", heroName)
end

return HeroPoster

