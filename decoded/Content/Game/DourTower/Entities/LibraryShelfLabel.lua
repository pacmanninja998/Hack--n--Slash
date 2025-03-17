-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryShelfLabel.lua 

local Entity = require("Entity")
local LibraryShelfLabel = require("Class").create(Entity, "LibraryShelfLabel")
local SpriteComponent = require("Components.SpriteComponent")
local Direction = require("Direction")
LibraryShelfLabel.MAX_WIDTH = 345
LibraryShelfLabel.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/LibraryShelfLabel/LibraryShelfLabel", "LibraryShelfLabel")
  l_1_0:setLabelText("")
  l_1_0.fileLabel = Entity.create("Content/Game/DourTower/Entities/NamePlaque", l_1_1, l_1_2, l_1_3, l_1_4 .. " name plaque", Direction.DIR_S, l_1_6, l_1_7, l_1_8)
  local minX, minY, maxX, maxY = l_1_0.fileLabel.textBox:getStringBounds(1, #l_1_6)
  local textWidth = 2.5 * (maxX - minY)
  if l_1_0.MAX_WIDTH < textWidth then
    local widthPerLetter = textWidth / #l_1_6
    l_1_6 = l_1_6:sub(1, l_1_0.MAX_WIDTH / widthPerLetter - 3) .. "..."
    l_1_0.fileLabel:setText(l_1_6)
    minX, minY, maxX, maxY = l_1_0.fileLabel.textBox:getStringBounds(1, #l_1_6)
    textWidth = 2.5 * (maxX - minY)
  end
  l_1_0.angle = l_1_5 or 0
  l_1_0.scale = math.max(1, math.min(l_1_0.MAX_WIDTH, textWidth) / 32)
  l_1_0.prop:setRot(0, 0, l_1_0.angle)
  l_1_0.prop:setScl(l_1_0.scale, 1)
  l_1_0.prop:forceUpdate()
  l_1_0:get(SpriteComponent).prop:setPriority(256)
  l_1_0.fileLabel.textBox:setPriority(512)
  if l_1_0.angle > 90 and l_1_0.angle < 270 then
    l_1_0.fileLabel.prop:setRot(0, 0, l_1_0.angle + 180)
  else
    l_1_0.fileLabel.prop:setRot(0, 0, l_1_0.angle)
  end
  l_1_0.shade = l_1_9 or 0
  l_1_0:get(SpriteComponent):setSprite("LibraryShelfLabel", l_1_0.shade)
end

return LibraryShelfLabel

