-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ChooseFieldGui.lua 

local Delegate = require("DFMoai.Delegate")
local Class = require("Class")
local Gui = require("Gui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local FieldGui = Gui.load("Content/Game/Global/Gui/FieldGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local ChooseFieldGui = Class.create(Gui, "ChooseFieldGui")
ChooseFieldGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Class.super(ChooseFieldGui).init(l_1_0, l_1_1)
  l_1_0.fieldChosenEvent = Delegate.new()
  l_1_0.dismissEvent = Delegate.new()
  l_1_0.fields = l_1_3
  l_1_0.gui = HackFramedGui.new(l_1_0, l_1_2, l_1_5)
  l_1_0.list = ListGui.new(l_1_0.gui)
  for index,field in ipairs(l_1_3) do
    local fieldGui = FieldGui.create(l_1_0.list, l_1_3, index, l_1_4, l_1_5)
    l_1_0.list:insert(fieldGui)
  end
  l_1_0.gui:setHackInnerGui(l_1_0.list)
end

ChooseFieldGui.dismiss = function(l_2_0)
  l_2_0.dismissed = true
  l_2_0.dismissEvent:dispatch()
end

ChooseFieldGui.resize = function(l_3_0, l_3_1, l_3_2)
  Class.super(ChooseFieldGui).resize(l_3_0, l_3_1, l_3_2)
  local guiX, guiY = l_3_0.gui:measure(l_3_1, l_3_2)
  local x0, y0 = (l_3_1 - guiX) * 0.5, (l_3_2 - guiY) * 0.5
  l_3_0.gui:position(x0, y0, x0 + guiX, y0 + guiY)
end

ChooseFieldGui.handleMotive = function(l_4_0, l_4_1)
  if l_4_1 == "Select" then
    l_4_0.fieldChosenEvent:dispatch(l_4_0.fields[l_4_0.list.selectionIndex])
    l_4_0:dismiss()
  elseif l_4_1 == "Dismiss" then
    l_4_0:dismiss()
  else
    Class.super(ChooseFieldGui).handleMotive(l_4_0, l_4_1)
  end
end

ChooseFieldGui.handleFocusGain = function(l_5_0)
  if l_5_0.root.focus == l_5_0 then
    l_5_0.root:setFocus(l_5_0.gui)
  end
end

return ChooseFieldGui

