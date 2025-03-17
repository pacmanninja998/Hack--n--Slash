-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Rooms\Hub.lua 

local Hub = require("Room").classFromLayout("Content/Game/EGW/Layouts/Hub", "Hub", "Content/Game/Global/Rooms/GameRoom")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
local Music = require("Music")
Hub.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("GuardHallway exit", "Content/Game/EGW/Rooms/GuardHallway", "Hub exit")
  l_1_0:defineCollisionExit("InvisiblePlatformRoom exit", "Content/Game/EGW/Rooms/InvisiblePlatformRoom", "Hub exit")
  l_1_0:defineCollisionExit("PlatformToNowhere exit", "Content/Game/EGW/Rooms/PlatformToNowhere", "Hub exit")
  l_1_0:defineCollisionExit("Universe exit", "Content/Game/EGW/Rooms/Universe", "Hub exit")
  l_1_0:defineTreasureChestScene("TreasureChest (boss key)", l_1_0.onBossKeyTreasureChestScene, l_1_0, "Opening")
  l_1_0:getEntity("Lock"):get(InteractionComponent).interactEvent:register(l_1_0.onLockInteract, l_1_0)
  Music:playAmbient("Ambience/Ambience/Castle_Ambience_Fire")
  Music:setReverb("Reflective")
end

Hub.onLockInteract = function(l_2_0, l_2_1, l_2_2)
  l_2_1:get(SceneComponent):play(function(l_1_0)
    interactor:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    if not interactor.host.state.hasBossKey then
      l_1_0:speakLineLeft(alicePortrait, "That's a really big key hole.", "Surprised")
    else
      l_1_0:speakLineLeft(alicePortrait, "Hey! This novelty key fits perfectly!", "Laughing")
      l_1_0:speakLineLeft(alicePortrait, "Wait, how does this work exactly? They're just bars. There's no actual lock hardware.", "Snobby")
      lock:destroy()
      l_1_0:speakLineLeft(alicePortrait, "Oh well, somehow the bars dematerialized anyway!", "Spooked")
    end
    interactor:halt(false)
    lock:get(InteractionComponent):stopInteract(interactor)
   end)
end

Hub.onBossKeyTreasureChestScene = function(l_3_0, l_3_1, l_3_2)
  local alicePortrait = l_3_1:addAlicePortrait()
  l_3_1:speakLineLeft(alicePortrait, "It's a key! A really really big one.", "Excited")
  l_3_1:speakLineLeft(alicePortrait, "I'll just slip this in my pocket. No use taking up an equipment slot.", "Default")
  l_3_2.host.state.hasBossKey = true
end

return Hub

