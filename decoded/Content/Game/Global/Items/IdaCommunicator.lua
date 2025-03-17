-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\IdaCommunicator.lua 

local Class = require("Class")
local Action = require("Action")
local Item = require("Item")
local SceneComponent = require("Components.SceneComponent")
local IdaCommunicator = Class.create(Item, "IdaCommunicator")
IdaCommunicator.Communicate = Class.create(Action, "IdaCommunicator.Communicate")
IdaCommunicator.Communicate.init = function(l_1_0, l_1_1)
  Action.init(l_1_0)
  l_1_0.item = l_1_1
end

IdaCommunicator.Communicate.tick = function(l_2_0)
  local sceneComponent = l_2_0.entity:get(SceneComponent)
  sceneComponent:play(function(l_1_0)
    self.entity:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    local idaPortrait = l_1_0:addCharacter("Portraits/Ida/Ida")
    if not self.item.state.searchSucceeded then
      l_1_0:speakLineRight(idaPortrait, "<shifted>Good evening.  Oh dear, I apologize...you may not yet be able to understand me, though I have no way of knowing.</>")
      l_1_0:speakLineRight(idaPortrait, "<shifted>If you have corrected the wizard's corruption, I applaud your cleverness and would be happy to provide my aid.</>")
      l_1_0:speakLineRight(idaPortrait, "<shifted>I possess the ability to search the universe. Name something of importance and I will tell you where in the fabric it is held.</>")
    end
    local playerName = self.entity.state.name
    l_1_0:speakLineRight(idaPortrait, "<shifted>What would you like to search for?</>")
    local searchText = l_1_0:getPlayerText("")
    if searchText:lower() == playerName:lower() then
      l_1_0:speakLineRight(idaPortrait, "<shifted>Ah yes, your name. Let us instead search for <c:72FEFDFF>name</> itself, which will contain it...</>", nil, true)
      searchText = "name"
    else
      l_1_0:speakLineRight(idaPortrait, "<shifted>Searching for <c:72FEFDFF>" .. searchText .. "</>...</>", nil, true)
    end
    coroutine.yield()
    local fakeSearchTime = 1
    local startTime = MOAISim.getDeviceTime()
    local paths = DFHack.searchObject(self.entity.state, searchText, true, true)
    local searchTime = MOAISim.getDeviceTime() - startTime
    l_1_0:sleep(fakeSearchTime - searchTime)
    if #paths == 0 then
      l_1_0:speakLineRight(idaPortrait, "<shifted>Unfortunately, I cannot find <c:72FEFDFF>" .. searchText .. "</> in the universe at this time.</>")
    elseif #paths > 1 then
      l_1_0:speakLineRight(idaPortrait, "<shifted><c:72FEFDFF>" .. searchText .. "</> occurs many times in the universe.  Might you be more specific?</>")
    elseif #paths == 1 then
      self.item.state.searchSucceeded = true
      local path = paths[1]
      l_1_0:speakLineRight(idaPortrait, "<shifted>It is found.  This device is now imprinted with the location in the universe where the fact resides. (" .. paths[1] .. ")</>")
      self.item.state.activePath = paths[1]
    end
    self.entity:halt(false)
   end)
  return false
end

IdaCommunicator.init = function(l_3_0, l_3_1)
  Item.init(l_3_0, l_3_1)
end

IdaCommunicator.getAction = function(l_4_0, l_4_1)
  return IdaCommunicator.Communicate.new(l_4_0)
end

IdaCommunicator.getDescription = function(l_5_0)
  if not l_5_0.state.searchSucceeded then
    return "A device the lady in the inner prison gave us."
  else
    return "Ida's device for finding locations in the universal state."
  end
end

IdaCommunicator.getSprite = function(l_6_0)
  return "UI/ArtifactIcons/ArtifactIcons", "Pyramid"
end

return IdaCommunicator

