-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\HorizontalLayoutGui.lua 

local Gui = require("Gui")
local HorizontalLayoutGui = require("Class").create(Gui, "HorizontalLayoutGui")
HorizontalLayoutGui.init = function(l_1_0, l_1_1)
  Gui.init(l_1_0, l_1_1)
  l_1_0.guis = {}
end

HorizontalLayoutGui.insert = function(l_2_0, l_2_1, l_2_2)
  if not l_2_2 then
    l_2_2 = l_2_1
    l_2_1 = #l_2_0.guis + 1
  end
  assert(l_2_2.parent == l_2_0)
  table.insert(l_2_0.guis, l_2_1, l_2_2)
  l_2_0:requestResize()
end

HorizontalLayoutGui.measure = function(l_3_0, l_3_1, l_3_2)
  local totalX = 0
  local maxGuiY = 0
  for index,gui in ipairs(l_3_0.guis) do
    local guiX, guiY = gui:measure(l_3_1 - totalX, l_3_2)
    totalX = totalX + guiX
    if maxGuiY < guiY then
      maxGuiY = guiY
    end
  end
  return totalX, maxGuiY
end

HorizontalLayoutGui.resize = function(l_4_0, l_4_1, l_4_2)
  Gui.resize(l_4_0, l_4_1, l_4_2)
  local offsetX = 0
  for index,gui in ipairs(l_4_0.guis) do
    local guiX, guiY = gui:measure(l_4_1 - offsetX, l_4_2)
    gui:position(offsetX, 0, offsetX + guiX, l_4_2)
    offsetX = offsetX + guiX
  end
end

return HorizontalLayoutGui

