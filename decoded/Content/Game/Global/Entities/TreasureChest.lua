-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\TreasureChest.lua 

local Entity = require("Entity")
local TreasureChest = require("Class").create(Entity, "TreasureChest")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local Delegate = require("DFMoai.Delegate")
local CommonActions = require("CommonActions")
local ChestOpenAction = require("Class").create(CommonActions.PlayAnimation, "ChestOpenAction")
ChestOpenAction.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0.interactor = l_1_1
  CommonActions.PlayAnimation.init(l_1_0, l_1_2)
end

ChestOpenAction.start = function(l_2_0, l_2_1)
  CommonActions.PlayAnimation.start(l_2_0, l_2_1)
  if l_2_0.entity.openingSFX then
    l_2_0.entity:get(SoundComponent):playCue(l_2_0.entity.openingSFX, nil, 0.5)
    l_2_0.entity:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
  end
end

ChestOpenAction.stop = function(l_3_0)
  CommonActions.PlayAnimation.stop(l_3_0)
  l_3_0.entity.isOpen = true
  l_3_0.entity:get(AnimatorComponent):play(l_3_0.entity.openedAnim)
  l_3_0.entity:get(InteractionComponent):setEnabled(false)
  l_3_0.entity.layer.room:getState()[l_3_0.entity.name .. " open"] = l_3_0.entity.isOpen
  l_3_0.interactor:halt(false)
  l_3_0.entity.openedEvent:dispatch()
end

TreasureChest.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5, l_4_6, l_4_7, l_4_8, l_4_9, l_4_10, l_4_11, l_4_12, l_4_13)
  Entity.init(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  l_4_0.spriteSheet = l_4_6 or "Interactions/Props/Chest/Chest"
  l_4_0.width = l_4_7 or 128
  l_4_0.height = l_4_8 or 64
  l_4_0.openedAnim = l_4_9 or "Opened"
  l_4_0.closedAnim = l_4_10 or "Closed"
  l_4_0.openingAnim = l_4_11 or "Opening"
  l_4_0.closingAnim = l_4_12 or "Closing"
  l_4_0.openingSFX = l_4_13 or "SFX/Objects/Chest_Open"
  SpriteComponent.new(l_4_0, l_4_0.spriteSheet)
  PhysicsComponent.new(l_4_0, l_4_0.width, l_4_0.height, PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.STATIC)
  AnimatorComponent.new(l_4_0, false)
  InteractionComponent.new(l_4_0, true)
  SoundComponent.new(l_4_0, {})
  l_4_0.isOpen = false
  l_4_0:get(InteractionComponent).interactEvent:register(l_4_0.onInteract, l_4_0)
  l_4_0:get(AnimatorComponent):play(l_4_0.closedAnim)
  l_4_0.itemPath = nil
  l_4_0.args = nil
  l_4_0.openedEvent = Delegate.new()
  local stateOpen = l_4_0.layer.room:getState()[l_4_0.name .. " open"]
  if stateOpen then
    l_4_0.isOpen = true
    l_4_0:get(AnimatorComponent):play(l_4_0.openedAnim)
    l_4_0:get(InteractionComponent):setEnabled(false)
  end
end

TreasureChest.setItem = function(l_5_0, l_5_1, l_5_2)
  l_5_0.itemPath = l_5_1
  l_5_0.args = l_5_2
end

TreasureChest.setArtifact = function(l_6_0, l_6_1)
  l_6_0.artifactPath = l_6_1
end

TreasureChest.onInteract = function(l_7_0, l_7_1, l_7_2)
  l_7_1:halt(true)
  if not l_7_0.isOpen then
    local inventory = l_7_1:get(InventoryComponent)
    if inventory and l_7_0.itemPath then
      inventory:insertItem(l_7_0.itemPath, l_7_0.args)
    end
    if l_7_0.openingAnim then
      l_7_0:forceAction(ChestOpenAction.new(l_7_1, l_7_0.openingAnim))
    end
  end
  l_7_2:get(InteractionComponent):stopInteract(l_7_1)
end

return TreasureChest

