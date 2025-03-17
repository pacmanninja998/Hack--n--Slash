-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\DungeonLobby.lua 

local Class = require("Class")
local DungeonLobby = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/DungeonLobby", "DungeonLobby", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local LogoComponent = require("Components.LogoComponent")
local Direction = require("Direction")
local Music = require("Music")
local SceneComponent = require("Components.SceneComponent")
DungeonLobby.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("DungeonLobbyNorthHallway exit", "Content/Game/DweebKeep/Rooms/DungeonLobbyNorthHallway", "South exit")
  l_1_0:defineCollisionExit("DungeonLobbySouthHallway exit", "Content/Game/DweebKeep/Rooms/DungeonLobbySouthHallway", "North exit")
  require("Music"):playMusic("Music/Music/DungeonLobby_Cue1", false)
  Music:setReverb("Reflective")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 2 do
    Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs (left) " .. i, l_1_0.collisionAreasByName["Stairs (left) " .. i], Direction.DIR_W, 0.6)
    Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, "Stairs (right) " .. i, l_1_0.collisionAreasByName["Stairs (right) " .. i], Direction.DIR_E, 0.6)
  end
  for i = 1, 13 do
    local name = "Abyss " .. i
    Entity.create("Content/Game/Global/Entities/Abyss", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  l_1_0:defineLogicTrigger("Demon hand trigger", l_1_0.onDemonHandTrigger, l_1_0, true)
  l_1_0:getEntity("Guard A (patrolling)").IDLE_ROUTINE = {{TYPE = "MOVE", TILES = 10}, {TYPE = "IDLE", SECONDS = 3}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "IDLE", SECONDS = 1}}
  l_1_0:getEntity("Guard B (patrolling)").IDLE_ROUTINE = {{TYPE = "MOVE", TILES = 10}, {TYPE = "IDLE", SECONDS = 3}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "IDLE", SECONDS = 1}}
  l_1_0.hsvTint = {0.083, -0.111, 0}
  l_1_0:defineLogicTrigger("Closest guards trigger", l_1_0.onClosestGuardsTrigger, l_1_0)
  l_1_0:defineLogicTrigger("Patrol guards trigger", l_1_0.onPatrolGuardsTrigger, l_1_0)
  l_1_0:defineLogicTrigger("Monster guards trigger", l_1_0.onMonsterGuardsTrigger, l_1_0)
  l_1_0:defineLogicTrigger("Armory guards trigger", l_1_0.onArmoryGuardsTrigger, l_1_0)
  l_1_0:defineLogicTrigger("Ledge guards trigger", l_1_0.onLedgeGuardsTrigger, l_1_0)
  l_1_0:defineLogicTrigger("Stairs guards trigger", l_1_0.onStairsGuardsTrigger, l_1_0)
  l_1_0:defineLogicTrigger("Box guards trigger", l_1_0.onBoxGuardsTrigger, l_1_0)
  l_1_0.fadeEvent:register(l_1_0.onFade, l_1_0)
  l_1_0:enableWater()
end

DungeonLobby.fade = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  if l_2_1 == l_2_0.FADE_IN then
    local alice = l_2_0:getAlice()
    do
      if not l_2_0:getState()["Displayed title cards"] then
        alice:get(SceneComponent):play(function(l_1_0)
        alice:halt(true)
        l_1_0:displayTitleCard(2, "ACT 3")
        l_1_0:displayTitleCard(2, "IN WHICH WE\nESCAPE A DUNGEON")
        alice:halt(false)
        Class.super(DungeonLobby).fade(self, type, duration, host, exitArgs)
         end)
        return 
      end
    end
  end
  Class.super(DungeonLobby).fade(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
end

DungeonLobby.onFade = function(l_3_0, l_3_1, l_3_2)
  if l_3_1 == l_3_0.FADE_IN and not l_3_2 then
    local alice = l_3_0:getAlice()
    do
      if not l_3_0:getState()["Displayed title cards"] then
        local sceneComponent = alice:get(SceneComponent)
        sceneComponent:play(function(l_1_0)
          alice:halt(true)
          l_1_0:sleep(1)
          l_1_0:displayTitleCard(2, "...INSIDE A\nLARGER DUNGEON")
          self:getState()["Displayed title cards"] = true
          alice:halt(false)
            end)
      end
    end
  end
end

DungeonLobby.onDemonHandTrigger = function(l_4_0, l_4_1)
  if l_4_1 == l_4_0:getAlice() then
    local x, y = l_4_0:getEntity("DemonHand spawner"):getPosition()
    local hand = Entity.create("Content/Game/DweebKeep/Entities/DungeonLobby/DemonHand", l_4_0:getLayerByOrder(0), x, y)
    hand.target:setEntity(l_4_1)
    l_4_0:getCollisionArea("Demon hand trigger"):destroy()
  end
end

DungeonLobby.onClosestGuardsTrigger = function(l_5_0)
  l_5_0:playGuardBanter("Guard A (closest)", "Guard B (closest)", {"A: The girl finally stopped snoring.", "B: Good, she was keeping the warden awake"})
end

DungeonLobby.onPatrolGuardsTrigger = function(l_6_0)
  l_6_0:playGuardBanter("Guard A (patrolling)", "Guard B (patrolling)", {"A: So I hear the vat password got changed\nAND the blinky lights are gone.", "B: Aw, bits!"})
end

DungeonLobby.onMonsterGuardsTrigger = function(l_7_0)
  l_7_0:playGuardBanter("Guard A (monster)", "Guard B (monster)", {"A: Where'd that monster come from?", "B: Infinite Woods.", "A: I don't understand infinity well enough\nto joke with you about it.", "B: That's too bad.", "B: It's a fascinating and illuminating\nconcept that I return to regularly.", "B: I would've loved a good infinity joke.", "A: I'll look into it.", "A: There are so many moments when it seems appropriate.", "B: Did you just...no.  Nevermind."})
end

DungeonLobby.onArmoryGuardsTrigger = function(l_8_0)
  l_8_0:playGuardBanter("Guard A (armory)", "Guard B (armory)", {"A: I think I ordered the wrong swords.", "A: And every boomerang was all bent.", "A: I don't even know what a\nboomerang IS, but that can't be right.", "B: It just hasn't been your day."})
end

DungeonLobby.onLedgeGuardsTrigger = function(l_9_0)
  l_9_0:playGuardBanter("Guard A (ledge)", "Guard B (ledge)", {"A: I checked on the cells and didn't see that sprite anywhere.", "B: Who cares?", "A: Heh, right."})
end

DungeonLobby.onStairsGuardsTrigger = function(l_10_0)
  l_10_0:playGuardBanter("Guard A (stairs)", "Guard B (stairs)", {"A: ...turns out every single one of them\nis just a covered up plug.  Can't cut a thing.", "B: That must have cost a fortune.\nSome kind of mistake in purchasing?", "A: I hope not.\nThat's a fireball-able offense if anything is."})
end

DungeonLobby.onBoxGuardsTrigger = function(l_11_0)
  l_11_0:playGuardBanter("Guard A (box)", "Guard B (box)", {"A: ...and he just pops out of nowhere screaming something incoherent.", "B: What did you do?", "A: I screamed!  What would you do?", "B: Probably that.", "A: Then he just laughs and disappears again.\nHostile work environment..."})
end

DungeonLobby.playGuardBanter = function(l_12_0, l_12_1, l_12_2, l_12_3)
  local guardA = EntityRef.new(l_12_0.entitiesByName[l_12_1])
  local guardB = EntityRef.new(l_12_0.entitiesByName[l_12_2])
  local targetFound = false
  local activeScene = nil
  if guardA:isValid() and guardB:isValid() then
    guardA.entity.targetFoundEvent:register(function(l_1_0)
    if guardB:isValid() then
      guardB.entity.targetEntity:setEntity(l_1_0)
    end
    upvalue_512 = true
    if activeScene then
      activeScene.skipping = true
    end
   end)
    guardB.entity.targetFoundEvent:register(function(l_2_0)
      if guardA:isValid() then
        guardA.entity.targetEntity:setEntity(l_2_0)
      end
      upvalue_512 = true
      if activeScene then
        activeScene.skipping = true
      end
      end)
    local alice = l_12_0:getAlice()
    alice:get(SceneComponent):play(function(l_3_0)
      activeScene = l_3_0
      local index = 1
      repeat
        if guardA:isValid() and guardB:isValid() and not targetFound and index <= #lines then
          local charsPerSecond = 10
          local line = lines[index]
          local guard, color = nil, nil
          if line:sub(1, 3) == "A: " then
            guard = guardA
            color = {1, 0.80392156862745, 0.46666666666667}
          else
            guard = guardB
            color = {1, 0.50588235294118, 0.46666666666667}
          end
          line = line:sub(4)
          index = index + 1
          l_3_0:floatText(guard.entity, line, #line / charsPerSecond, {color = color})
          l_3_0:sleep(0.5)
        else
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
  end
end

return DungeonLobby

