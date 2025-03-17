-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\HalcyonLamp.lua 

local Entity = require("Entity")
local HalcyonLamp = require("Class").create(Entity, "HalcyonLamp")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
HalcyonLamp.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/HalcyonLamp/HalcyonLamp")
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_1_0)
  l_1_0:get(InteractionComponent).interactEvent:register(l_1_0.onInteract, l_1_0)
end

HalcyonLamp.onInteract = function(l_2_0, l_2_1)
  if l_2_1 then
    local sceneComponent = l_2_1:get(SceneComponent)
    if sceneComponent then
      sceneComponent:play(function(l_1_0)
      interactor:halt(true)
      local alicePortrait = l_1_0:addAlicePortrait()
      local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
      l_1_0:speakLineLeft(alicePortrait, "What do you think this is?")
      l_1_0:speakLineRight(bobPortrait, "I don't know, but it's shiny! I think we should take it.")
      l_1_0:speakLineLeft(alicePortrait, "Are you sure?")
      l_1_0:speakLineRight(bobPortrait, "When have I led you astray?")
      l_1_0:speakLineLeft(alicePortrait, "...")
      local inventory = interactor:get(InventoryComponent)
      if inventory then
        inventory:insertItem("Content/Game/Global/Items/HalcyonLampItem", {numWishes = 3})
        interactor:get(SoundComponent):playCue("Music/Music/Fanfare", nil, 0.5)
        self:destroy()
      end
      interactor:halt(false)
      end)
    end
  end
end

return HalcyonLamp

