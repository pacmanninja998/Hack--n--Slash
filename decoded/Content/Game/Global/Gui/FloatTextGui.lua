-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\FloatTextGui.lua 

local EntityRef = require("EntityRef")
local Gui = require("Gui")
local FloatTextGui = require("Class").create(Gui, "FloatTextGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ColorGui = Gui.load("Content/Game/Global/Gui/ColorGui")
FloatTextGui.HEIGHT_BUFFER_RATIO = 0.5
FloatTextGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  if not l_1_4 then
    l_1_4 = {}
  end
  Gui.init(l_1_0, l_1_1)
  l_1_0.entity = EntityRef.new(l_1_2)
  l_1_0.floatAbove = l_1_4.floatAbove
  if l_1_0.floatAbove == nil then
    l_1_0.floatAbove = true
  end
  l_1_0.background = ColorGui.new(l_1_0, 0, 0, 0, 0.25)
  local color = nil
  if l_1_4.color then
    color = l_1_4.color
  elseif l_1_2.TEXT_COLOR then
    color = l_1_2.TEXT_COLOR
  else
    color = {1, 1, 1, 1}
  end
  l_1_0.label = LabelGui.new(l_1_0, l_1_3, {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, color = color})
  l_1_0:playCue("UI/Hacking_UI/Promptless_Dialogue")
end

FloatTextGui.tick = function(l_2_0)
  if not l_2_0.entity.entity or not l_2_0.root.screen then
    return 
  end
  local x, y = nil, nil
  if l_2_0.floatAbove then
    local ex0, ey0, ex1, ey1 = l_2_0:getEntityClientBounds(l_2_0.entity.entity)
    x, y = (ex0 + ex1) * 0.5, ey1 + l_2_0.label.height * (l_2_0.HEIGHT_BUFFER_RATIO + 0.5)
  else
    x, y = l_2_0:getEntityClientLoc(l_2_0.entity.entity)
  end
  local sizeX, sizeY = l_2_0.label:measure(l_2_0.sizeX, l_2_0.sizeY)
  sizeY = l_2_0.label.height * math.ceil(sizeY / l_2_0.label.height)
  local x0, y0, x1, y1 = x - sizeX * 0.5, y - sizeY * 0.5, x + sizeX * 0.5, y + sizeY * 0.5
  l_2_0.background:positionClamped(x0, y0, x1, y1)
  l_2_0.label:positionClamped(x0, y0, x1, y1)
end

return FloatTextGui

