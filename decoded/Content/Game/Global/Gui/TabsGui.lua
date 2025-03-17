-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\TabsGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local TabsGui = Class.create(Gui, "TabsGui")
local EntityRef = require("EntityRef")
local SpriteSheet = require("SpriteSheet")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local PromptGui = Gui.load("Content/Game/Global/Gui/PromptGui")
TabsGui.INVENTORY_TAB = 1
TabsGui.TAB_COUNT = TabsGui.INVENTORY_TAB
TabsGui.TAB_NAMES = {TabsGui.INVENTORY_TAB = "InventoryScreen"}
TabsGui.TAB_LABELS = {TabsGui.INVENTORY_TAB = "Inventory"}
TabsGui.TAB_POSITIONS = {TabsGui.INVENTORY_TAB = {338, 904, 588, 952}}
TabsGui.TAB_GUIS = {TabsGui.INVENTORY_TAB = Gui.load("Content/Game/Global/Gui/InventoryGui")}
TabsGui.FRAME_POSITION = {312, 296, 1600, 844}
TabsGui.DESCRIPTION_POSITION = {344, 176, 1568, 234}
TabsGui.DISMISS_PROMPT_POSITION = {1498, 878, 1562, 954}
TabsGui.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(TabsGui).init(l_1_0, l_1_1)
  l_1_0.entity = EntityRef.new(l_1_2)
  l_1_0.sheet = SpriteSheet.load("UI/MenuScreen/MenuScreen")
  l_1_0.background = SpriteGui.new(l_1_0, l_1_0.sheet)
  l_1_0.description = LabelGui.new(l_1_0, "")
  l_1_0.labels = {}
  l_1_0.tabs = {}
  for i = 1, l_1_0.TAB_COUNT do
    l_1_0.labels[i] = LabelGui.new(l_1_0, l_1_0.TAB_LABELS[i], {justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, color = {0.043137254901961, 0.074509803921569, 0.16862745098039, 1}})
    l_1_0.tabs[i] = l_1_0.TAB_GUIS[i].new(l_1_0)
  end
  l_1_0.prompt = PromptGui.new(l_1_0, l_1_2, "OpenTabs")
  if not l_1_2.state.currentTab then
    l_1_0:setCurrentTab(TabsGui.INVENTORY_TAB)
  end
end

TabsGui.setDescription = function(l_2_0, l_2_1)
  l_2_0.description:setText(l_2_1)
end

TabsGui.setCurrentTab = function(l_3_0, l_3_1)
  l_3_1 = 1 + (l_3_1 - 1) % l_3_0.TAB_COUNT
  if l_3_0.entity.entity then
    l_3_0.entity.entity.state.currentTab = l_3_1
  end
  if l_3_0.activeTab then
    l_3_0.activeTab:show(false)
  end
  l_3_0.activeTab = l_3_0.tabs[l_3_1]
  l_3_0.activeTab:show(true)
  l_3_0:setFocus(l_3_0.activeTab)
  l_3_0.background:setSprite(l_3_0.sheet, l_3_0.TAB_NAMES[l_3_1])
end

TabsGui.handleMotive = function(l_4_0, l_4_1)
  local tabIndex = l_4_0.entity.entity.state.currentTab
  if l_4_1 == "CycleLeft" then
    l_4_0:setCurrentTab(tabIndex - 1)
  elseif l_4_1 == "CycleRight" then
    l_4_0:setCurrentTab(tabIndex + 1)
  elseif l_4_1 == "Dismiss" then
    l_4_0.dismissed = true
  else
    Class.super(TabsGui).handleMotive(l_4_1)
  end
end

TabsGui.resize = function(l_5_0, l_5_1, l_5_2)
  Class.super(TabsGui).resize(l_5_0, l_5_1, l_5_2)
  l_5_0.background:position(0, 0, l_5_1, l_5_2)
  l_5_0.description:position(unpack(l_5_0.DESCRIPTION_POSITION))
  l_5_0.prompt:position(unpack(l_5_0.DISMISS_PROMPT_POSITION))
  for i = 1, l_5_0.TAB_COUNT do
    l_5_0.labels[i]:position(unpack(l_5_0.TAB_POSITIONS[i]))
    l_5_0.tabs[i]:position(unpack(l_5_0.FRAME_POSITION))
  end
end

return TabsGui

