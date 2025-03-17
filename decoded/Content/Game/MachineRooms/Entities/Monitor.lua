-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Monitor.lua 

local Class = require("Class")
local Entity = require("Entity")
local Monitor = Class.create(Entity, "Monitor")
local SpriteSheet = require("SpriteSheet")
local SpriteComponent = require("Components.SpriteComponent")
Monitor.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Monitor).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/Monitor/Monitor")
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  l_1_0:setLabelText("")
end

Monitor.setMonitor = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0.prototype = l_2_1
  local crystalX, crystalY = 0, 0
  local crystalWidth, crystalHeight = 180, 180
  local sprite = l_2_0:get(SpriteComponent)
  if l_2_2 then
    sprite:setSprite(l_2_2)
    crystalX, crystalY = sprite.sheet:getJoint("crystal", l_2_2)
  else
    l_2_0:setVisible(false)
  end
  local crystalSheet = SpriteSheet.load("Interactions/Props/CodeRoomHardware/Crystal/Crystal")
  local crystalSizeX, crystalSizeY = crystalSheet:getDimensions("Crystal")
  local totalCrystalSizeX = crystalSizeX * #l_2_3
  local crystalScale = nil
  if crystalWidth / crystalHeight <= totalCrystalSizeX / crystalSizeY then
    crystalScale = crystalWidth / totalCrystalSizeX
  else
    crystalScale = crystalHeight / crystalSizeY
  end
  local crystalOffsetX = crystalX - totalCrystalSizeX * (crystalScale) * 0.5 + crystalSizeX * (crystalScale) * 0.5
  for i,colorIndex in ipairs(l_2_3) do
    local colorX, colorY = crystalOffsetX, crystalY
    local posX, posY = l_2_0.prop:modelToWorld(crystalOffsetX, crystalY)
    local crystal = Entity.create("Content/Game/MachineRooms/Entities/Crystal", l_2_0.layer, posX, posY)
    crystal:setCrystalColor(l_2_1, colorIndex, true)
    crystal.prop:setScl(crystalScale * 0.25)
    crystalOffsetX = crystalOffsetX + crystalSizeX * (crystalScale)
  end
end

return Monitor

