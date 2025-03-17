-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ItemGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local ItemGui = Class.create(Gui, "ItemGui")
local SpriteSheet = require("SpriteSheet")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
ItemGui.SLOT_HEIGHT = 40
ItemGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0, l_1_1)
  l_1_0.controller = l_1_3
  l_1_0.inventory = l_1_2
  l_1_0.item = l_1_4
  l_1_0.item.stateUpdateEvent:register(l_1_0.onItemStateUpdate, l_1_0)
  l_1_0.controller.modeChangeEvent:register(l_1_0.onControllerModeChange, l_1_0)
  l_1_0.inventory.itemEquipPrimaryEvent:register(l_1_0.onItemEquipChange, l_1_0)
  l_1_0.inventory.itemEquipSlotEvent:register(l_1_0.onItemEquipChange, l_1_0)
  l_1_0.background = SpriteGui.new(l_1_0, SpriteSheet.load("UI/ItemIcons/ItemSlot/ItemSlot"), "ItemSlot")
  l_1_0.sprite = SpriteGui.new(l_1_0)
  l_1_0.slot = SpriteGui.new(l_1_0, l_1_0.controller.sheet)
  l_1_0:updateSlot()
  l_1_0:onItemStateUpdate()
end

ItemGui.onControllerModeChange = function(l_2_0)
  l_2_0:updateSlot()
end

ItemGui.onItemStateUpdate = function(l_3_0)
  if not l_3_0.parent then
    return 
  end
  local path, name = l_3_0.item:getSprite(l_3_0.parent.entity)
  local sheet = SpriteSheet.load(path)
  l_3_0.sprite:setSprite(sheet, name)
end

ItemGui.onItemEquipChange = function(l_4_0)
  l_4_0:updateSlot()
end

ItemGui.getPrimaryName = function(l_5_0)
  return l_5_0.controller.promptMap.UsePrimary
end

ItemGui.getSlotName = function(l_6_0, l_6_1)
  return l_6_0.controller.promptMap.Use" .. l_6_
end

ItemGui.resize = function(l_7_0, l_7_1, l_7_2)
  Gui.resize(l_7_0, l_7_1, l_7_2)
  l_7_0.background:position(0, 0, l_7_1, l_7_2)
  l_7_0.sprite:position(0, 0, l_7_1, l_7_2)
  if l_7_0.slot.name then
    local slotX, slotY = l_7_0.slot.spritesheet:getDimensions(l_7_0.slot.name)
    slotX, slotY = ItemGui.SLOT_HEIGHT * slotX / slotY, ItemGui.SLOT_HEIGHT
    l_7_0.slot:position(l_7_1 - slotX, 0, l_7_1, slotY)
  end
end

ItemGui.updateSlot = function(l_8_0)
  local name = nil
  if l_8_0.inventory.primary == l_8_0.item then
    name = l_8_0:getPrimaryName()
  else
    for slot,item in pairs(l_8_0.inventory.slots) do
      if item == l_8_0.item then
        name = l_8_0:getSlotName(slot)
    else
      end
    end
    if name then
      l_8_0.slot:setSprite(l_8_0.controller.sheet, name)
      l_8_0.slot:show(true)
      l_8_0:requestResize()
    else
      l_8_0.slot:show(false)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ItemGui

