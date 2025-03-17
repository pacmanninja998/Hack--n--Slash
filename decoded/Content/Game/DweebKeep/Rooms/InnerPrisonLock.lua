-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\InnerPrisonLock.lua 

local InnerPrisonLock = require("Room").classFromLayout("Content/Game/DweebKeep/Layouts/InnerPrisonLock", "InnerPrisonLock", "Content/Game/Global/Rooms/GameRoom")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local LogoComponent = require("Components.LogoComponent")
local Music = require("Music")
local Direction = require("Direction")
InnerPrisonLock.INITIAL_WALL_OFFSET = 0
InnerPrisonLock.CENTER_PLATFORM_RADIUS = 340
InnerPrisonLock.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("ArmoryEastHallway exit", "Content/Game/DweebKeep/Rooms/Armory", "ArmoryEastHallway exit")
  l_1_0:defineCollisionExit("InnerPrisonLobby exit", "Content/Game/DweebKeep/Rooms/InnerPrisonLobby", "InnerPrisonLock exit")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  for i = 1, 19 do
    local name = "Abyss " .. i
    Entity.create("Content/Game/Global/Entities/Abyss", gameplayLayer, nil, nil, name, l_1_0:getCollisionArea(name))
  end
  Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, "Hidden platform", l_1_0:getCollisionArea("Hidden platform"))
  l_1_0:getEntity("MovingPlatform1x1 South").ROUTINE = {{TYPE = "MOVE", TILES = 1, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 1, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "MOVE", TILES = 2, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 1, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 1, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "IDLE", SECONDS = 1}}
  l_1_0:getEntity("MovingPlatform1x1 North").ROUTINE = {{TYPE = "MOVE", TILES = 2, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 2.5, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "MOVE", TILES = 2.5, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2.5, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "MOVE", TILES = 2.5, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 2, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2, SPEED = 1.5}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "IDLE", SECONDS = 1}}
  l_1_0:setUpBlock(l_1_0:getEntity("Port 1"), Direction.DIR_E, l_1_0:getEntity("PinnaBlades1"), "OFFSET1", 48)
  l_1_0:setUpBlock(l_1_0:getEntity("Port 2"), Direction.DIR_W, l_1_0:getEntity("PinnaBlades2"), "OFFSET2", -92)
  l_1_0:setUpBlock(l_1_0:getEntity("Port 3"), Direction.DIR_E, l_1_0:getEntity("PinnaBlades3"), "OFFSET3", 7)
  l_1_0:setUpBlock(l_1_0:getEntity("Port 4"), Direction.DIR_W, l_1_0:getEntity("PinnaBlades4"), "OFFSET4", 29)
  l_1_0:setUpBlock(l_1_0:getEntity("Port 5"), Direction.DIR_W, l_1_0:getEntity("Pillar"), "OFFSET5", 300)
  l_1_0:getEntity("Guard").IDLE_ROUTINE = {{TYPE = "IDLE", SECONDS = 2}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "around"}, {TYPE = "IDLE", SECONDS = 1}, {TYPE = "TURN", DIRECTION = "left"}}
  Music:playAmbient("Ambience/Ambience/InnerPrisonLock_Ambience")
  require("Music"):playMusic("Music/Music/InnerPrisonLock_Cue1", false)
  Music:setReverb("ShipExterior")
  l_1_0.hsvTint = {0.083, -0.111, 0}
end

InnerPrisonLock.setUpBlock = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  l_2_1.direction = l_2_2
  l_2_1.schemas.OFFSET:registerValueSetHandler(l_2_1, function()
    self:getState()[key] = block.OFFSET
    connectedEntity.OFFSET = block.OFFSET
   end)
  l_2_1.OFFSET = l_2_0:getState()[l_2_4] or l_2_5
end

return InnerPrisonLock

