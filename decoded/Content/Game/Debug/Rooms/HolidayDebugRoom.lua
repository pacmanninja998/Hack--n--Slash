-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Debug\Rooms\HolidayDebugRoom.lua 

local UniverseState = require("UniverseState")
local HostState = require("HostState")
local Room = require("Room")
local HolidayDebugRoom = Room.classFromLayout("Content/Game/Debug/Layouts/HolidayDebugRoom", "HolidayDebugRoom")
HolidayDebugRoom.onInit = function(l_1_0)
  local blockEntity = l_1_0:getEntity("PortBlock")
  local PortBlock = blockEntity:class()
  local DebugRoomPortBlock = require("Class").create(PortBlock, "DebugRoomPortBlock")
  local schema = DebugRoomPortBlock.addIntegerField("CRITICAL_PATH_INDEX", 1)
  local x, y = blockEntity:getPosition()
  blockEntity:destroy()
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  gameplayLayer:removeEntity(blockEntity)
  blockEntity = DebugRoomPortBlock.new(gameplayLayer, x, y, "PortBlock")
  gameplayLayer:addEntity(blockEntity)
  blockEntity.label:setOffset(0, 100)
  schema:registerValueSetHandler(blockEntity, l_1_0.onPortBlockValueSet, l_1_0)
  l_1_0:onPortBlockValueSet(blockEntity.CRITICAL_PATH_INDEX)
  l_1_0:defineLogicTrigger("Teleporter exit", l_1_0.onTeleporterExitTriggered, l_1_0)
end

HolidayDebugRoom.getPathIndex = function(l_2_0, l_2_1)
  return math.max(1, math.min(#HostState.CRITICAL_PATH_LAYOUT_ORDER, l_2_1))
end

HolidayDebugRoom.onPortBlockValueSet = function(l_3_0, l_3_1)
  local index = l_3_0:getPathIndex(l_3_1)
  local act, room = unpack(HostState.CRITICAL_PATH_LAYOUT_ORDER[index])
  l_3_0:getEntity("PortBlock"):setLabelText(act .. ": " .. room)
end

HolidayDebugRoom.onTeleporterExitTriggered = function(l_4_0)
  local index = l_4_0:getPathIndex(l_4_0:getEntity("PortBlock").CRITICAL_PATH_INDEX)
  local act, room = unpack(HostState.CRITICAL_PATH_LAYOUT_ORDER[index])
  local state = HostState.generateInitialState(act, room)
  state.EntranceRoomPath = "Content/Game/" .. act .. "/Rooms/" .. room
  local ourState = UniverseState.deepCopy(g_hack.universeState.state)
  g_hack.universeState:setState(ourState)
  g_hack.universeState:checkPoint("Back to the Holiday Debug Room!")
  g_hack.universeState.state = state
  g_hack.toRestart = true
end

return HolidayDebugRoom

