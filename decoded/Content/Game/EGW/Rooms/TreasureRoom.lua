-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Rooms\TreasureRoom.lua 

local TreasureRoom = require("Room").classFromLayout("Content/Game/EGW/Layouts/TreasureRoom", "TreasureRoom", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
local InteractionComponent = require("Components.InteractionComponent")
local SceneComponent = require("Components.SceneComponent")
TreasureRoom.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("BlockHallway exit", "Content/Game/EGW/Rooms/BlockHallway", "TreasureRoom exit")
  l_1_0:defineCollisionExit("InvisiblePlatformRoom exit", "Content/Game/EGW/Rooms/InvisiblePlatformRoom", "TreasureRoom exit")
  l_1_0:defineCollisionExit("PlatformToNowhere exit", "Content/Game/EGW/Rooms/PlatformToNowhere", "TreasureRoom exit")
  l_1_0:defineCollisionExit("Universe exit", "Content/Game/EGW/Rooms/Universe")
  for i = 1, 5 do
    l_1_0:getEntity("Lit HackBlock " .. i).REMAINING_PUSHES = 1
  end
  l_1_0:getEntity("Reverse HackBlock").TILES_PER_PUSH = -1
  l_1_0:defineTreasureChestScene("TreasureChest (maxHealth)", l_1_0.onMaxHealthTreasureChestScene, l_1_0)
  l_1_0:defineTreasureChestScene("TreasureChest (timeDilation)", l_1_0.onTimeDilationTreasureChestScene, l_1_0)
  l_1_0:defineTreasureChestScene("TreasureChest (glyphsDecoded)", l_1_0.onGlyphsDecodedTreasureChestScene, l_1_0)
  l_1_0:defineTreasureChestScene("TreasureChest (bossKey)", l_1_0.onBossKeyTreasureChestScene, l_1_0)
  l_1_0:getEntity("Lock"):get(InteractionComponent).interactEvent:register(l_1_0.onLockInteract, l_1_0)
  Music:playAmbient("Ambience/Ambience/Castle_Ambience1")
  require("Music"):playMusic("Music/Music/Armory_Cue1", false)
  Music:setReverb("Reflective")
end

TreasureRoom.onLockInteract = function(l_2_0, l_2_1, l_2_2)
  l_2_1:get(SceneComponent):play(function(l_1_0)
    interactor:halt(true)
    if not interactor.host.state.hasBossKey then
      l_1_0:displayLine("That's an enormous keyhole. Unfortunately, you can't quite squeeze yourself through it.")
    else
      l_1_0:displayLine("Your enormous novelty key fits perfectly! Wait, how does this work exactly? They're just bars. There's no actual lock hardware.")
      lock:destroy()
      self:getCollisionArea("Lock"):destroy()
      l_1_0:displayLine("Oh well, somehow the bars dematerialized anyway!")
    end
    interactor:halt(false)
    lock:get(InteractionComponent):stopInteract(interactor)
   end)
end

TreasureRoom.onMaxHealthTreasureChestScene = function(l_3_0, l_3_1, l_3_2)
  l_3_1:displayLine("A strange artifact labeled <c:0000FFFF>maxHealth</c>.")
  table.insert(l_3_2.host.state.discoveredValues, "maxHealth")
end

TreasureRoom.onTimeDilationTreasureChestScene = function(l_4_0, l_4_1, l_4_2)
  l_4_1:displayLine("A strange artifact labeled <c:0000FFFF>timeDilation</c>.")
  table.insert(l_4_2.host.state.discoveredValues, "timeDilation")
end

TreasureRoom.onGlyphsDecodedTreasureChestScene = function(l_5_0, l_5_1, l_5_2)
  l_5_1:displayLine("A strange artifact labeled <c:0000FFFF>glyphsDecoded</c>.")
  table.insert(l_5_2.host.state.discoveredValues, "glyphsDecoded")
end

TreasureRoom.onBossKeyTreasureChestScene = function(l_6_0, l_6_1, l_6_2)
  l_6_1:displayLine("There's a key inside. It's enormous, but somehow it still fits in your pocket.")
  l_6_2.host.state.hasBossKey = true
end

return TreasureRoom

