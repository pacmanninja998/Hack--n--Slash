-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\CodeTrap\Port.lua 

local Class = require("Class")
local Entity = require("Entity")
local Port = Class.create(Entity, "Port")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
Port.addIntegerField("VALUE", 0)
Port.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/CrackerCavern/CodeTrap/CodeTrap", l_1_4)
  PhysicsComponent.new(l_1_0, {rect = {-32, -32, 32, 32}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_1_0.schemas.VALUE:registerValueSetHandler(l_1_0, l_1_0.onValueSet, l_1_0)
  l_1_0:onValueSet(l_1_0.value)
end

Port.onValueSet = function(l_2_0)
  local number = string.byte(l_2_0.name:gsub("Port ", ""))
  l_2_0:setLabelText(string.char(string.byte("A") + number - string.byte("1")) .. ":" .. l_2_0.VALUE)
end

Port.isHackable = function(l_3_0)
  return true
end

return Port

