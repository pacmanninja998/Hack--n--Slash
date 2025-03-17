-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\TitleCardGui.lua 

local Gui = require("Gui")
local Delegate = require("DFMoai.Delegate")
local ColorGui = Gui.load("Content/Game/Global/Gui/ColorGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local TitleCardGui = require("Class").create(Gui, "TitleCardGui")
TitleCardGui.FONT_HEIGHT = 60
TitleCardGui.BACKGROUND_COLOR = {0, 0, 0, 1}
TitleCardGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0, l_1_1)
  l_1_0.skipEvent = Delegate.new()
  if not l_1_3 then
    l_1_0.background = ColorGui.new(l_1_0, unpack(l_1_0.BACKGROUND_COLOR))
  else
    l_1_0.background = SpriteGui.new(l_1_0, l_1_3, l_1_4)
  end
  l_1_0.label = LabelGui.new(l_1_0, "<title>" .. l_1_2 .. "</title>", {height = l_1_0.FONT_HEIGHT, justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  l_1_0:setFocus(l_1_0)
end

TitleCardGui.handleMotive = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == "Dismiss" then
    l_2_0.skipEvent:dispatch()
  else
    Gui.handleMotive(l_2_0, l_2_1, l_2_2)
  end
end

TitleCardGui.resize = function(l_3_0, l_3_1, l_3_2)
  l_3_0.background:position(0, 0, l_3_1, l_3_2)
  l_3_0.label:position(0, 0, l_3_1, l_3_2)
end

return TitleCardGui

