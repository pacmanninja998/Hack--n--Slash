-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\ModsGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local MenuGui = Gui.load("Content/Game/Global/Gui/MenuGui")
local MessageGui = Gui.load("Content/Game/Global/Gui/MessageGui")
local PlayerInputGui = Gui.load("Content/Game/Global/Gui/PlayerInputGui")
local ModsGui = Class.create(MenuGui, "ModsGui")
local Storage = require("Storage")
local ModManager = require("ModManager")
ModsGui.PublishProgressGui = Class.create(MessageGui, "ModsGui.PublishProgressGui")
ModsGui.PublishProgressGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(ModsGui.PublishProgressGui).init(l_1_0, l_1_1, "Publishing mod...", "Uploading mod...", l_1_4)
  l_1_0.localMod, l_1_0.publisher = l_1_2, l_1_3
  l_1_0:setDismissEnabled(false)
end

ModsGui.PublishProgressGui.tick = function(l_2_0)
  Class.super(ModsGui.PublishProgressGui).tick(l_2_0)
  local status = l_2_0.publisher:getStatus()
  local statusText = "Uploading mod..."
  if status == DFHackPublisher.SHARING_PREVIEW_FILE then
    statusText = "Uploading preview file..."
  else
    if status == DFHackPublisher.SHARING_FILE then
      statusText = "Uploading mod..."
    else
      if status == DFHackPublisher.CHECK_STATUS then
        statusText = "Checking the mod's publishing status..."
      else
        if status == DFHackPublisher.PUBLISHING then
          statusText = "Publishing mod..."
        else
          if status == DFHackPublisher.UPDATING then
            statusText = "Updating mod..."
          else
            if status == DFHackPublisher.FAILED then
              statusText = "Upload failed."
              l_2_0:setDismissEnabled(true)
            else
              if status == DFHackPublisher.PUBLISHED then
                statusText = "The mod was published successfully!"
                if not l_2_0.completed then
                  l_2_0.localMod:completePublish(l_2_0.publisher:getPublishedFileId())
                  l_2_0.completed = true
                end
                l_2_0:setDismissEnabled(true)
              end
            end
          end
        end
      end
    end
  end
  if statusText ~= l_2_0.label.text then
    l_2_0.label:setText(statusText)
  end
end

ModsGui.init = function(l_3_0, l_3_1, l_3_2, l_3_3)
  Class.super(ModsGui).init(l_3_0, l_3_1, "Manage mods", l_3_3)
  l_3_0.entity = l_3_3
  l_3_0.modManager = l_3_2
  l_3_0:rebuild()
end

ModsGui.rebuild = function(l_4_0)
  l_4_0:reset()
  local keys = {}
  for key in pairs(l_4_0.modManager.mods) do
    do
      table.insert(keys, key)
    end
  end
  table.sort(keys, function(l_1_0, l_1_1)
    return self.modManager.mods[l_1_0].name < self.modManager.mods[l_1_1].name
   end)
  do
    for index,key in ipairs(keys) do
      local modInstance = l_4_0.modManager.mods[key]
      l_4_0:addMenuButton(modInstance.name, function()
        self:onModSelected(key, modInstance)
         end)
    end
  end
  l_4_0:addMenuButton("Create new mod", l_4_0.onCreateNewMod, l_4_0)
end

ModsGui.onModSelected = function(l_5_0, l_5_1, l_5_2)
  local modsMenu = MenuGui.new(l_5_0.root, l_5_2.name, l_5_0.entity)
  if DFHack.hasRemoteStorage() and l_5_2:is(ModManager.LocalMod) then
    modsMenu:addMenuButton("Publish mod", function()
    self:publishMod(modInstance)
   end)
  end
  if l_5_2:is(ModManager.PackagedMod) then
    modsMenu:addMenuButton("Clone mod", function()
    self:cloneMod(modInstance)
   end)
  end
  l_5_0.root:openModalGui(modsMenu)
end

ModsGui.cloneMod = function(l_6_0, l_6_1)
  local input = PlayerInputGui.new(l_6_0.root, "", "Name your cloned mod (alphanumeric) ...", l_6_0.entity, "%w")
  input.selectEvent:register(function()
    self:onNewModNamed(input:getResult(), packagedMod)
   end)
  l_6_0.root:openModalGui(input)
end

ModsGui.publishMod = function(l_7_0, l_7_1)
  local publisher = l_7_1:beginPublish()
  if not publisher then
    l_7_0.root:openModalGui(MessageGui.new(l_7_0.root, "Publishing failure", "Couldn't start the publish operation.", l_7_0.entity))
  else
    l_7_0.root:openModalGui(ModsGui.PublishProgressGui.new(l_7_0.root, l_7_1, publisher, l_7_0.entity))
  end
end

ModsGui.onCreateNewMod = function(l_8_0)
  local input = PlayerInputGui.new(l_8_0.root, "", "Name your mod (alphanumeric) ...", l_8_0.entity, "%w")
  input.selectEvent:register(function()
    self:onNewModNamed(input:getResult())
   end)
  l_8_0.root:openModalGui(input)
end

ModsGui.onNewModNamed = function(l_9_0, l_9_1, l_9_2)
  if #l_9_1 == 0 then
    return 
  end
  local key = l_9_1:lower()
  if l_9_0.modManager.mods[key] then
    local message = MessageGui.new(l_9_0.root, "Couldn't create new mod", "A mod already exists with that name.", l_9_0.entity)
    l_9_0.root:openModalGui(message)
  else
    l_9_0.modManager:createMod(l_9_1, l_9_2)
    l_9_0:rebuild()
    local message = MessageGui.new(l_9_0.root, "Mod successfully created!", string.format("Your new mod %q has been created. Your mod files are in your documents directory at %q.", l_9_1, "Mods/" .. l_9_1 .. "/"), l_9_0.entity)
    l_9_0.root:openModalGui(message)
  end
end

return ModsGui

