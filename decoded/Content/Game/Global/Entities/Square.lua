-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Square.lua 

local Class = require("Class")
local Entity = require("Entity")
local Square = Class.create(Entity, "Square")
Square.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Square).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local image = MOAIImage.new()
  image:init(4, 4)
  image:fillRect(0, 0, 4, 4, 1, 1, 1, 1)
  local deck = MOAIGfxQuad2D.new()
  deck:setTexture(image)
  deck:setRect(0, 0, 1, 1)
  l_1_0.squareProp = MOAIProp.new()
  l_1_0.squareProp:setDeck(deck)
  l_1_0:attachProp(l_1_0.squareProp)
end

Square.preDestroy = function(l_2_0)
  l_2_0:detachProp(l_2_0.squareProp)
end

Square.setColor = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  l_3_0.prop:setColor(l_3_1, l_3_2, l_3_3, l_3_4)
end

Square.setSize = function(l_4_0, l_4_1, l_4_2)
  l_4_0.squareProp:setScl(l_4_1, l_4_2)
end

return Square

