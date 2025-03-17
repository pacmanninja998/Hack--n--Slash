-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CaveStash\BlockPlate.lua 

local Entity = require("Entity")
local PressurePlate = Entity.cache:load("Content/Game/Global/Entities/PressurePlate")
local LayoutEntity = require("Class").create(PressurePlate, "BlockPlate")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local options = {spriteSheet = "Layouts/Game/CrackerCavern/CaveStash/CaveStash", unpressedAnim = l_1_4, unpressAnim = l_1_4, pressedAnim = l_1_4, pressAnim = l_1_4}
  PressurePlate.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, nil, options)
  local animator = l_1_0:get(AnimatorComponent)
  local x0, y0, x1, y1 = animator:getHitboxPoints("sensor")
  l_1_0:makeSensor(x0, y0, x1, y1)
end

return LayoutEntity

