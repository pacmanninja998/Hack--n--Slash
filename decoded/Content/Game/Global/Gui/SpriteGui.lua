-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\SpriteGui.lua 

local Gui = require("Gui")
local SpriteGui = require("Class").create(Gui, "SpriteGui")
SpriteGui.DEFAULT_FRAME_RATE = 15
SpriteGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0, l_1_1)
  if l_1_2 and not l_1_3 then
    l_1_3 = next(l_1_2.data.animations)
  end
  if not l_1_4 then
    l_1_4 = {}
  end
  l_1_0.spriteProp = MOAIProp.new()
  l_1_0.spriteProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  l_1_0:addProp(l_1_0.spriteProp)
  l_1_0.stretch = l_1_4.stretch
  l_1_0.magnify = l_1_4.magnify or 1
  l_1_0.blinkDuration = l_1_4.blinkDuration
  if l_1_2 and l_1_3 then
    l_1_0:setSprite(l_1_2, l_1_3, l_1_4.frameRate, l_1_4.loop)
  end
end

SpriteGui.setSprite = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  if l_2_4 == nil then
    l_2_4 = true
  end
  l_2_0.spritesheet, l_2_0.name = l_2_1, l_2_2
  if not l_2_3 then
    l_2_0.frameRate = l_2_0.DEFAULT_FRAME_RATE
  end
  l_2_0.elapsed = 0
  l_2_0.loop = l_2_4
  l_2_0:advance(0)
end

SpriteGui.setDefaultShader = function(l_3_0, l_3_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_3_0.spriteProp:setMaterial(l_3_1:makeMaterial(nil))
 -- DECOMPILER ERROR: Confused about usage of registers!

l_3_0.material = l_3_1:makeMaterial(nil)
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SpriteGui.reset = function(l_4_0)
  l_4_0:setSprite(l_4_0.spritesheet, l_4_0.name, l_4_0.frameRate, l_4_0.loop)
end

SpriteGui.tick = function(l_5_0)
  Gui.tick(l_5_0)
  l_5_0:advance(MOAISim.getStep())
end

SpriteGui.setColor = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  l_6_0.spriteProp:setColor(l_6_1, l_6_2, l_6_3, l_6_4)
end

SpriteGui.finished = function(l_7_0)
  if l_7_0.loop then
    return false
  end
  local frame = math.floor(1 + l_7_0.elapsed * l_7_0.frameRate)
  return l_7_0.spritesheet:getFrameCount(l_7_0.name) <= frame
end

SpriteGui.advance = function(l_8_0, l_8_1)
  if l_8_0.frameRate ~= 0 then
    l_8_0.elapsed = l_8_0.elapsed + l_8_1
    local frame = math.floor(1 + l_8_0.elapsed * l_8_0.frameRate)
    local deck, index = l_8_0.spritesheet:getDeck(l_8_0.name, frame, l_8_0.loop)
    if deck and index then
      l_8_0.spriteProp:setDeck(deck)
      l_8_0.spriteProp:setIndex(index)
    end
  end
  if math.floor(l_8_0.elapsed / l_8_0.blinkDuration) % 2 ~= 1 then
    local blinking = not l_8_0.blinkDuration
  end
  l_8_0.spriteProp:setVisible(not blinking)
end

SpriteGui.resize = function(l_9_0, l_9_1, l_9_2)
  Gui.resize(l_9_0, l_9_1, l_9_2)
  if not l_9_0.spritesheet then
    return 
  end
  local width, height = l_9_0.spritesheet:getDimensions(l_9_0.name)
  l_9_0.spriteProp:setLoc(l_9_1 * 0.5, l_9_2 * 0.5)
  local scaleX, scaleY = l_9_1 / width, l_9_2 / height
  if not l_9_0.stretch then
    local scale = math.min(scaleX, scaleY)
    l_9_0.spriteProp:setScl(scale * l_9_0.magnify)
  else
    l_9_0.spriteProp:setScl(scaleX * l_9_0.magnify, scaleY * l_9_0.magnify)
  end
end

return SpriteGui

