-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryRug.lua 

local Entity = require("Entity")
local LibraryRug = require("Class").create(Entity, "LibraryRug")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local Direction = require("Direction")
LibraryRug.MAX_WIDTH = 240
local LibraryRugEndCap = require("Class").create(Entity, "LibraryRugEndCap")
LibraryRugEndCap.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/LibraryRug/LibraryRug", l_1_5)
  l_1_0:setLabelText("")
end

LibraryRug.init = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  Entity.init(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  SpriteComponent.new(l_2_0, "Interactions/Props/LibraryRug/LibraryRug")
  AnimatorComponent.new(l_2_0, true)
  l_2_0:get(AnimatorComponent):play("Center", 0)
  l_2_0:setLabelText("")
  l_2_0.facingDir = l_2_5
end

LibraryRug.setLabel = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_0:setLabelText(l_3_1)
  local posX, posY = l_3_0:getPosition()
  l_3_0.namePlaque = Entity.create("Content/Game/DourTower/Entities/NamePlaque", l_3_0.layer, posX, posY, l_3_0.name .. " name plaque", l_3_0.facingDir, l_3_1, l_3_2, l_3_3)
  local minX, minY, maxX, maxY = l_3_0.namePlaque.textBox:getStringBounds(1, #l_3_1)
  local textWidth = 2 * (maxX - minY)
  if l_3_0.MAX_WIDTH < textWidth then
    local widthPerLetter = textWidth / #l_3_1
    l_3_1 = l_3_1:sub(1, l_3_0.MAX_WIDTH / widthPerLetter - 3) .. "..."
    l_3_0.namePlaque:setText(l_3_1)
    minX, minY, maxX, maxY = l_3_0.namePlaque.textBox:getStringBounds(1, #l_3_1)
    textWidth = 2 * (maxX - minY)
  end
  l_3_0.angle = Direction.dirToAngle(l_3_0.facingDir) + 90
  l_3_0.scale = math.max(1, math.min(l_3_0.MAX_WIDTH, textWidth) / 32)
  l_3_0.prop:setRot(0, 0, l_3_0.angle)
  l_3_0.prop:setScl(l_3_0.scale, 1)
  l_3_0.prop:forceUpdate()
  local priority = -128 * l_3_0.scale
  l_3_0:get(SpriteComponent).prop:setPriority(priority)
  l_3_0.namePlaque.textBox:setPriority(priority + 8)
  local leftEndX, leftEndY = l_3_0:get(AnimatorComponent):getJointLoc("LeftEnd", true)
  leftEndX, leftEndY = l_3_0.prop:modelToWorld(leftEndX, leftEndY, 0)
  l_3_0.leftEnd = l_3_0.layer:addEntity(LibraryRugEndCap.new(l_3_0.layer, leftEndX, leftEndY, l_3_0.name .. " left end", "LeftEnd"))
  l_3_0.leftEnd.prop:setRot(0, 0, l_3_0.angle)
  l_3_0.leftEnd:get(SpriteComponent).prop:setPriority(leftEndY - posY + priority)
  local rightEndX, rightEndY = l_3_0:get(AnimatorComponent):getJointLoc("RightEnd")
  rightEndX, rightEndY = l_3_0.prop:modelToWorld(rightEndX, rightEndY, 0)
  l_3_0.rightEnd = l_3_0.layer:addEntity(LibraryRugEndCap.new(l_3_0.layer, rightEndX, rightEndY, l_3_0.name .. " right end", "RightEnd"))
  l_3_0.rightEnd.prop:setRot(0, 0, l_3_0.angle)
  l_3_0.rightEnd:get(SpriteComponent).prop:setPriority(rightEndY - posY + priority)
end

return LibraryRug

