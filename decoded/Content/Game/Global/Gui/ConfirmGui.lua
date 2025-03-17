-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ConfirmGui.lua 

local Class = require("Class")
local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local ConfirmGui = Class.create(Gui, "ConfirmGui")
local ColorGui = Gui.load("Content/Game/Global/Gui/ColorGui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local TextButtonGui = Gui.load("Content/Game/Global/Gui/TextButtonGui")
ConfirmGui.InnerGui = Class.create(Gui, "ConfirmGui.InnerGui")
ConfirmGui.InnerGui.MAX_WIDTH = 1024
ConfirmGui.InnerGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(ConfirmGui.InnerGui).init(l_1_0, l_1_1)
  l_1_0.message = LabelGui.new(l_1_0, l_1_2, {justifyVertical = MOAITextBox.LEFT_JUSTIFY})
  l_1_0.confirm = TextButtonGui.new(l_1_0, l_1_3)
  l_1_0.deny = TextButtonGui.new(l_1_0, l_1_4)
end

ConfirmGui.InnerGui.measure = function(l_2_0, l_2_1, l_2_2)
  local messageX, messageY = l_2_0.message:measure(math.min(l_2_0.MAX_WIDTH, l_2_1), l_2_2)
  local confirmX, confirmY = l_2_0.confirm:measure(l_2_1, l_2_2)
  local denyX, denyY = l_2_0.deny:measure(l_2_1, l_2_2)
  return math.max(messageX, confirmX + denyX), messageY + math.max(confirmY, denyY) * 2
end

ConfirmGui.InnerGui.resize = function(l_3_0, l_3_1, l_3_2)
  Class.super(ConfirmGui.InnerGui).resize(l_3_0, l_3_1, l_3_2)
  l_3_0.message:position(0, 0, l_3_1, l_3_2)
  local confirmX, confirmY = l_3_0.confirm:measure(l_3_1, l_3_2)
  local denyX, denyY = l_3_0.deny:measure(l_3_1, l_3_2)
  l_3_0.deny:position(0, 0, denyX, denyY)
  l_3_0.confirm:position(l_3_1 - confirmX, 0, l_3_1, denyY)
end

ConfirmGui.InnerGui.handleFocusGain = function(l_4_0)
  if l_4_0.root.focus == l_4_0 then
    l_4_0.root:setFocus(l_4_0.deny)
  end
end

ConfirmGui.InnerGui.handleMotive = function(l_5_0, l_5_1, l_5_2)
  if l_5_1 == "Left" or l_5_1 == "Right" then
    l_5_0:playCue("UI/Hacking_UI/HackingUI_ToggleParameter")
    if l_5_0.root.focus == l_5_0.deny then
      l_5_0.root:setFocus(l_5_0.confirm)
    else
      l_5_0.root:setFocus(l_5_0.deny)
    end
  else
    Class.super(ConfirmGui.InnerGui).handleMotive(l_5_0, l_5_1, l_5_2)
  end
end

ConfirmGui.init = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4, l_6_5, l_6_6)
  Class.super(ConfirmGui).init(l_6_0, l_6_1)
  l_6_0.colorGui = ColorGui.new(l_6_0, 0, 0, 0, 0.25)
  l_6_0.gui = HackFramedGui.new(l_6_0, l_6_2, l_6_6)
  local inner = ConfirmGui.InnerGui.new(l_6_0.gui, l_6_3, l_6_4, l_6_5)
  inner.confirm.selectedEvent:register(l_6_0.onConfirmSelected, l_6_0)
  inner.deny.selectedEvent:register(l_6_0.onDenySelected, l_6_0)
  l_6_0.gui:setHackInnerGui(inner)
  l_6_0.root:setFocus(l_6_0)
  l_6_0.dismissEvent = Delegate.new()
  l_6_0.confirmEvent = Delegate.new()
end

ConfirmGui.onConfirmSelected = function(l_7_0)
  l_7_0.confirmEvent:dispatch()
  l_7_0:dismiss()
end

ConfirmGui.onDenySelected = function(l_8_0)
  l_8_0:dismiss()
end

ConfirmGui.dismiss = function(l_9_0)
  l_9_0.dismissEvent:dispatch()
end

ConfirmGui.handleFocusGain = function(l_10_0)
  if l_10_0.root.focus == l_10_0 then
    l_10_0.root:setFocus(l_10_0.gui)
  end
end

ConfirmGui.handleMotive = function(l_11_0, l_11_1)
  if l_11_1 == "Dismiss" then
    l_11_0:dismiss()
  else
    Class.super(ConfirmGui).handleMotive(l_11_0, l_11_1)
  end
end

ConfirmGui.resize = function(l_12_0, l_12_1, l_12_2)
  Class.super(ConfirmGui).resize(l_12_0, l_12_1, l_12_2)
  local guiX, guiY = l_12_0.gui:measure(l_12_1, l_12_2)
  local x0, y0 = (l_12_1 - guiX) * 0.5, (l_12_2 - guiY) * 0.5
  l_12_0.colorGui:position(0, 0, l_12_1, l_12_2)
  l_12_0.gui:position(x0, y0, x0 + guiX, y0 + guiY)
end

return ConfirmGui

