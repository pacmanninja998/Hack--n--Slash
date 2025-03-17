-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\BitmapLetter.lua 

local Entity = require("Entity")
local Font = require("Font")
local BitmapLetter = require("Class").create(Entity, "BitmapLetter")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
BitmapLetter.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.size = 48
  PhysicsComponent.new(l_1_0, l_1_0.size, l_1_0.size, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  InteractionComponent.new(l_1_0)
  l_1_0.letterProp = MOAIProp.new()
  l_1_0.letterProp:setPriority(-32)
  l_1_0.letterProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  l_1_0:attachProp(l_1_0.letterProp)
  l_1_0.letterDeck = MOAIGfxQuadDeck2D.new()
  l_1_0:setLabelText("")
end

BitmapLetter.setFontData = function(l_2_0, l_2_1, l_2_2, l_2_3)
  _, l_2_0.fontData = next(l_2_1), l_2_1
  if not l_2_2 then
    l_2_0.fontTexture = l_2_0.fontTexture
  end
  if not l_2_3 or not string.byte(l_2_3, 1) then
    l_2_0.letterCode = l_2_0.letterCode
  end
  local glyphData = l_2_0.fontData.mGlyphMap[l_2_0.letterCode]
  local texW, texH = l_2_0.fontTexture:getSize()
  l_2_0.letterDeck:setTexture(l_2_0.fontTexture)
  l_2_0.letterDeck:reserve(1)
  l_2_0.letterDeck:setUVQuad(1, glyphData.mSrcX / texW, glyphData.mSrcY / texH, (glyphData.mSrcX + glyphData.mWidth) / texW, glyphData.mSrcY / texH, (glyphData.mSrcX + glyphData.mWidth) / texW, (glyphData.mSrcY + glyphData.mHeight) / texH, glyphData.mSrcX / texW, (glyphData.mSrcY + glyphData.mHeight) / texH)
  local halfWidth, halfHeight = l_2_0.size / 2, l_2_0.size / 2
  if glyphData.mWidth < glyphData.mHeight then
    halfWidth = halfHeight * (glyphData.mWidth / glyphData.mHeight)
  else
    halfHeight = halfWidth * (glyphData.mHeight / glyphData.mWidth)
  end
  l_2_0.letterDeck:setRect(1, -(halfWidth), -(halfHeight), halfWidth, halfHeight)
  l_2_0.letterProp:setDeck(l_2_0.letterDeck)
end

return BitmapLetter

