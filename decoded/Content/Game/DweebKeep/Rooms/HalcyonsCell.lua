-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\HalcyonsCell.lua 

local HalcyonsCell = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/HalcyonsCell", "HalcyonsCell", "Content/Game/Global/Rooms/GameRoom")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local Math = require("DFCommon.Math")
local Music = require("Music")
local Entity = require("Entity")
local Direction = require("Direction")
local Shader = require("Shader")
local Gui = require("Gui")
HalcyonsCell.DEFAULT_WAVELENGTH = 390
HalcyonsCell.SLIT_WIDTH = 200
HalcyonsCell.WAVELENGTH_FACTOR = 0.1
local DiffractionParticle = require("Class").create(Entity, "DiffractionParticle")
DiffractionParticle.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Entity.init(l_1_0, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0.sprite = SpriteComponent.new(l_1_0, l_1_1)
  l_1_0.sprite.prop:setPriority(l_1_6)
  l_1_0.diffractionShader = Shader.create("Content/Game/Global/Shaders/SlitDiffraction")
  l_1_0.sprite:setDefaultShader(l_1_0.diffractionShader)
  l_1_0.diffractionShader:setFragmentUniformFloat("ShaderIntensity", 1)
end

HalcyonsCell.onInit = function(l_2_0)
  l_2_0:defineCollisionExit("InnerPrisonLobby exit", "Content/Game/DweebKeep/Rooms/InnerPrisonLobby", "HalcyonsCell exit")
  Music:playMusic(nil)
  Music:playAmbient("Ambience/Ambience/HalcyonCell_Ambience")
  require("Music"):playMusic("Music/Music/InnerPrison_Cue1", false)
  Music:setReverb("Reflective")
  local gameplayLayer = l_2_0:getLayerByOrder(0)
  l_2_0.fringeWalls = {}
  if not l_2_0:getState().wavelength then
    l_2_0.wavelength = l_2_0.DEFAULT_WAVELENGTH
  end
  l_2_0.wavelengthPortBlock = l_2_0:getEntity("WavelengthPortBlock")
  l_2_0.wavelengthPortBlock.WAVELENGTH = l_2_0.DEFAULT_WAVELENGTH
  l_2_0.wavelengthPortBlock.fieldSetEvent:register(l_2_0.onPortBlockFieldSet, l_2_0)
  l_2_0.slitX, l_2_0.slitY = l_2_0:getEntity("Slit Locator"):getPosition(), l_2_0:getEntity("Slit Locator")
  local overoverlayLayer = l_2_0:getLayerByName("Overoverlay")
  l_2_0.diffraction = DiffractionParticle.new("Particles/Textures/White/White", overoverlayLayer, l_2_0.slitX, l_2_0.slitY, overoverlayLayer:uniqueNameForEntity("Diffraction"), 1500)
  l_2_0:onPortBlockFieldSet("WAVELENGTH", l_2_0.wavelength, l_2_0.wavelengthPortBlock)
  l_2_0.lamp = l_2_0:getEntity("HalcyonLamp")
  l_2_0.lamp:get(InteractionComponent).interactEvent:register(l_2_0.onLampInteract, l_2_0)
  if l_2_0:getState()["Took lamp"] then
    l_2_0.lamp:destroy()
  end
  for i = 1, 2 do
    l_2_0:getEntity("ReflectionBlock " .. tostring(i)).prop:setVisible(false)
  end
  l_2_0.hsvTint = {0.083, -0.111, 0}
end

HalcyonsCell.onLampInteract = function(l_3_0, l_3_1)
  l_3_0:getState()["Took lamp"] = true
end

HalcyonsCell.waveLengthToRGB = function(l_4_0, l_4_1)
  local minHue, maxHue = 0, 0.83333333333333
  local minWavelength, maxWavelength = 38, 75
  l_4_1 = math.min(maxWavelength, math.max(minWavelength, l_4_1))
  local hue = Math.lerp(minHue, maxHue, (maxWavelength - l_4_1) / (maxWavelength - minWavelength))
  return Math.hsl2rgb(hue, 1, 0.5)
end

HalcyonsCell.onPortBlockFieldSet = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_3 == l_5_0.wavelengthPortBlock and l_5_1 == "WAVELENGTH" then
    l_5_0.wavelength = l_5_2 * l_5_0.WAVELENGTH_FACTOR
    l_5_0:getState().wavelength = l_5_2
    local r, g, b = l_5_0:waveLengthToRGB(l_5_0.wavelength)
    local fringeWallIndex = 0
    local numFringePoints = 1
    repeat
      if numFringePoints > 0 then
        numFringePoints = l_5_0:updatePoints(fringeWallIndex, l_5_0.wavelength, l_5_0.SLIT_WIDTH, r, g, b)
        fringeWallIndex = fringeWallIndex + 1
      else
        fringeWallIndex = fringeWallIndex - 1
        repeat
          if l_5_0.fringeWalls[fringeWallIndex] then
            l_5_0.fringeWalls[fringeWallIndex]:destroy()
            l_5_0.fringeWalls[fringeWallIndex] = nil
            fringeWallIndex = fringeWallIndex + 1
          else
            fringeWallIndex = -1
            numFringePoints = 1
            repeat
              if numFringePoints > 0 then
                numFringePoints = l_5_0:updatePoints(fringeWallIndex, l_5_0.wavelength, l_5_0.SLIT_WIDTH, r, g, b)
                fringeWallIndex = fringeWallIndex - 1
              else
                fringeWallIndex = fringeWallIndex + 1
                repeat
                  if l_5_0.fringeWalls[fringeWallIndex] then
                    l_5_0.fringeWalls[fringeWallIndex]:destroy()
                    l_5_0.fringeWalls[fringeWallIndex] = nil
                    fringeWallIndex = fringeWallIndex - 1
                  else
                    local widthX = l_5_0.sizeX - l_5_0.slitX
                    local sizeX = widthX / 512
                    local sizeY = l_5_0.sizeY / 512
                    l_5_0.diffraction:setPosition(l_5_0.slitX + widthX * 0.5, l_5_0.slitY)
                    l_5_0.diffraction.sprite.prop:setScl(sizeX, sizeY)
                    local slitUVY = l_5_0.slitY / l_5_0.sizeY
                    local slitWidthV = l_5_0.SLIT_WIDTH / l_5_0.sizeY
                    l_5_0.diffraction.diffractionShader:setFragmentUniformFloat("Wavelength", l_5_0.wavelength)
                    l_5_0.diffraction.diffractionShader:setFragmentUniform("ColorTint", {r, g, b})
                    l_5_0.diffraction.diffractionShader:setFragmentUniform("SlitLocationA", {0, slitUVY + slitWidthV})
                    l_5_0.diffraction.diffractionShader:setFragmentUniform("SlitLocationB", {0, slitUVY - slitWidthV})
                  end
                   -- Warning: missing end command somewhere! Added here
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HalcyonsCell.updatePoints = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4, l_6_5, l_6_6)
  local fringeWall = l_6_0.fringeWalls[l_6_1]
  if not fringeWall then
    fringeWall = Entity.create("Content/Game/DweebKeep/Entities/FringeWall", l_6_0:getLayerByOrder(0), l_6_0.slitX, l_6_0.slitY, "FringeWall " .. tostring(l_6_1), l_6_2, l_6_3, l_6_1, nil, l_6_4, l_6_5, l_6_6)
    l_6_0.fringeWalls[l_6_1] = fringeWall
  end
  return fringeWall:updatePoints(l_6_2, l_6_3, l_6_4, l_6_5, l_6_6)
end

return HalcyonsCell

