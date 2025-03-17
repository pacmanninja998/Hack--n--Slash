-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Tube.lua 

local Class = require("Class")
local Entity = require("Entity")
local Tube = Class.create(Entity, "Tube")
local SpriteSheet = require("SpriteSheet")
local SpriteComponent = require("Components.SpriteComponent")
Tube.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Tube).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/Tube/Tube")
  sprite.prop:setPriority(1000)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  l_1_0:setLabelText("")
end

Tube.setTube = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0.prototype = l_2_1
  local crystalX, crystalY = 0, 0
  local crystalWidth, crystalHeight = 120, 120
  local baseScale = 0.25
  if l_2_2 then
    local sprite = l_2_0:get(SpriteComponent)
    sprite:setSprite(l_2_2)
    crystalX, crystalY = sprite.sheet:getJoint("crystal", l_2_2)
    crystalWidth, crystalHeight = sprite.sheet:getDimensions(l_2_2)
    if l_2_2 == "Left" or l_2_2 == "Right" then
      baseScale = 0.2
    else
      crystalWidth, crystalHeight = crystalWidth * 0.75, crystalHeight * 0.6
    end
  else
    l_2_0:setVisible(false)
  end
  l_2_0.prop:setScl(baseScale)
  l_2_0.prop:forceUpdate()
  local crystalSheet = SpriteSheet.load("Interactions/Props/CodeRoomHardware/Crystal/Crystal")
  local crystalSizeX, crystalSizeY = crystalSheet:getDimensions("Crystal")
  local totalCrystalSizeX = crystalSizeX * #l_2_3
  local crystalScale = nil
  if crystalWidth / (crystalHeight) <= totalCrystalSizeX / crystalSizeY then
    crystalScale = crystalWidth / totalCrystalSizeX
  else
    crystalScale = crystalHeight / crystalSizeY
  end
  local crystalOffsetX = crystalX - totalCrystalSizeX * (crystalScale) * 0.5 + crystalSizeX * (crystalScale) * 0.5
  for i,colorIndex in ipairs(l_2_3) do
    local colorX, colorY = crystalOffsetX, crystalY
    local posX, posY = l_2_0.prop:modelToWorld(crystalOffsetX, crystalY)
    local crystal = Entity.create("Content/Game/MachineRooms/Entities/Crystal", l_2_0.layer, posX, posY)
    crystal:setCrystalColor(l_2_1, colorIndex, false)
    crystal.prop:setScl(crystalScale * baseScale)
    crystalOffsetX = crystalOffsetX + crystalSizeX * (crystalScale)
  end
end

return Tube

