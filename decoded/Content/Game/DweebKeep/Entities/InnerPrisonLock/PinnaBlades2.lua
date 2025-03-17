-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\InnerPrisonLock\PinnaBlades2.lua 

local Entity = require("Entity")
local PinnaBlades = Entity.cache:load("Content/Game/DweebKeep/Entities/PinnaBlades")
local LayoutEntity = require("Class").create(PinnaBlades, "PinnaBlades2")
local SpriteComponent = require("Components.SpriteComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PinnaBlades.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, 150, 180, 181, 26, 30, -15, 0, false)
  SpriteComponent.new(l_1_0, "Layouts/Game/DweebKeep/InnerPrisonLock/InnerPrisonLock", "PinnaBlades2")
  l_1_0:setLabelText("")
  local sprite = l_1_0:get(SpriteComponent)
  local pivotX, pivotY = sprite:getPivot()
  local sizeX, sizeY = sprite:getSize()
  local defaultOffsetX, defaultOffsetY = sizeX / 2 - pivotX, sizeY - pivotY
  l_1_0:setPosition(l_1_2 + defaultOffsetX, l_1_3 + defaultOffsetY)
end

return LayoutEntity

