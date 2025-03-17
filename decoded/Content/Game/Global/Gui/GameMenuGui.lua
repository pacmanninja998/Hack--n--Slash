-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\GameMenuGui.lua 

local Delegate = require("DFMoai.Delegate")
local Class = require("Class")
local Gui = require("Gui")
local HackFramedGui = Gui.load("Content/Game/Global/Gui/HackFramedGui")
local TextButtonGui = Gui.load("Content/Game/Global/Gui/TextButtonGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local ControlsGui = Gui.load("Content/Game/Global/Gui/ControlsGui")
local EditGui = Gui.load("Content/Game/Global/Gui/EditGui")
local ColorGui = Gui.load("Content/Game/Global/Gui/ColorGui")
local GameMenuGui = Class.create(Gui, "GameMenuGui")
GameMenuGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(GameMenuGui).init(l_1_0, l_1_1)
  l_1_0.entity = l_1_2
  l_1_0.userState = l_1_3
  l_1_0.colorGui = ColorGui.new(l_1_0, 0, 0, 0, 0.25)
  l_1_0.menu = HackFramedGui.new(l_1_0, "Hack 'n' Slash", l_1_2)
  l_1_0.list = ListGui.new(l_1_0.menu)
  l_1_0.dismissEvent = Delegate.new()
  l_1_0.menu:setHackInnerGui(l_1_0.list)
  for index,option in ipairs(l_1_0.menuOptions) do
    local button = TextButtonGui.new(l_1_0.list, option.display)
    button.selectedEvent:register(option.handler, l_1_0)
    l_1_0.list:insert(button)
  end
  if not l_1_4 then
    local quitButton = TextButtonGui.new(l_1_0.list, "Quit game")
    quitButton.selectedEvent:register(l_1_0.onExitGameSelected, l_1_0)
    l_1_0.list:insert(quitButton)
  end
  l_1_0.root:setFocus(l_1_0)
end

GameMenuGui.dismiss = function(l_2_0)
  l_2_0.dismissed = true
  l_2_0.dismissEvent:dispatch()
end

GameMenuGui.handleMotiveStart = function(l_3_0, l_3_1)
  if l_3_1 == "Dismiss" or l_3_1 == "OpenMenu" then
    l_3_0:dismiss()
  end
end

GameMenuGui.handleFocusGain = function(l_4_0)
  if l_4_0.root.focus == l_4_0 then
    l_4_0.root:setFocus(l_4_0.menu)
  end
end

GameMenuGui.resize = function(l_5_0, l_5_1, l_5_2)
  Class.super(GameMenuGui).resize(l_5_0, l_5_1, l_5_2)
  l_5_0.colorGui:position(0, 0, l_5_1, l_5_2)
  local frameX, frameY = l_5_0.menu:measure(l_5_1, l_5_2)
  local x0, y0 = (l_5_1 - frameX) * 0.5, (l_5_2 - frameY) * 0.5
  l_5_0.menu:position(x0, y0, x0 + frameX, y0 + frameY)
end

GameMenuGui.onControlsSelected = function(l_6_0)
  local edit = ControlsGui.new(l_6_0, l_6_0.userState, l_6_0.entity)
  l_6_0.root:openModalGui(edit)
end

GameMenuGui.onSettingsSelected = function(l_7_0)
  local edit = EditGui.new(l_7_0, "Settings", l_7_0.entity)
  local graphicsSchema = l_7_0.userState.schemas.data.fieldSchemas.graphics
  edit:addField(l_7_0.userState.data.graphics, "FULLSCREEN", graphicsSchema.fieldSchemas.FULLSCREEN)
  local audioSchema = l_7_0.userState.schemas.data.fieldSchemas.audio
  edit:addField(l_7_0.userState.data.audio, "MASTER_VOLUME", audioSchema.fieldSchemas.MASTER_VOLUME)
  edit:addField(l_7_0.userState.data.audio, "AMBIENCE_VOLUME", audioSchema.fieldSchemas.AMBIENCE_VOLUME)
  edit:addField(l_7_0.userState.data.audio, "FX_VOLUME", audioSchema.fieldSchemas.FX_VOLUME)
  edit:addField(l_7_0.userState.data.audio, "MUSIC_VOLUME", audioSchema.fieldSchemas.MUSIC_VOLUME)
  edit:addField(l_7_0.userState.data.audio, "UI_VOLUME", audioSchema.fieldSchemas.UI_VOLUME)
  l_7_0.root:openModalGui(edit)
end

GameMenuGui.onExitGameSelected = function(l_8_0)
  l_8_0.entity.host.running = false
  l_8_0:dismiss()
end

GameMenuGui.menuOptions = {{display = "Keyboard controls", handler = GameMenuGui.onControlsSelected}, {display = "Settings", handler = GameMenuGui.onSettingsSelected}}
return GameMenuGui

