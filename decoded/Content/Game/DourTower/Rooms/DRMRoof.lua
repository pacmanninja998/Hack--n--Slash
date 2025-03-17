-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\DRMRoof.lua 

local Class = require("Class")
local Room = require("Room")
local DRMRoof = Room.classFromLayout("Content/Game/DourTower/Layouts/DRMRoof", "DRMRoof", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local Music = require("Music")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local SceneComponent = require("Components.SceneComponent")
local SoundComponent = require("Components.SoundComponent")
DRMRoof.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("TowerLevel5 exit", "Content/Game/DourTower/Rooms/TowerLevel5", "DRMRoof exit")
  l_1_0:defineCollisionExit("PrincessChambers exit", "Content/Game/DourTower/Rooms/PrincessChambers", "DRMRoof exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, nil, l_1_0:getCollisionArea("Stairs_Lft"), Direction.DIR_E, 2.2, true)
  Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, nil, l_1_0:getCollisionArea("Stairs_Rt"), Direction.DIR_W, 2.2, true)
  Music:playMusic("Music/Music/WizardTower_Level6")
  Music:setReverb("Exterior")
  local beamPort = l_1_0:getEntity("BeamPort")
  beamPort.schemas.DECIPHER_KEY:registerValueSetHandler(beamPort, l_1_0.onDecipherKeySet, l_1_0)
  local pedestal = l_1_0:getEntity("Pedestal")
  pedestal:get(InteractionComponent).interactEvent:register(l_1_0.onPedestalInteract, l_1_0)
  if not l_1_0:universe().state.encipheredPrincessChambers then
    l_1_0:encipherBook("Data/Content/Game/DourTower/Rooms/PrincessChambers.lua")
    l_1_0:universe().state.encipheredPrincessChambers = true
  end
  l_1_0:updateBook()
  l_1_0:updateBeam()
end

DRMRoof.onAliceCreated = function(l_2_0, l_2_1)
  Class.super(DRMRoof).onAliceCreated(l_2_0, l_2_1)
end

DRMRoof.onPedestalInteract = function(l_3_0, l_3_1)
  local bookPath = l_3_0:getState().pedestalBook
  local alice = l_3_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    if bookPath then
      alice:halt(true)
      l_1_0:speakLineRight(bobPortrait, "It's labeled...", "Excited")
      l_1_0:speakLineRight(bobPortrait, bookPath, "NoWay")
      l_1_0:speakLineLeft(alicePortrait, "Let's take it.", "HappyLaugh")
      l_1_0:sleep(0.2)
      alice:get(InventoryComponent):insertItem("Content/Game/Global/Items/LibraryBookItem", {filePath = bookPath})
      self:getState().pedestalBook = nil
      self:updateBook()
      l_1_0:sleep(0.3)
      alice:halt(false)
    else
      alice:halt(true)
      l_1_0:speakLineRight(bobPortrait, "Do you want to put a book on there?", "Talk")
      local menu = l_1_0:createMenu({}, "Pedestal options", alicePortrait)
      menu:addRepeatOption("no", "Not right now.")
      for index,item in ipairs(alice:get(InventoryComponent).state.inventory) do
        if item.path == "Content/Game/Global/Items/LibraryBookItem" then
          menu:addRepeatOption(index, item.state.filePath)
        end
      end
      local option = menu:choose()
      if option == "no" then
        l_1_0:speakLineLeft(alicePortrait, "Not right now.", "Talk2")
      else
        l_1_0:speakLineLeft(alicePortrait, "Yeah, let's put this one on there.", "Talk2")
        l_1_0:speakLineRight(bobPortrait, "We'll see you later...", "Excited")
        local item = alice:get(InventoryComponent).state.inventory[option]
        l_1_0:speakLineRight(bobPortrait, item.state.filePath, "NoWay")
        l_1_0:sleep(0.2)
        alice:get(InventoryComponent):removeItem(option)
        self:getState().pedestalBook = item.state.filePath
        self:updateBook()
        self:updateBeam()
        l_1_0:sleep(0.5)
      end
      alice:halt(false)
    end
   end)
end

DRMRoof.updateBeam = function(l_4_0)
  local activate = l_4_0:getState().pedestalBook ~= nil
  if activate and l_4_0:isDecrypted(l_4_0:getState().pedestalBook) then
    activate = false
  end
  l_4_0:getEntity("LightBeam"):setVisible(activate)
  l_4_0:getCollisionArea("Beam volume"):setActive(activate)
  l_4_0:getEntity("Pedestal"):get(InteractionComponent):setEnabled(not activate)
end

DRMRoof.updateBook = function(l_5_0)
  l_5_0:getEntity("Book"):setVisible(l_5_0:getState().pedestalBook ~= nil)
end

DRMRoof.encipherBook = function(l_6_0, l_6_1)
  local fileSystem = l_6_0:getFileSystem()
  local pathData = fileSystem:loadFile(l_6_1)
  local encipheredData = DFHack.encipherBuffer(pathData, "With this incantation the princess I do bind and protect.")
  fileSystem:storeFile(l_6_1, encipheredData)
  l_6_0:getState().pedestalBook = l_6_1
end

DRMRoof.getFileSystem = function(l_7_0)
  return l_7_0:universe().state.fileSystem
end

DRMRoof.onDecipherKeySet = function(l_8_0, l_8_1)
  local book = l_8_0:getState().pedestalBook
  if book and not l_8_0:isDecrypted(book) then
    local fileSystem = l_8_0:getFileSystem()
    local bookData = fileSystem:loadFile(book)
    local deciphered = DFHack.decipherBuffer(bookData, l_8_1)
    if deciphered then
      fileSystem:storeFile(book, deciphered)
    else
      l_8_0:getAlice():get(SoundComponent):playCue("SFX/Objects/CorruptionMachine_Shutdown", nil, 0.5)
    end
    l_8_0:updateBeam()
  end
end

DRMRoof.isDecrypted = function(l_9_0, l_9_1)
  local fn = loadfile(l_9_1)
  return fn ~= nil
end

return DRMRoof

