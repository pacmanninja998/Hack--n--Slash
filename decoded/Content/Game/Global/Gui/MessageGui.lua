-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\MessageGui.lua 

local Delegate = require("DFMoai.Delegate")
local Class = require("Class")
local Gui = require("Gui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local MessageGui = Class.create(Gui, "MessageGui")
MessageGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0, l_1_1)
  l_1_0.gui = HackFramedGui.new(l_1_0, l_1_2)
  l_1_0.label = LabelGui.new(l_1_0.gui, l_1_3)
  l_1_0.gui:setHackInnerGui(l_1_0.label)
  l_1_0.root:setFocus(l_1_0)
  l_1_0.dismissEvent = Delegate.new()
  l_1_0.dismissEnabled = true
  if l_1_4 then
    l_1_0:setEntity(l_1_4)
  end
end

MessageGui.setEntity = function(l_2_0, l_2_1)
  l_2_0.gui:setEntity(l_2_1)
end

MessageGui.setDismissEnabled = function(l_3_0, l_3_1)
  if l_3_0.dismissPrompt then
    l_3_0.dismissPrompt:show(l_3_1)
  end
  l_3_0.dismissEnabled = l_3_1
end

MessageGui.setMessage = function(l_4_0, l_4_1)
  l_4_0.label:setText(l_4_1)
  l_4_0:requestResize()
end

MessageGui.resize = function(l_5_0, l_5_1, l_5_2)
  Gui.resize(l_5_0, l_5_1, l_5_2)
  local guiX, guiY = l_5_0.gui:measure(l_5_1, l_5_2)
  local x0, y0 = (l_5_1 - guiX) * 0.5, (l_5_2 - guiY) * 0.5
  l_5_0.gui:position(x0, y0, x0 + guiX, y0 + guiY)
end

MessageGui.handleMotiveStart = function(l_6_0, l_6_1)
  if l_6_0.dismissEnabled and (l_6_1 == "Select" or l_6_1 == "Dismiss") then
    l_6_0.dismissed = true
    l_6_0.dismissEvent:dispatch()
  else
    Gui.handleMotiveStart(l_6_0, l_6_1)
  end
end

return MessageGui

