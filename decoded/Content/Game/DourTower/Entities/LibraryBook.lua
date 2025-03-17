-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryBook.lua 

local Action = require("Action")
local Entity = require("Entity")
local Item = require("Item")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local TakeBookAction = require("Class").create(Action, "TakeBookAction")
TakeBookAction.ANIMATION = "AttackSword"
TakeBookAction.FRAMES_PER_SECOND = 15
TakeBookAction.ITEM_PATH = "Content/Game/Global/Items/LibraryBookItem"
TakeBookAction.init = function(l_1_0, l_1_1)
  Action.init(l_1_0)
  l_1_0.book = l_1_1
end

TakeBookAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.entity:get(PhysicsComponent):setLinearVelocity(0, 0)
  l_2_0.sequence = l_2_0.entity:get(AnimatorComponent):playOnce(l_2_0.ANIMATION, l_2_0.FRAMES_PER_SECOND)
end

TakeBookAction.tick = function(l_3_0)
  return l_3_0.entity:get(AnimatorComponent):isPlaying(l_3_0.sequence)
end

TakeBookAction.stop = function(l_4_0)
  local inventory = l_4_0.entity:get(InventoryComponent)
  if inventory then
    inventory:insertItem(l_4_0.ITEM_PATH, {filePath = l_4_0.book.fullPath})
  end
  l_4_0.book:get(InteractionComponent):stopInteract(l_4_0.entity)
  l_4_0:universe().state.state.checkedOutBooks[l_4_0.book.fullPath] = true
  l_4_0.book:setEmpty(true)
end

local LibraryBook = require("Class").create(Entity, "LibraryBook")
LibraryBook.init = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5, l_5_6, l_5_7)
  Entity.init(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  SpriteComponent.new(l_5_0, "Interactions/Props/LibraryBook/LibraryBook")
  PhysicsComponent.new(l_5_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_5_0, false, 24 * math.cos(math.rad(l_5_5)), 24 * math.sin(math.rad(l_5_5)))
  l_5_0.rotation = l_5_5 or 0
  l_5_0:get(PhysicsComponent).body:setTransform(l_5_2, l_5_3, l_5_0.rotation)
  l_5_0.fullPath = l_5_6
  l_5_0:setEmpty(l_5_7 or false)
  l_5_0:get(InteractionComponent).interactEvent:register(l_5_0.onInteract, l_5_0)
end

LibraryBook.setEmpty = function(l_6_0, l_6_1)
  if l_6_0.empty ~= l_6_1 then
    l_6_0.empty = l_6_1
    l_6_0:get(SpriteComponent).prop:setVisible(not l_6_0.empty)
  end
end

LibraryBook.onInteract = function(l_7_0, l_7_1)
  if l_7_0.empty then
    local inventory = l_7_1:get(InventoryComponent)
    if inventory then
      local LibraryBookItem = Item.load("Content/Game/Global/Items/LibraryBookItem")
      for index,item in ipairs(inventory.items) do
        if item:is(LibraryBookItem) and item.state.fullPath == l_7_0.fullPath then
          inventory:removeItem(index)
          l_7_0:setEmpty(false)
      else
        end
      end
      l_7_0:get(InteractionComponent):stopInteract(l_7_1)
    else
      l_7_1:forceAction(TakeBookAction.new(l_7_0))
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return LibraryBook

