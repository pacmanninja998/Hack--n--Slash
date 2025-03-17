-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ControlsGui.lua 

local Delegate = require("DFMoai.Delegate")
local Class = require("Class")
local Gui = require("Gui")
local LocalInput = require("LocalInput")
local SpriteSheet = require("SpriteSheet")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local TextButtonGui = Gui.load("Content/Game/Global/Gui/TextButtonGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local ControlsGui = Class.create(HackFramedGui, "ControlsGui")
ControlsGui.KeyboardDialogGui = Class.create(HackFramedGui, "ControlsGui.KeyboardDialogGui")
ControlsGui.KeyboardDialogGui.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(ControlsGui.KeyboardDialogGui).init(l_1_0, l_1_1, l_1_2)
  l_1_0.keyEvent = Delegate.new()
  l_1_0:setHackInnerGui(LabelGui.new(l_1_0, "Press the key you want to bind", {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY}))
  l_1_0:captureInput(true)
  l_1_0.firstFrame = true
end

ControlsGui.KeyboardDialogGui.tick = function(l_2_0)
  Class.super(ControlsGui.KeyboardDialogGui).tick(l_2_0)
  if l_2_0.firstFrame then
    l_2_0.firstFrame = false
    return 
  end
  if l_2_0.keyPressed then
    l_2_0.keyEvent:dispatch(l_2_0.keyPressed)
    return 
  end
  local keyboard = MOAIInputMgr.device.keyboard
  for keyCode in pairs(LocalInput.KEY_PROMPTS) do
    if keyboard:keyDown(keyCode) then
      l_2_0.keyPressed = keyCode
  else
    end
  end
end

ControlsGui.MotiveGui = Class.create(Gui, "ControlsGui.MotiveGui")
ControlsGui.MotiveGui.LABEL_WIDTH = 400
ControlsGui.MotiveGui.PROMPT_SIZE = 48
ControlsGui.MotiveGui.PROMPT_SPACING = 8
ControlsGui.MotiveGui.init = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  Class.super(ControlsGui.MotiveGui).init(l_3_0, l_3_1)
  l_3_0.container = l_3_3
  l_3_0.motive = l_3_4
  l_3_0.label = LabelGui.new(l_3_0, l_3_5)
  l_3_0.sheet = SpriteSheet.load("UI/Prompts/Keyboard/Keyboard")
  l_3_0.keyGuis = {}
  l_3_0.addBindingButton = TextButtonGui.new(l_3_0, "Add key")
  l_3_0.addBindingButton.selectedEvent:register(l_3_0.onAddBindingSelected, l_3_0)
  l_3_0.resetBindingsButton = TextButtonGui.new(l_3_0, "Reset")
  l_3_0.resetBindingsButton.selectedEvent:register(l_3_0.onResetBindingsSelected, l_3_0)
  l_3_0.schema = l_3_2
  l_3_0.schema:registerValueSetHandler(l_3_0.container, l_3_0.onArraySet, l_3_0)
  l_3_0:onArraySet(l_3_0.container[l_3_0.motive])
end

ControlsGui.MotiveGui.onAddBindingSelected = function(l_4_0)
  l_4_0.parent.parent:openKeyDialog(l_4_0.label.text, function(l_1_0)
    for index,existing in ipairs(self.array) do
      if existing == l_1_0 then
        return 
      end
    end
    table.insert(self.array, l_1_0)
   end)
end

ControlsGui.MotiveGui.onResetBindingsSelected = function(l_5_0)
  l_5_0.parent.parent:openKeyDialog(l_5_0.label.text, function(l_1_0)
    self.container[self.motive] = {l_1_0}
   end)
end

ControlsGui.MotiveGui.onArraySet = function(l_6_0, l_6_1)
  if l_6_0.array then
    l_6_0.schema:unregisterInsertHandler(l_6_0.array, l_6_0.onInsert, l_6_0)
    l_6_0.schema:unregisterRemoveHandler(l_6_0.array, l_6_0.onRemove, l_6_0)
    l_6_0.schema:unregisterSetHandler(l_6_0.array, l_6_0.onSet, l_6_0)
    for i,keyGui in ipairs(l_6_0.keyGuis) do
      keyGui:destroy()
    end
  end
  l_6_0.array = l_6_1
  l_6_0.schema:registerInsertHandler(l_6_0.array, l_6_0.onInsert, l_6_0)
  l_6_0.schema:registerRemoveHandler(l_6_0.array, l_6_0.onRemove, l_6_0)
  l_6_0.schema:registerSetHandler(l_6_0.array, l_6_0.onSet, l_6_0)
  l_6_0.keyGuis = {}
  for index,value in ipairs(l_6_0.array) do
    l_6_0:onInsert(index, value)
  end
end

ControlsGui.MotiveGui.onInsert = function(l_7_0, l_7_1, l_7_2)
  table.insert(l_7_0.keyGuis, SpriteGui.new(l_7_0))
  l_7_0:onSet(l_7_1, l_7_2)
  l_7_0:requestResize()
end

ControlsGui.MotiveGui.onRemove = function(l_8_0, l_8_1, l_8_2)
  local gui = l_8_0.keyGuis[l_8_1]
  table.remove(l_8_0.keyGuis, l_8_1)
  gui:destroy()
  l_8_0:requestResize()
end

ControlsGui.MotiveGui.setColumn = function(l_9_0, l_9_1)
  l_9_0.column = l_9_1
  if l_9_0:hasFocus() then
    l_9_0:handleFocusGain()
  end
end

ControlsGui.MotiveGui.handleFocusGain = function(l_10_0)
  if l_10_0.column == 1 then
    l_10_0.root:setFocus(l_10_0.addBindingButton)
  elseif l_10_0.column == 2 then
    l_10_0.root:setFocus(l_10_0.resetBindingsButton)
  end
end

ControlsGui.MotiveGui.onSet = function(l_11_0, l_11_1, l_11_2)
  local gui = l_11_0.keyGuis[l_11_1]
  gui:setSprite(l_11_0.sheet, LocalInput.KEY_PROMPTS[l_11_2])
  l_11_0:requestResize()
end

ControlsGui.MotiveGui.measure = function(l_12_0, l_12_1, l_12_2)
  local addX, addY = l_12_0.addBindingButton:measure(l_12_1, l_12_2)
  local resetX, resetY = l_12_0.resetBindingsButton:measure(l_12_1, l_12_2)
  return l_12_0.LABEL_WIDTH + (l_12_0.PROMPT_SIZE + l_12_0.PROMPT_SPACING) * #l_12_0.keyGuis + l_12_0.PROMPT_SPACING + addX + resetX, math.max(l_12_0.PROMPT_SIZE, addY, resetY)
end

ControlsGui.MotiveGui.resize = function(l_13_0, l_13_1, l_13_2)
  Class.super(ControlsGui.MotiveGui).resize(l_13_0, l_13_1, l_13_2)
  l_13_0.label:position(0, 0, l_13_0.LABEL_WIDTH, l_13_0.PROMPT_SIZE)
  for i,keyGui in pairs(l_13_0.keyGuis) do
    local xOffset = l_13_0.LABEL_WIDTH + (l_13_0.PROMPT_SIZE + l_13_0.PROMPT_SPACING) * (i - 1) + l_13_0.PROMPT_SPACING
    keyGui:position(xOffset, 0, xOffset + l_13_0.PROMPT_SIZE, l_13_0.PROMPT_SIZE)
  end
  local addX, addY = l_13_0.addBindingButton:measure(l_13_1, l_13_2)
  local resetX, resetY = l_13_0.resetBindingsButton:measure(l_13_1, l_13_2)
  l_13_0.resetBindingsButton:position(l_13_1 - resetX, 0, l_13_1, l_13_2)
  l_13_0.addBindingButton:position(l_13_1 - resetX - addX, 0, l_13_1 - resetX, l_13_2)
end

ControlsGui.COLUMN_COUNT = 2
ControlsGui.init = function(l_14_0, l_14_1, l_14_2, l_14_3)
  Class.super(ControlsGui).init(l_14_0, l_14_1, "Controls", l_14_3)
  l_14_0.userState = l_14_2
  l_14_0.list = ListGui.new(l_14_0, ControlsGui.MotiveGui.PROMPT_SIZE)
  l_14_0:setHackInnerGui(l_14_0.list)
  l_14_0.dismissEvent = Delegate.new()
  local keyBindingsSchema = l_14_2.schemas.data.fieldSchemas.controls.fieldSchemas.KEY_BINDINGS
  local addMotive = function(l_1_0, l_1_1)
    local motiveGui = ControlsGui.MotiveGui.new(self.list, keyBindingsSchema.fieldSchemas[l_1_0], userState.data.controls.KEY_BINDINGS, l_1_0, l_1_1 or l_1_0)
    self.list:insert(motiveGui)
   end
  addMotive("Up")
  addMotive("Left")
  addMotive("Down")
  addMotive("Right")
  addMotive("Interact")
  addMotive("Select")
  addMotive("UsePrimary", "Primary item")
  addMotive("Use1", "Secondary item 1")
  addMotive("Use2", "Secondary item 2")
  addMotive("Use3", "Secondary item 3")
  addMotive("Use4", "Secondary item 4")
  addMotive("OpenTabs", "Open inventory")
  addMotive("OpenMenu", "Open menu")
  addMotive("Dismiss")
  l_14_0.list:insert(LabelGui.new(l_14_0.list, "[Reset to defaults]"))
  l_14_0:setColumn(1)
  l_14_0.list.selectionChangeEvent:register(l_14_0.onListSelectionChange, l_14_0)
end

ControlsGui.openKeyDialog = function(l_15_0, l_15_1, l_15_2)
  l_15_0.resultHandler = l_15_2
  l_15_0.dialog = ControlsGui.KeyboardDialogGui.new(l_15_0, l_15_1)
  l_15_0.dialog.keyEvent:register(l_15_0.onDialogKey, l_15_0)
  l_15_0.root:setFocus(l_15_0.dialog)
  l_15_0:requestResize()
end

ControlsGui.onDialogKey = function(l_16_0, l_16_1)
  l_16_0.resultHandler(l_16_1)
  l_16_0.dialog:destroy()
  l_16_0.dialog = nil
  l_16_0.resultHandler = nil
  l_16_0.root:setFocus(nil)
  l_16_0.root:setFocus(l_16_0)
end

ControlsGui.resize = function(l_17_0, l_17_1, l_17_2)
  Class.super(ControlsGui).resize(l_17_0, l_17_1, l_17_2)
  if l_17_0.dialog then
    local dialogX, dialogY = l_17_0.dialog:measure(l_17_1, l_17_2)
    local x0, y0 = (l_17_1 - dialogX) * 0.5, (l_17_2 - dialogY) * 0.5
    l_17_0.dialog:position(x0, y0, x0 + dialogX, y0 + dialogY)
  end
end

ControlsGui.onListSelectionChange = function(l_18_0, l_18_1)
  l_18_0:setColumn(l_18_0.column)
end

ControlsGui.setColumn = function(l_19_0, l_19_1)
  l_19_0.column = l_19_1
  local item = l_19_0.list.guis[l_19_0.list.selectionIndex]
  if item.setColumn then
    item:setColumn(l_19_0.column)
  end
end

ControlsGui.handleMotiveStart = function(l_20_0, l_20_1)
  if l_20_1 == "Dismiss" then
    l_20_0.dismissEvent:dispatch()
  do
     -- DECOMPILER ERROR: unhandled construct in 'if'

    elseif l_20_1 == "Select" and l_20_0.list.selectionIndex == #l_20_0.list.guis then
      local keyBindingsSchema = l_20_0.userState.schemas.data.fieldSchemas.controls.fieldSchemas.KEY_BINDINGS
      for motive,motiveSchema in pairs(keyBindingsSchema.fieldSchemas) do
        l_20_0.userState.data.controls.KEY_BINDINGS[motive] = motiveSchema:getDefault()
      end
    end
    do return end
    if l_20_1 == "Left" then
      l_20_0:setColumn(1 + (l_20_0.column - 2) % l_20_0.COLUMN_COUNT)
    elseif l_20_1 == "Right" then
      l_20_0:setColumn(1 + l_20_0.column % l_20_0.COLUMN_COUNT)
    else
      Class.super(ControlsGui).handleMotiveStart(l_20_0, l_20_1)
    end
  end
end

return ControlsGui

