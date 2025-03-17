-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\EquippedGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local EntityRef = require("EntityRef")
local SpriteSheet = require("SpriteSheet")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local ControllerComponent = require("Components.ControllerComponent")
local InventoryComponent = require("Components.InventoryComponent")
local EquippedGui = Class.create(Gui, "EquippedGui")
EquippedGui.SLOT_HEIGHT = 40
EquippedGui.ITEM_WIDTH = 144
EquippedGui.ITEM_HEIGHT = 144
EquippedGui.ITEM_SPACING = 8
EquippedGui.ChildGui = Class.create(Gui, "EquippedGui.ChildGui")
EquippedGui.ChildGui.init = function(l_1_0, l_1_1, l_1_2)
  Gui.init(l_1_0, l_1_1)
  local sheet = SpriteSheet.load("UI/ItemIcons/ItemSlot/ItemSlot")
  l_1_0.background = SpriteGui.new(l_1_0, sheet, l_1_2)
end

EquippedGui.ChildGui.resize = function(l_2_0, l_2_1, l_2_2)
  Gui.resize(l_2_0, l_2_1, l_2_2)
  l_2_0.background:position(0, 0, l_2_1, l_2_2)
  if l_2_0.sprite then
    l_2_0.sprite:position(0, 0, l_2_1, l_2_2)
  end
  if l_2_0.slotGui then
    local slotX, slotY = l_2_0.slotGui.spritesheet:getDimensions(l_2_0.slotGui.name)
    slotX, slotY = EquippedGui.SLOT_HEIGHT * slotX / slotY, EquippedGui.SLOT_HEIGHT
    l_2_0.slotGui:position(l_2_1 - slotX, 0, l_2_1, slotY)
  end
end

EquippedGui.ChildGui.rebuild = function(l_3_0)
  if l_3_0.sprite then
    l_3_0.sprite:destroy()
    l_3_0.sprite = nil
  end
  if l_3_0.slotGui then
    l_3_0.slotGui:destroy()
    l_3_0.slotGui = nil
  end
  if l_3_0.item then
    local path, name = l_3_0.item:getSprite(l_3_0.parent.entity)
    l_3_0.sprite = SpriteGui.new(l_3_0, SpriteSheet.load(path), name)
  end
  if l_3_0.slotSheet and l_3_0.slotName then
    l_3_0.slotGui = SpriteGui.new(l_3_0, l_3_0.slotSheet, l_3_0.slotName)
  end
  l_3_0:requestResize()
end

EquippedGui.ChildGui.setItem = function(l_4_0, l_4_1)
  if l_4_0.item then
    l_4_0.item.stateUpdateEvent:unregister(l_4_0.onItemStateUpdate, l_4_0)
  end
  l_4_0.item = l_4_1
  if l_4_0.item then
    l_4_0.item.stateUpdateEvent:register(l_4_0.onItemStateUpdate, l_4_0)
  end
  l_4_0:rebuild()
end

EquippedGui.ChildGui.onItemStateUpdate = function(l_5_0)
  l_5_0:rebuild()
end

EquippedGui.ChildGui.setSlot = function(l_6_0, l_6_1, l_6_2)
  l_6_0.slotSheet, l_6_0.slotName = l_6_1, l_6_2
  l_6_0:rebuild()
end

EquippedGui.PrimaryGui = Class.create(EquippedGui.ChildGui, "EquippedGui.PrimaryGui")
EquippedGui.PrimaryGui.init = function(l_7_0, l_7_1, l_7_2)
  EquippedGui.ChildGui.init(l_7_0, l_7_1, "Highlighted")
  l_7_0.inventory = l_7_2
  l_7_0.inventory.itemEquipPrimaryEvent:register(l_7_0.onItemEquipPrimary, l_7_0)
  l_7_0:onItemEquipPrimary(l_7_0.inventory.primary)
end

EquippedGui.PrimaryGui.setPrompt = function(l_8_0, l_8_1, l_8_2)
  l_8_0:setSlot(l_8_1, l_8_2.UsePrimary)
end

EquippedGui.PrimaryGui.onItemEquipPrimary = function(l_9_0, l_9_1)
  l_9_0:setItem(l_9_1)
end

EquippedGui.SlotGui = Class.create(EquippedGui.ChildGui, "EquippedGui.SlotGui")
EquippedGui.SlotGui.init = function(l_10_0, l_10_1, l_10_2, l_10_3)
  EquippedGui.ChildGui.init(l_10_0, l_10_1, "ItemSlot")
  l_10_0.inventory = l_10_2
  l_10_0.slot = l_10_3
  l_10_0.inventory.itemEquipSlotEvent:register(l_10_0.onItemEquipSlot, l_10_0)
  l_10_0:onItemEquipSlot(l_10_3, l_10_0.inventory.slots[l_10_3])
end

EquippedGui.SlotGui.setPrompt = function(l_11_0, l_11_1, l_11_2)
  l_11_0:setSlot(l_11_1, l_11_2.Use" .. l_11_0.slo)
end

EquippedGui.SlotGui.onItemEquipSlot = function(l_12_0, l_12_1, l_12_2)
  if l_12_1 == l_12_0.slot then
    l_12_0:setItem(l_12_2)
  end
end

EquippedGui.init = function(l_13_0, l_13_1, l_13_2)
  Gui.init(l_13_0, l_13_1)
  local inventory = l_13_2:get(InventoryComponent)
  l_13_0.entity = l_13_2
  l_13_0.primaryGui = EquippedGui.PrimaryGui.new(l_13_0, inventory)
  l_13_0.slotGuis = {}
  for slot = 1, InventoryComponent.SLOT_COUNT do
    table.insert(l_13_0.slotGuis, EquippedGui.SlotGui.new(l_13_0, inventory, slot))
  end
  local controller = l_13_2:get(ControllerComponent)
  controller.modeChangeEvent:register(l_13_0.onControllerModeChange, l_13_0)
  l_13_0:onControllerModeChange(controller.sheet, controller.promptMap)
end

EquippedGui.onControllerModeChange = function(l_14_0, l_14_1, l_14_2)
  l_14_0.primaryGui:setPrompt(l_14_1, l_14_2)
  for slot,gui in pairs(l_14_0.slotGuis) do
    gui:setPrompt(l_14_1, l_14_2)
  end
end

EquippedGui.resize = function(l_15_0, l_15_1, l_15_2)
  Gui.resize(l_15_0, l_15_1, l_15_2)
  local slotCount = InventoryComponent.SLOT_COUNT
  repeat
    if slotCount > 0 and not l_15_0.slotGuis[slotCount].item then
      local gui = l_15_0.slotGuis[slotCount]
      gui:position(0, 0, 0, 0)
      gui:show(false)
      slotCount = slotCount - 1
    do
      else
        local x = l_15_1 - (1 + (slotCount)) * (l_15_0.ITEM_WIDTH + l_15_0.ITEM_SPACING)
        l_15_0.primaryGui:show(l_15_0.primaryGui.item ~= nil)
        l_15_0.primaryGui:position(x, l_15_0.ITEM_SPACING, x + l_15_0.ITEM_WIDTH, l_15_0.ITEM_SPACING + l_15_0.ITEM_HEIGHT)
        for slot = 1, slotCount do
          local gui = l_15_0.slotGuis[slot]
          x = x + l_15_0.ITEM_WIDTH + l_15_0.ITEM_SPACING
          gui:show(true)
          gui:position(x, l_15_0.ITEM_SPACING, x + l_15_0.ITEM_WIDTH, l_15_0.ITEM_SPACING + l_15_0.ITEM_HEIGHT)
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return EquippedGui

