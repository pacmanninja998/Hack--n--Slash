-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\FramedGui.lua 

local Gui = require("Gui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local FramedGui = require("Class").create(Gui, "FramedGui")
FramedGui.init = function(l_1_0, l_1_1, l_1_2)
  Gui.init(l_1_0, l_1_1, true)
  l_1_0.frameGuis = {}
  if l_1_2 then
    l_1_0:setSpritesheet(l_1_2)
  end
end

FramedGui.setInnerGui = function(l_2_0, l_2_1, l_2_2)
  l_2_0.inner = l_2_1
  if l_2_2 then
    if not l_2_2.W then
      l_2_0.innerBorderW = l_2_0.borderW
    end
    if not l_2_2.E then
      l_2_0.innerBorderE = l_2_0.borderE
    end
    if not l_2_2.S then
      l_2_0.innerBorderS = l_2_0.borderS
    end
    if not l_2_2.N then
      l_2_0.innerBorderN = l_2_0.borderN
  else
    end
    l_2_0.innerBorderW, l_2_0.innerBorderE, l_2_0.innerBorderS, l_2_0.innerBorderN = l_2_0.borderW, l_2_0.borderE, l_2_0.borderS, l_2_0.borderN
  end
  l_2_0:requestResize()
end

FramedGui.handleFocusGain = function(l_3_0)
  if l_3_0.root.focus == l_3_0 and l_3_0.inner then
    l_3_0.root:setFocus(l_3_0.inner)
  end
end

FramedGui.setSpritesheet = function(l_4_0, l_4_1)
  for name,prop in pairs(l_4_0.frameGuis) do
    l_4_0.layer:removeProp(prop)
    l_4_0.frameGuis[name] = nil
  end
  local frameSizes = {}
  local addFrameSprite = function(l_1_0)
    do
      local gui = SpriteGui.new(self, spritesheet, l_1_0, {stretch = true})
      self.frameGuis[l_1_0] = gui
       -- DECOMPILER ERROR: No list found. Setlist fails

    end
     -- Warning: undefined locals caused missing assignments!
   end
  addFrameSprite("E")
  addFrameSprite("NE")
  addFrameSprite("N")
  addFrameSprite("NW")
  addFrameSprite("W")
  addFrameSprite("SW")
  addFrameSprite("S")
  addFrameSprite("SE")
  addFrameSprite("Center")
  l_4_0.borderW = math.max(frameSizes.SW[1], frameSizes.W[1], frameSizes.NW[1])
  l_4_0.borderE = math.max(frameSizes.SE[1], frameSizes.E[1], frameSizes.NE[1])
  l_4_0.borderS = math.max(frameSizes.SW[2], frameSizes.S[2], frameSizes.SE[2])
  l_4_0.borderN = math.max(frameSizes.NW[2], frameSizes.N[2], frameSizes.NE[2])
  l_4_0:requestResize()
end

FramedGui.measure = function(l_5_0, l_5_1, l_5_2)
  if l_5_0.inner then
    if next(l_5_0.frameGuis) then
      l_5_1 = l_5_1 - l_5_0.innerBorderW - l_5_0.innerBorderE
      l_5_2 = l_5_2 - l_5_0.innerBorderN - l_5_0.innerBorderS
    end
    local innerX, innerY = l_5_0.inner:measure(l_5_1, l_5_2)
    local totalX, totalY = innerX + l_5_0.innerBorderW + l_5_0.innerBorderE, innerY + l_5_0.innerBorderN + l_5_0.innerBorderS
    if totalX < l_5_0.borderW + l_5_0.borderE then
      totalX = l_5_0.borderW + l_5_0.borderE
    end
    if totalY < l_5_0.borderN + l_5_0.borderS then
      totalY = l_5_0.borderN + l_5_0.borderS
    end
    return totalX, totalY
  else
    return l_5_0.borderW + l_5_0.borderE, l_5_0.borderN + l_5_0.borderS
  end
end

FramedGui.resize = function(l_6_0, l_6_1, l_6_2)
  Gui.resize(l_6_0, l_6_1, l_6_2)
  l_6_0.frameGuis.SW:position(0, 0, l_6_0.borderW, l_6_0.borderS)
  l_6_0.frameGuis.SE:position(l_6_1 - l_6_0.borderE, 0, l_6_1, l_6_0.borderS)
  l_6_0.frameGuis.NW:position(0, l_6_2 - l_6_0.borderN, l_6_0.borderW, l_6_2)
  l_6_0.frameGuis.NE:position(l_6_1 - l_6_0.borderE, l_6_2 - l_6_0.borderN, l_6_1, l_6_2)
  l_6_0.frameGuis.W:position(0, l_6_0.borderS, l_6_0.borderW, l_6_2 - l_6_0.borderN)
  l_6_0.frameGuis.E:position(l_6_1 - l_6_0.borderS, l_6_0.borderS, l_6_1, l_6_2 - l_6_0.borderN)
  l_6_0.frameGuis.S:position(l_6_0.borderW, 0, l_6_1 - l_6_0.borderE, l_6_0.borderS)
  l_6_0.frameGuis.N:position(l_6_0.borderW, l_6_2 - l_6_0.borderN, l_6_1 - l_6_0.borderE, l_6_2)
  l_6_0.frameGuis.Center:position(l_6_0.borderW, l_6_0.borderS, l_6_1 - l_6_0.borderE, l_6_2 - l_6_0.borderN)
  if l_6_0.inner then
    l_6_0.inner:position(l_6_0.innerBorderW, l_6_0.innerBorderS, l_6_1 - l_6_0.innerBorderE, l_6_2 - l_6_0.innerBorderN)
  end
end

return FramedGui

