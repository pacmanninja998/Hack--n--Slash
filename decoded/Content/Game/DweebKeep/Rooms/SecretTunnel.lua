-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Rooms\SecretTunnel.lua 

local Room = require("Room")
local Class = require("Class")
local SecretTunnel = Room.classFromLayout("Content/Game/DweebKeep/Layouts/SecretTunnel", "SecretTunnel", "Content/Game/Global/Rooms/GameRoom")
local Music = require("Music")
local Entity = require("Entity")
local Direction = require("Direction")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
local LogoComponent = require("Components.LogoComponent")
local SceneComponent = require("Components.SceneComponent")
SecretTunnel.SPIRAL_PLATFORM_SPAWN_PERIOD = 4
SecretTunnel.SPIRAL_PLATFORM_BEHAVIOR = {{TYPE = "MOVE", TILES = 5, SPEED = 1}, {TYPE = "MOVE", TILES = 5, SPEED = 2}, {TYPE = "MOVE", TILES = 5, SPEED = 3}, {TYPE = "MOVE", TILES = 5, SPEED = 4}, {TYPE = "SPIRAL", TARGET_NAME = "watercenter", TANGENT_VELOCITY = 4, RADIAL_VELOCITY = 2}, {TYPE = "DESTROY"}}
SecretTunnel.onInit = function(l_1_0)
  l_1_0:defineCollisionExit("WardenEntrance exit", "Content/Game/DweebKeep/Rooms/WardenEntrance", "SecretTunnel exit")
  l_1_0:defineCollisionExit("SpookyPath exit", "Content/Game/DorkForest/Rooms/SpookyPath", "SecretTunnel exit", l_1_0.onExitSpooky, l_1_0)
  l_1_0.freeCamera = true
  Music:playAmbient("Ambience/Ambience/CaveStash_Ambience")
  Music:playMusic("Music/Music/MagicGate_Cue1", false)
  Music:setReverb("Reflective")
  local gameplayLayer = l_1_0:getLayerByOrder(0)
  local shadowLayer = l_1_0:getLayerByOrder(-1)
  local groundLayer = l_1_0:getLayerByOrder(-2)
  local floorEntity = Entity.create("Content/Game/Global/Entities/Square", groundLayer, -l_1_0.sizeX * 10, -l_1_0.sizeY * 10, "Floor")
  floorEntity:setSize(l_1_0.sizeX * 20, l_1_0.sizeY * 20)
  floorEntity:setColor(0, 0, 0, 1)
  for i = 1, 8 do
    local name = "Water " .. i
    Entity.create("Content/Game/Global/Entities/Water", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  for i = 1, 24 do
    local name = "Hole " .. i
    Entity.create("Content/Game/Global/Entities/Water", gameplayLayer, nil, nil, name, l_1_0.collisionAreasByName[name])
  end
  Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, "Tunnel Platform", (l_1_0:getCollisionArea("Tunnel Platform")), nil, true)
  Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, "Spiral Dock", l_1_0:getCollisionArea("Spiral Dock"))
  local waterfallArea = l_1_0:getCollisionArea("Waterfall")
  l_1_0.waterfall = Entity.create("Content/Game/Global/Entities/Platform", gameplayLayer, nil, nil, "Waterfall", waterfallArea, nil, true)
  waterfallArea.fixture:setFilter(PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.ALL_CATEGORY)
  local waterfallPlatform = l_1_0.waterfall:get(PlatformComponent)
  waterfallPlatform.velOffsetY = -64
  waterfallPlatform.platformContribution = 0
  waterfallPlatform.solidContribution = -1
  l_1_0:getEntity("MovingPlatform1x1 1").ROUTINE = {{TYPE = "MOVE", TILES = 2, SPEED = 1}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  l_1_0:getEntity("MovingPlatform1x1 2").ROUTINE = {{TYPE = "MOVE", TILES = 4, SPEED = 1}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  l_1_0:getEntity("MovingPlatform1x1 3").ROUTINE = {{TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2}}
  l_1_0:getEntity("MovingPlatform1x1 4").ROUTINE = {{TYPE = "MOVE", TILES = 2}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 4}, {TYPE = "TURN", DIRECTION = "right"}, {TYPE = "MOVE", TILES = 2}}
  l_1_0:getEntity("MovingPlatform1x1 5").ROUTINE = {{TYPE = "MOVE", TILES = 4, SPEED = 1}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  l_1_0:getEntity("MovingPlatform1x1 6").ROUTINE = {{TYPE = "MOVE", TILES = 2, SPEED = 1}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 4, SPEED = 1}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "MOVE", TILES = 2}}
  for i = 7, 12 do
    local platformName = "MovingPlatform1x1 " .. tostring(i)
    l_1_0:getEntity(platformName).ROUTINE = {{TYPE = "MOVE", TILES = 3, SPEED = 2.5}, {TYPE = "IDLE", SECONDS = 0.25}, {TYPE = "TURN", DIRECTION = "left"}, {TYPE = "TURN", DIRECTION = "left"}}
  end
  l_1_0:getCollisionArea("Tunnel Entrance Left"):setSensor(true)
  l_1_0:getCollisionArea("Tunnel Entrance Left"):setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY, l_1_0.onHitTunnelLeft, l_1_0, MOAIBox2DArbiter.END)
  l_1_0:getCollisionArea("Tunnel Entrance Right"):setSensor(true)
  l_1_0:getCollisionArea("Tunnel Entrance Right"):setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY, l_1_0.onHitTunnelRight, l_1_0, MOAIBox2DArbiter.END)
  l_1_0:enableTunnelCollision(false)
  l_1_0.spiralPlatformSpawner = l_1_0:getEntity("Drain Platform Spawner")
  l_1_0.timeSinceSpiralPlatformSpawned = 0
  l_1_0.drainRecovery = l_1_0:getEntity("Drain Recovery")
  l_1_0.spiralPlatformTouchingCount = 0
  if not l_1_0:getState().HitBobTrigger then
    l_1_0:defineLogicTrigger("Bob Trigger", l_1_0.onHitBobTrigger, l_1_0)
  else
    l_1_0:getCollisionArea("Bob Trigger"):destroy()
  end
  l_1_0.hsvTint = {0.083, -0.111, 0}
end

SecretTunnel.onExitSpooky = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  local spookyPathState = l_2_0.world:getRoomState("Content/Game/DorkForest/Rooms/SpookyPath")
  if spookyPathState then
    spookyPathState["Outhouse open"] = true
  end
end

SecretTunnel.onHitBobTrigger = function(l_3_0)
  local alice = l_3_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    local alicePortrait = l_1_0:addAlicePortrait()
    local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
    l_1_0:speakLineRight(bobPortrait, "I'm feeling a bit claustrophobic in here... I think we should turn back.", "Sad")
    l_1_0:speakLineLeft(alicePortrait, "I really don't want to go back to that dungeon. I'm sure we're almost out!", "Default")
    l_1_0:speakLineRight(bobPortrait, "If you say so...", "Sad")
    alice:halt(false)
    self:getState().HitBobTrigger = true
   end)
end

SecretTunnel.tick = function(l_4_0)
  Class.super(SecretTunnel).tick(l_4_0)
  if SecretTunnel.SPIRAL_PLATFORM_SPAWN_PERIOD < l_4_0.timeSinceSpiralPlatformSpawned then
    local spawnX, spawnY = l_4_0.spiralPlatformSpawner:getPosition()
    local gameplayLayer = l_4_0:getLayerByOrder(0)
    local spiralPlatform = Entity.create("Content/Game/DweebKeep/Entities/SpiralPlatform", gameplayLayer, spawnX, spawnY, nil, Direction.DIR_S, false)
    spiralPlatform:get(LogoComponent):setBehavior(SecretTunnel.SPIRAL_PLATFORM_BEHAVIOR)
    spiralPlatform:get(PlatformComponent).collisionDelegate:register(l_4_0.onHitSpiralPlatform, l_4_0)
    l_4_0.timeSinceSpiralPlatformSpawned = 0
  end
  l_4_0.timeSinceSpiralPlatformSpawned = l_4_0.timeSinceSpiralPlatformSpawned + MOAISim.getStep()
end

SecretTunnel.onHitSpiralPlatform = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  if l_5_1 and l_5_1:is(Alice) then
    if l_5_2 == MOAIBox2DArbiter.BEGIN then
      l_5_0.spiralPlatformTouchingCount = l_5_0.spiralPlatformTouchingCount + 1
    else
      if l_5_2 == MOAIBox2DArbiter.END then
        l_5_0.spiralPlatformTouchingCount = l_5_0.spiralPlatformTouchingCount - 1
      end
    end
    if l_5_0.spiralPlatformTouchingCount > 0 then
      local solidX, solidY = l_5_0.drainRecovery:getPosition()
      l_5_1:setSolidPosition(solidX, solidY)
    end
  end
end

SecretTunnel.onHitTunnel = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4, l_6_5)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  if l_6_3 and l_6_3:is(Alice) then
    local physics = l_6_3:get(PhysicsComponent)
    local collisionArea = l_6_0:getCollisionArea(l_6_2)
    local avgX, avgWeight = 0, 0
    for i,point in ipairs(collisionArea.points) do
      avgX = avgX + point[1]
      avgWeight = avgWeight + 1
    end
    if avgWeight > 0 then
      avgX = (avgX) / (avgWeight)
    end
    local entityX, entityY = l_6_3:getPosition()
    local diffX = entityX - avgX
    local enabled = diffX * l_6_1 > 0
    l_6_0:enableTunnelCollision(enabled)
    physics.receivesPlatformVel = not enabled
  end
end

SecretTunnel.enableTunnelCollision = function(l_7_0, l_7_1)
  l_7_0:getCollisionArea("Tunnel Wall 1"):setActive(l_7_1)
  l_7_0:getCollisionArea("Tunnel Wall 2"):setActive(l_7_1)
  l_7_0:getCollisionArea("Tunnel Platform"):setActive(l_7_1)
  l_7_0:getCollisionArea("Tunnel Entrance Wall Left 3"):setActive(not l_7_1)
  l_7_0:getCollisionArea("Tunnel Entrance Wall Right 3"):setActive(not l_7_1)
end

SecretTunnel.onHitTunnelLeft = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  local contactNormX, contactNormY = l_8_5:getContactNormal()
  l_8_0:queueUpdate(function()
    self:onHitTunnel(1, "Tunnel Entrance Left", entity, contactNormX, contactNormY)
   end)
end

SecretTunnel.onHitTunnelRight = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
  local contactNormX, contactNormY = l_9_5:getContactNormal()
  l_9_0:queueUpdate(function()
    self:onHitTunnel(-1, "Tunnel Entrance Right", entity, contactNormX, contactNormY)
   end)
end

return SecretTunnel

