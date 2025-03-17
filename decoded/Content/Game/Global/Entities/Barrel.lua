-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Barrel.lua 

local Entity = require("Entity")
local Barrel = require("Class").create(Entity, "Barrel")
local CommonActions = require("CommonActions")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
Barrel.addIntegerField("HEARTS_TO_DROP", 0)
Barrel.addIntegerField("HITPOINTS", 1)
Barrel.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Barrel_Dungeon/Barrel_Dungeon")
  PhysicsComponent.new(l_1_0, {rect = {-32, 0, 32, 64}, category = PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HITTABLE_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_1_0.prop:setScl(0.65)
end

Barrel.onFieldSet = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == "HITPOINTS" and l_2_2 <= 0 then
    l_2_0:forceAction(CommonActions.GlitchOut.new())
  end
end

Barrel.preDestroy = function(l_3_0)
  for i = 1, l_3_0.HEARTS_TO_DROP do
    local posX, posY = l_3_0:getPosition()
    local angle = 2 * math.pi * math.random()
    local speed = math.random(50, 100)
    local velX, velY = speed * math.cos(angle), speed * math.sin(angle)
    Entity.create("Content/Game/Global/Entities/HealthPickup", l_3_0.layer, posX, posY, nil, nil, 1, velX, velY)
  end
end

Barrel.isHackable = function(l_4_0)
  return true
end

return Barrel

