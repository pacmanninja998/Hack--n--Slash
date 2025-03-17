-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\HackSwordStand.lua 

local Entity = require("Entity")
local TreasureChest = Entity.cache:load("Content/Game/Global/Entities/TreasureChest")
local HackSwordStand = require("Class").create(TreasureChest, "HackSwordStand")
local PhysicsComponent = require("Components.PhysicsComponent")
HackSwordStand.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  TreasureChest.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, "Interactions/Props/Placeholder/SwordStand/SwordStand", 64, 64, "NormalEmpty", "NormalFull", "NormalEmpty", "NormalFull")
  l_1_0:get(PhysicsComponent):addRect(-80, -64, 80, 32)
  l_1_0:setItem("Content/Game/Global/Items/HackItem", {exposed = true, plugUsed = true})
end

return HackSwordStand

