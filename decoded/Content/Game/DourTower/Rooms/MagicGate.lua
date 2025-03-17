-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\MagicGate.lua 

local Class = require("Class")
local Entity = require("Entity")
local MagicGate = require("Room").classFromLayout("Content/Game/DourTower/Layouts/MagicGate", "MagicGate", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local EntityRef = require("EntityRef")
local Music = require("Music")
local RedSprite = Entity.cache:load("Content/Game/Global/Entities/RedSprite")
local Shader = require("Shader")
MagicGate.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("SpookyPath exit", "Content/Game/DorkForest/Rooms/SpookyPath", "MagicGate exit")
  Music:playMusic(nil)
  Music:playAmbient("Ambience/Ambience/SpookyPath_Ambience")
  Music:setReverb("Exterior")
  l_1_0:defineCollisionExit("TowerLevel1 exit", "Content/Game/DourTower/Rooms/TowerLevel1", "MagicGate exit", nil, nil, Direction.DIR_E)
  l_1_0.timeOfDayHighlight = "ShaderResources/TimeOfDay/SpookyPath_HilightGradient"
  l_1_0.timeOfDayMidtone = "ShaderResources/TimeOfDay/SpookyPath_MidtoneGradient"
  l_1_0.timeofDayShadow = "ShaderResources/TimeOfDay/SpookyPath_ShadowGradient"
  l_1_0.timeOfDayRampMagnitude = 1.7
  l_1_0.hsvTint = {0, 0, 0}
  l_1_0:enableTimeOfDay()
  l_1_0.trackers = {}
  l_1_0.gateTraps = {}
  l_1_0:defineLogicTrigger("Tracker trigger", l_1_0.onTrackerTrigger, l_1_0, true, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END)
  l_1_0:defineLogicTrigger("GateTrap trigger", l_1_0.onGateTrapTrigger, l_1_0, true, MOAIBox2DArbiter.BEGIN)
  l_1_0:activateGateTraps(false)
  local gatePort = l_1_0:getEntity("GatePort")
  gatePort.schemas.OPEN_AMOUNT:registerValueSetHandler(gatePort, l_1_0.onGatePortOpenAmountSet, l_1_0)
  local openAmount = l_1_0:getState().gateOpenAmount or 0
  gatePort.OPEN_AMOUNT = openAmount
end

MagicGate.triggerTraps = function(l_2_0)
  for entity,tracker in pairs(l_2_0.trackers) do
    tracker:fire()
  end
end

MagicGate.activateGateTraps = function(l_3_0, l_3_1)
  if l_3_0.gateTrapsActive == l_3_1 then
    return 
  end
  for i = 1, 8 do
    if l_3_1 then
      local tracker = Entity.create("Content/Game/DourTower/Entities/MagicGate/Tracker", l_3_0:getLayerByOrder(-1), 0, 0)
      tracker:trackTarget(l_3_0:getEntity("GateTrap " .. i))
      l_3_0.gateTraps[i] = tracker
    else
      local tracker = l_3_0.gateTraps[i]
      if tracker then
        tracker:trackTarget()
        l_3_0.gateTraps[i] = nil
      end
    end
  end
  l_3_0.gateTrapsActive = l_3_1
  l_3_0:getCollisionArea("GateTrap trigger"):setActive(l_3_1)
end

MagicGate.onTrackerTrigger = function(l_4_0, l_4_1, l_4_2)
  if l_4_1:is(RedSprite) then
    return 
  end
  if l_4_2 == MOAIBox2DArbiter.BEGIN then
    local posX, posY = l_4_1:getPosition()
    local tracker = Entity.create("Content/Game/DourTower/Entities/MagicGate/Tracker", l_4_0:getLayerByOrder(-1), posX, posY)
    tracker:trackTarget(l_4_1)
    l_4_0.trackers[l_4_1] = tracker
  else
    if l_4_2 == MOAIBox2DArbiter.END then
      l_4_0.trackers[l_4_1]:trackTarget(nil)
      l_4_0.trackers[l_4_1] = nil
    end
  end
end

MagicGate.onGateTrapTrigger = function(l_5_0, l_5_1)
  if l_5_1:is(RedSprite) then
    return 
  end
  for i,tracker in pairs(l_5_0.gateTraps) do
    tracker:fire()
  end
  local gatePort = l_5_0:getEntity("GatePort")
  gatePort.OPEN_AMOUNT = 0
end

MagicGate.onGatePortOpenAmountSet = function(l_6_0, l_6_1)
  local magicGate = l_6_0:getCollisionArea("Magic gate")
  magicGate:setActive(l_6_1 ~= 350)
  l_6_0:getState().gateOpenAmount = l_6_1
end

return MagicGate

