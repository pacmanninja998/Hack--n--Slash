-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\InventoryGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local InventoryGui = Class.create(Gui, "InventoryGui")
local ControllerComponent = require("Components.ControllerComponent")
local InventoryComponent = require("Components.InventoryComponent")
local ItemGui = Gui.load("Content/Game/Global/Gui/ItemGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local SpriteSheet = require("SpriteSheet")
InventoryGui.ITEM_WIDTH = 180
InventoryGui.ITEM_HEIGHT = 180
InventoryGui.ITEM_SPACING = 25
InventoryGui.init = function(l_1_0, l_1_1)
  Class.super(InventoryGui).init(l_1_0, l_1_1)
  l_1_0.entity = l_1_1.entity.entity
  l_1_0.controller = l_1_0.entity:get(ControllerComponent)
  l_1_0.inventory = l_1_0.entity:get(InventoryComponent)
  l_1_0.inventory.itemInsertedEvent:register(l_1_0.onInventoryChanged, l_1_0)
  l_1_0.inventory.itemRemovedEvent:register(l_1_0.onInventoryChanged, l_1_0)
  l_1_0.inventory.itemEquipPrimaryEvent:register(l_1_0.onInventoryChanged, l_1_0)
  l_1_0.inventory.itemEquipSlotEvent:register(l_1_0.onInventoryChanged, l_1_0)
  l_1_0.firstVisible = 1
  l_1_0.itemGuis = {}
  l_1_0:rebuild()
  l_1_0:setCursor(1)
end

InventoryGui.onInventoryChanged = function(l_2_0)
  l_2_0:rebuild()
  if #l_2_0.inventory.items < l_2_0.cursor then
    l_2_0:setCursor(#l_2_0.inventory.items)
  end
end

InventoryGui.handleFocusGain = function(l_3_0)
  l_3_0:updateDescription()
end

InventoryGui.handleFocusLoss = function(l_4_0)
  l_4_0.parent:setDescription("")
end

InventoryGui.rebuild = function(l_5_0)
  for index,item in ipairs(l_5_0.itemGuis) do
    item:destroy()
  end
  l_5_0.itemGuis = {}
  if l_5_0.cursorGui then
    l_5_0.cursorGui:destroy()
  end
  l_5_0.cursorGui = SpriteGui.new(l_5_0, SpriteSheet.load("UI/ItemIcons/ItemSlotCursor/ItemSlotCursor"), "ItemSlotCursor", {blinkDuration = 0.5})
  for index,item in ipairs(l_5_0.inventory.items) do
    local itemGui = ItemGui.new(l_5_0, l_5_0.inventory, l_5_0.controller, item)
    table.insert(l_5_0.itemGuis, itemGui)
  end
  l_5_0:requestResize()
end

InventoryGui.handleMoveMotive = function(l_6_0, l_6_1)
  local x = math.floor((l_6_0.cursor - 1) % l_6_0.itemsPerRow)
  local y = math.floor((l_6_0.cursor - 1) / l_6_0.itemsPerRow)
  if l_6_1 == "Up" then
    y = y - 1
  elseif l_6_1 == "Down" then
    y = y + 1
  elseif l_6_1 == "Left" then
    x = x - 1
  elseif l_6_1 == "Right" then
    x = x + 1
  else
    return false
  end
  if x < 0 then
    x = 0
  elseif l_6_0.itemsPerRow <= x then
    x = l_6_0.itemsPerRow - 1
  end
  if y < 0 then
    y = 0
  else
    local totalRows = math.max(1, math.ceil(#l_6_0.itemGuis / l_6_0.itemsPerRow))
    if totalRows <= y then
      y = totalRows - 1
    end
  end
  local cursor = (y) * l_6_0.itemsPerRow + (x) + 1
  if #l_6_0.itemGuis < cursor then
    cursor = #l_6_0.itemGuis
  elseif cursor < 1 then
    cursor = 1
  end
  l_6_0:setCursor(cursor)
  return true
end

InventoryGui.updateDescription = function(l_7_0)
  l_7_0.parent:setDescription(l_7_0.cursorItem and l_7_0.cursorItem:getDescription() or "")
end

InventoryGui.setCursor = function(l_8_0, l_8_1)
  if l_8_0.cursor == l_8_1 then
    return 
  end
  l_8_0.cursor = l_8_1
  if l_8_0.cursorItem then
    l_8_0.cursorItem.stateUpdateEvent:unregister(l_8_0.onCursorItemStateUpdate, l_8_0)
  end
  l_8_0.cursorItem = l_8_0.inventory.items[l_8_0.cursor]
  if l_8_0.cursorItem then
    l_8_0.cursorItem.stateUpdateEvent:register(l_8_0.onCursorItemStateUpdate, l_8_0)
  end
  l_8_0:updateDescription()
  l_8_0.cursorGui:reset()
  l_8_0:requestResize()
end

InventoryGui.onCursorItemStateUpdate = function(l_9_0)
  l_9_0:updateDescription()
end

InventoryGui.handleMotive = function(l_10_0, l_10_1, l_10_2)
  if l_10_0:handleMoveMotive(l_10_1) then
    l_10_0:playCue("UI/Hacking_UI/Inventory_Navigate")
    return 
  elseif l_10_1 == "UsePrimary" then
    l_10_0:playCue("UI/Hacking_UI/Inventory_SelectItem")
    l_10_0.inventory:equipPrimaryItem(l_10_0.cursor)
  elseif l_10_1 == "Use1" then
    l_10_0:playCue("UI/Hacking_UI/Inventory_SelectItem")
    l_10_0.inventory:equipSlotItem(1, l_10_0.cursor)
  elseif l_10_1 == "Use2" then
    l_10_0:playCue("UI/Hacking_UI/Inventory_SelectItem")
    l_10_0.inventory:equipSlotItem(2, l_10_0.cursor)
  elseif l_10_1 == "Use3" then
    l_10_0:playCue("UI/Hacking_UI/Inventory_SelectItem")
    l_10_0.inventory:equipSlotItem(3, l_10_0.cursor)
  elseif l_10_1 == "Use4" then
    l_10_0:playCue("UI/Hacking_UI/Inventory_SelectItem")
    l_10_0.inventory:equipSlotItem(4, l_10_0.cursor)
  else
    Gui.handleMotive(l_10_0, l_10_1, l_10_2)
  end
end

InventoryGui.resize = function(l_11_0, l_11_1, l_11_2)
  Gui.resize(l_11_0, l_11_1, l_11_2)
  local totalItemWidth = l_11_0.ITEM_WIDTH + l_11_0.ITEM_SPACING
  l_11_0.itemsPerRow = math.max(1, math.floor(l_11_1 / totalItemWidth))
  local totalItemHeight = l_11_0.ITEM_HEIGHT + l_11_0.ITEM_SPACING
  l_11_0.itemsPerColumn = math.max(1, math.floor(l_11_2 / totalItemHeight))
  local totalRows = math.max(1, math.ceil(#l_11_0.itemGuis / l_11_0.itemsPerRow))
  if #l_11_0.itemGuis == 0 then
    l_11_0.cursorGui:show(false)
    return 
  end
  if #l_11_0.itemGuis < l_11_0.cursor then
    l_11_0.cursor = #l_11_0.itemGuis
  end
  local cursorRow = math.floor((l_11_0.cursor - 1) / l_11_0.itemsPerRow)
  if l_11_0.cursor < l_11_0.firstVisible then
    l_11_0.firstVisible = cursorRow * l_11_0.itemsPerRow + 1
  else
    if l_11_0.firstVisible + l_11_0.itemsPerColumn * l_11_0.itemsPerRow <= l_11_0.cursor then
      l_11_0.firstVisible = (cursorRow - (l_11_0.itemsPerColumn - 1)) * l_11_0.itemsPerRow + 1
    end
  end
  l_11_0.cursorGui:show(false)
  for index = 1, l_11_0.firstVisible - 1 do
    l_11_0.itemGuis[index]:show(false)
  end
  local visible = l_11_0.firstVisible
  for j = 1, l_11_0.itemsPerColumn do
    for i = 1, l_11_0.itemsPerRow do
      local x = (i - 1) * (l_11_0.ITEM_WIDTH + l_11_0.ITEM_SPACING) + l_11_0.ITEM_SPACING
      local y = l_11_2 - j * (l_11_0.ITEM_HEIGHT + l_11_0.ITEM_SPACING) + l_11_0.ITEM_SPACING
      local item = l_11_0.itemGuis[visible]
      if item then
        item:show(true)
        item:position(x, y, x + l_11_0.ITEM_WIDTH, y + l_11_0.ITEM_HEIGHT)
        if l_11_0.cursor == visible then
          l_11_0.cursorGui:show(true)
          l_11_0.cursorGui:position(x, y, x + l_11_0.ITEM_WIDTH, y + l_11_0.ITEM_HEIGHT)
        end
      end
      visible = visible + 1
    end
  end
  for index = visible, #l_11_0.itemGuis do
    l_11_0.itemGuis[index]:show(false)
  end
end

return InventoryGui

