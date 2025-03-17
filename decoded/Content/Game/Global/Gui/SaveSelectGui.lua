-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\SaveSelectGui.lua 

local Delegate = require("DFMoai.Delegate")
local Gui = require("Gui")
local SpriteSheet = require("SpriteSheet")
local Storage = require("Storage")
local ModManager = require("ModManager")
local Class = require("Class")
local SaveSelectGui = Class.create(Gui, "SaveSelectGui")
local ArrayEditGui = Gui.load("Content/Game/Global/Gui/ArrayEditGui")
local ConfirmGui = Gui.load("Content/Game/Global/Gui/ConfirmGui")
local ChooseFieldGui = Gui.load("Content/Game/Global/Gui/ChooseFieldGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local ModsGui = Gui.load("Content/Game/Global/Gui/ModsGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local TextButtonGui = Gui.load("Content/Game/Global/Gui/TextButtonGui")
local MessageGui = Gui.load("Content/Game/Global/Gui/MessageGui")
SaveSelectGui.LabelItem = Class.create(Gui, "SaveSelectGui.LabelItem")
SaveSelectGui.LabelItem.LABEL_COLOR = {0.44705882352941, 0.99607843137255, 0.9921568627451}
SaveSelectGui.LabelItem.CURSOR_OFFSET = 128
SaveSelectGui.LabelItem.CURSOR_SIZE = 64
SaveSelectGui.LabelItem.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(SaveSelectGui.LabelItem).init(l_1_0, l_1_1)
  local saveSheet = SpriteSheet.load("UI/SaveSelectScreen/SaveSelectScreen")
  l_1_0.background = SpriteGui.new(l_1_0, saveSheet, "Box")
  l_1_0.label = LabelGui.new(l_1_0, "<title>" .. l_1_2 .. "</>", {height = 42, justifyHorizontal = MOAITextBox.CENTER_JUSTIFY, color = l_1_0.LABEL_COLOR})
  l_1_0.left = SpriteGui.new(l_1_0, saveSheet, "NewGameLeftArrow", {blinkDuration = 0.5})
  l_1_0.left:show(false)
  l_1_0.right = SpriteGui.new(l_1_0, saveSheet, "NewGameRightArrow", {blinkDuration = 0.5})
  l_1_0.right:show(false)
  l_1_0.selectedEvent = Delegate.new()
end

SaveSelectGui.LabelItem.handleFocusGain = function(l_2_0)
  Class.super(SaveSelectGui.LabelItem).handleFocusGain(l_2_0)
  l_2_0.left:reset()
  l_2_0.left:show(true)
  l_2_0.right:reset()
  l_2_0.right:show(true)
end

SaveSelectGui.LabelItem.handleFocusLoss = function(l_3_0)
  Class.super(SaveSelectGui.LabelItem).handleFocusLoss(l_3_0)
  l_3_0.left:show(false)
  l_3_0.right:show(false)
end

SaveSelectGui.LabelItem.handleMotiveStart = function(l_4_0, l_4_1)
  if l_4_1 == "Select" then
    l_4_0.selectedEvent:dispatch()
  else
    Class.super(SaveSelectGui.LabelItem).handleMotiveStart(l_4_1)
  end
end

SaveSelectGui.LabelItem.measure = function(l_5_0, l_5_1, l_5_2)
  return l_5_0.background.spritesheet:getDimensions("Box")
end

SaveSelectGui.LabelItem.resize = function(l_6_0, l_6_1, l_6_2)
  l_6_0.background:position(0, 0, l_6_1, l_6_2)
  l_6_0.label:position(0, 0, l_6_1, l_6_2)
  local cursorY0 = (l_6_2 - l_6_0.CURSOR_SIZE) * 0.5
  l_6_0.left:position(l_6_0.CURSOR_OFFSET, cursorY0, l_6_0.CURSOR_OFFSET + l_6_0.CURSOR_SIZE, cursorY0 + l_6_0.CURSOR_SIZE)
  l_6_0.right:position(l_6_1 - l_6_0.CURSOR_OFFSET - l_6_0.CURSOR_SIZE, cursorY0, l_6_1 - l_6_0.CURSOR_OFFSET, cursorY0 + l_6_0.CURSOR_SIZE)
end

SaveSelectGui.SaveItem = Class.create(Gui, "SaveSelectGui.SaveItem")
SaveSelectGui.SaveItem.INFO_OFFSET = 250
SaveSelectGui.SaveItem.VERTICAL_BORDER = 64
SaveSelectGui.SaveItem.HORIZONTAL_BORDER = 80
SaveSelectGui.SaveItem.init = function(l_7_0, l_7_1, l_7_2, l_7_3)
  Class.super(SaveSelectGui.SaveItem).init(l_7_0, l_7_1)
  local saveSheet = SpriteSheet.load("UI/SaveSelectScreen/SaveSelectScreen")
  l_7_0.background = SpriteGui.new(l_7_0, saveSheet, "Box")
  l_7_0.name = l_7_2
  l_7_0.nameLabel = LabelGui.new(l_7_0, l_7_2, {justifyVertical = MOAITextBox.LEFT_JUSTIFY})
  l_7_0.continueEvent = Delegate.new()
  l_7_0.buttons = {}
  local createButton = function(l_1_0)
    local button = TextButtonGui.new(self, l_1_0, {justifyVertical = MOAITextBox.RIGHT_JUSTIFY, height = 32})
    table.insert(self.buttons, button)
    return button
   end
  l_7_0.continueButton = createButton("Continue")
  l_7_0.continueButton.selectedEvent:register(l_7_0.onContinueSelected, l_7_0)
  l_7_0.modsButton = createButton("Mods")
  l_7_0.modsButton.selectedEvent:register(l_7_0.onModsSelected, l_7_0)
  l_7_0.deleteButton = createButton("Delete")
  l_7_0.deleteButton.selectedEvent:register(l_7_0.onDeleteSelected, l_7_0)
  if not next(l_7_3.mods) then
    l_7_0.modsButton:setEnabled(false)
    l_7_3.modAddedEvent:register(l_7_0.onModManagerModAdded, l_7_0)
  end
  l_7_0.data = Storage.loadData("Saves/" .. l_7_2 .. "Description.sav")
  if l_7_0.data then
    if type(l_7_0.data.name) == "string" then
      l_7_0.nameLabel:setText(l_7_0.data.name)
    end
    local timestamp = l_7_0.data.date
    if type(timestamp) == "table" then
      local day, month, year, hour, minute, second = timestamp.day, timestamp.month, timestamp.year, timestamp.hour, timestamp.minute, timestamp.second
      if type(day) == "number" and type(month) == "number" and type(year) == "number" and type(hour) == "number" and type(minute) == "number" and type(second) == "number" then
        l_7_0.date = LabelGui.new(l_7_0, string.format("%d:%02d:%02d %d/%02d/%04d", hour, minute, second, day, month, year), {justifyVertical = MOAITextBox.LEFT_JUSTIFY, justifyHorizontal = MOAITextBox.RIGHT_JUSTIFY})
      end
    end
    local age = l_7_0.data.age
    if type(age) ~= "number" then
      age = 0
    end
    local seconds = age % 60
    local minutes = math.floor((age - seconds) / 60) % 60
    local hours = math.floor((age - minutes - seconds) / 3600)
    if hours > 0 then
      ageDescription = string.format("%dh %dm", hours, minutes)
    else
      ageDescription = string.format("%dm %ds", minutes, seconds)
    end
    l_7_0.age = LabelGui.new(l_7_0, "<c:8>" .. ageDescription .. " played</c>", {justifyHorizontal = MOAITextBox.RIGHT_JUSTIFY, height = 32})
    local aliceSheet = nil
    if not l_7_0.data.hoodless then
      aliceSheet = SpriteSheet.load("Characters/Hero/Hero")
    else
      aliceSheet = SpriteSheet.load("Characters/Hero_Hair/Hero_Hair")
    end
    l_7_0.alice = SpriteGui.new(l_7_0, aliceSheet, "Breathe_Frnt", {magnify = 2})
    l_7_0.alice.prop:setPiv(-20, 50)
  end
end

SaveSelectGui.SaveItem.onModManagerModAdded = function(l_8_0)
  l_8_0.modsButton:setEnabled(true)
end

SaveSelectGui.SaveItem.onContinueSelected = function(l_9_0)
  l_9_0.continueEvent:dispatch()
end

SaveSelectGui.SaveItem.onModsSelected = function(l_10_0)
  local gui = l_10_0.parent.parent:createManifestGui(l_10_0.name)
  l_10_0.root:openModalGui(gui)
end

SaveSelectGui.SaveItem.onDeleteSelected = function(l_11_0)
  local deleteConfirmGui = ConfirmGui.new(l_11_0.root, string.format("Delete %s?", l_11_0.nameLabel.text), "This operation can't be undone. Are you sure you want to delete this save?", "Delete save", "Keep save", l_11_0.parent.parent.entity)
  deleteConfirmGui.confirmEvent:register(l_11_0.onDeleteConfirm, l_11_0)
  l_11_0.root:openModalGui(deleteConfirmGui)
end

SaveSelectGui.SaveItem.onDeleteConfirm = function(l_12_0)
  Storage.deleteData("Saves/" .. l_12_0.name .. ".sav")
  Storage.deleteData("Saves/" .. l_12_0.name .. "Description.sav")
  l_12_0.parent.parent:repopulate()
end

SaveSelectGui.SaveItem.handleFocusGain = function(l_13_0)
  if l_13_0.root.focus == l_13_0 then
    l_13_0.buttonFocus = 1
    l_13_0.root:setFocus(l_13_0.buttons[l_13_0.buttonFocus])
  end
end

SaveSelectGui.SaveItem.handleMotive = function(l_14_0, l_14_1, l_14_2)
  local delta = 0
  if l_14_1 == "Left" then
    delta = -1
  elseif l_14_1 == "Right" then
    delta = 1
  else
    Class.super(SaveSelectGui.SaveItem).handleMotive(l_14_0, l_14_1, l_14_2)
    return 
  end
  l_14_0.buttonFocus = 1 + (l_14_0.buttonFocus - 1 + delta) % #l_14_0.buttons
  l_14_0.root:setFocus(l_14_0.buttons[l_14_0.buttonFocus])
  l_14_0:playCue("UI/Hacking_UI/HackingUI_ToggleParameter")
end

SaveSelectGui.SaveItem.measure = function(l_15_0, l_15_1, l_15_2)
  return l_15_0.background.spritesheet:getDimensions("Box")
end

SaveSelectGui.SaveItem.resize = function(l_16_0, l_16_1, l_16_2)
  l_16_0.background:position(0, 0, l_16_1, l_16_2)
  local infoX0, infoY0, infoX1, infoY1 = l_16_0.INFO_OFFSET, l_16_0.VERTICAL_BORDER, l_16_1 - l_16_0.HORIZONTAL_BORDER, l_16_2 - l_16_0.HORIZONTAL_BORDER
  l_16_0.nameLabel:position(infoX0, infoY0, infoX1, infoY1)
  if l_16_0.data then
    l_16_0.age:position(infoX0, infoY0, infoX1, infoY1)
    if l_16_0.date then
      l_16_0.date:position(infoX0, infoY0, infoX1, infoY1)
    end
    l_16_0.alice:position(0, 0, l_16_0.INFO_OFFSET, l_16_2)
  end
  local continueX = l_16_0.buttons[1]:measure(l_16_1, l_16_2)
  local modsX = l_16_0.buttons[2]:measure(l_16_1, l_16_2)
  local deleteX = l_16_0.buttons[3]:measure(l_16_1, l_16_2)
  l_16_0.buttons[1]:position(infoX0, infoY0, infoX0 + continueX, infoY1)
  l_16_0.buttons[2]:position(infoX0 + continueX, infoY0, infoX1 - deleteX, infoY1)
  l_16_0.buttons[3]:position(infoX1 - deleteX, infoY0, infoX1, infoY1)
end

SaveSelectGui.init = function(l_17_0, l_17_1, l_17_2)
  Class.super(SaveSelectGui).init(l_17_0, l_17_1)
  l_17_0.saveSelectedEvent = Delegate.new()
  l_17_0.modManager = l_17_2
  local sheet = SpriteSheet.load("UI/SaveSelectScreen/SaveSelectScreen")
  local boxX, boxY = sheet:getDimensions("Box")
  l_17_0.list = ListGui.new(l_17_0, boxY)
  l_17_0:repopulate()
end

SaveSelectGui.repopulate = function(l_18_0)
  l_18_0.list:clear()
  local paths = Storage.findData()
  for index,path in ipairs(paths) do
    local lower = path:lower()
    local savesDirectory = "saves/"
    if lower:sub(1, #savesDirectory) == savesDirectory then
      local file = path:sub(#savesDirectory + 1)
      local fileLower = file:lower()
      if fileLower:sub(-#".sav") == ".sav" then
        local name = file:sub(1, -#".sav" - 1)
        do
          local nameLower = fileLower:sub(1, -#".sav" - 1)
          if nameLower:sub(1, #"save") == "save" and nameLower:sub(-#"description") ~= "description" then
            local child = SaveSelectGui.SaveItem.new(l_18_0.list, name, l_18_0.modManager)
            child.continueEvent:register(function()
              self:onSaveSelected(name)
                  end)
            l_18_0.list:insert(child)
          end
        end
      end
    end
  end
  local newGame = SaveSelectGui.LabelItem.new(l_18_0.list, "NEW GAME")
  newGame.selectedEvent:register(l_18_0.onNewGameSelected, l_18_0)
  l_18_0.list:insert(newGame)
  local modManagement = SaveSelectGui.LabelItem.new(l_18_0.list, "MANAGE MODS")
  modManagement.selectedEvent:register(l_18_0.onManageModsSelected, l_18_0)
  l_18_0.list:insert(modManagement)
  local exitGame = SaveSelectGui.LabelItem.new(l_18_0.list, "EXIT")
  exitGame.selectedEvent:register(l_18_0.onExitSelected, l_18_0)
  l_18_0.list:insert(exitGame)
  l_18_0.root:setFocus(l_18_0)
end

SaveSelectGui.setEntity = function(l_19_0, l_19_1)
  l_19_0.entity = l_19_1
end

SaveSelectGui.createManifestGui = function(l_20_0, l_20_1)
  local manifest = l_20_0.modManager:getManifest(l_20_1)
  local gui = ArrayEditGui.new(l_20_0.root, manifest, "mods", manifest.schemas.mods, l_20_0.entity, function()
    local modOptions = {}
    for key,modInstance in pairs(self.modManager.mods) do
      modOptions[key] = {key = key, title = modInstance.name, exists = true}
    end
    for index,record in ipairs(manifest.mods) do
      modOptions[record.key] = nil
    end
    local list = {}
    for key,record in pairs(modOptions) do
      table.insert(list, record)
    end
    table.sort(list, function(l_1_0, l_1_1)
      return l_1_0.title < l_1_1.title
      end)
    if #list == 0 then
      local dialog = MessageGui.new(self.root, "Could not activate a new mod", "No more available mods to activate.", self.entity)
      self.root:openModalGui(dialog)
    else
      local dialog = ChooseFieldGui.new(self.root, "Choose a mod to activate", list, manifest.schemas.mods.elementSchema, self.entity)
      dialog.fieldChosenEvent:register(function(l_2_0)
        table.insert(manifest.mods, l_2_0)
         end)
      self.root:openModalGui(dialog)
    end
   end)
  gui.dismissEvent:register(function()
    manifest:save()
   end)
  gui:setColumn(3)
  return gui
end

SaveSelectGui.onSaveSelected = function(l_21_0, l_21_1)
  l_21_0.saveSelectedEvent:dispatch(l_21_1)
end

SaveSelectGui.onNewGameSelected = function(l_22_0)
  local name = "Save1"
  local index = 1
  repeat
    if Storage.hasData("Saves/" .. name .. ".sav") then
      index = index + 1
      name = "Save" .. index
    else
      if next(l_22_0.modManager.mods) then
        Storage.deleteData("Saves/" .. name .. "Mods.manifest")
        local gui = l_22_0:createManifestGui(name)
        gui.dismissEvent:register(function()
          self.saveSelectedEvent:dispatch(name)
            end)
        l_22_0.root:openModalGui(gui)
      else
        l_22_0.saveSelectedEvent:dispatch(name)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SaveSelectGui.onManageModsSelected = function(l_23_0)
  local gui = ModsGui.new(l_23_0, l_23_0.modManager, l_23_0.entity)
  l_23_0.root:openModalGui(gui)
end

SaveSelectGui.onExitSelected = function(l_24_0)
  MOAISim.exit()
end

SaveSelectGui.handleFocusGain = function(l_25_0)
  if l_25_0.root.focus == l_25_0 then
    l_25_0.root:setFocus(l_25_0.list)
  end
end

SaveSelectGui.resize = function(l_26_0, l_26_1, l_26_2)
  Class.super(SaveSelectGui).resize(l_26_0, l_26_1, l_26_2)
  local listX, listY = l_26_0.list:measure(l_26_1, l_26_2)
  local x0 = (l_26_1 - listX) * 0.5
  l_26_0.list:position(x0, 0, x0 + listX, l_26_2)
end

return SaveSelectGui

