-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\WizardBat_Roof.lua 

local Class = require("Class")
local Entity = (require("Entity"))
local WizardBat_Roof = nil
local WizardBat_Roof = Class.create(Entity, "WizardBat_Roof")
local CommonActions = require("CommonActions")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
WizardBat_Roof.TEXT_COLOR = {0.96862745098039, 0.31372549019608, 0.3843137254902}
WizardBat_Roof.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(WizardBat_Roof).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Characters/WizardBat_Roof/WizardBat_Roof", "BreatheRoof_Front")
  sprite.prop:setPriority(2000)
  AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_SIDE)
  SoundComponent.new(l_1_0)
  PhysicsComponent.new(l_1_0, {rect = {-128, -128, 128, 128}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_1_0.back = Entity.create("Content/Game/DourTower/Entities/WizardBat_Roof_Back", l_1_0:room():getLayerByOrder(-2), l_1_2, l_1_3, l_1_4 .. "_Back")
  l_1_0.fx = Entity.create("Content/Game/DourTower/Entities/WizardBat_Roof_FX", l_1_1, l_1_2, l_1_3, l_1_4 .. "_FX")
  l_1_0.fileQueue = {}
  l_1_0.directoryQueue = {}
  local stateGenerator = "Data/Content/Game/StateGenerator.lua"
  local universeState = l_1_0:universe().state.state
  if not universeState.checkedOutBooks then
    local checkoutState = {}
  end
  if not checkoutState[stateGenerator] then
    table.insert(l_1_0.fileQueue, stateGenerator)
  end
  l_1_0.fileSystem = l_1_0:universe().state.fileSystem
  l_1_0:queueDirectory("Data/Content/Game/CrackerCavern")
  l_1_0:queueDirectory("Data/Content/Game/DweebKeep")
  l_1_0:queueDirectory("Data/Content/Game/Global")
  l_1_0:queueDirectory("Data/Content/Game/DorkForest")
  l_1_0:queueDirectory("Data/Content/Game/DourTower")
  l_1_0:queueDirectory("Data/Content/Game/MachineRooms")
end

WizardBat_Roof.destroy = function(l_2_0)
  Class.super(WizardBat_Roof).destroy(l_2_0)
  l_2_0.back:destroy()
end

WizardBat_Roof.tick = function(l_3_0)
  Class.super(WizardBat_Roof).tick(l_3_0)
  if not l_3_0.action then
    l_3_0:playAnimation("BreatheRoof")
  end
end

WizardBat_Roof.queueDirectory = function(l_4_0, l_4_1)
  local directories, assets = l_4_0.fileSystem:getAssetListing(l_4_1)
  for i,directory in ipairs(directories) do
    table.insert(l_4_0.directoryQueue, l_4_1 .. "/" .. directory)
  end
  local universeState = l_4_0:universe().state.state
  if not universeState.checkedOutBooks then
    local checkoutState = {}
  end
  for i,asset in ipairs(assets) do
    local fullPath = l_4_1 .. "/" .. asset
    if not checkoutState[fullPath] then
      table.insert(l_4_0.fileQueue, fullPath)
    end
  end
end

WizardBat_Roof.dequeue = function(l_5_0, l_5_1)
  local result = l_5_1[1]
  if result then
    table.remove(l_5_1, 1)
  end
  return result
end

WizardBat_Roof.targetNextRoom = function(l_6_0)
  local directory = l_6_0:dequeue(l_6_0.directoryQueue)
  if directory then
    l_6_0:queueDirectory(directory)
    return true
  end
end

WizardBat_Roof.destroyNextFile = function(l_7_0)
  local file = l_7_0:dequeue(l_7_0.fileQueue)
  if file then
    l_7_0.fileSystem:deleteFile(file)
    return true
  else
    if l_7_0:targetNextRoom() then
      return l_7_0:destroyNextFile()
    end
  end
end

WizardBat_Roof.playAnimation = function(l_8_0, l_8_1)
  local mainAction = CommonActions.PlayAnimation.new(l_8_1 .. "_Front")
  l_8_0:forceAction(mainAction)
  l_8_0.back:forceAction(CommonActions.PlayAnimation.new(l_8_1 .. "_Back"))
  if l_8_0.fx:get(AnimatorComponent):hasAnimation(l_8_1 .. "_FX") then
    l_8_0.fx:setVisible(true)
    l_8_0.fx:forceAction(CommonActions.PlayAnimation.new(l_8_1 .. "_FX"))
  end
  return mainAction
end

return WizardBat_Roof

