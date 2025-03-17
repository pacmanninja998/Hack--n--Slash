-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\InteractIconGui.lua 

local EntityRef = require("EntityRef")
local SpriteSheet = require("SpriteSheet")
local Gui = require("Gui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local InteractIconGui = require("Class").create(Gui, "InteractIconGui")
local ControllerComponent = require("Components.ControllerComponent")
InteractIconGui.SIZE = 64
InteractIconGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0)
  l_1_0.target = EntityRef.new(l_1_2)
  l_1_0.offsetX, l_1_0.offsetY = l_1_3 or 0, l_1_4 or 0
  local controller = l_1_1:get(ControllerComponent)
  controller.modeChangeEvent:register(l_1_0.onControllerModeChange, l_1_0)
  l_1_0:onControllerModeChange(controller.sheet, controller.promptMap)
end

InteractIconGui.onControllerModeChange = function(l_2_0, l_2_1, l_2_2)
  if l_2_0.icon then
    l_2_0.icon:destroy()
  end
  l_2_0.icon = SpriteGui.new(l_2_0, l_2_1, l_2_2.Interact)
  l_2_0:requestResize()
end

InteractIconGui.resize = function(l_3_0, l_3_1, l_3_2)
  Gui.resize(l_3_0, l_3_1, l_3_2)
  l_3_0:updatePosition()
end

InteractIconGui.tick = function(l_4_0)
  Gui.tick(l_4_0)
  l_4_0:updatePosition()
end

InteractIconGui.updatePosition = function(l_5_0)
  if not l_5_0.screen then
    return 
  end
  local entity = l_5_0.target.entity
  if not entity then
    l_5_0:show(false)
    return 
  end
  local x, y = l_5_0:getEntityClientLoc(entity)
  x, y = x + l_5_0.offsetX, y + l_5_0.offsetY
  local half = l_5_0.SIZE * 0.5
  x = math.max(half, math.min(l_5_0.sizeX - half, x))
  y = math.max(half, math.min(l_5_0.sizeY - half, y))
  l_5_0.icon:position(x - half, y - half, x + half, y + half)
end

return InteractIconGui

