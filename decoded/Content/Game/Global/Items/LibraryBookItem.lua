-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\LibraryBookItem.lua 

local Item = require("Item")
local Action = require("Action")
local Room = require("Room")
local Disassembly = require("Disassembly")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local OpenBookAction = require("Class").create(Action, "OpenBookAction")
OpenBookAction.init = function(l_1_0, l_1_1)
  l_1_0.item = l_1_1
end

OpenBookAction.stop = function(l_2_0)
  l_2_0.entity:room():queueUpdate(function()
    local fullPath = self.item.state.filePath
    local baseName = fullPath:gmatch(".*/([^.]+)")() or fullPath
    local code = loadfile(fullPath)
    if code then
      local disassembly = Disassembly.new(code)
      self.entity.host:enterPrototype(self.entity:world(), baseName, disassembly.prototype)
    end
   end)
end

local LibraryBookItem = require("Class").create(Item, "LibraryBookItem")
LibraryBookItem.getAction = function(l_3_0, l_3_1)
  return OpenBookAction.new(l_3_0)
end

LibraryBookItem.getDescription = function(l_4_0)
  return l_4_0.state.filePath
end

LibraryBookItem.getSprite = function(l_5_0)
  return "UI/Placeholder/ItemIcons/LibraryBook/LibraryBook", "LibraryBook"
end

return LibraryBookItem

