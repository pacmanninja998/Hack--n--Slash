-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ArrayEditGui.lua 

local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local HorizontalLayoutGui = Gui.load("Content/Game/Global/Gui/HorizontalLayoutGui")
local ArrayEditGui = require("Class").create(HackFramedGui, "ArrayEditGui")
ArrayEditGui.ElementGui = require("Class").create(Gui, "ArrayEditGui.ElementGui")
ArrayEditGui.ElementGui.HACK_COLOR = {0.44705882352941, 0.99607843137255, 0.9921568627451}
ArrayEditGui.ElementGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Gui.init(l_1_0, l_1_1)
  local FieldGui = Gui.load("Content/Game/Global/Gui/FieldGui")
  local createLabel = function(l_1_0, l_1_1)
    local gui = LabelGui.new(l_1_0, l_1_1, {color = self.HACK_COLOR, justifyHorizontal = MOAITextBox.CENTER_JUSTIFY})
    if l_1_0 ~= self then
      l_1_0:insert(gui)
    end
    return gui
   end
  l_1_0.columnSizes = {0, 0, 0, 0}
  l_1_0.index = createLabel(l_1_0)
  l_1_0.fieldContainer = HorizontalLayoutGui.new(l_1_0)
  l_1_0.field = FieldGui.create(l_1_0.fieldContainer, l_1_2, l_1_3, l_1_4, l_1_5)
  if not l_1_0.field:isParameterized() then
    l_1_0.fieldLeft = createLabel(l_1_0.fieldContainer, "[")
  end
  l_1_0.fieldContainer:insert(l_1_0.field)
  if not l_1_0.field:isParameterized() then
    l_1_0.fieldRight = createLabel(l_1_0.fieldContainer, "]")
  end
  l_1_0.moveContainer = HorizontalLayoutGui.new(l_1_0)
  l_1_0.moveLeft = createLabel(l_1_0.moveContainer, "[")
  l_1_0.move = createLabel(l_1_0.moveContainer, "move")
  l_1_0.moveRight = createLabel(l_1_0.moveContainer, "]")
  l_1_0.deleteContainer = HorizontalLayoutGui.new(l_1_0)
  l_1_0.deleteLeft = createLabel(l_1_0.deleteContainer, "[")
  l_1_0.delete = createLabel(l_1_0.deleteContainer, "delete")
  l_1_0.deleteRight = createLabel(l_1_0.deleteContainer, "]")
  l_1_0:updateBrackets()
  l_1_0:setIndex(l_1_3)
end

ArrayEditGui.ElementGui.setColumnSizes = function(l_2_0, l_2_1)
  l_2_0.columnSizes = l_2_1
  if l_2_0.field:isParameterized() then
    local fieldColumnSizes = {}
    for i = 2, #l_2_0.columnSizes - 3 do
      table.insert(fieldColumnSizes, l_2_1[i])
    end
    l_2_0.field:setColumnSizes(fieldColumnSizes)
  end
end

ArrayEditGui.ElementGui.countColumns = function(l_3_0)
  local columnCount = 3
  if not l_3_0.field:isParameterized() then
    return columnCount + 1
  else
    return columnCount + #l_3_0.field.containers
  end
end

ArrayEditGui.ElementGui.measureColumns = function(l_4_0, l_4_1, l_4_2, l_4_3)
  local columns = {}
  for i = 1, l_4_1 do
    columns[i] = 0
  end
  local indexX, indexY = l_4_0.index:measure(l_4_2, l_4_3)
  columns[1] = indexX
  if not l_4_0.field:isParameterized() then
    local fieldX, fieldY = l_4_0.fieldContainer:measure(l_4_2, l_4_3)
    columns[2] = fieldX
  else
    for index,container in ipairs(l_4_0.field.containers) do
      local containerX, containerY = container:measure(l_4_2, l_4_3)
      columns[1 + index] = containerX
    end
  end
  local moveX, moveY = l_4_0.moveContainer:measure(l_4_2, l_4_3)
  columns[l_4_1 - 1] = moveX
  local deleteX, deleteY = l_4_0.deleteContainer:measure(l_4_2, l_4_3)
  columns[l_4_1] = moveX
  return columns
end

ArrayEditGui.ElementGui.setIndex = function(l_5_0, l_5_1)
  l_5_0.field.field = l_5_1
  l_5_0.index:setText(tostring(l_5_1))
end

ArrayEditGui.ElementGui.handleFocusGain = function(l_6_0)
  l_6_0:updateBrackets()
end

ArrayEditGui.ElementGui.handleFocusLoss = function(l_7_0)
  l_7_0:updateBrackets()
end

ArrayEditGui.ElementGui.isColumnSelectable = function(l_8_0, l_8_1)
  if #l_8_0.columnSizes - 1 <= l_8_1 then
    return true
  end
  if l_8_1 > 1 then
    if not l_8_0.field:isParameterized() then
      return l_8_0.field:isEditable()
    else
      if l_8_0.field.containers[l_8_1 - 1] then
        return true
      end
    end
  end
  return false
end

ArrayEditGui.ElementGui.setColumn = function(l_9_0, l_9_1)
  l_9_0.column = l_9_1
  l_9_0:updateBrackets()
end

ArrayEditGui.ElementGui.updateBrackets = function(l_10_0)
  local hasFocus = l_10_0:hasFocus()
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if hasFocus and l_10_0.column ~= 2 then
    l_10_0.fieldLeft:show(l_10_0.field:isParameterized())
  end
  l_10_0.fieldRight:show(not hasFocus or l_10_0.column == 2)
  do return end
  if hasFocus and l_10_0.column and l_10_0.column > 1 and l_10_0.column < #l_10_0.columnSizes - 1 then
    l_10_0.field:setColumn(l_10_0.column - 1)
  else
    l_10_0.field:setColumn()
  end
  l_10_0.moveLeft:show(not hasFocus or l_10_0.column == #l_10_0.columnSizes - 1)
  l_10_0.moveRight:show(not hasFocus or l_10_0.column == #l_10_0.columnSizes - 1)
  l_10_0.deleteLeft:show(not hasFocus or l_10_0.column == #l_10_0.columnSizes)
  l_10_0.deleteRight:show(not hasFocus or l_10_0.column == #l_10_0.columnSizes)
end

ArrayEditGui.ElementGui.measure = function(l_11_0, l_11_1, l_11_2)
  local totalX = 0
  for index,columnSize in pairs(l_11_0.columnSizes) do
    totalX = totalX + columnSize
  end
  local fieldX, fieldY = l_11_0.field:measure(l_11_1, l_11_2)
  return totalX, fieldY
end

ArrayEditGui.ElementGui.resize = function(l_12_0, l_12_1, l_12_2)
  Gui.resize(l_12_0, l_12_1, l_12_2)
  local columnCount = #l_12_0.columnSizes
  l_12_0.deleteContainer:position(l_12_1 - l_12_0.columnSizes[columnCount], 0, l_12_1, l_12_2)
  l_12_1 = l_12_1 - l_12_0.columnSizes[columnCount]
  l_12_0.moveContainer:position(l_12_1 - l_12_0.columnSizes[columnCount - 1], 0, l_12_1, l_12_2)
  l_12_1 = l_12_1 - l_12_0.columnSizes[columnCount - 1]
  l_12_0.index:position(0, 0, l_12_0.columnSizes[1], l_12_2)
  l_12_0.fieldContainer:position(l_12_0.columnSizes[1], 0, l_12_1, l_12_2)
  if l_12_0.editGui then
    l_12_0:placeEditGui()
  end
end

ArrayEditGui.ElementGui.editField = function(l_13_0)
  local EditGui = Gui.load("Content/Game/Global/Gui/EditGui")
  local editGui = EditGui.new(l_13_0, tostring(l_13_0.field.field), l_13_0.field.entity)
  editGui:addField(l_13_0.field.container, l_13_0.field.field, l_13_0.field.schema)
  l_13_0:openEditGui(editGui)
end

ArrayEditGui.ElementGui.openEditGui = function(l_14_0, l_14_1)
  l_14_0.editGui = l_14_1
  l_14_0.editGui.dismissEvent:register(l_14_0.onEditGuiDismiss, l_14_0)
  l_14_0:captureInput(true)
  l_14_0.root:setFocus(l_14_0.editGui)
  l_14_0:placeEditGui()
end

ArrayEditGui.ElementGui.onEditGuiDismiss = function(l_15_0)
  l_15_0.editGui:destroy()
  l_15_0.editGui = nil
  l_15_0:captureInput(false)
  l_15_0.root:setFocus(l_15_0)
end

ArrayEditGui.ElementGui.beginMove = function(l_16_0)
  l_16_0.moving = true
  l_16_0.move:setText("stop")
end

ArrayEditGui.ElementGui.endMove = function(l_17_0)
  l_17_0.moving = false
  l_17_0.move:setText("move")
end

ArrayEditGui.ElementGui.placeEditGui = function(l_18_0)
  local editX, editY = l_18_0.editGui:measure(l_18_0.root.sizeX, l_18_0.root.sizeY)
  l_18_0.editGui:positionClamped(l_18_0.sizeX * 0.5 - editX * 0.5, l_18_0.sizeY * 0.5 - editY * 0.5, l_18_0.sizeX * 0.5 + editX * 0.5, l_18_0.sizeY * 0.5 + editY * 0.5)
end

ArrayEditGui.ElementGui.handleMotiveStart = function(l_19_0, l_19_1)
  if not l_19_0.moving and not l_19_0.editGui and l_19_1 == "Select" then
    if l_19_0.column == #l_19_0.columnSizes - 1 then
      l_19_0.parent.parent:beginMove(l_19_0.field.field)
    else
      if l_19_0.column == #l_19_0.columnSizes then
        table.remove(l_19_0.field.container, l_19_0.field.field)
      else
        if not l_19_0.field:isParameterized() then
          l_19_0:editField()
        else
          local value = l_19_0.field.values[l_19_0.column - 1]
          local EditGui = Gui.load("Content/Game/Global/Gui/EditGui")
          local editGui = EditGui.new(l_19_0, tostring(value.field), l_19_0.entity)
          editGui:addField(l_19_0.field.container[l_19_0.field.field], value.field, value.schema)
          l_19_0:openEditGui(editGui)
        end
      end
    end
    return 
  end
  Gui.handleMotiveStart(l_19_0, l_19_1)
end

ArrayEditGui.init = function(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4, l_20_5, l_20_6)
  HackFramedGui.init(l_20_0, l_20_1, tostring(l_20_3), l_20_5)
  l_20_0.container, l_20_0.field, l_20_0.schema, l_20_0.entity, l_20_0.createHandler = l_20_2, l_20_3, l_20_4, l_20_5, l_20_6
  l_20_0.column = 2
  local list = ListGui.new(l_20_0)
  list.selectionChangeEvent:register(l_20_0.onListSelectionChange, l_20_0)
  l_20_0:setHackInnerGui(list)
  l_20_0.dismissEvent = Delegate.new()
  l_20_4:registerValueSetHandler(l_20_2, l_20_0.onValueSet, l_20_0)
  l_20_0:onValueSet(l_20_0.container[l_20_0.field])
end

ArrayEditGui.destroy = function(l_21_0)
  HackFramedGui.destroy(l_21_0)
  l_21_0:unregister()
end

ArrayEditGui.unregister = function(l_22_0)
  if l_22_0.array then
    l_22_0.schema:unregisterInsertHandler(l_22_0.array, l_22_0.onArrayInsert, l_22_0)
    l_22_0.schema:unregisterRemoveHandler(l_22_0.array, l_22_0.onArrayRemove, l_22_0)
    l_22_0.schema:unregisterSetHandler(l_22_0.array, l_22_0.onArraySet, l_22_0)
  end
end

ArrayEditGui.onListSelectionChange = function(l_23_0, l_23_1)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_23_0.movingIndex and l_23_0.movingIndex ~= l_23_1 then
    if #l_23_0.array < l_23_1 then
      if l_23_0.movingIndex == #l_23_0.array then
        l_23_0.inner:setSelection(1)
      else
        l_23_0.inner:setSelection(#l_23_0.array)
      end
    else
      local sourceIndex = l_23_0.movingIndex
      local source = l_23_0.array[sourceIndex]
      do
        local target = l_23_0.array[l_23_1]
        l_23_0.array[l_23_1] = source
        l_23_0.array[sourceIndex] = target
        l_23_0:beginMove(l_23_1)
      end
      do return end
      if l_23_1 and l_23_1 < #l_23_0.inner.guis then
        local element = l_23_0.inner.guis[l_23_1]
        repeat
          if l_23_0.column > 0 and not element:isColumnSelectable(l_23_0.column) then
            l_23_0:setColumn(l_23_0.column - 1)
          else
            element:setColumn(l_23_0.column)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ArrayEditGui.onValueSet = function(l_24_0, l_24_1)
  l_24_0:unregister()
  l_24_0.array = l_24_1
  l_24_0.schema:registerInsertHandler(l_24_1, l_24_0.onArrayInsert, l_24_0)
  l_24_0.schema:registerRemoveHandler(l_24_1, l_24_0.onArrayRemove, l_24_0)
  l_24_0.schema:registerSetHandler(l_24_1, l_24_0.onArraySet, l_24_0)
  local list = l_24_0.inner
  list:clear()
  list:insert(LabelGui.new(list, "[+]"))
  for index,value in ipairs(l_24_1) do
    l_24_0:onArrayInsert(index, value)
  end
  list:setSelection(1)
end

ArrayEditGui.beginMove = function(l_25_0, l_25_1)
  l_25_0.movingIndex = l_25_1
  l_25_0.inner.guis[l_25_0.movingIndex]:beginMove()
  l_25_0:redoLayout()
end

ArrayEditGui.endMove = function(l_26_0)
  if l_26_0.movingIndex then
    l_26_0.inner.guis[l_26_0.movingIndex]:endMove()
    l_26_0.movingIndex = nil
  end
end

ArrayEditGui.onArrayInsert = function(l_27_0, l_27_1, l_27_2)
  l_27_0:endMove()
  local gui = l_27_0.ElementGui.new(l_27_0.inner, l_27_0.container[l_27_0.field], l_27_1, l_27_0.schema.elementSchema, l_27_0.entity)
  l_27_0.inner:insert(l_27_1, gui)
  for i = l_27_1 + 1, #l_27_0.inner.guis - 1 do
    l_27_0.inner.guis[i]:setIndex(i)
  end
end

ArrayEditGui.onArrayRemove = function(l_28_0, l_28_1)
  l_28_0:endMove()
  l_28_0.inner:remove(l_28_1)
  for i = l_28_1, #l_28_0.inner.guis - 1 do
    l_28_0.inner.guis[i]:setIndex(i)
  end
end

ArrayEditGui.onArraySet = function(l_29_0, l_29_1, l_29_2)
  l_29_0:endMove()
  local wasSelection = l_29_1 == l_29_0.inner.selectionIndex
  l_29_0:onArrayRemove(l_29_1)
  l_29_0:onArrayInsert(l_29_1, l_29_2)
  if wasSelection then
    l_29_0.inner:setSelection(l_29_1)
  end
end

ArrayEditGui.measure = function(l_30_0, l_30_1, l_30_2)
  l_30_0:recomputeColumns(l_30_1, l_30_2)
  return HackFramedGui.measure(l_30_0, l_30_1, l_30_2)
end

ArrayEditGui.recomputeColumns = function(l_31_0, l_31_1, l_31_2)
  l_31_0.columnCount = 0
  for i = 1, #l_31_0.inner.guis - 1 do
    local guiColumns = l_31_0.inner.guis[i]:countColumns()
    if l_31_0.columnCount < guiColumns then
      l_31_0.columnCount = guiColumns
    end
  end
  local columnSizes = {}
  for i = 1, #l_31_0.inner.guis - 1 do
    local gui = l_31_0.inner.guis[i]
    local columns = gui:measureColumns(l_31_0.columnCount, l_31_1, l_31_2)
    for index,columnSize in ipairs(columns) do
      local currentColumnSize = columnSizes[index]
      if not currentColumnSize or currentColumnSize < columnSize then
        columnSizes[index] = columnSize
      end
    end
  end
  if l_31_0.columnCount < l_31_0.column then
    l_31_0:setColumn(l_31_0.columnCount)
  end
  for i = 1, #l_31_0.inner.guis - 1 do
    local gui = l_31_0.inner.guis[i]
    gui:setColumnSizes(columnSizes)
  end
end

ArrayEditGui.setColumn = function(l_32_0, l_32_1)
  l_32_0.column = l_32_1
  if l_32_0.inner.selectionIndex and l_32_0.inner.selectionIndex < #l_32_0.inner.guis then
    l_32_0.inner.guis[l_32_0.inner.selectionIndex]:setColumn(l_32_0.column)
  end
end

ArrayEditGui.handleMotiveStart = function(l_33_0, l_33_1)
  if l_33_1 == "Dismiss" then
    if l_33_0.movingIndex then
      l_33_0:endMove()
    else
      l_33_0.dismissEvent:dispatch()
      l_33_0.dismissed = true
    end
    return 
  elseif l_33_1 == "Select" then
    if l_33_0.movingIndex then
      l_33_0:endMove()
    else
      if l_33_0.inner.selectionIndex == #l_33_0.inner.guis then
        if not l_33_0.createHandler then
          local value = l_33_0.schema.elementSchema:getDefault()
          local array = l_33_0.container[l_33_0.field]
          table.insert(array, value)
          l_33_0.inner:setSelection(#array)
        else
          l_33_0.createHandler()
        end
      end
    end
    return 
  elseif l_33_1 == "Left" or l_33_1 == "Right" then
    if not l_33_0.movingIndex and l_33_0.inner.selectionIndex < #l_33_0.inner.guis then
      local item = l_33_0.inner.guis[l_33_0.inner.selectionIndex]
      local delta = l_33_1 == "Left" and -1 or 1
      local column = l_33_0.column
      repeat
        repeat
          column = 1 + (column + delta - 1) % l_33_0.columnCount
        until item:isColumnSelectable(column)
        l_33_0:setColumn(column)
        do return end
      else
        return 
      end
      HackFramedGui.handleMotiveStart(l_33_0, l_33_1)
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ArrayEditGui

