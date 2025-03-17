-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\HayItem.lua 

local Item = require("Item")
local HayItem = require("Class").create(Item, "HayItem")
HayItem.getDescription = function(l_1_0)
  return "Hey! Hay."
end

HayItem.getSprite = function(l_2_0)
  return "UI/ItemIcons/HayItem/HayItem", "HayItem"
end

return HayItem

