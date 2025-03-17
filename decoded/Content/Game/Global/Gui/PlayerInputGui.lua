-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\PlayerInputGui.lua 

local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local PlayerInputGui = require("Class").create(Gui, "PlayerInputGui")
local StringEditGui = Gui.load("Content/Game/Global/Gui/StringEditGui")
PlayerInputGui.MINIMUM_WIDTH = 400
PlayerInputGui.StringContainer = require("Class").create("PlayerInputGui.StringContainer")
PlayerInputGui.StringContainer.addStringField("value")
PlayerInputGui.StringContainer.init = function(l_1_0, l_1_1)
  l_1_0.value = l_1_1 or ""
end

PlayerInputGui.init = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  Gui.init(l_2_0, l_2_1)
  l_2_0.dismissEvent = Delegate.new()
  l_2_0.selectEvent = Delegate.new()
  l_2_0.container = PlayerInputGui.StringContainer.new(l_2_2)
  l_2_0.child = StringEditGui.new(l_2_0, l_2_0.container, "value", l_2_0.container.schemas.value, l_2_4, l_2_5)
  l_2_0.child.dismissEvent:register(l_2_0.onChildDismiss, l_2_0)
  l_2_0.child.selectEvent:register(l_2_0.onChildSelect, l_2_0)
  if l_2_3 then
    l_2_0.child.label:setText(l_2_3)
  end
end

PlayerInputGui.onChildDismiss = function(l_3_0)
  l_3_0.dismissed = true
  l_3_0.dismissEvent:dispatch()
end

PlayerInputGui.onChildSelect = function(l_4_0)
  l_4_0.selectEvent:dispatch()
end

PlayerInputGui.isDone = function(l_5_0)
  return l_5_0.child.dismissed
end

PlayerInputGui.getResult = function(l_6_0)
  return l_6_0.container.value
end

PlayerInputGui.handleFocusGain = function(l_7_0)
  l_7_0.root:setFocus(l_7_0.child)
end

PlayerInputGui.onChildRequestResize = function(l_8_0)
  l_8_0:resize(l_8_0.sizeX, l_8_0.sizeY)
end

PlayerInputGui.resize = function(l_9_0, l_9_1, l_9_2)
  Gui.resize(l_9_0, l_9_1, l_9_2)
  local childX, childY = l_9_0.child:measure(l_9_1, l_9_2)
  if childX < l_9_0.MINIMUM_WIDTH then
    childX = l_9_0.MINIMUM_WIDTH
  end
  local x0, y0 = (l_9_1 - childX) * 0.5, (l_9_2 - childY) * 0.5
  l_9_0.child:position(x0, y0, x0 + childX, y0 + childY)
end

return PlayerInputGui

