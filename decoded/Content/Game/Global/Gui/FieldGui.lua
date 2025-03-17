-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\FieldGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local SpriteSheet = require("SpriteSheet")
local ArrayEditGui = Gui.load("Content/Game/Global/Gui/ArrayEditGui")
local StringEditGui = Gui.load("Content/Game/Global/Gui/StringEditGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local HorizontalLayoutGui = Gui.load("Content/Game/Global/Gui/HorizontalLayoutGui")
local FieldGui = Class.create(Gui, "FieldGui")
FieldGui.HACK_COLOR = {0.44705882352941, 0.99607843137255, 0.9921568627451}
local ArrayFieldGui = Class.create(FieldGui, "ArrayFieldGui")
ArrayFieldGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  FieldGui.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0.label = LabelGui.new(l_1_0, "{ ... }")
  l_1_0.left = LabelGui.new(l_1_0, "[", {color = l_1_0.HACK_COLOR, justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  l_1_0.right = LabelGui.new(l_1_0, "]", {color = l_1_0.HACK_COLOR, justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  l_1_0:showBrackets(false)
end

ArrayFieldGui.handleFocusGain = function(l_2_0)
  FieldGui.handleFocusGain(l_2_0)
  l_2_0:showBrackets(true)
end

ArrayFieldGui.handleFocusLoss = function(l_3_0)
  FieldGui.handleFocusLoss(l_3_0)
  l_3_0:showBrackets(false)
end

ArrayFieldGui.handleMotiveStart = function(l_4_0, l_4_1)
  if not l_4_0.editGui and (l_4_1 == "Select" or l_4_1 == "Interact") then
    local gui = ArrayEditGui.new(l_4_0, l_4_0.container, l_4_0.field, l_4_0.schema, l_4_0.entity)
    l_4_0:openEditGui(gui)
    return 
  end
  Gui.handleMotiveStart(l_4_0, l_4_1)
end

ArrayFieldGui.showBrackets = function(l_5_0, l_5_1)
  l_5_0.left:show(l_5_1)
  l_5_0.right:show(l_5_1)
end

ArrayFieldGui.measure = function(l_6_0, l_6_1, l_6_2)
  local labelX, labelY = l_6_0.label:measure(l_6_1, l_6_2)
  local leftX, leftY = l_6_0.left:measure(l_6_1, l_6_2)
  local rightX, rightY = l_6_0.right:measure(l_6_1, l_6_2)
  return leftX + labelX + rightX, math.max(labelY, leftY, rightY)
end

ArrayFieldGui.resize = function(l_7_0, l_7_1, l_7_2)
  FieldGui.resize(l_7_0, l_7_1, l_7_2)
  local labelX, labelY = l_7_0.label:measure(l_7_1, l_7_2)
  local leftX, leftY = l_7_0.left:measure(l_7_1, l_7_2)
  local rightX, rightY = l_7_0.right:measure(l_7_1, l_7_2)
  l_7_0.left:position(l_7_1 - rightX - labelX - leftX, 0, l_7_1 - rightX - labelX, l_7_2)
  l_7_0.label:position(l_7_1 - rightX - labelX, 0, l_7_1 - rightX, l_7_2)
  l_7_0.right:position(l_7_1 - rightX, 0, l_7_1, l_7_2)
end

local BooleanFieldGui = Class.create(FieldGui, "BooleanFieldGui")
BooleanFieldGui.CURSOR_SIZE = 16
BooleanFieldGui.LABEL_WIDTH = 160
BooleanFieldGui.init = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  FieldGui.init(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  l_8_0.label = LabelGui.new(l_8_0, nil, {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  local cursors = SpriteSheet.load("UI/Cursors/Cursors")
  l_8_0.left = SpriteGui.new(l_8_0, cursors, "LeftArrow", {blinkDuration = 0.5})
  l_8_0.right = SpriteGui.new(l_8_0, cursors, "RightArrow", {blinkDuration = 0.5})
  l_8_0:showArrows(false)
  l_8_0:onValueSet(l_8_2[l_8_3])
end

BooleanFieldGui.onValueSet = function(l_9_0, l_9_1)
  l_9_0.label:setText(tostring(l_9_1))
  FieldGui.onValueSet(l_9_0, l_9_1)
end

BooleanFieldGui.handleFocusGain = function(l_10_0)
  FieldGui.handleFocusGain(l_10_0)
  l_10_0:showArrows(true)
end

BooleanFieldGui.handleFocusLoss = function(l_11_0)
  FieldGui.handleFocusLoss(l_11_0)
  l_11_0:showArrows(false)
end

BooleanFieldGui.showArrows = function(l_12_0, l_12_1)
  l_12_0.left:show(l_12_1)
  l_12_0.right:show(l_12_1)
  if l_12_1 then
    l_12_0.left:reset()
    l_12_0.right:reset()
  end
end

BooleanFieldGui.handleMotive = function(l_13_0, l_13_1, l_13_2)
  if l_13_1 == "Left" or l_13_1 == "Right" then
    local curValue = l_13_0.container[l_13_0.field]
    l_13_0.container[l_13_0.field] = not curValue
    if l_13_0.container[l_13_0.field] ~= not curValue then
      l_13_0:onValueSet(l_13_0.container[l_13_0.field])
    end
    l_13_0:playCue("UI/Hacking_UI/HackingUI_ToggleParameter")
    return 
  end
  return Gui.handleMotive(l_13_0, l_13_1, l_13_2)
end

BooleanFieldGui.measure = function(l_14_0, l_14_1, l_14_2)
  return l_14_0.LABEL_WIDTH + 2 * l_14_0.CURSOR_SIZE, l_14_0.CURSOR_SIZE
end

BooleanFieldGui.resize = function(l_15_0, l_15_1, l_15_2)
  FieldGui.resize(l_15_0, l_15_1, l_15_2)
  l_15_0.left:position(l_15_1 - l_15_0.CURSOR_SIZE * 2 - l_15_0.LABEL_WIDTH, 0, l_15_1 - l_15_0.CURSOR_SIZE - l_15_0.LABEL_WIDTH, l_15_2)
  l_15_0.label:position(l_15_1 - l_15_0.CURSOR_SIZE - l_15_0.LABEL_WIDTH, 0, l_15_1 - l_15_0.CURSOR_SIZE, l_15_2)
  l_15_0.right:position(l_15_1 - l_15_0.CURSOR_SIZE, 0, l_15_1, l_15_2)
end

local EnumFieldGui = Class.create(FieldGui, "BooleanFieldGui")
EnumFieldGui.CURSOR_SIZE = 16
EnumFieldGui.LABEL_WIDTH = 350
EnumFieldGui.init = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5)
  FieldGui.init(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5)
  l_16_0.label = LabelGui.new(l_16_0, nil, {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  local cursors = SpriteSheet.load("UI/Cursors/Cursors")
  l_16_0.left = SpriteGui.new(l_16_0, cursors, "LeftArrow", {blinkDuration = 0.5})
  l_16_0.right = SpriteGui.new(l_16_0, cursors, "RightArrow", {blinkDuration = 0.5})
  l_16_0:showArrows(false)
  l_16_0:onValueSet(l_16_2[l_16_3])
end

EnumFieldGui.onValueSet = function(l_17_0, l_17_1)
  l_17_0.label:setText(tostring(l_17_1))
  FieldGui.onValueSet(l_17_0, l_17_1)
end

EnumFieldGui.handleFocusGain = function(l_18_0)
  FieldGui.handleFocusGain(l_18_0)
  l_18_0:showArrows(true)
end

EnumFieldGui.handleFocusLoss = function(l_19_0)
  FieldGui.handleFocusLoss(l_19_0)
  l_19_0:showArrows(false)
end

EnumFieldGui.showArrows = function(l_20_0, l_20_1)
  l_20_0.left:show(l_20_1)
  l_20_0.right:show(l_20_1)
  if l_20_1 then
    l_20_0.left:reset()
    l_20_0.right:reset()
  end
end

EnumFieldGui.handleMotive = function(l_21_0, l_21_1, l_21_2)
  local delta = 0
  if l_21_1 == "Left" then
    delta = -1
  elseif l_21_1 == "Right" then
    delta = 1
  end
  if delta ~= 0 then
    local curValue = l_21_0.container[l_21_0.field]
    local curIndex = #l_21_0.schema.values
    for index,value in ipairs(l_21_0.schema.values) do
      if value == curValue then
        curIndex = index
    else
      end
    end
    l_21_0.container[l_21_0.field] = l_21_0.schema.values[1 + (curIndex + delta - 1) % #l_21_0.schema.values]
    l_21_0:playCue("UI/Hacking_UI/HackingUI_ToggleParameter")
    return 
  end
  return Gui.handleMotive(l_21_0, l_21_1, l_21_2)
end

EnumFieldGui.measure = function(l_22_0, l_22_1, l_22_2)
  return l_22_0.LABEL_WIDTH + 2 * l_22_0.CURSOR_SIZE, l_22_0.CURSOR_SIZE
end

EnumFieldGui.resize = function(l_23_0, l_23_1, l_23_2)
  FieldGui.resize(l_23_0, l_23_1, l_23_2)
  l_23_0.left:position(l_23_1 - l_23_0.CURSOR_SIZE * 2 - l_23_0.LABEL_WIDTH, 0, l_23_1 - l_23_0.CURSOR_SIZE - l_23_0.LABEL_WIDTH, l_23_2)
  l_23_0.label:position(l_23_1 - l_23_0.CURSOR_SIZE - l_23_0.LABEL_WIDTH, 0, l_23_1 - l_23_0.CURSOR_SIZE, l_23_2)
  l_23_0.right:position(l_23_1 - l_23_0.CURSOR_SIZE, 0, l_23_1, l_23_2)
end

local NumberFieldGui = Class.create(FieldGui, "NumberFieldGui")
NumberFieldGui.CURSOR_SIZE = 16
NumberFieldGui.LABEL_WIDTH = 160
NumberFieldGui.REPEAT_INCREASE_DELAY = 20
NumberFieldGui.REPEAT_INCREASE_FACTOR = 2
NumberFieldGui.init = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5)
  FieldGui.init(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5)
  l_24_0.label = LabelGui.new(l_24_0, "", {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  local cursors = SpriteSheet.load("UI/Cursors/Cursors")
  l_24_0.left = SpriteGui.new(l_24_0, cursors, "LeftArrow", {blinkDuration = 0.5})
  l_24_0.right = SpriteGui.new(l_24_0, cursors, "RightArrow", {blinkDuration = 0.5})
  l_24_0:showArrows(false)
  l_24_0:onValueSet(l_24_2[l_24_3])
end

NumberFieldGui.onValueSet = function(l_25_0, l_25_1)
  local currentLength = #l_25_0.label.text
  l_25_0.label:setText(tostring(l_25_0:formatValue(l_25_1)))
  if #l_25_0.label.text ~= currentLength then
    l_25_0:requestResize()
  end
  FieldGui.onValueSet(l_25_0, l_25_1)
end

NumberFieldGui.handleFocusGain = function(l_26_0)
  FieldGui.handleFocusGain(l_26_0)
  l_26_0:showArrows(true)
end

NumberFieldGui.handleFocusLoss = function(l_27_0)
  FieldGui.handleFocusLoss(l_27_0)
  l_27_0:showArrows(false)
end

NumberFieldGui.formatValue = function(l_28_0, l_28_1)
  if l_28_0.schema:is(Class.ScalarSchema) then
    return string.format("%.f%%", l_28_1 * 100)
  else
    return tostring(l_28_1)
  end
end

NumberFieldGui.showArrows = function(l_29_0, l_29_1)
  l_29_0.left:show(l_29_1)
  l_29_0.right:show(l_29_1)
  if l_29_1 then
    l_29_0.left:reset()
    l_29_0.right:reset()
  end
end

NumberFieldGui.handleMotive = function(l_30_0, l_30_1, l_30_2)
  local repeatRate = math.floor(l_30_2 / l_30_0.REPEAT_INCREASE_DELAY)
  local increment = l_30_0.REPEAT_INCREASE_FACTOR ^ repeatRate
  if l_30_0.schema.step then
    increment = increment * l_30_0.schema.step
  end
  local oldValue = l_30_0.container[l_30_0.field]
  local newValue = oldValue
  if l_30_1 == "Left" then
    newValue = oldValue - increment
    if l_30_0.schema.minValue then
      newValue = math.max(newValue, l_30_0.schema.minValue)
    elseif l_30_1 == "Right" then
      newValue = oldValue + increment
      if l_30_0.schema.maxValue then
        newValue = math.min(newValue, l_30_0.schema.maxValue)
      else
        Gui.handleMotive(l_30_0, l_30_1, l_30_2)
      end
    end
  end
  if newValue ~= oldValue then
    l_30_0.container[l_30_0.field] = newValue
    l_30_0:playCue("UI/Hacking_UI/HackingUI_ValueToggle")
  end
end

NumberFieldGui.measure = function(l_31_0, l_31_1, l_31_2)
  local labelX, labelY = l_31_0.label:measure(l_31_1, l_31_2)
  return math.max(labelX, l_31_0.LABEL_WIDTH) + 2 * l_31_0.CURSOR_SIZE, l_31_0.CURSOR_SIZE
end

NumberFieldGui.resize = function(l_32_0, l_32_1, l_32_2)
  FieldGui.resize(l_32_0, l_32_1, l_32_2)
  local labelX, labelY = l_32_0.label:measure(l_32_1, l_32_2)
  local labelWidth = math.max(labelX, l_32_0.LABEL_WIDTH)
  l_32_0.left:position(l_32_1 - l_32_0.CURSOR_SIZE * 2 - labelWidth, 0, l_32_1 - l_32_0.CURSOR_SIZE - labelWidth, l_32_2)
  l_32_0.label:position(l_32_1 - l_32_0.CURSOR_SIZE - math.max(labelX, labelWidth), 0, l_32_1 - l_32_0.CURSOR_SIZE, l_32_2)
  l_32_0.right:position(l_32_1 - l_32_0.CURSOR_SIZE, 0, l_32_1, l_32_2)
end

local ParameterizedFieldGui = Class.create(FieldGui, "ObjectFieldGui")
ParameterizedFieldGui.init = function(l_33_0, l_33_1, l_33_2, l_33_3, l_33_4, l_33_5)
  FieldGui.init(l_33_0, l_33_1, l_33_2, l_33_3, l_33_4, l_33_5)
  l_33_0.leftBrackets = {}
  l_33_0.values = {}
  l_33_0.rightBrackets = {}
  l_33_0.containers = {}
  l_33_0:onValueSet(l_33_2[l_33_3])
  l_33_0:setColumn()
end

ParameterizedFieldGui.isParameterized = function(l_34_0)
  return true
end

ParameterizedFieldGui.destroy = function(l_35_0)
  FieldGui.destroy(l_35_0)
end

ParameterizedFieldGui.clearFields = function(l_36_0, l_36_1)
  for i = #l_36_0.containers, l_36_1 or 1, -1 do
    l_36_0.containers[i]:destroy()
    l_36_0.containers[i] = nil
    l_36_0.leftBrackets[i] = nil
    l_36_0.values[i] = nil
    l_36_0.rightBrackets[i] = nil
  end
end

ParameterizedFieldGui.setColumn = function(l_37_0, l_37_1)
  l_37_0.column = l_37_1
  for index,value in ipairs(l_37_0.values) do
    local selected = l_37_1 == index
    l_37_0.leftBrackets[index]:show(selected)
    l_37_0.rightBrackets[index]:show(selected)
  end
end

ParameterizedFieldGui.setColumnSizes = function(l_38_0, l_38_1)
  l_38_0.columnSizes = l_38_1
end

ParameterizedFieldGui.handleFocusGain = function(l_39_0)
  l_39_0:setColumn(1)
end

ParameterizedFieldGui.handleFocusLoss = function(l_40_0)
  l_40_0:setColumn()
end

ParameterizedFieldGui.handleMotive = function(l_41_0, l_41_1, l_41_2)
  if l_41_1 ~= "Left" or not -1 then
    local delta = l_41_1 ~= "Left" and l_41_1 ~= "Right" or 1
  end
  do
    local newColumn = 1 + (l_41_0.column + delta - 1) % #l_41_0.values
    l_41_0:setColumn(newColumn)
  end
  do return end
  if l_41_1 == "Select" then
    local value = l_41_0.values[l_41_0.column]
    local EditGui = Gui.load("Content/Game/Global/Gui/EditGui")
    local editGui = EditGui.new(l_41_0, tostring(value.field), l_41_0.entity)
    editGui:addField(l_41_0.container[l_41_0.field], value.field, value.schema)
    l_41_0:openEditGui(editGui)
  else
    FieldGui.handleMotive(l_41_0, l_41_1, l_41_2)
  end
end

ParameterizedFieldGui.addField = function(l_42_0, l_42_1, l_42_2, l_42_3)
  local container = HorizontalLayoutGui.new(l_42_0)
  table.insert(l_42_0.containers, container)
  local index = #l_42_0.containers
  table.insert(l_42_0.leftBrackets, LabelGui.new(container, "[", {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, color = l_42_0.HACK_COLOR}))
  table.insert(l_42_0.values, FieldGui.create(container, l_42_1, l_42_2, l_42_3, l_42_0.entity))
  table.insert(l_42_0.rightBrackets, LabelGui.new(container, "]", {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, color = l_42_0.HACK_COLOR}))
  l_42_0.leftBrackets[index]:show(false)
  l_42_0.rightBrackets[index]:show(false)
  container:insert(l_42_0.leftBrackets[index])
  container:insert(l_42_0.values[index])
  container:insert(l_42_0.rightBrackets[index])
end

ParameterizedFieldGui.measure = function(l_43_0, l_43_1, l_43_2)
  local totalX, maxElementY = 0, 0
  for index,container in ipairs(l_43_0.containers) do
    local containerX, containerY = container:measure(l_43_1 - totalX, l_43_2)
    if l_43_0.columnSizes[index] then
      containerX = l_43_0.columnSizes[index]
    end
    totalX = totalX + containerX
    maxElementY = math.max(maxElementY, containerY)
  end
  for index = #l_43_0.containers + 1, #l_43_0.columnSizes do
    totalX = totalX + l_43_0.columnSizes[index]
  end
  return totalX, maxElementY
end

ParameterizedFieldGui.resize = function(l_44_0, l_44_1, l_44_2)
  FieldGui.resize(l_44_0, l_44_1, l_44_2)
  local offsetX = 0
  for index,container in ipairs(l_44_0.containers) do
    local containerX, containerY = container:measure(l_44_1 - offsetX, l_44_2)
    if l_44_0.columnSizes[index] then
      containerX = l_44_0.columnSizes[index]
    end
    container:position(offsetX, 0, offsetX + containerX, l_44_2)
    offsetX = offsetX + containerX
  end
end

local ObjectFieldGui = Class.create(ParameterizedFieldGui, "ObjectFieldGui")
ObjectFieldGui.init = function(l_45_0, l_45_1, l_45_2, l_45_3, l_45_4, l_45_5)
  ParameterizedFieldGui.init(l_45_0, l_45_1, l_45_2, l_45_3, l_45_4, l_45_5)
end

ObjectFieldGui.onValueSet = function(l_46_0)
  local object = l_46_0.container[l_46_0.field]
  l_46_0:clearFields()
  local fieldNames = {}
  for name,fieldSchema in pairs(l_46_0.schema.fieldSchemas) do
    table.insert(fieldNames, name)
  end
  table.sort(fieldNames)
  for index,name in ipairs(fieldNames) do
    l_46_0:addField(object, name, l_46_0.schema.fieldSchemas[name])
  end
  l_46_0:requestResize()
  ParameterizedFieldGui.onValueSet(l_46_0, object)
end

local PolymorphicFieldGui = Class.create(ParameterizedFieldGui, "PolymorphicFieldGui")
PolymorphicFieldGui.init = function(l_47_0, l_47_1, l_47_2, l_47_3, l_47_4, l_47_5)
  ParameterizedFieldGui.init(l_47_0, l_47_1, l_47_2, l_47_3, l_47_4, l_47_5)
end

PolymorphicFieldGui.destroy = function(l_48_0)
  ParameterizedFieldGui.destroy(l_48_0)
  l_48_0.schema.identifierSchema:unregisterValueSetHandler(l_48_0.object, l_48_0.onIdentifierSet, l_48_0)
end

PolymorphicFieldGui.onValueSet = function(l_49_0)
  if l_49_0.object then
    l_49_0.schema.identifierSchema:unregisterValueSetHandler(l_49_0.object, l_49_0.onIdentifierSet, l_49_0)
  end
  l_49_0.object = l_49_0.container[l_49_0.field]
  l_49_0.schema.identifierSchema:registerValueSetHandler(l_49_0.object, l_49_0.onIdentifierSet, l_49_0)
  l_49_0:clearFields()
  l_49_0:addField(l_49_0.object, l_49_0.schema.identifierField, l_49_0.schema.identifierSchema)
  l_49_0:addTypeFields()
  l_49_0:requestResize()
  ParameterizedFieldGui.onValueSet(l_49_0, l_49_0.object)
end

PolymorphicFieldGui.addTypeFields = function(l_50_0)
  local type = l_50_0.object[l_50_0.schema.identifierField]
  local typeSchemas = l_50_0.schema.typeMap[type]
  local fieldNames = {}
  for name,fieldSchema in pairs(typeSchemas) do
    table.insert(fieldNames, name)
  end
  table.sort(fieldNames)
  for index,name in ipairs(fieldNames) do
    l_50_0:addField(l_50_0.object, name, typeSchemas[name])
  end
end

PolymorphicFieldGui.onIdentifierSet = function(l_51_0)
  l_51_0:clearFields(2)
  l_51_0:addTypeFields()
  l_51_0:requestResize()
end

local StringFieldGui = Class.create(FieldGui, "StringFieldGui")
StringFieldGui.init = function(l_52_0, l_52_1, l_52_2, l_52_3, l_52_4, l_52_5)
  FieldGui.init(l_52_0, l_52_1, l_52_2, l_52_3, l_52_4, l_52_5)
  l_52_0.label = LabelGui.new(l_52_0, "")
  l_52_0.left = LabelGui.new(l_52_0, "[", {color = l_52_0.HACK_COLOR, justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  l_52_0.right = LabelGui.new(l_52_0, "]", {color = l_52_0.HACK_COLOR, justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
  l_52_0:showBrackets(false)
  l_52_0:onValueSet(l_52_2[l_52_3])
end

StringFieldGui.onValueSet = function(l_53_0, l_53_1)
  local currentLength = #l_53_0.label.text
  l_53_0.label:setText(l_53_1)
  if #l_53_1 ~= currentLength then
    l_53_0:requestResize()
  end
  FieldGui.onValueSet(l_53_0, l_53_1)
end

StringFieldGui.handleFocusGain = function(l_54_0)
  FieldGui.handleFocusGain(l_54_0)
  l_54_0:showBrackets(true)
end

StringFieldGui.handleFocusLoss = function(l_55_0)
  FieldGui.handleFocusLoss(l_55_0)
  l_55_0:showBrackets(false)
end

StringFieldGui.handleMotiveStart = function(l_56_0, l_56_1)
  if l_56_1 == "Select" or l_56_1 == "Interact" then
    l_56_0:openEditGui(StringEditGui.new(l_56_0, l_56_0.container, l_56_0.field, l_56_0.schema))
    return 
  end
  FieldGui.handleMotiveStart(l_56_0, l_56_1)
end

StringFieldGui.showBrackets = function(l_57_0, l_57_1)
  l_57_0.left:show(l_57_1)
  l_57_0.right:show(l_57_1)
end

StringFieldGui.measure = function(l_58_0, l_58_1, l_58_2)
  local labelX, labelY = l_58_0.label:measure(l_58_1, l_58_2)
  local leftX, leftY = l_58_0.left:measure(l_58_1, l_58_2)
  local rightX, rightY = l_58_0.right:measure(l_58_1, l_58_2)
  return leftX + labelX + rightX, math.max(labelY, leftY, rightY)
end

StringFieldGui.resize = function(l_59_0, l_59_1, l_59_2)
  FieldGui.resize(l_59_0, l_59_1, l_59_2)
  local labelX, labelY = l_59_0.label:measure(l_59_1, l_59_2)
  local leftX, leftY = l_59_0.left:measure(l_59_1, l_59_2)
  local rightX, rightY = l_59_0.right:measure(l_59_1, l_59_2)
  l_59_0.left:position(l_59_1 - rightX - labelX - leftX, 0, l_59_1 - rightX - labelX, l_59_2)
  l_59_0.label:position(l_59_1 - rightX - labelX, 0, l_59_1 - rightX, l_59_2)
  l_59_0.right:position(l_59_1 - rightX, 0, l_59_1, l_59_2)
end

FieldGui.VALUE_SPACER = 32
FieldGui.create = function(l_60_0, l_60_1, l_60_2, l_60_3, l_60_4)
  local guiClass = nil
  if l_60_3.guiClass then
    guiClass = l_60_3.guiClass
  else
    if l_60_3:is(Class.BooleanSchema) then
      guiClass = BooleanFieldGui
    else
      if l_60_3:is(Class.EnumSchema) then
        guiClass = EnumFieldGui
      else
        if l_60_3:is(Class.IntegerSchema) then
          guiClass = NumberFieldGui
        else
          if l_60_3:is(Class.ScalarSchema) then
            guiClass = NumberFieldGui
          else
            if l_60_3:is(Class.NumberSchema) then
              guiClass = NumberFieldGui
            else
              if l_60_3:is(Class.StringSchema) then
                guiClass = StringFieldGui
              else
                if l_60_3:is(Class.ArraySchema) then
                  guiClass = ArrayFieldGui
                else
                  if l_60_3:is(Class.ObjectSchema) then
                    guiClass = ObjectFieldGui
                  else
                    if l_60_3:is(Class.PolymorphicSchema) then
                      guiClass = PolymorphicFieldGui
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if not guiClass then
    error("Unsupported field schema type '" .. l_60_3:name() .. "'")
  end
  return guiClass.new(l_60_0, l_60_1, l_60_2, l_60_3, l_60_4)
end

FieldGui.init = function(l_61_0, l_61_1, l_61_2, l_61_3, l_61_4, l_61_5)
  Gui.init(l_61_0, l_61_1)
  l_61_0.container, l_61_0.field, l_61_0.schema, l_61_0.entity = l_61_2, l_61_3, l_61_4, l_61_5
  l_61_0.schema:registerValueSetHandler(l_61_0.container, l_61_0.onValueSet, l_61_0)
end

FieldGui.destroy = function(l_62_0)
  Gui.destroy(l_62_0)
  l_62_0.schema:unregisterValueSetHandler(l_62_0.container, l_62_0.onValueSet, l_62_0)
end

FieldGui.onValueSet = function(l_63_0, l_63_1)
end

FieldGui.isParameterized = function(l_64_0)
  return false
end

FieldGui.isEditable = function(l_65_0)
  return true
end

FieldGui.openEditGui = function(l_66_0, l_66_1)
  l_66_0.editGui = l_66_1
  l_66_0.editGui.dismissEvent:register(l_66_0.onEditGuiDismiss, l_66_0)
  l_66_0.editGui:captureInput(true)
  l_66_0.root:setFocus(l_66_0.editGui)
  l_66_0:requestResize()
end

FieldGui.onEditGuiDismiss = function(l_67_0)
  l_67_0.editGui:destroy()
  l_67_0.editGui = nil
  l_67_0.root:setFocus(l_67_0)
end

FieldGui.onChildRequestResize = function(l_68_0, l_68_1)
  if l_68_1 == l_68_0.editGui then
    l_68_0:positionEditGui()
  else
    Gui.onChildRequestResize(l_68_0, l_68_1)
  end
end

FieldGui.resize = function(l_69_0, l_69_1, l_69_2)
  Gui.resize(l_69_0, l_69_1, l_69_2)
  if l_69_0.editGui then
    l_69_0:positionEditGui()
  end
end

FieldGui.positionEditGui = function(l_70_0)
  local editX, editY = l_70_0.editGui:measure(l_70_0.root.sizeX, l_70_0.root.sizeY)
  l_70_0.editGui:positionClamped(0, l_70_0.sizeY * 0.5 - editY * 0.5, editX, l_70_0.sizeY * 0.5 + editY * 0.5)
end

return FieldGui

