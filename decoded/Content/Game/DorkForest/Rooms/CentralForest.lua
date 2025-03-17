-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Rooms\CentralForest.lua 

local CentralForest = require("Room").classFromLayout("Content/Game/DorkForest/Layouts/CentralForest", "CentralForest", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local Music = require("Music")
local Shader = require("Shader")
local CorruptedTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/CorruptedTurtle")
local SwampTurtle = Entity.cache:load("Content/Game/DorkForest/Entities/SwampTurtle")
local Raven = Entity.cache:load("Content/Game/DorkForest/Entities/Raven")
local TurtleSpawner = Entity.cache:load("Content/Game/DorkForest/Entities/TurtleSpawner")
CentralForest.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("SleepingSwampExit", "Content/Game/DorkForest/Rooms/SleepingSwamp", "CentralForestExit")
  l_1_0:defineCollisionExit("SpriteClearingExit", "Content/Game/DorkForest/Rooms/SpriteClearing", "CentralForestExit")
  l_1_0:defineCollisionExit("InnerForestExit", "Content/Game/DorkForest/Rooms/InnerForest", "CentralForestExit")
  l_1_0:defineCollisionExit("InfiniteWoodsExit", "Content/Game/CrackerCavern/Rooms/InfiniteWoods", "CentralForestExit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 5 do
    local name = "Water " .. i
    Entity.create("Content/Game/Global/Entities/Water", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  require("Music"):playMusic("Music/Music/CentralForest_Cue1", false)
  Music:playAmbient("Ambience/Ambience/CentralForest_Ambience")
  Music:setReverb("ExteriorSlap")
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/CentralForest_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/CentralForest_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/CentralForest_ShadowGradient"
  l_1_0.timeOfDayRampMagnitude = 1.7
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0:enableTimeOfDay()
  l_1_0:enableWater()
  l_1_0.corruptedWaterShader = Shader.create("Content/Game/Global/Shaders/CorruptedWater")
  local layer = l_1_0:getLayerByName("Water")
  for _,chunkset in ipairs(layer.chunksets) do
    chunkset:setCurrentShader(l_1_0.corruptedWaterShader)
  end
  local healAmount = l_1_0:universe().state.state.forestHealAmount
  l_1_0:setHealAmount(healAmount)
  l_1_0.defaultSoundMat = require("Components.PlatformComponent").SOUND_MAT_SAND
  l_1_0:defineTreasureChestScene("TreasureChest (cave)", l_1_0.onCaveTreasureChestOpened, l_1_0, "Opening_Heart")
  l_1_0:defineTreasureChestScene("TreasureChest (charge puzzle)", l_1_0.onChargePuzzleTreasureChestOpened, l_1_0, "Opening")
  local turtleSpawner = l_1_0:getEntity("TurtleSpawner")
  turtleSpawner.MAX_ACTIVE_SPAWNS = 3
  turtleSpawner.SPAWN_BEHAVIOR = {{TYPE = "MOVE", TILES = 3}, {TYPE = "IDLE", SECONDS = 3}, {TYPE = "BURROW"}}
  for i = 1, string.len(2) do
    local corruptedWaterSourcePoint = l_1_0.entitiesByName["SFX/SourcePoints/SpookyPath_Corrupted_Water " .. tostring(i)]
    if corruptedWaterSourcePoint and healAmount >= 0 then
      corruptedWaterSourcePoint.cue:stop()
    end
  end
end

CentralForest.setHealAmount = function(l_2_0, l_2_1)
  if l_2_0.corruptedWaterShader then
    local corruptionLevel = math.max(0, math.min(999, -l_2_1) * 0.001)
    l_2_0.corruptedWaterShader:setFragmentUniformFloat("CorruptionIntensity", corruptionLevel)
  end
  local corrupted = l_2_1 < 0
  if corrupted == l_2_0.waterIsCorrupted then
    return 
  end
  l_2_0.waterIsCorrupted = corrupted
  do
    local layer = l_2_0:getLayerByName("Water")
    for _,chunkset in ipairs(layer.chunksets) do
      if l_2_0.waterIsCorrupted then
        chunkset:setCurrentShader(l_2_0.corruptedWaterShader)
        for i = 1, string.len(2) do
          local corruptedWaterSourcePoint = l_2_0.entitiesByName["SFX/SourcePoints/SpookyPath_Corrupted_Water " .. tostring(i)]
          if corruptedWaterSourcePoint then
            corruptedWaterSourcePoint:restartSound()
          end
        end
        for _,chunkset in (for generator) do
        end
        chunkset:resetShader()
        for i = 1, string.len(2) do
          local corruptedWaterSourcePoint = l_2_0.entitiesByName["SFX/SourcePoints/SpookyPath_Corrupted_Water " .. tostring(i)]
          if corruptedWaterSourcePoint then
            corruptedWaterSourcePoint.cue:stop()
          end
        end
      end
      for name,entity in pairs(l_2_0.entitiesByName) do
        do
          if entity:is(CorruptedTurtle) and not l_2_0.waterIsCorrupted then
            local x, y = entity:getPosition()
            entity:destroy()
          end
          for name,entity in (for generator) do
          end
          do
            if entity:is(SwampTurtle) and l_2_0.waterIsCorrupted then
              local x, y = entity:getPosition()
              entity:destroy()
              Entity.create("Content/Game/DorkForest/Entities/SpikeyTurtle", l_2_0:getLayerByOrder(0), x, y)
            end
            for name,entity in (for generator) do
            end
            if entity:is(Raven) and not l_2_0.waterIsCorrupted then
              entity:destroy()
              for name,entity in (for generator) do
              end
              if entity:is(TurtleSpawner) and l_2_0.waterIsCorrupted then
                entity:destroy()
              end
            end
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

CentralForest.onCaveTreasureChestOpened = function(l_3_0, l_3_1, l_3_2)
  l_3_2.host.maxHealth = l_3_2.host.maxHealth + 3
  local alicePortrait = l_3_1:addAlicePortrait()
  local bobPortrait = l_3_1:addCharacter("Portraits/Bob/Bob")
  l_3_1:speakLineLeft(alicePortrait, "Wow, there are three hearts in here!", "Excited")
  l_3_1:speakLineRight(bobPortrait, "That's quite the bounty of extra internal organs!", "Happy")
end

CentralForest.onChargePuzzleTreasureChestOpened = function(l_4_0, l_4_1, l_4_2)
  local alicePortrait = l_4_1:addAlicePortrait()
  local bobPortrait = l_4_1:addCharacter("Portraits/Bob/Bob")
  l_4_1:speakLineLeft(alicePortrait, "What!? I don't see anything in here...", "Spooked")
  l_4_1:speakLineRight(bobPortrait, "Why would there be a treasure chest without any treasure?", "Sad")
end

return CentralForest

