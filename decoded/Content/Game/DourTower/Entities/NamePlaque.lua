-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\NamePlaque.lua 

local Entity = require("Entity")
local NamePlaque = require("Class").create(Entity, "NamePlaque")
local Direction = require("Direction")
local Font = require("Font")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
NamePlaque.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10, l_1_11)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  if not l_1_5 then
    l_1_0.downDir = Direction.DIR_S
  end
  l_1_0.textBox = MOAITextBox.new()
  l_1_0:attachProp(l_1_0.textBox)
  if l_1_0.downDir ~= Direction.DIR_S then
    local angle = Direction.dirToAngle(l_1_0.downDir) - 270
    l_1_0.prop:setRot(0, 0, angle)
  end
  l_1_0:setStyles(l_1_7, l_1_8, l_1_10)
  l_1_0.textBox:setYFlip(true)
  l_1_0.textBox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  l_1_0:setText(l_1_6)
  l_1_0.priority = l_1_9 or -128
  l_1_0.textBox:setPriority(l_1_0.priority)
  l_1_0:setLabelText("")
  l_1_0.renderAsPhysics = l_1_11
end

NamePlaque.setStyles = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0.charHeightScale = l_2_1 or 1
  if not l_2_2 then
    l_2_2 = {0, 0, 0, 1}
  end
  if not l_2_3 then
    l_2_3 = Font.STANDARD_PATH
  end
  l_2_0.font = Font.load(l_2_3)
  l_2_0.charHeight = Font.getDefaultCharHeight() * l_2_0.charHeightScale
  l_2_0.defaultStyle = l_2_0.font:makeStyle(l_2_0.charHeight, l_2_2)
  l_2_0.textBox:setStyle(l_2_0.defaultStyle)
end

NamePlaque.setText = function(l_3_0, l_3_1)
  if not l_3_1 then
    l_3_1 = ""
  end
  l_3_0.textBox:setRect(-2048, -2048, 2048, 2048)
  l_3_0.textBox:setString(l_3_1)
end

NamePlaque.setDefaultShader = function(l_4_0, l_4_1)
  Entity.setDefaultShader(l_4_0, l_4_1)
  local material = nil
  if l_4_1 then
    material = l_4_1:makeMaterial(nil)
  end
  l_4_0.textBox:setMaterial(material)
  l_4_0.material = material
end

NamePlaque.setCurrentShader = function(l_5_0, l_5_1)
  Entity.setCurrentShader(l_5_0, l_5_1)
  local material = nil
  if l_5_1 then
    material = l_5_1:makeMaterial(nil)
  end
  l_5_0.textBox:setMaterial(material)
  l_5_0.material = material
end

NamePlaque.resetShader = function(l_6_0)
  Entity.resetShader(l_6_0)
  local material = nil
  if l_6_0.shader then
    material = l_6_0.shader:makeMaterial(nil)
  end
  l_6_0.textBox:setMaterial(material)
  l_6_0.material = material
end

return NamePlaque

