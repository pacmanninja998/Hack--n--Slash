-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\HackFramedGui.lua 

local Gui = require("Gui")
local SpriteSheet = require("SpriteSheet")
local FramedGui = Gui.load("Content/Game/Global/Gui/FramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local PromptGui = Gui.load("Content/Game/Global/Gui/PromptGui")
local HackFramedGui = require("Class").create(FramedGui, "HackFramedGui")
HackFramedGui.LABEL_COLOR = {0.44705882352941, 0.99607843137255, 0.9921568627451}
HackFramedGui.INNER_BORDERS = {N = 182, E = 110, S = 105, W = 110}
HackFramedGui.LABEL_BORDERS = {N = 84, E = 175, W = 120}
HackFramedGui.LABEL_HEIGHT = 54
HackFramedGui.DISMISS_RECT = {64, 64, 112, 112}
HackFramedGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  FramedGui.init(l_1_0, l_1_1, SpriteSheet.load("UI/HackInterface/HackInterface"))
  l_1_0.label = LabelGui.new(l_1_0, l_1_2, {color = LABEL_COLOR})
  if l_1_3 then
    l_1_0:setEntity(l_1_3)
  end
end

HackFramedGui.setEntity = function(l_2_0, l_2_1)
  if l_2_0.dismissPrompt then
    l_2_0.dismissPrompt:destroy()
    l_2_0.dismissPrompt = nil
  end
  if l_2_1 then
    l_2_0.dismissPrompt = PromptGui.new(l_2_0, l_2_1, "Dismiss")
    l_2_0:requestResize()
  end
end

HackFramedGui.measure = function(l_3_0, l_3_1, l_3_2)
  local sizeX, sizeY = FramedGui.measure(l_3_0, l_3_1, l_3_2)
  local labelX, labelY = l_3_0.label:measure(l_3_1 - l_3_0.LABEL_BORDERS.W - l_3_0.LABEL_BORDERS.E, l_3_2 - l_3_0.LABEL_BORDERS.N)
  sizeX = math.max(sizeX, labelX + l_3_0.LABEL_BORDERS.W + l_3_0.LABEL_BORDERS.E)
  return sizeX, sizeY
end

HackFramedGui.resize = function(l_4_0, l_4_1, l_4_2)
  FramedGui.resize(l_4_0, l_4_1, l_4_2)
  l_4_0.label:position(l_4_0.LABEL_BORDERS.W, l_4_2 - l_4_0.LABEL_BORDERS.N - l_4_0.LABEL_HEIGHT, l_4_1 - l_4_0.LABEL_BORDERS.E, l_4_2 - l_4_0.LABEL_BORDERS.N)
  if l_4_0.dismissPrompt then
    local cornerX, cornerY = l_4_1 - l_4_0.borderE, l_4_2 - l_4_0.borderN
    local x0, y0, x1, y1 = unpack(l_4_0.DISMISS_RECT)
    l_4_0.dismissPrompt:position(cornerX + x0, cornerY + y0, cornerX + x1, cornerY + y1)
  end
end

HackFramedGui.setHackInnerGui = function(l_5_0, l_5_1)
  assert(l_5_1.parent == l_5_0)
  l_5_0:setInnerGui(l_5_1, l_5_0.INNER_BORDERS)
end

return HackFramedGui

