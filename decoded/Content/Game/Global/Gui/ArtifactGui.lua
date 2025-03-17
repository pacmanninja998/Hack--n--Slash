-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ArtifactGui.lua 

local Gui = require("Gui")
local ArtifactGui = require("Class").create(Gui, "ArtifactGui")
local EditGui = Gui.load("Content/Game/Global/Gui/EditGui")
ArtifactGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Gui.init(l_1_0, l_1_1)
  l_1_0.entity = l_1_2
  l_1_0.item = l_1_3
  local field, container = l_1_3:getField(l_1_2)
  l_1_0.edit = EditGui.new(l_1_0, "Artifact")
  l_1_0.edit.dismissEvent:register(l_1_0.onEditDismiss, l_1_0)
  l_1_0.edit:addField(container, field, container.schemas[field])
  l_1_0:setFocus(l_1_0.edit)
end

ArtifactGui.onEditDismiss = function(l_2_0)
  l_2_0.dismissed = true
end

ArtifactGui.resize = function(l_3_0, l_3_1, l_3_2)
  Gui.resize(l_3_0, l_3_1, l_3_2)
  local editX, editY = l_3_0.edit:measure(l_3_1, l_3_2)
  local x0 = (l_3_1 - editX) * 0.5
  l_3_0.edit:position(x0, 0, x0 + editX, editY)
end

return ArtifactGui

