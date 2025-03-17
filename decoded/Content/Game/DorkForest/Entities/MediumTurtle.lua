-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\MediumTurtle.lua 

local Entity = require("Entity")
local CorruptedTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/CorruptedTurtle")
local MediumTurtle = require("Class").create(CorruptedTurtle, "SpikeyTurtle")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
MediumTurtle.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  CorruptedTurtle.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, "Characters/Turtle_Med/Turtle_Med")
end

MediumTurtle.onHitRegionEntityEnter = function(l_2_0, l_2_1)
  if not l_2_0.flipped and l_2_1:is(Alice) and l_2_0.action and l_2_0.action:is(CorruptedTurtle.ChargeAction) then
    l_2_1:get(HealthComponent):damageKnockback(l_2_0.DAMAGE, l_2_0, 100)
    l_2_0.action:onHit()
  end
end

return MediumTurtle

