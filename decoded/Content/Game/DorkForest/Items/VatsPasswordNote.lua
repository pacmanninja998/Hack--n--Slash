-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Items\VatsPasswordNote.lua 

local Action = require("Action")
local Item = require("Item")
local SpriteSheet = require("SpriteSheet")
local ControllerComponent = require("Components.ControllerComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local SpriteGui = require("Gui").load("Content/Game/Global/Gui/SpriteGui")
local VatsPasswordNote = require("Class").create(Item, "VatsPasswordNote")
VatsPasswordNote.ReadAction = require("Class").create(Action, "VatsPasswordNote.ReadAction")
VatsPasswordNote.ReadAction.start = function(l_1_0, l_1_1)
  Action.start(l_1_0, l_1_1)
  l_1_0.entity:move(0)
  local interface = l_1_0.entity:get(InterfaceComponent)
  l_1_0.gui = SpriteGui.new(nil, SpriteSheet.load("UI/Notes/VatsPasswordNote/VatsPasswordNote"), "VatsPasswordNote")
  interface:pushInterface(l_1_0.gui)
end

VatsPasswordNote.ReadAction.tick = function(l_2_0)
  Action.tick(l_2_0)
  local controller = l_2_0.entity:get(ControllerComponent)
  return (not controller:consumeNewMotive("Dismiss") and not controller:consumeNewMotive("Select"))
end

VatsPasswordNote.ReadAction.stop = function(l_3_0)
  l_3_0.entity:get(InterfaceComponent):removeInterface(l_3_0.gui)
  l_3_0.gui = nil
end

VatsPasswordNote.getDescription = function(l_4_0)
  return "It's a note we found in the destroyed labs."
end

VatsPasswordNote.getSprite = function(l_5_0)
  return "UI/ItemIcons/PasswordNote/PasswordNote", "PasswordNote"
end

VatsPasswordNote.getAction = function(l_6_0)
  return VatsPasswordNote.ReadAction.new()
end

return VatsPasswordNote

