-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\LabRuins\Vats.lua 

local Entity = require("Entity")
local EntityRef = require("EntityRef")
local Vat = require("Class").create(Entity, "Vat")
local SpriteSheet = require("SpriteSheet")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
Vat.addIntegerField("healAmount", 0)
Vat.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DorkForest/LabRuins/LabRuins", "Vats")
  PhysicsComponent.new(l_1_0, {category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC, rect = {32, 128, 96, 256}})
  l_1_0.healAmount = l_1_0:universe().state.state.forestHealAmount
  l_1_0:get(SpriteComponent).prop:setPriority(-256)
end

Vat.setPond = function(l_2_0, l_2_1)
  l_2_0.pond:setEntity(l_2_1)
end

Vat.isHackable = function(l_3_0)
  return true
end

Vat.onFieldSet = function(l_4_0, l_4_1, l_4_2)
  if l_4_1 == "healAmount" then
    local room = l_4_0:room()
    if room.setHealAmount then
      room:setHealAmount(l_4_2)
    end
  end
end

return Vat

