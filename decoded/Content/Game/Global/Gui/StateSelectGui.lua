-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\StateSelectGui.lua 

local Class = require("Class")
local Storage = require("Storage")
local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local StateSelectGui = Class.create(Gui, "StateSelectGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local ModsGui = Gui.load("Content/Game/Global/Gui/ModsGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local TextButtonGui = Gui.load("Content/Game/Global/Gui/TextButtonGui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local GameMenuGui = Gui.load("Content/Game/Global/Gui/GameMenuGui")
local HorizontalLayoutGui = Gui.load("Content/Game/Global/Gui/HorizontalLayoutGui")
StateSelectGui.Description = Class.create(Gui, "StateSelectGui.Description")
StateSelectGui.Description.HORIZONTAL_SPACER = 64
StateSelectGui.Description.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Gui.init(l_1_0, l_1_1)
  l_1_0.data = l_1_2
  local age = l_1_0.data.age
  if not age or type(age) ~= "number" then
    age = 0
  end
  local ageDescription = "<c:8>"
  local seconds = age % 60
  local minutes = math.floor((age - seconds) / 60) % 60
  local hours = math.floor((age - minutes - seconds) / 3600)
  if hours > 0 then
    ageDescription = ageDescription .. hours .. "h "
  end
  ageDescription = ageDescription .. minutes .. "m played</c>"
  l_1_0.nameLabel = LabelGui.new(l_1_0, l_1_0.data.name or "[unknown]", {justifyVertical = MOAITextBox.LEFT_JUSTIFY})
  l_1_0.dateLabel = LabelGui.new(l_1_0, "", {justifyHorizontal = MOAITextBox.RIGHT_JUSTIFY, justifyVertical = MOAITextBox.LEFT_JUSTIFY})
  l_1_0.ageLabel = LabelGui.new(l_1_0, ageDescription, {justifyHorizontal = MOAITextBox.RIGHT_JUSTIFY, justifyVertical = MOAITextBox.RIGHT_JUSTIFY})
  local timestamp = l_1_0.data.date
  if timestamp then
    local day, month, year, hour, minute, second = timestamp.day, timestamp.month, timestamp.year, timestamp.hour, timestamp.minute, timestamp.second
    if type(day) == "number" and type(month) == "number" and type(year) == "number" and type(hour) == "number" and type(minute) == "number" and type(second) == "number" then
      l_1_0.dateLabel:setText(string.format("%d:%02d:%02d %d/%02d/%04d", hour, minute, second, day, month, year))
    end
  end
  l_1_0.buttonBar = HorizontalLayoutGui.new(l_1_0)
  local continue = TextButtonGui.new(l_1_0.buttonBar, "Continue")
  continue.selectedEvent:register(l_1_0.onContinueSelected, l_1_0)
  local delete = TextButtonGui.new(l_1_0.buttonBar, "Delete")
  delete.selectedEvent:register(l_1_0.onDeleteSelected, l_1_0)
  l_1_0.buttonBar:insert(continue)
  l_1_0.buttonBar:insert(delete)
  if l_1_3 then
    local mods = TextButtonGui.new(l_1_0.buttonBar, "Active mods")
    mods.selectedEvent:register(l_1_0.onModsSelected, l_1_0)
    l_1_0.buttonBar:insert(l_1_3)
  end
end

StateSelectGui.Description.measure = function(l_2_0, l_2_1, l_2_2)
  local nameX, nameY = l_2_0.nameLabel:measure(l_2_1, l_2_2)
  local ageX, ageY = l_2_0.ageLabel:measure(l_2_1, l_2_2)
  local dateX, dateY = l_2_0.dateLabel:measure(l_2_1, l_2_2)
  local barX, barY = l_2_0.buttonBar:measure(l_2_1, l_2_2)
  return math.max(barX, nameX + l_2_0.HORIZONTAL_SPACER + math.max(ageX, dateX)), math.max(nameY, ageY + dateY, barY)
end

StateSelectGui.Description.resize = function(l_3_0, l_3_1, l_3_2)
  local barX, barY = l_3_0.buttonBar:measure(l_3_1, l_3_2)
  l_3_0.buttonBar:position(0, 0, l_3_1, barY)
  l_3_0.nameLabel:position(0, barY, l_3_1, l_3_2)
  l_3_0.ageLabel:position(0, barY, l_3_1, l_3_2)
  l_3_0.dateLabel:position(0, barY, l_3_1, l_3_2)
end

StateSelectGui.init = function(l_4_0, l_4_1, l_4_2)
  Gui.init(l_4_0, l_4_1)
  l_4_0.userState = l_4_2
  l_4_0.menu = HackFramedGui.new(l_4_0, "Game select")
  l_4_0.list = ListGui.new(l_4_0.menu, ListGui.DEFAULT_ITEM_HEIGHT * 3)
  l_4_0.stateSelectedEvent = Delegate.new()
  local paths = Storage.findData()
  for index,path in ipairs(paths) do
    local lower = path:lower()
    local savesDirectory = "saves/"
    if lower:sub(1, #savesDirectory) == savesDirectory then
      local file = lower:sub(#savesDirectory + 1)
      local name = file:gsub("%..*$", "")
      if name:sub(1, #"save") == "save" and name:sub(-#"description") ~= "description" then
        local descriptionData = (Storage.loadData("Saves/" .. name .. "Description.sav"))
        local child = nil
        if descriptionData then
          child = StateSelectGui.Description.new(l_4_0.list, descriptionData)
        else
          child = LabelGui.new(l_4_0.list, name)
        end
        child.saveName = name
        l_4_0.list:insert(child)
      end
    end
  end
  local newGameItem = TextButtonGui.new(l_4_0.list, "New game")
  newGameItem.selectedEvent:register(l_4_0.onNewGameSelected, l_4_0)
  local modsItem = TextButtonGui.new(l_4_0.list, "Manage mods")
  modsItem.selectedEvent:register(l_4_0.onModsSelected, l_4_0)
  local optionsItem = TextButtonGui.new(l_4_0.list, "Options")
  optionsItem.selectedEvent:register(l_4_0.onOptionsSelected, l_4_0)
  local exitItem = TextButtonGui.new(l_4_0.list, "Exit")
  exitItem.selectedEvent:register(l_4_0.onExitSelected, l_4_0)
  l_4_0.list:insert(newGameItem)
  l_4_0.list:insert(modsItem)
  l_4_0.list:insert(optionsItem)
  l_4_0.list:insert(exitItem)
  l_4_0.menu:setHackInnerGui(l_4_0.list)
  l_4_0:setFocus(l_4_0)
end

StateSelectGui.handleFocusGain = function(l_5_0)
  if l_5_0.root.focus == l_5_0 then
    l_5_0.root:setFocus(l_5_0.menu)
  end
end

StateSelectGui.setEntity = function(l_6_0, l_6_1)
  l_6_0.entity = l_6_1
end

StateSelectGui.onNewGameSelected = function(l_7_0)
  name = "Save1"
  do
    local index = 1
    repeat
      if Storage.hasData("Saves/" .. name .. ".sav") then
        index = index + 1
        name = "Save" .. index
      else
        l_7_0.stateSelectedEvent:dispatch(name)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StateSelectGui.onModsSelected = function(l_8_0)
  local gui = ModsGui.new(l_8_0, l_8_0.entity)
  l_8_0:openModalGui(gui)
end

StateSelectGui.onExitSelected = function(l_9_0)
  MOAISim.exit()
end

StateSelectGui.onOptionsSelected = function(l_10_0)
  local gui = GameMenuGui.new(l_10_0, l_10_0.entity, l_10_0.userState, true)
  l_10_0:openModalGui(gui)
end

StateSelectGui.resize = function(l_11_0, l_11_1, l_11_2)
  Gui.resize(l_11_0, l_11_1, l_11_2)
  local menuX, menuY = l_11_0.menu:measure(l_11_1, l_11_2)
  local offsetX, offsetY = (l_11_1 - menuX) * 0.5, (l_11_2 - menuY) * 0.5
  l_11_0.menu:position(offsetX, offsetY, offsetX + menuX, offsetY + menuY)
end

StateSelectGui.handleMotiveStart = function(l_12_0, l_12_1)
  if l_12_1 == "Select" then
    local item = l_12_0.list.guis[l_12_0.list.selectionIndex]
    l_12_0.stateSelectedEvent:dispatch(item.saveName)
  end
end

return StateSelectGui

