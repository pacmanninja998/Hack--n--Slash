-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\HalcyonLampItem.lua 

local Item = require("Item")
local Action = require("Action")
local SpriteSheet = require("SpriteSheet")
local AnimatorComponent = require("Components.AnimatorComponent")
local ControllerComponent = require("Components.ControllerComponent")
local SceneComponent = require("Components.SceneComponent")
local InventoryComponent = require("Components.InventoryComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local WishAction = require("Class").create(Action, "WishAction")
WishAction.PULL_OUT_ANIMATION = "PullOut_Lamp"
WishAction.FRAMES_PER_SECOND = 15
WishAction.init = function(l_1_0, l_1_1)
  l_1_0.item = l_1_1
end

WishAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.pullOutSequence = l_2_0.entity:get(AnimatorComponent):playOnce(l_2_0.PULL_OUT_ANIMATION, l_2_0.FRAMES_PER_SECOND)
end

WishAction.tick = function(l_3_0)
  if l_3_0.entity:get(AnimatorComponent):isPlaying(l_3_0.pullOutSequence) then
    l_3_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
    return true
  else
    local sceneComponent = l_3_0.entity:get(SceneComponent)
    if sceneComponent then
      sceneComponent:play(function(l_1_0)
      self.entity:halt(true)
      local alicePortrait = l_1_0:addAlicePortrait()
      local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
      local halcyonPortrait = l_1_0:addCharacter("Portraits/Halcyon/Halcyon")
      speakHalcyonLine = function(l_1_0)
        if not self.entity:universe().state.state.fixedSymbolicFont then
          l_1_0 = "<symbolic>" .. l_1_0 .. "</>"
        end
        scene:speakLineRight(halcyonPortrait, l_1_0)
         end
      if self.item.state.numWishes > 0 then
        if not self.item.state.replaceSucceeded then
          speakHalcyonLine("You're escaping?  How novel.  You probably don't understand the glyphs though...")
          speakHalcyonLine("If you can, though, I shall grant you wishes. Find a location where a true fact is stored in the universe.")
          speakHalcyonLine("Bring it to me and I can change it.")
        end
        local inventory = self.entity:get(InventoryComponent)
        local index = inventory:findItemIndex("Content/Game/Global/Items/IdaCommunicator")
        if index and inventory.items[index].state.activePath then
          local activePath = inventory.items[index].state.activePath
          speakHalcyonLine("Ah, so Ida has found a location for you... " .. activePath .. "")
          speakHalcyonLine("You have " .. tostring(self.item.state.numWishes) .. " wish" .. (self.item.state.numWishes > 1 and "es" or "") .. " left.")
          speakHalcyonLine("What would you like to change this fact to?")
          local replacement = l_1_0:getPlayerText("")
          if replacement then
            self.item.state.numWishes = self.item.state.numWishes - 1
            local curValue = DFHack.walkPath(self.entity.state, activePath)
            if type(curValue) == "number" and tonumber(replacement) then
              replacement = tonumber(replacement)
            end
            local result = DFHack.replacePath(self.entity.state, activePath, replacement)
            if result then
              speakHalcyonLine("The stars now speak of " .. replacement .. ".")
              self.item.state.replaceSucceeded = true
            else
              speakHalcyonLine("That part of the universe has folded in upon itself. It no longer exists.")
              self.item.state.numWishes = self.itemState.numWishes + 1
            end
          else
            speakHalcyonLine("Very well. Let me know when you would like to make a wish.")
          end
        else
          speakHalcyonLine("Bring me a stellar coordinate, and I can grant you a wish and rewrite the state of the universe.")
        end
      else
        speakHalcyonLine("Unfortunately, you have used up all of your wishest Please come back in 10,000 years.")
      end
    end
    self.entity:halt(false)
      end)
    end
  end
  return false
end

local HalcyonLampItem = require("Class").create(Item, "HalcyonLampItem")
HalcyonLampItem.init = function(l_4_0, l_4_1)
  Item.init(l_4_0, l_4_1)
  l_4_0.state.numWishes = l_4_0.state.numWishes or 3
end

HalcyonLampItem.getAction = function(l_5_0, l_5_1)
  return WishAction.new(l_5_0)
end

HalcyonLampItem.getDescription = function(l_6_0)
  return "Magic lamp"
end

HalcyonLampItem.getSprite = function(l_7_0)
  return "UI/Placeholder/ItemIcons/HalcyonLamp/HalcyonLamp", "HalcyonLamp"
end

return HalcyonLampItem

