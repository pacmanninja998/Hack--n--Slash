-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\NotificationGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local Debugger = require("DFMoai.Debugger")
local SpriteSheet = require("SpriteSheet")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local NotificationGui = Class.create(Gui, "NotificationGui")
NotificationGui.NoticeGui = Class.create(Gui, "NotificationGui.NoticeGui")
NotificationGui.NoticeGui.BORDER = 64
NotificationGui.NoticeGui.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(NotificationGui.NoticeGui).init(l_1_0, l_1_1)
  l_1_0.background = SpriteGui.new(l_1_0, SpriteSheet.load("UI/SaveSelectScreen/SaveSelectScreen"), "Box")
  l_1_0.label = LabelGui.new(l_1_0, l_1_2, {height = 40})
  l_1_0.age = MOAISim.getElapsedTime()
end

NotificationGui.NoticeGui.measure = function(l_2_0, l_2_1, l_2_2)
  return l_2_0.background.spritesheet:getDimensions("Box")
end

NotificationGui.NoticeGui.resize = function(l_3_0, l_3_1, l_3_2)
  l_3_0.background:position(0, 0, l_3_1, l_3_2)
  l_3_0.label:position(l_3_0.BORDER, l_3_0.BORDER, l_3_1 - l_3_0.BORDER, l_3_2 - l_3_0.BORDER)
end

NotificationGui.NoticeGui.setAlpha = function(l_4_0, l_4_1)
  l_4_0.background:setColor(1, 1, 1, l_4_1)
  l_4_0.label:setColor(1, 1, 1, l_4_1)
end

NotificationGui.DISPLAY_TIME = 2
NotificationGui.FADE_TIME = 0.5
NotificationGui.init = function(l_5_0, l_5_1)
  Class.super(NotificationGui).init(l_5_0, l_5_1)
  l_5_0.noticeGuis = {}
  Debugger.dFileChanged:register(l_5_0.onFileChanged, l_5_0)
  Debugger.dFileDeleted:register(l_5_0.onFileDeleted, l_5_0)
end

NotificationGui.deactivate = function(l_6_0)
  Class.super(NotificationGui).deactivate(l_6_0)
  Debugger.dFileChanged:unregister(l_6_0.onFileChanged, l_6_0)
  Debugger.dFileDeleted:unregister(l_6_0.onFileDeleted, l_6_0)
end

NotificationGui.onFileChanged = function(l_7_0, l_7_1)
  if l_7_1:sub(1, #"Data/Content/Game/") == "Data/Content/Game/" then
    l_7_1 = l_7_1:sub(#"Data/Content/Game/" + 1)
  end
  l_7_0:addNotice(string.format("'%s' modified.", l_7_1))
end

NotificationGui.onFileDeleted = function(l_8_0, l_8_1)
  if l_8_1:sub(1, #"Data/Content/Game/") == "Data/Content/Game/" then
    l_8_1 = l_8_1:sub(#"Data/Content/Game/" + 1)
  end
  l_8_0:addNotice(string.format("'%s' deleted.", l_8_1))
end

NotificationGui.addNotice = function(l_9_0, l_9_1)
  local gui = NotificationGui.NoticeGui.new(l_9_0, l_9_1)
  table.insert(l_9_0.noticeGuis, gui)
  l_9_0:requestResize()
end

NotificationGui.tick = function(l_10_0)
  local noticesExpired = false
  local currentAge = MOAISim.getElapsedTime()
  for i = #l_10_0.noticeGuis, 1, -1 do
    local gui = l_10_0.noticeGuis[i]
    local age = currentAge - gui.age
    if l_10_0.DISPLAY_TIME < age then
      local fadeAmount = (age - l_10_0.DISPLAY_TIME) / l_10_0.FADE_TIME
      if fadeAmount < 1 then
        gui:setAlpha(1 - fadeAmount)
      else
        gui:destroy()
        table.remove(l_10_0.noticeGuis, i)
        noticesExpired = true
      end
    end
  end
  if noticesExpired then
    l_10_0:requestResize()
  end
end

NotificationGui.resize = function(l_11_0, l_11_1, l_11_2)
  Class.super(NotificationGui).resize(l_11_0, l_11_1, l_11_2)
  local totalSize = 0
  local lastIndex = 1
  for i = #l_11_0.noticeGuis, 1, -1 do
    local gui = l_11_0.noticeGuis[i]
    local guiX, guiY = gui:measure(l_11_1, l_11_2)
    if l_11_2 < totalSize + guiY then
      do return end
    end
    lastIndex = i
    totalSize = totalSize + guiY
  end
  for i = lastIndex - 1, 1, -1 do
    local gui = l_11_0.noticeGuis[i]
    gui:destroy()
    table.remove(l_11_0.noticeGuis, i)
  end
  local offsetY = l_11_2
  for index,gui in ipairs(l_11_0.noticeGuis) do
    local guiX, guiY = gui:measure(l_11_1, l_11_2)
    gui:position(l_11_1 - guiX, offsetY - guiY, l_11_1, offsetY)
    offsetY = offsetY - guiY
  end
end

return NotificationGui

