-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CaveStash.lua 

local Room = require("Room")
local Class = require("Class")
local CaveStash = Room.classFromLayout("Content/Game/CrackerCavern/Layouts/CaveStash", "CaveStash", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local Direction = require("Direction")
local PhysicsComponent = require("Components.PhysicsComponent")
local FunctionComponent = require("Components.FunctionComponent")
local SceneComponent = require("Components.SceneComponent")
local LogoComponent = require("Components.LogoComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local Music = require("Music")
CaveStash.BLOCK_PASSWORD = "hack the planet"
CaveStash.BLOCK_PASSWORD_STRINGS = {"hack", " t", "he pl", "an", "et"}
CaveStash.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("CaveLab exit", "Content/Game/CrackerCavern/Rooms/CaveLab", "CaveStash exit")
  l_1_0:defineCollisionExit("Completion exit", "Content/Game/CrackerCavern/Rooms/CaveLab", "Completion entrance")
  require("Music"):playMusic("Music/Music/CaveStash_Cue1", false)
  Music:playAmbient("Ambience/Ambience/CaveStash_Ambience")
  Music:setReverb("SmallPreDelayReverb")
  l_1_0.gameplayLayer = l_1_0:getLayerByOrder(0)
  l_1_0:setupAbysses()
  l_1_0:setupLayoutPlatforms()
  l_1_0:setupFunctions()
  l_1_0:setupHackPlatforms()
  l_1_0:setupFakeWall()
  l_1_0:setupTiles()
  l_1_0:setupText()
  Entity.create("Content/Game/Global/Entities/Effects/CloudA", l_1_0:getLayerByName("Fog"), 2000, 3800, nil, 1, "Particles/Textures/SlowFogA/SlowFogA", 2000, 4000, 4, 20, 10, 15, 3, 2, 0.8, 1000)
  l_1_0:enableWater()
end

CaveStash.setupAbysses = function(l_2_0)
  for abyssIndex = 1, 30 do
    local abyssName = "Abyss " .. tostring(abyssIndex)
    local abyss = l_2_0.collisionAreasByName[abyssName]
    if abyss then
      Entity.create("Content/Game/Global/Entities/Abyss", l_2_0.gameplayLayer, nil, nil, abyssName, abyss)
    end
  end
end

CaveStash.setupLayoutPlatforms = function(l_3_0)
  for platformIndex = 1, 1 do
    local platformName = "Platform " .. tostring(platformIndex)
    local platform = l_3_0.collisionAreasByName[platformName]
    if platform then
      Entity.create("Content/Game/Global/Entities/Platform", l_3_0.gameplayLayer, nil, nil, platformName, platform)
    end
  end
end

CaveStash.setupFunctions = function(l_4_0)
  l_4_0.outerGateSignpost = l_4_0:getEntity("Signpost openOuterGate")
  l_4_0.innerGateSignpost = l_4_0:getEntity("Signpost openInnerGate")
  l_4_0.BridgeSignpost = l_4_0:getEntity("Signpost createBridge")
  l_4_0.PitSignpost = l_4_0:getEntity("Signpost fillPit")
  l_4_0.testBlocksSignpost = l_4_0:getEntity("Signpost testBlocks")
  l_4_0.updatePlatformSignpost = l_4_0:getEntity("Signpost updatePlatform")
  l_4_0.outerGateSignpost:setFunction(l_4_0.outerLockTestFunction, "outerLockTestFunction")
  l_4_0.innerGateSignpost:setFunction(l_4_0.innerLockTestFunction, "innerLockTestFunction")
  l_4_0.BridgeSignpost:setFunction(l_4_0.createBridgeFunction, "createBridgeFunction")
  l_4_0.PitSignpost:setFunction(l_4_0.fillPitFunction, "fillPitFunction")
  l_4_0.testBlocksSignpost:setFunction(l_4_0.testBlocksFunction, "testBlocksFunction")
  l_4_0.updatePlatformSignpost:setFunction(l_4_0.updatePlatformFunction, "updatePlatformFunction")
  local outerGate = l_4_0:getEntity("Celldoor 2")
  local innerGate = l_4_0:getEntity("Celldoor 1")
  outerGate:setFunctionSign(l_4_0.outerGateSignpost)
  outerGate.schemas.PASSWORD:registerValueSetHandler(outerGate, l_4_0.onOuterGateFieldSet, l_4_0)
  innerGate:setFunctionSign(l_4_0.innerGateSignpost)
  innerGate.firstGate = outerGate
  l_4_0.testBlocksSignpost:get(FunctionComponent).functionChangedEvent:register(l_4_0.testFakeWall, l_4_0)
end

CaveStash.onOuterGateFieldSet = function(l_5_0)
  local innerGate = l_5_0:getEntity("Celldoor 1")
  innerGate:onFieldSet("PASSWORD", innerGate.PASSWORD)
end

CaveStash.setupHackPlatforms = function(l_6_0)
  l_6_0.baseOffsets = {}
  for portIndex = 1, 3 do
    local portBlock = l_6_0:getEntity("PlatformHackPillar " .. tostring(portIndex))
    local platform = l_6_0:getEntity("Long Bridge " .. tostring(portIndex))
    if portBlock and platform then
      local posX, _ = platform:getPosition()
      l_6_0.baseOffsets[portIndex] = posX
      portBlock.fieldSetEvent:register(l_6_0.platformFieldSet, l_6_0)
      local platformOffset = l_6_0:getState().Platform" .. tostring(portIndex) .. "Offset or 0
      portBlock:onFieldSet("OFFSET", platformOffset)
    end
  end
  local resettingPortBlock = l_6_0:getEntity("PlatformHackPillar 3")
  local resettingPlatform = l_6_0:getEntity("Long Bridge 3")
  local oldTick = resettingPlatform.tick
  resettingPlatform.tick = function(l_1_0)
    oldTick(l_1_0)
    self.updatePlatformSignpost:get(FunctionComponent):exec(resettingPortBlock)
   end
end

CaveStash.setupFakeWall = function(l_7_0)
  if l_7_0:getState().FakeWallMoved then
    l_7_0:retractFakeWall(0)
  end
  l_7_0.allHaveMessage = true
  l_7_0.pressingEntities = {}
  l_7_0.matchingBlocks = {false, false, false}
end

CaveStash.setupTiles = function(l_8_0)
  l_8_0.tileTypes = {"Bridge", "Pit"}
  l_8_0.tileModes = {"Enable", "Disable"}
  local tileNumbers = {8, 10}
  for typeIndex,tileType in ipairs(l_8_0.tileTypes) do
    l_8_0[tileType .. "Tiles"] = {}
    l_8_0[tileType .. "TileIndicesToEnable"] = {}
    l_8_0[tileType .. "TileIndicesToDisable"] = {}
    l_8_0[tileType .. "Enable"] = false
    l_8_0[tileType .. "Disable"] = false
    l_8_0[tileType .. "TilesReversed"] = false
    l_8_0[tileType .. "TilePeriod"] = 0.2
    l_8_0[tileType .. "DisableDelay"] = 1
    l_8_0[tileType .. "TileEnableTime"] = 0
    l_8_0[tileType .. "TileDisableTime"] = 0
    l_8_0.num" .. tileType .. "Tiles = tileNumbers[typeIndex]
    for tileIndex = 1, l_8_0.num" .. tileType .. "Tiles do
      local name = tileType .. " Tile " .. tostring(tileIndex)
      local tile = l_8_0:getEntity(name)
      tile:enable(false, 0)
      l_8_0[tileType .. "Tiles"][tileIndex] = tile
    end
    l_8_0.entitiesByName["PressurePlateUnpressed " .. tostring(2 * (typeIndex - 1) + 1)].pressedEvent:register(l_8_0.on" .. tileType .. "PlatePressed, l_8_0)
    l_8_0.entitiesByName["PressurePlateUnpressed " .. tostring(2 * typeIndex)].pressedEvent:register(l_8_0.on" .. tileType .. "ReturnPlatePressed, l_8_0)
  end
end

CaveStash.setupText = function(l_9_0)
  l_9_0.entitiesByName["HackBlock 1"].message = l_9_0.BLOCK_PASSWORD_STRINGS[5]
  l_9_0.entitiesByName["HackBlock 2"].message = l_9_0.BLOCK_PASSWORD_STRINGS[3]
  l_9_0.entitiesByName["HackBlock 3"].message = l_9_0.BLOCK_PASSWORD_STRINGS[1]
  l_9_0.blockPlates = {}
  for blockIndex = 1, 3 do
    l_9_0.blockPlates[blockIndex] = l_9_0:getEntity("BlockPlate " .. tostring(blockIndex))
    l_9_0.blockPlates[blockIndex].pressedEvent:register(l_9_0.onBlockPlatePressed, l_9_0)
    l_9_0.blockPlates[blockIndex]:setLabelText("")
    local hackBlock = l_9_0:getEntity("HackBlock " .. tostring(blockIndex))
    hackBlock:setLabelText(hackBlock.message)
    local textIndex = blockIndex * 2 - 1
    local hackText = l_9_0:getEntity("Text " .. tostring(textIndex))
    hackText:fade(false, 0)
  end
  if l_9_0:getState().FakeWallMoved then
    for i = 1, 5 do
      local hackText = l_9_0:getEntity("Text " .. tostring(i))
      hackText:fade(false, 0)
    end
  end
end

CaveStash.outerLockTestFunction = function(l_10_0)
  if l_10_0 == "seek knowledge" then
    return true
  else
    return false
  end
end

CaveStash.innerLockTestFunction = function(l_11_0, l_11_1)
  if l_11_0 == "seek knowledge" then
    return false
  elseif l_11_1 == "change the rules" then
    return true
  else
    return false
  end
end

CaveStash.createBridgeFunction = function(l_12_0)
  for i = 1, 4 do
    l_12_0:queueBridgeTile(i)
  end
end

CaveStash.fillPitFunction = function(l_13_0)
  local isEven = function(l_1_0)
    if l_1_0 % 2 == 0 then
      return true
    else
      return false
    end
   end
  for i = 1, 10 do
    if isEven(i) then
      l_13_0:queuePlatformTile(i)
    end
  end
end

CaveStash.testBlocksFunction = function(l_14_0)
  local a, b, c = l_14_0[1].message, l_14_0[2].message, l_14_0[3].message
  local combined = a .. " t" .. b .. "an" .. c
  return combined
end

CaveStash.updatePlatformFunction = function(l_15_0)
  local curOffset = l_15_0.OFFSET
  if curOffset > 0 then
    l_15_0.OFFSET = curOffset - 1
  end
end

CaveStash.tick = function(l_16_0)
  for _,tileType in ipairs(l_16_0.tileTypes) do
    for _,mode in ipairs(l_16_0.tileModes) do
      if l_16_0[tileType .. mode] and #l_16_0[tileType .. "TileIndicesTo" .. mode] > 0 then
        l_16_0[tileType .. "Tile" .. mode .. "Time"] = l_16_0[tileType .. "Tile" .. mode .. "Time"] + MOAISim.getStep()
        if l_16_0[tileType .. "TilePeriod"] < l_16_0[tileType .. "Tile" .. mode .. "Time"] then
          local tileIndex = table.remove(l_16_0[tileType .. "TileIndicesTo" .. mode], 1)
          local tile = l_16_0[tileType .. "Tiles"][tileIndex]
          if mode ~= "Enable" then
            tile:enable(not tile)
          end
          if mode == "Enable" then
            table.insert(l_16_0[tileType .. "TileIndicesToDisable"], tileIndex)
          end
          l_16_0[tileType .. "Tile" .. mode .. "Time"] = 0
          if #l_16_0[tileType .. "TileIndicesTo" .. mode] == 0 then
            l_16_0[tileType .. mode] = false
          end
        end
      end
    end
  end
  Class.super(CaveStash).tick(l_16_0)
end

CaveStash.queueTile = function(l_17_0, l_17_1, l_17_2)
  if l_17_0[l_17_1 .. "TilesReversed"] then
    l_17_2 = l_17_0.num" .. l_17_1 .. "Tiles + 1 - l_17_2
  end
  table.insert(l_17_0[l_17_1 .. "TileIndicesToEnable"], l_17_2)
end

CaveStash.queueBridgeTile = function(l_18_0, l_18_1)
  l_18_0:queueTile("Bridge", l_18_1)
end

CaveStash.queuePlatformTile = function(l_19_0, l_19_1)
  l_19_0:queueTile("Pit", l_19_1)
end

CaveStash.enableTiles = function(l_20_0, l_20_1, l_20_2)
  if l_20_2 then
    if l_20_0[l_20_1 .. "Enable"] then
      l_20_0[l_20_1 .. "TileIndicesToEnable"] = {}
    end
    l_20_0[l_20_1 .. "Signpost"]:get(FunctionComponent):exec(l_20_0)
    l_20_0[l_20_1 .. "Enable"] = true
    l_20_0[l_20_1 .. "TileEnableTime"] = l_20_0[l_20_1 .. "TilePeriod"]
    if l_20_0[l_20_1 .. "Disable"] then
      for i,tileIndexToDisable in ipairs(l_20_0[l_20_1 .. "TileIndicesToDisable"]) do
        local tile = l_20_0[l_20_1 .. "Tiles"][tileIndexToDisable]
        tile:enable(false)
      end
      l_20_0[l_20_1 .. "TileIndicesToDisable"] = {}
      l_20_0[l_20_1 .. "Disable"] = false
    else
      if not l_20_0[l_20_1 .. "Disable"] then
        l_20_0[l_20_1 .. "Disable"] = true
        l_20_0[l_20_1 .. "TileDisableTime"] = -l_20_0[l_20_1 .. "DisableDelay"]
      end
    end
  end
end

CaveStash.onBridgePlatePressed = function(l_21_0, l_21_1, l_21_2)
  l_21_0.BridgeTilesReversed = false
  l_21_0:enableTiles("Bridge", l_21_2)
end

CaveStash.onBridgeReturnPlatePressed = function(l_22_0, l_22_1, l_22_2)
  l_22_0.BridgeTilesReversed = true
  l_22_0:enableTiles("Bridge", l_22_2)
end

CaveStash.onPitPlatePressed = function(l_23_0, l_23_1, l_23_2)
  l_23_0.PitTilesReversed = false
  l_23_0:enableTiles("Pit", l_23_2)
end

CaveStash.onPitReturnPlatePressed = function(l_24_0, l_24_1, l_24_2)
  l_24_0.PitTilesReversed = true
  l_24_0:enableTiles("Pit", l_24_2)
end

CaveStash.platformFieldSet = function(l_25_0, l_25_1, l_25_2, l_25_3)
  if l_25_1 == "OFFSET" and tonumber(l_25_2) then
    for i = 1, 3 do
      if l_25_3.name == "PlatformHackPillar " .. tostring(i) then
        l_25_0:getState().Platform" .. tostring(i) .. "Offset = l_25_2
        l_25_0:setPlatformOffset(i, l_25_2)
      end
    end
  end
end

CaveStash.setPlatformOffset = function(l_26_0, l_26_1, l_26_2)
  local platform = l_26_0:getEntity("Long Bridge " .. tostring(l_26_1))
  if platform then
    local posX, posY = platform:getPosition()
    local scaledXOffset = l_26_2
    platform:setTarget(l_26_0.baseOffsets[l_26_1] + scaledXOffset, posY, nil, true)
    platform:get(SoundComponent):playCue("SFX/Objects/Platform_Alignment", nil, 0.5)
  end
end

CaveStash.onBlockPlatePressed = function(l_27_0, l_27_1, l_27_2)
  l_27_0:testFakeWall()
end

CaveStash.testFakeWall = function(l_28_0)
  l_28_0:testFakeWallPlates()
  l_28_0:tryPlayFakeWallScene()
  l_28_0:updateHackText()
end

CaveStash.testFakeWallPlate = function(l_29_0, l_29_1, l_29_2)
  if l_29_2.pressed then
    local presser = l_29_2:getClosestPresser()
    l_29_0.pressingEntities[l_29_1] = presser
    local textIndex = l_29_1 * 2 - 1
    if presser and presser.message == l_29_0.BLOCK_PASSWORD_STRINGS[textIndex] then
      l_29_0.matchingBlocks[l_29_1] = true
    else
      l_29_0.matchingBlocks[l_29_1] = false
    end
  end
end

CaveStash.testFakeWallPlates = function(l_30_0)
  l_30_0.allHaveMessage = true
  l_30_0.pressingEntities = {}
  l_30_0.matchingBlocks = {false, false, false}
  if l_30_0:getState().FakeWallMoved then
    l_30_0.allHaveMessage = false
  else
    for plateIndex,plate in ipairs(l_30_0.blockPlates) do
      l_30_0:testFakeWallPlate(plateIndex, plate)
    end
    for plateIndex,plate in ipairs(l_30_0.blockPlates) do
      if not l_30_0.pressingEntities[plateIndex] or not l_30_0.pressingEntities[plateIndex].message then
        l_30_0.allHaveMessage = false
      end
    end
  end
end

CaveStash.tryPlayFakeWallScene = function(l_31_0)
  if l_31_0.allHaveMessage and #l_31_0.pressingEntities == 3 and l_31_0.testBlocksSignpost:get(FunctionComponent):exec(l_31_0.pressingEntities) == l_31_0.BLOCK_PASSWORD then
    l_31_0:playFakeWallScene()
    l_31_0.matchingBlocks = {true, true, true}
  end
end

CaveStash.updateHackText = function(l_32_0)
  for blockIndex,matching in ipairs(l_32_0.matchingBlocks) do
    local textIndex = blockIndex * 2 - 1
    local hackText = l_32_0:getEntity("Text " .. tostring(textIndex))
    local red, green, blue, alpha = hackText.prop:getColor()
    local targetAlpha = matching and 1 or 0
    if alpha ~= targetAlpha then
      hackText:fade(matching)
    end
  end
end

CaveStash.playFakeWallScene = function(l_33_0)
  local fakeWall = l_33_0:getEntity("Fake Wall")
  local wallScene = fakeWall:get(SceneComponent)
  if wallScene then
    wallScene:play(function(l_1_0)
    l_1_0:sleep(2)
    for i = 1, 5 do
      local hackText = self:getEntity("Text " .. tostring(i))
      hackText:fade(false)
    end
    l_1_0:sleep(1)
    self:retractFakeWall(8)
   end)
  end
end

CaveStash.retractFakeWall = function(l_34_0, l_34_1)
  local fakeWall = l_34_0:getEntity("Fake Wall")
  local fakeWallX, fakeWallY = fakeWall:getPosition()
  fakeWall:move(fakeWallX - 800, fakeWallY, l_34_1)
  l_34_0:getState().FakeWallMoved = true
end

return CaveStash

