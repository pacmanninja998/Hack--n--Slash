-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Rooms\GameRoom.lua 

local Class = require("Class")
local Entity = require("Entity")
local Room = require("Room")
local Shader = require("Shader")
local Delegate = require("DFMoai.Delegate")
local GameRoom = require("Class").create(Room, "GameRoom")
local PrimaryHost = require("Host").cache:load("Content/Game/Hosts/PrimaryHost")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local RedSprite = Entity.cache:load("Content/Game/Global/Entities/RedSprite")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
GameRoom.FADE_IN = 0
GameRoom.FADE_OUT = 1
GameRoom.FADE_IN_DURATION = 1
GameRoom.DIALOGUE_FADE_IN = 0
GameRoom.DIALOGUE_FADE_OUT = 1
GameRoom.DIALOGUE_FADE_DURATION = 0.25
GameRoom.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Room.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  l_1_0.dialogueShader = Shader.load("Content/Game/Global/Shaders/DialogueMode")
  l_1_0.dialogueIntensity = 0
  l_1_0.dialogueIntensityTarget = 0
  l_1_0.timeOfDayEnabled = false
  l_1_0.dialogueShader = Shader.load("Content/Game/Global/Shaders/DialogueMode")
  l_1_0.shadowedShader = Shader.create("Content/Game/Global/Shaders/Shadowed")
  l_1_0.timeOfDayShader = Shader.create("Content/Game/Global/Shaders/TimeOfDay")
  l_1_0.shadowedTimeOfDayShader = Shader.create("Content/Game/Global/Shaders/TimeOfDayShadowed")
  l_1_0.normalWaterShader = Shader.create("Content/Game/Global/Shaders/NormalWater")
  l_1_0.shadowedShaderMainChar = Shader.create("Content/Game/Global/Shaders/Shadowed_MainChars")
  l_1_0.timeOfDayShaderMainChar = Shader.create("Content/Game/Global/Shaders/TimeOfDay_MainChars")
  l_1_0.shadowedTimeOfDayShaderMainChar = Shader.create("Content/Game/Global/Shaders/TimeOfDayShadowed_MainChars")
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/Default_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/Default_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/Default_ShadowGradient"
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0.fadeOutShader = Shader.load("Content/Game/Global/Shaders/CircleFadeOut")
  l_1_0.fadeType = nil
  l_1_0.fadeDuration = 0
  l_1_0.fadeElapsed = 0
  l_1_0.fadeEvent = Delegate.new()
  l_1_0.defaultSoundMat = require("Components.PlatformComponent").SOUND_MAT_STONE
end

GameRoom.persistValue = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local entity = l_2_0:getEntity(l_2_1)
  entity.schemas[l_2_2]:registerValueSetHandler(entity, function(l_1_0, l_1_1)
    local roomState = self:getState()
    if not roomState[entityName] then
      roomState[entityName] = {}
    end
    roomState[entityName][key] = l_1_1
   end)
  local roomState = l_2_0:getState()
  local entityState = roomState[l_2_1]
  if not entityState or entityState[l_2_2] == nil then
    entity[l_2_2] = l_2_3
  else
    entity[l_2_2] = entityState[l_2_2]
  end
end

GameRoom.fade = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  if l_3_0.fadeType ~= l_3_1 then
    l_3_0.fadeType = l_3_1
    l_3_0.fadeDuration = l_3_2 or 1
    l_3_0.fadeElapsed = 0
    if l_3_0.fadeType == GameRoom.FADE_IN then
      MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/ScreenFade_In", false)
      l_3_0.fadeOutShader:setFragmentUniformFloat("shaderDuration", 1)
    else
      if l_3_0.fadeType == GameRoom.FADE_OUT then
        MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/ScreenFade_Out", false)
        l_3_0.fadeOutShader:setFragmentUniformFloat("shaderDuration", 0)
      end
    end
    l_3_0:insertPostEffect(l_3_0.fadeOutShader)
    l_3_0.fadeHost = l_3_3
    l_3_0.fadeExitArgs = l_3_4
    local alice = l_3_0:getAlice()
    if alice then
      alice:halt(true)
    end
    l_3_0.fadeEvent:dispatch(l_3_1, true)
  end
end

GameRoom.startDialogueMode = function(l_4_0)
  l_4_0.dialogueIntensityTarget = 1
end

GameRoom.endDialogueMode = function(l_5_0)
  l_5_0.dialogueIntensityTarget = 0
end

GameRoom.enableTimeOfDay = function(l_6_0)
  l_6_0.materialUniforms[l_6_0.timeOfDayShader] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeofDayShadow}}
  l_6_0.materialUniforms[l_6_0.shadowedTimeOfDayShader] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeofDayShadow}}
  l_6_0.materialUniforms[l_6_0.normalWaterShader] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeofDayShadow}}
  l_6_0.materialUniforms[l_6_0.timeOfDayShaderMainChar] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeofDayShadow}, hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_6_0.hsvTint}}
  l_6_0.materialUniforms[l_6_0.shadowedTimeOfDayShaderMainChar] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_6_0.timeofDayShadow}, hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_6_0.hsvTint}}
  for i,layer in ipairs(l_6_0.sortedLayers) do
    if l_6_0.sortedLayerKeys[i] ~= -1 and layer.name ~= "Water" then
      layer:setDefaultShader(l_6_0.timeOfDayShader)
    end
  end
  l_6_0.timeOfDayEnabled = true
end

GameRoom.enableWater = function(l_7_0)
  local layer = l_7_0:getLayerByName("Water")
  if layer then
    for _,chunkset in ipairs(layer.chunksets) do
      chunkset:setDefaultShader(l_7_0.normalWaterShader)
    end
  end
end

GameRoom.tick = function(l_8_0)
  Room.tick(l_8_0)
  if l_8_0.timeOfDayEnabled and l_8_0.world.timeOfDay then
    local timeOfDay = l_8_0.world.timeOfDay
    local shadowOpacity = timeOfDay / 0.5
    if timeOfDay > 0.5 then
      shadowOpacity = 2 - shadowOpacity
    end
    l_8_0.timeOfDayShader:setFragmentUniformFloat("timeOfDayCursor", timeOfDay)
    l_8_0.shadowedTimeOfDayShader:setFragmentUniformFloat("timeOfDayCursor", timeOfDay)
    l_8_0.timeOfDayShaderMainChar:setFragmentUniformFloat("timeOfDayCursor", timeOfDay)
    l_8_0.normalWaterShader:setFragmentUniformFloat("timeOfDayCursor", timeOfDay)
    l_8_0.shadowedTimeOfDayShaderMainChar:setFragmentUniformFloat("timeOfDayCursor", timeOfDay)
    local shadowLayer = l_8_0:getLayerByOrder(-1)
    for _,chunkset in ipairs(shadowLayer.chunksets) do
      for _,prop in ipairs(chunkset.chunkProps) do
        prop:setColor(1, 1, 1, shadowOpacity)
      end
    end
  end
  if l_8_0.fadeType then
    l_8_0.fadeElapsed = math.min(l_8_0.fadeDuration, l_8_0.fadeElapsed + MOAISim.getStep())
    local elapsedRatio = l_8_0.fadeElapsed / l_8_0.fadeDuration
    if l_8_0.fadeType == GameRoom.FADE_IN then
      l_8_0.fadeOutShader:setFragmentUniformFloat("shaderDuration", 1 - elapsedRatio)
    else
      if l_8_0.fadeType == GameRoom.FADE_OUT then
        l_8_0.fadeOutShader:setFragmentUniformFloat("shaderDuration", elapsedRatio)
      end
    end
    if elapsedRatio >= 1 then
      if l_8_0.fadeType == GameRoom.FADE_IN then
        local alice = l_8_0:getAlice()
        if alice then
          alice:halt(false)
        else
          if l_8_0.fadeType == GameRoom.FADE_OUT then
            l_8_0.fadeHost:doRoomExit(unpack(l_8_0.fadeExitArgs))
          end
        end
      end
      l_8_0:removePostEffect(l_8_0.fadeOutShader)
      l_8_0.fadeEvent:dispatch(l_8_0.fadeType, false)
      l_8_0.fadeType = nil
    end
  end
  if l_8_0.dialogueIntensity ~= l_8_0.dialogueIntensityTarget then
    local step = MOAISim.getStep() / GameRoom.DIALOGUE_FADE_DURATION
    if l_8_0.dialogueIntensity == 0 then
      l_8_0:insertPostEffect(l_8_0.dialogueShader)
    end
    if l_8_0.dialogueIntensity < l_8_0.dialogueIntensityTarget then
      l_8_0.dialogueIntensity = math.min(1, l_8_0.dialogueIntensity + step)
    else
      l_8_0.dialogueIntensity = math.max(0, l_8_0.dialogueIntensity - step)
    end
    if l_8_0.dialogueIntensity == 0 then
      l_8_0:removePostEffect(l_8_0.dialogueShader)
    else
      l_8_0.dialogueShader:setFragmentUniformFloat("ShaderIntensity", l_8_0.dialogueIntensity)
    end
  end
end

GameRoom.markHostEntity = function(l_9_0, l_9_1, l_9_2, l_9_3)
  Class.super(GameRoom).markHostEntity(l_9_0, l_9_1, l_9_2, l_9_3)
  if l_9_1.host:is(PrimaryHost) then
    if l_9_1:is(Alice) then
      l_9_0:onAliceCreated(l_9_1)
    end
    if l_9_1:is(RedSprite) then
      l_9_0:onBobCreated(l_9_1)
    end
  end
end

GameRoom.markShadowedEntity = function(l_10_0, l_10_1)
  if l_10_0.timeOfDayEnabled then
    if l_10_1:is(Alice) or l_10_1:is(RedSprite) then
      l_10_0.materialUniforms[l_10_0.shadowedTimeOfDayShaderMainChar] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_10_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_10_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_10_0.timeofDayShadow}, hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_10_0.hsvTint}}
      l_10_1:setDefaultShader(l_10_0.shadowedTimeOfDayShaderMainChar)
    else
      l_10_1:setDefaultShader(l_10_0.shadowedTimeOfDayShader)
    end
  else
    if l_10_1:is(Alice) or l_10_1:is(RedSprite) then
      l_10_1:setDefaultShader(l_10_0.shadowedShaderMainChar)
      l_10_0.materialUniforms[l_10_0.shadowedShaderMainChar] = {hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_10_0.hsvTint}}
    else
      l_10_1:setDefaultShader(l_10_0.shadowedShader)
      l_10_0.materialUniforms[l_10_0.shadowedShader] = {hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_10_0.hsvTint}}
    end
  end
  Room.markShadowedEntity(l_10_0, l_10_1)
end

GameRoom.onAliceCreated = function(l_11_0, l_11_1)
  l_11_0.alice = l_11_1
  l_11_0.alice.destroyEvent:register(l_11_0.onAliceDestroyed, l_11_0)
  if l_11_0.timeOfDayEnabled then
    l_11_0.materialUniforms[l_11_0.shadowedTimeOfDayShaderMainChar] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_11_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_11_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_11_0.timeofDayShadow}, hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_11_0.hsvTint}}
    l_11_1:setDefaultShader(l_11_0.shadowedTimeOfDayShaderMainChar)
  else
    l_11_0.materialUniforms[l_11_0.shadowedShaderMainChar] = {hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_11_0.hsvTint}}
    l_11_1:setDefaultShader(l_11_0.shadowedShaderMainChar)
  end
  if l_11_0.fadeType then
    l_11_0.alice:halt(true)
  end
end

GameRoom.onAliceDestroyed = function(l_12_0)
  l_12_0.alice = nil
end

GameRoom.onBobCreated = function(l_13_0, l_13_1)
  l_13_0.bob = l_13_1
  l_13_0.bob.destroyEvent:register(l_13_0.onBobDestroyed, l_13_0)
  if l_13_0.timeOfDayEnabled then
    l_13_0.materialUniforms[l_13_0.shadowedTimeOfDayShaderMainChar] = {hilightGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_13_0.timeOfDayHighlight}, midtoneGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_13_0.timeOfDayMidtone}, shadowGradient = {type = MOAIMaterial.VALUETYPE_TEXTURE, value = l_13_0.timeofDayShadow}, hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_13_0.hsvTint}}
    l_13_1:setDefaultShader(l_13_0.shadowedTimeOfDayShaderMainChar)
  else
    l_13_0.materialUniforms[l_13_0.shadowedShaderMainChar] = {hsvTint = {type = MOAIMaterial.VALUETYPE_VEC3, value = l_13_0.hsvTint}}
    l_13_1:setDefaultShader(l_13_0.shadowedShaderMainChar)
  end
end

GameRoom.onBobDestroyed = function(l_14_0)
  l_14_0.bob = nil
end

GameRoom.getAlice = function(l_15_0)
  return l_15_0.alice
end

GameRoom.getBob = function(l_16_0)
  return l_16_0.bob
end

GameRoom.scale = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4)
  Class.super(GameRoom).scale(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4)
  if not l_17_0.alice then
    return 
  end
  if l_17_3 then
    l_17_0.alice:scale(l_17_1)
  end
  if l_17_4 then
    local playerX, playerY = l_17_0.alice:getPosition()
    local offsetX, offsetY = -playerX, -playerY
    for _,layer in ipairs(l_17_0.sortedLayers) do
      layer:translate(offsetX, offsetY)
    end
    for _,collisionArea in pairs(l_17_0.collisionAreasByName) do
      collisionArea:translate(offsetX, offsetY)
    end
  end
end

GameRoom.defineTreasureChestScene = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4)
  local chest = l_18_0:getEntity(l_18_1)
  if l_18_4 then
    chest.openingAnim = l_18_4
  end
  chest.openedEvent:register(function()
    local alice = self:getAlice()
    alice:get(SceneComponent):play(function(l_1_0)
      alice:halt(true)
      sceneHandler(firstArg, l_1_0, alice)
      alice:halt(false)
      end)
   end)
end

GameRoom.startCameraShake = function(l_19_0, l_19_1, l_19_2, l_19_3)
  if not l_19_0.cameraShake then
    l_19_0.cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    l_19_0:insertPostEffect(l_19_0.cameraShake)
  end
  l_19_1:animate(l_19_2, function(l_1_0)
    self.cameraShake:setFragmentUniformFloat("shaderDuration", l_1_0 * targetValue)
   end)
end

GameRoom.stopCameraShake = function(l_20_0, l_20_1, l_20_2, l_20_3)
  if not l_20_0.cameraShake then
    l_20_0.cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    l_20_0:insertPostEffect(l_20_0.cameraShake)
  end
  l_20_1:animate(l_20_2, function(l_1_0)
    self.cameraShake:setFragmentUniformFloat("shaderDuration", startValue * (1 - l_1_0))
   end)
  l_20_0:removePostEffect(l_20_0.cameraShake)
  l_20_0.cameraShake = nil
end

return GameRoom

