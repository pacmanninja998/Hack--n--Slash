-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\PrototypeGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local Delegate = require("DFMoai.Delegate")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local TextButtonGui = Gui.load("Content/Game/Global/Gui/TextButtonGui")
local HorizontalLayoutGui = Gui.load("Content/Game/Global/Gui/HorizontalLayoutGui")
local Disassembly = require("Disassembly")
local PrototypeLayout = require("PrototypeLayout")
local PrototypeGui = Class.create(HackFramedGui, "PrototypeGui")
PrototypeGui.ExpressionGui = Class.create(Gui, "ExpressionGui")
PrototypeGui.ExpressionGui.PC_WIDTH = 150
PrototypeGui.ExpressionGui.OPCODE_WIDTH = 250
PrototypeGui.ExpressionGui.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(PrototypeGui.ExpressionGui).init(l_1_0, l_1_1)
  l_1_0.expression = l_1_2
  l_1_0.pcGui = TextButtonGui.new(l_1_0, tostring(l_1_2.expression.pc))
  l_1_0.opcodeGui = LabelGui.new(l_1_0, l_1_2.expression.instruction:GET_OPCODE_NAME())
  l_1_0.descriptionGui = LabelGui.new(l_1_0, l_1_2:getFormat())
end

PrototypeGui.ExpressionGui.measure = function(l_2_0, l_2_1, l_2_2)
  local sizeX, sizeY = l_2_0.descriptionGui:measure(l_2_1, l_2_2)
  sizeX = sizeX + l_2_0.PC_WIDTH + l_2_0.OPCODE_WIDTH
  return sizeX, sizeY
end

PrototypeGui.ExpressionGui.resize = function(l_3_0, l_3_1, l_3_2)
  Class.super(PrototypeGui.ExpressionGui).resize(l_3_0, l_3_1, l_3_2)
  l_3_0.pcGui:position(0, 0, l_3_0.PC_WIDTH, l_3_2)
  l_3_0.opcodeGui:position(l_3_0.PC_WIDTH, 0, l_3_0.PC_WIDTH + l_3_0.OPCODE_WIDTH, l_3_2)
  l_3_0.descriptionGui:position(l_3_0.PC_WIDTH + l_3_0.OPCODE_WIDTH, 0, l_3_1, l_3_2)
end

PrototypeGui.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  HackFramedGui.init(l_4_0, l_4_1, l_4_2, l_4_4)
  l_4_0.prototype = l_4_3
  l_4_0.dismissEvent = Delegate.new()
  l_4_0.listGui = ListGui.new(l_4_0, LabelGui.DEFAULT_HEIGHT)
  l_4_0.layout = PrototypeLayout.new(l_4_3)
  for i,block in ipairs(l_4_0.layout.orderedBlockLayouts) do
    for j,expression in ipairs(block.expressionLayouts) do
      l_4_0.listGui:insert(PrototypeGui.ExpressionGui.new(l_4_0.listGui, expression))
    end
  end
  l_4_0:setHackInnerGui(l_4_0.listGui)
  l_4_0:setFocus(l_4_0.listGui)
end

PrototypeGui.handleMotiveStart = function(l_5_0, l_5_1)
  if l_5_1 == "Dismiss" or l_5_1 == "Select" then
    if l_5_1 == "Select" then
      local targetGui = l_5_0.listGui.guis[l_5_0.listGui.selectionIndex]
      if targetGui then
        l_5_0.targetPC = targetGui.expression.expression.pc
      end
    end
    l_5_0.dismissEvent:dispatch()
    l_5_0.dismissed = true
    return 
  end
  HackFramedGui.handleMotiveStart(l_5_0, l_5_1)
end

return PrototypeGui

