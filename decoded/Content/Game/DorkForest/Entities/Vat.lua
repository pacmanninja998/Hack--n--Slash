-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Vat.lua 

local Entity = require("Entity")
local EntityRef = require("EntityRef")
local Vat = require("Class").create(Entity, "Vat")
local SpriteSheet = require("SpriteSheet")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
Vat.addIntegerField("healAmount", 0)
Vat.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/Vat/Vat")
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:get(SpriteComponent).prop:setLoc(0, 96)
  l_1_0.portProp = MOAIProp.new()
  l_1_0.portProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  l_1_0.portSheet = SpriteSheet.load("Interactions/Props/Placeholder/Port/Port")
  local firstName = next(l_1_0.portSheet.data.animations, nil)
  local deck, index = l_1_0.portSheet:getDeck(firstName, 1, false)
  l_1_0.portProp:setDeck(deck)
  l_1_0.portProp:setIndex(index)
  l_1_0:attachProp(l_1_0.portProp)
  l_1_0.portProp:setScl(3, 3)
  local portX, portY = l_1_0.portProp:getLoc()
  local offset = -16
  l_1_0.portProp:setLoc(portX, portY + offset)
  l_1_0.portProp:setPriority(offset + 1)
  l_1_0.portProp:forceUpdate()
  l_1_0.healAmount = l_1_0:universe().state.state.forestHealAmount
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

