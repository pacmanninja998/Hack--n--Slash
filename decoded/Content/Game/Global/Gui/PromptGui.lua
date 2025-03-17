-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\PromptGui.lua 

local Gui = require("Gui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local PromptGui = require("Class").create(SpriteGui, "PromptGui")
local ControllerComponent = require("Components.ControllerComponent")
PromptGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  SpriteGui.init(l_1_0, l_1_1)
  l_1_0.motive = l_1_3
  l_1_0:setEntity(l_1_2)
end

PromptGui.setEntity = function(l_2_0, l_2_1)
  if l_2_0.entity == l_2_1 then
    return 
  end
  if l_2_0.entity then
    local controller = l_2_0.entity:get(ControllerComponent)
    controller.modeChangeEvent:unregister(l_2_0.onControllerModeChange, l_2_0)
  end
  l_2_0.entity = l_2_1
  if l_2_0.entity then
    local controller = l_2_0.entity:get(ControllerComponent)
    controller.modeChangeEvent:register(l_2_0.onControllerModeChange, l_2_0)
    l_2_0:onControllerModeChange(controller.sheet, controller.promptMap)
  end
end

PromptGui.onControllerModeChange = function(l_3_0, l_3_1, l_3_2)
  local mappedMotive = l_3_2[l_3_0.motive]
  if not mappedMotive then
    return 
  end
  l_3_0:setSprite(l_3_1, mappedMotive)
  l_3_0:requestResize()
end

PromptGui.measure = function(l_4_0, l_4_1, l_4_2)
  return l_4_0.spritesheet:getDimensions(l_4_0.name)
end

return PromptGui

