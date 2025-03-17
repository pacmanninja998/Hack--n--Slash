-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\TowerLevel3.lua 

local Room = require("Room")
local TowerLevel3 = Room.classFromLayout("Content/Game/DourTower/Layouts/TowerLevel3", "TowerLevel3", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local Math = require("DFCommon.Math")
local Music = require("Music")
local Shader = require("Shader")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
TowerLevel3.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("Staircase2 exit", "Content/Game/DourTower/Rooms/Staircase2", "Exit_Rt")
  l_1_0:defineCollisionExit("Staircase3 exit", "Content/Game/DourTower/Rooms/Staircase3", "Exit_Lft")
  l_1_0:defineCollisionExit("Library exit", "Content/Game/DourTower/Rooms/LibraryOfBabble,Content/Game/DourTower/Rooms/TowerLevel3", nil, nil, nil, Direction.DIR_E)
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  local libraryPit = l_1_0.collisionAreasByName.Pit
  Entity.create("Content/Game/Global/Entities/Water", gameplayLayer, nil, nil, libraryPit.name, libraryPit)
  l_1_0:makePlatforms("Floor Platform ", 2)
  l_1_0:makePlatforms("Rock Platform ", 20)
  l_1_0.stairs = Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, nil, l_1_0.collisionAreasByName.Stairs, Direction.DIR_E, 0.75)
  Music:playMusic("Music/Music/WizardTower_Level3")
  Music:setReverb("Exterior")
  l_1_0:enableWater()
  if not l_1_0:getState().passedTrap then
    l_1_0:defineLogicTrigger("Trap trigger", l_1_0.onTrapTrigger, l_1_0)
    l_1_0:defineLogicTrigger("Pass trigger", l_1_0.onPassTrigger, l_1_0)
  else
    l_1_0:getCollisionArea("Trap trigger"):setActive(false)
    l_1_0:getCollisionArea("Pass trigger"):setActive(false)
  end
  l_1_0:openDoors(true)
end

TowerLevel3.openDoors = function(l_2_0, l_2_1)
  l_2_0:getEntity("TrapDoor_Lft").prop:setVisible(not l_2_1)
  l_2_0:getEntity("TrapDoor_Rt").prop:setVisible(not l_2_1)
  l_2_0:getCollisionArea("TrapDoor 1"):setActive(not l_2_1)
  l_2_0:getCollisionArea("TrapDoor 2"):setActive(not l_2_1)
end

TowerLevel3.makePlatforms = function(l_3_0, l_3_1, l_3_2)
  local gameplayLayer = l_3_0:getLayerByOrder(0)
  for i = 1, l_3_2 do
    local platformName = l_3_1 .. tostring(i)
    local platform = l_3_0.collisionAreasByName[platformName]
    if platform then
      Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, platformName, platform)
    end
  end
end

TowerLevel3.onTrapTrigger = function(l_4_0)
  local alice = l_4_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    alice:halt(true)
    self:openDoors(false)
    alice:get(SoundComponent):playCue("SFX/Hackable_Objects/ArmoryGate_Close")
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.3)
    self:insertPostEffect(cameraShake)
    l_1_0:animate(0.5, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.3, 0, l_1_0))
      end)
    self:removePostEffect()
    l_1_0:sleep(1)
    l_1_0:speakLineRight(bobPortrait, "Oh wow, this looks scary.", "OMG")
    l_1_0:sleep(1)
    l_1_0:speakLineLeft(alicePortrait, "It's not doing anything.", "Spooked")
    alice:halt(false)
   end)
end

TowerLevel3.onPassTrigger = function(l_5_0)
  l_5_0:getState().passedTrap = true
  local alice = l_5_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    alice:halt(true)
    self:openDoors(true)
    alice:get(SoundComponent):playCue("SFX/Hackable_Objects/ArmoryGate_Open")
    local cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
    cameraShake:setFragmentUniformFloat("shaderDuration", 0.3)
    self:insertPostEffect(cameraShake)
    l_1_0:animate(0.5, function(l_1_0)
      cameraShake:setFragmentUniformFloat("shaderDuration", Math.lerp(0.3, 0, l_1_0))
      end)
    self:removePostEffect()
    l_1_0:speakLineRight(bobPortrait, "This trap really isn't going to do anything?", "Talk2")
    l_1_0:speakLineLeft(alicePortrait, "Did the wizard even finish this one?", "Talk2")
    alice:halt(false)
   end)
end

return TowerLevel3

