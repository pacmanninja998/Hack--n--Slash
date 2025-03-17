-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryOfBabble\Book.lua 

local Class = require("Class")
local Entity = require("Entity")
local Book = Class.create(Entity, "Book")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SceneComponent = require("Components.SceneComponent")
local SpriteComponent = require("Components.SpriteComponent")
Book.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Layouts/Game/DourTower/LibraryOfBabble/LibraryOfBabble", l_1_5)
  local interaction = InteractionComponent.new(l_1_0)
  l_1_0:setLabelText("")
  interaction:setEnabled(false)
  interaction.interactEvent:register(l_1_0.onInteract, l_1_0)
end

Book.setBookPath = function(l_2_0, l_2_1)
  l_2_0:get(InteractionComponent):setEnabled(true)
  l_2_0.bookPath = l_2_1
  l_2_0:updateState()
end

Book.isCheckedOut = function(l_3_0)
  local universeState = l_3_0:universe().state.state
  return universeState.checkedOutBooks[l_3_0.bookPath]
end

Book.setCheckedOut = function(l_4_0, l_4_1)
  local universeState = l_4_0:universe().state.state
  universeState.checkedOutBooks[l_4_0.bookPath] = l_4_1 or nil
  l_4_0:updateState()
end

Book.updateState = function(l_5_0)
  if l_5_0:isCheckedOut() then
    l_5_0:setLabelText("")
    l_5_0:setVisible(false)
  else
    local lastPart = l_5_0.bookPath
    for part in l_5_0.bookPath:gmatch("[^/]+") do
      lastPart = part
    end
    l_5_0:setLabelText(lastPart)
    l_5_0:setVisible(true)
  end
end

Book.onInteract = function(l_6_0, l_6_1)
  l_6_1:get(SceneComponent):play(function(l_1_0)
    local inventory = interactor:get(InventoryComponent)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    interactor:halt(true)
    local bookItemIndex = nil
    for index,item in ipairs(inventory.state.inventory) do
      if item.path == "Content/Game/Global/Items/LibraryBookItem" and item.state.filePath == self.bookPath then
        bookItemIndex = index
    else
      end
    end
    if self:isCheckedOut() then
      l_1_0:speakLineRight(bobPortrait, "The book that goes here is...", "Default")
      l_1_0:speakLineRight(bobPortrait, "<c:72FEFDFF>" .. self.bookPath .. "</c>", "Judgemental")
      l_1_0:speakLineLeft(alicePortrait, "How do you know that?", "Default")
      l_1_0:speakLineRight(bobPortrait, "I have no idea!", "Excited")
      if bookItemIndex then
        local menu = l_1_0:createMenu({}, "Book options", alicePortrait)
        menu:addRepeatOption("putback", "Let's put it back for now.")
        menu:addRepeatOption("keep", "Let's hold onto it for a while longer.")
        local option = menu:choose()
        if option == "putback" then
          l_1_0:speakLineLeft(alicePortrait, "Let's put it back for now.", "Spooked")
          l_1_0:sleep(0.1)
          inventory:removeItem(bookItemIndex)
          self:setCheckedOut(false)
          l_1_0:sleep(0.5)
        else
          l_1_0:speakLineLeft(alicePortrait, "Let's hold onto it for a while longer.", "Default")
          l_1_0:speakLineRight(bobPortrait, "Okay!", "Excited")
        end
      else
        l_1_0:speakLineRight(bobPortrait, "The label on the spine says...", "Default")
        l_1_0:speakLineRight(bobPortrait, "<c:72FEFDFF>" .. self.bookPath .. "</c>", "NoWay")
        if not bookItemIndex then
          local menu = l_1_0:createMenu({}, "Book options", alicePortrait)
          menu:addRepeatOption("take", "Let's take it.")
          menu:addRepeatOption("leave", "I don't think we need that one.")
          local option = menu:choose()
          if option == "take" then
            l_1_0:speakLineLeft(alicePortrait, "Let's take it.", "Spooked")
            l_1_0:sleep(0.1)
            inventory:insertItem("Content/Game/Global/Items/LibraryBookItem", {filePath = self.bookPath})
            self:setCheckedOut(true)
            l_1_0:sleep(0.5)
          else
            l_1_0:speakLineLeft(alicePortrait, "I don't think we need that one.", "Default")
          end
        else
          l_1_0:speakLineLeft(alicePortrait, "We already have a copy of this book. Somehow.", "Spooked")
        end
      end
    end
  end
  interactor:halt(false)
  self:get(InteractionComponent):stopInteract(interactor)
   end)
end

return Book

