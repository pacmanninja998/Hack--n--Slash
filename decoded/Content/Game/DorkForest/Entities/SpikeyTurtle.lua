-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\SpikeyTurtle.lua 

local Entity = require("Entity")
local CorruptedTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/CorruptedTurtle")
local SpikeyTurtle = require("Class").create(CorruptedTurtle, "SpikeyTurtle")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
SpikeyTurtle.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  CorruptedTurtle.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, "Characters/Turtle_Corrupted/Turtle_Corrupted")
end

SpikeyTurtle.onHitRegionEntityEnter = function(l_2_0, l_2_1)
  if not l_2_0.flipped and l_2_1:is(Alice) then
    l_2_1:get(HealthComponent):damageKnockback(l_2_0.DAMAGE, l_2_0, 100)
  end
end

return SpikeyTurtle

