-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ColorGui.lua 

local Gui = require("Gui")
local ColorGui = require("Class").create(Gui, "ColorGui")
ColorGui.BORDER_BUFFER = 1
ColorGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Gui.init(l_1_0, l_1_1)
  local image = MOAIImage.new()
  image:init(4, 4)
  image:fillRect(0, 0, 4, 4, 1, 1, 1, 1)
  local deck = MOAIGfxQuad2D.new()
  deck:setTexture(image)
  deck:setRect(0, 0, 1, 1)
  l_1_0.colorProp = MOAIProp.new()
  l_1_0.colorProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  l_1_0.colorProp:setDeck(deck)
  l_1_0:addProp(l_1_0.colorProp)
  l_1_0:setColor(l_1_2, l_1_3, l_1_4, l_1_5)
end

ColorGui.setColor = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_0.colorProp:setColor(l_2_1, l_2_2, l_2_3, l_2_4)
end

ColorGui.resize = function(l_3_0, l_3_1, l_3_2)
  Gui.resize(l_3_0, l_3_1, l_3_2)
  l_3_0.colorProp:setLoc(-0.5 * l_3_0.BORDER_BUFFER, -0.5 * l_3_0.BORDER_BUFFER)
  l_3_0.colorProp:setScl(l_3_1 + l_3_0.BORDER_BUFFER, l_3_2 + l_3_0.BORDER_BUFFER)
end

return ColorGui

