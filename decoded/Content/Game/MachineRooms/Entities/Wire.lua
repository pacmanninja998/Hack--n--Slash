-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Wire.lua 

local Class = require("Class")
local Entity = require("Entity")
local Wire = Class.create(Entity, "Wire")
local SpriteComponent = require("Components.SpriteComponent")
Wire.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Wire).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/WhiteWire/WhiteWire")
  l_1_0.prop:setScl(0.25)
  l_1_0:setLabelText("")
end

Wire.setTarget = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local sprite = l_2_0:get(SpriteComponent)
  local sizeX, sizeY = sprite.sheet:getDimensions(l_2_1)
  sprite:setSprite(l_2_1)
  local sclX, sclY = 0.25, 0.25
  if l_2_2 ~= 0 then
    sclX = l_2_2 / sizeX
  end
  if l_2_3 ~= 0 then
    sclY = l_2_3 / sizeY
  end
  l_2_0.prop:setScl(sclX, sclY)
end

return Wire

