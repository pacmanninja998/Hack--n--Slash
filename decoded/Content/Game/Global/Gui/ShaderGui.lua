-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ShaderGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local ShaderGui = Class.create(Gui, "ShaderGui")
ShaderGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  if not l_1_3 then
    l_1_3 = {}
  end
  Class.super(ShaderGui).init(l_1_0, l_1_1)
  l_1_0.shader = l_1_2
  l_1_0.material = l_1_2:makeMaterial(nil)
  l_1_0.material:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  local image = MOAIImage.new()
  image:init(4, 4)
  if not l_1_3.color then
    image:fillRect(0, 0, 4, 4, unpack({1, 1, 1, 1}))
  end
  local deck = MOAIGfxQuad2D.new()
  deck:setTexture(image)
  deck:setRect(0, 0, 1, 1)
  l_1_0.shaderProp = MOAIProp.new()
  l_1_0.shaderProp:setDeck(deck)
  l_1_0.shaderProp:setMaterial(l_1_0.material)
  l_1_0:addProp(l_1_0.shaderProp)
end

ShaderGui.resize = function(l_2_0, l_2_1, l_2_2)
  Class.super(ShaderGui).resize(l_2_0, l_2_1, l_2_2)
  l_2_0.shaderProp:setScl(l_2_1, l_2_2)
end

return ShaderGui

