-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\GlyphRoom\Key.lua 

local Entity = require("Entity")
local PressurePlate = Entity.cache:load("Content/Game/Global/Entities/PressurePlate")
local LayoutEntity = require("Class").create(PressurePlate, "Key")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PressurePlate.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0:get(SpriteComponent):setSpriteSheet("Layouts/Game/DweebKeep/GlyphRoom/GlyphRoom")
  local animator = l_1_0:get(AnimatorComponent)
  animator:play(l_1_4)
  l_1_0.unpressedAnim = l_1_4
  l_1_0.unpressAnim = false
  l_1_0.pressAnim = false
  l_1_0.unpressCue = false
  local x0, y0, x1, y1 = animator:getHitboxPoints("sensor")
  l_1_0:makeSensor(x0, y0, x1, y1)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  l_1_0.whiteList = {Alice = true}
  l_1_0.label:setOffset((x0 + x1) / 2, (y0 + y1) / 2)
end

return LayoutEntity

