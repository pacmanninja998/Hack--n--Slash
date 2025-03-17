-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\GlyphRoom.lua 

local GlyphRoom = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/GlyphRoom", "GlyphRoom", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local EntitySet = require("EntitySet")
local Direction = require("Direction")
local Font = require("Font")
local Graphics = require("DFCommon.Graphics")
local PortBlock = Entity.cache:load("Content/Game/Global/Entities/PortBlock")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
local Music = require("Music")
GlyphRoom.PANGRAM = "THE FIVE BOXING WIZARDS JUMP QUICKLY"
GlyphRoom.LETTER_SPACING_X = 51
GlyphRoom.LETTER_SPACING_Y = 52
GlyphRoom.FAKE_ORIGIN_X = 1200
GlyphRoom.FAKE_SIZE_X = 1692
GlyphRoom.FAKE_WALL_ENTITY_NAMES = {"Movingwall", "MovingStrut 1", "MovingStrut 2", "Torch_Shadow_Flipped 3", "Torch_Shadow_Flipped 4"}
GlyphRoom.FAKE_WALL_MOVE_X = -1600
GlyphRoom.FAKE_WALL_MOVE_TIME = 5
GlyphRoom.NOTE_SEQUENCE = {1, 2, 3, 4, 5, 4, 3, 2, 5}
GlyphRoom.NOTE_CUES = {"SFX/Objects/GlyphTones/GlyphTone_A1", "SFX/Objects/GlyphTones/GlyphTone_E", "SFX/Objects/GlyphTones/GlyphTone_F_Sharp", "SFX/Objects/GlyphTones/GlyphTone_G_Sharp", "SFX/Objects/GlyphTones/GlyphTone_A2"}
GlyphRoom.FINAL_CUE = "SFX/Objects/GlyphTones/GlyphTone_A_Major"
GlyphRoom.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("ArmoryWestHallway exit", "Content/Game/DweebKeep/Rooms/Armory", "ArmoryWestHallway exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  l_1_0.shiftedFont = Font.load(Font.SHIFTED_PATH)
  l_1_0.hackUOffset, l_1_0.hackVOffset = l_1_0.shiftedFont.uOffset, l_1_0.shiftedFont.vOffset
  l_1_0.shiftedFont:setUVOffsets(l_1_0.hackUOffset, l_1_0.hackVOffset)
  l_1_0.shiftedFontData = l_1_0.shiftedFont.font:getData()
  l_1_0.shiftedFontTex = Graphics.loadTexture(Font.SHIFTED_PATH .. "_0")
  l_1_0.shiftedFontTex:setFilter(MOAITexture.GL_LINEAR, MOAITexture.GL_NEAREST)
  l_1_0.symbolicFont = Font.load(Font.GLYPH_PATH)
  l_1_0.symbolicFontData = l_1_0.symbolicFont.font:getData()
  l_1_0.symbolicFontTex = Graphics.loadTexture(Font.GLYPH_PATH)
  l_1_0.symbolicFontTex:setFilter(MOAITexture.GL_LINEAR, MOAITexture.GL_NEAREST)
  l_1_0.shiftedLetters = EntitySet.new()
  l_1_0.bitmapLetters = EntitySet.new()
  l_1_0.shiftedLetterStartLocator = l_1_0:getEntity("ShiftedLetter Start Locator")
  l_1_0.bitmapLetterStartLocator = l_1_0:getEntity("BitmapLetter Start Locator")
  local shiftedStartX, shiftedStartY = l_1_0.shiftedLetterStartLocator:getPosition()
  local bitmapStartX, bitmapStartY = l_1_0.bitmapLetterStartLocator:getPosition()
  for i = 1, 36 do
    local xIndex = (i - 1) % 6
    local yIndex = (i - 1 - xIndex) / 6
    local shiftedPosX, shiftedPosY = shiftedStartX + l_1_0.LETTER_SPACING_X * xIndex, shiftedStartY - l_1_0.LETTER_SPACING_Y * yIndex
    local shiftedLetter = Entity.create("Content/Game/DweebKeep/Entities/ShiftedLetter", gameplayLayer, shiftedPosX, shiftedPosY, "ShiftedLetter " .. tostring(i))
    shiftedLetter:setFontData(l_1_0.shiftedFontData, l_1_0.shiftedFontTex, string.sub(l_1_0.PANGRAM, i, i))
    l_1_0.shiftedLetters:addEntity(shiftedLetter)
    local bitmapPosX, bitmapPosY = bitmapStartX + l_1_0.LETTER_SPACING_X * xIndex, bitmapStartY - l_1_0.LETTER_SPACING_Y * yIndex
    local bitmapLetter = Entity.create("Content/Game/DweebKeep/Entities/BitmapLetter", gameplayLayer, bitmapPosX, bitmapPosY, "BitmapLetter " .. tostring(i))
    if l_1_0:universe().state.state.fixedSymbolicFont then
      bitmapLetter:setFontData(l_1_0.shiftedFontData, l_1_0.shiftedFontTex, string.sub(l_1_0.PANGRAM, i, i))
    else
      bitmapLetter:setFontData(l_1_0.symbolicFontData, l_1_0.symbolicFontTex, string.sub(l_1_0.PANGRAM, i, i))
    end
    l_1_0.bitmapLetters:addEntity(bitmapLetter)
    bitmapLetter:get(InteractionComponent).interactEvent:register(l_1_0.onBitmapInteract, l_1_0)
  end
  l_1_0.portBlockU = l_1_0:getEntity("Port 1")
  l_1_0.portBlockU.OFFSET = l_1_0.hackUOffset
  l_1_0.portBlockU:setLabelText("Font U Port")
  l_1_0.portBlockU.fieldSetEvent:register(l_1_0.onPortBlockFieldSet, l_1_0)
  l_1_0.portBlockV = l_1_0:getEntity("Port 2")
  l_1_0.portBlockV.OFFSET = l_1_0.hackVOffset
  l_1_0.portBlockV:setLabelText("Font V Port")
  l_1_0.portBlockV.fieldSetEvent:register(l_1_0.onPortBlockFieldSet, l_1_0)
  l_1_0.soundButtonMap = {}
  for i = 1, 5 do
    local keyIndexStr = tostring(6 - i)
    local soundButton = l_1_0:getEntity("Key " .. keyIndexStr)
    soundButton.pressedAnim = "KeyPressed " .. keyIndexStr
    l_1_0.soundButtonMap[soundButton] = i
    soundButton.pressedEvent:register(l_1_0.onSoundButtonPressed, l_1_0)
    l_1_0:getEntity("KeyPressed " .. keyIndexStr):destroy()
  end
  l_1_0.nextHitIndex = 1
  l_1_0:setSoundButtonLabels()
  l_1_0.initOriginX, l_1_0.initSizeX = l_1_0.originX, l_1_0.sizeX
  l_1_0.fakeWallEntities = {}
  for i,entityName in ipairs(GlyphRoom.FAKE_WALL_ENTITY_NAMES) do
    l_1_0.fakeWallEntities[i] = l_1_0:getEntity(entityName)
  end
  if l_1_0:getState().FakeWallMoved then
    l_1_0:moveFakeWall(GlyphRoom.FAKE_WALL_MOVE_X, 0)
  else
    l_1_0.originX = l_1_0.FAKE_ORIGIN_X
    l_1_0.sizeX = l_1_0.FAKE_SIZE_X
  end
  Music:playAmbient("Ambience/Ambience/GlyphRoom_Ambience")
  Music:setReverb("Reflective")
  l_1_0.hsvTint = {0.083, -0.111, 0}
end

GlyphRoom.moveFakeWall = function(l_2_0, l_2_1, l_2_2)
  local perStepDiffX, numSteps = l_2_1, 1
  local soundEvent = nil
   -- DECOMPILER ERROR: Overwrote pending register.

  if l_2_2 > 0 then
    numSteps = l_2_2 / nil.getStep()
    perStepDiffX = l_2_1 / (numSteps)
    local posX, posY = l_2_0:getEntity("Movingwall"):getPosition()
    soundEvent = MOAIFmodEventMgr.playEvent3D("SFX/Objects/GlyphRoom_WallSlide", posX, posY, 0, true)
  end
  do
    local stepsElapsed = 0
    repeat
      repeat
        if stepsElapsed < numSteps then
          for i,entity in ipairs(l_2_0.fakeWallEntities) do
            local posX, posY = entity:getPosition()
            local newX, newY = posX + perStepDiffX, posY
            entity:setPosition(newX, newY)
          end
          stepsElapsed = stepsElapsed + 1
        until l_2_2 > 0
        coroutine.yield()
      elseif l_2_2 > 0 and soundEvent then
        soundEvent:stop()
      end
      l_2_0:getState().FakeWallMoved = true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GlyphRoom.moveWallScene = function(l_3_0)
  local alice = l_3_0:getAlice()
  if alice then
    local sceneComponent = alice:get(SceneComponent)
    if sceneComponent then
      sceneComponent:play(function(l_1_0)
      alice:halt(true)
      self:moveFakeWall(GlyphRoom.FAKE_WALL_MOVE_X, GlyphRoom.FAKE_WALL_MOVE_TIME)
      l_1_0:sleep(0.5)
      local alicePortrait = l_1_0:addAlicePortrait()
      local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
      l_1_0:speakLineLeft(alicePortrait, "Woah.")
      l_1_0:speakLineRight(bobPortrait, "Awesome.")
      alice:halt(false)
      self.originX = self.initOriginX
      self.sizeX = self.initSizeX
      end)
    end
  end
end

GlyphRoom.onPortBlockFieldSet = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_1 == "OFFSET" then
    local updateOffsets = false
    if l_4_3 == l_4_0.portBlockU then
      l_4_0.hackUOffset = l_4_2
      updateOffsets = true
    elseif l_4_3 == l_4_0.portBlockV then
      l_4_0.hackVOffset = l_4_2
      updateOffsets = true
    end
    if updateOffsets then
      l_4_0.shiftedFont:setUVOffsets(l_4_0.hackUOffset, l_4_0.hackVOffset)
      l_4_0:universe().state.state.shiftedFontUV = {l_4_0.hackUOffset, l_4_0.hackVOffset}
      l_4_0.shiftedFontData = l_4_0.shiftedFont.font:getData()
      for _,shiftedLetter in pairs(l_4_0.shiftedLetters.entities) do
        shiftedLetter:setFontData(l_4_0.shiftedFontData)
      end
    end
  end
end

GlyphRoom.onBitmapInteract = function(l_5_0, l_5_1, l_5_2)
  local sceneComponent = l_5_1:get(SceneComponent)
  if sceneComponent then
    sceneComponent:play(function(l_1_0)
    interactor:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    if self:universe().state.state.fixedSymbolicFont then
      l_1_0:speakLineLeft(alicePortrait, "These look good to me!")
    else
      local shiftedUV = self:universe().state.state.shiftedFontUV
      if shiftedUV[1] >= -2 and shiftedUV[1] <= 2 and shiftedUV[2] >= -2 and shiftedUV[2] <= 2 then
        l_1_0:speakLineRight(bobPortrait, "Let's copy the letters from the left side!")
        for _,bitmapLetter in pairs(self.bitmapLetters.entities) do
          bitmapLetter:setFontData(self.shiftedFontData, self.shiftedFontTex)
        end
        self:universe().state.state.fixedSymbolicFont = true
        for path,room in pairs(self.world.activeRooms) do
          for name,entity in pairs(room.entitiesByName) do
            entity.label:setStyles(Font.STANDARD_PATH)
          end
        end
      else
        if not self:getState().ExaminedBitmapLetters then
          l_1_0:speakLineLeft(alicePortrait, "Is this where all of those glyphs I've been seeing come from?")
          l_1_0:speakLineRight(bobPortrait, "It looks like we can draw whatever we want on these tiles.")
          l_1_0:speakLineRight(bobPortrait, "You could go do a careful frequency analysis of the glyphs you've seena and tabulate--")
          l_1_0:speakLineLeft(alicePortrait, "Let's see if we can figure out something simpler.")
          l_1_0:speakLineRight(bobPortrait, "Up to you!")
          self:getState().ExaminedBitmapLetters = true
        else
          l_1_0:speakLineRight(bobPortrait, "I wonder if we can find a cheat sheet somewhere.")
        end
      end
    end
    interacted:get(InteractionComponent):stopInteract(interactor)
    interactor:halt(false)
   end)
  end
end

GlyphRoom.setSoundButtonLabels = function(l_6_0)
  for i = 1, 5 do
    local soundButton = l_6_0.entitiesByName["Key " .. tostring(6 - i)]
    if soundButton then
      local buttonIndex = l_6_0.soundButtonMap[soundButton]
      if buttonIndex then
        if buttonIndex == l_6_0.NOTE_SEQUENCE[l_6_0.nextHitIndex] then
          soundButton:setLabelText("O")
        else
          soundButton:setLabelText("X")
        end
      end
    end
  end
end

GlyphRoom.onSoundButtonPressed = function(l_7_0, l_7_1, l_7_2)
  if not l_7_0:getState().FakeWallMoved and l_7_1 and l_7_2 then
    local buttonIndex = l_7_0.soundButtonMap[l_7_1]
    if buttonIndex then
      Trace(TT_Info, "Played buttonIndex %d", buttonIndex)
      local cue = GlyphRoom.NOTE_CUES[buttonIndex]
      if buttonIndex == l_7_0.NOTE_SEQUENCE[l_7_0.nextHitIndex] then
        if l_7_0.nextHitIndex == #l_7_0.NOTE_SEQUENCE then
          cue = GlyphRoom.FINAL_CUE
          l_7_0:moveWallScene()
        end
        l_7_0.nextHitIndex = l_7_0.nextHitIndex + 1
      else
        l_7_0.nextHitIndex = 1
      end
      l_7_0:setSoundButtonLabels()
      l_7_1:get(SoundComponent):playCue(cue, false)
    end
  end
end

return GlyphRoom

