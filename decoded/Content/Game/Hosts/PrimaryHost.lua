-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Hosts\PrimaryHost.lua 

local Host = require("Host")
local Entity = require("Entity")
local Direction = require("Direction")
local Delegate = require("DFMoai.Delegate")
local Font = require("Font")
local PrimaryHost = require("Class").create(Host, "PrimaryHost")
local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
local ControllerComponent = require("Components.ControllerComponent")
local InterfaceComponent = require("Components.InterfaceComponent")
local HealthComponent = require("Components.HealthComponent")
local CommonActions = require("CommonActions")
local Gui = require("Gui")
local GameMenuGui = Gui.load("Content/Game/Global/Gui/GameMenuGui")
PrimaryHost.SPAWN_ENTRANCE_OFFSET = 32
PrimaryHost.addIntegerField("maxHealth", 3, 1)
PrimaryHost.addIntegerField("TIME_DISTORTION", 0, -15, 15)
PrimaryHost.addBooleanField("glyphsDecoded", false)
PrimaryHost.addBooleanField("completeTheGame", false)
PrimaryHost.addBooleanField("queenSpriteGaveHearts", false)
PrimaryHost.addBooleanField("extraDemoPuzzle", false)
PrimaryHost.addScalarField("INFO_OPACITY", 0, 0, 1, 0.1)
PrimaryHost.addScalarField("DAY_NIGHT_SPEED", 0, 0, 10, 0.01)
PrimaryHost.addIntegerField("HEARTS_PER_DAY", 0, 0, 10)
PrimaryHost.addBooleanField("ENABLE_DEBUG_BUTTONS", false)
PrimaryHost.addBooleanField("BOOMERANGS_HACK_THROWER", false)
PrimaryHost.addStringField("LIBRARY_ROOT_PATH")
PrimaryHost.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Host.init(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0.running = true
  l_1_0.exitingRoom = false
end

PrimaryHost.onFieldSet = function(l_2_0, l_2_1, l_2_2)
  if l_2_2 == nil and l_2_0.schemas[l_2_1] then
    l_2_2 = l_2_0.schemas[l_2_1].defaultValue
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_2_1 == "maxHealth" and l_2_0.state.maxHealth ~= l_2_2 then
    l_2_0.state.maxHealth = l_2_2
    for index,room in ipairs(l_2_0.roomStack) do
      for entity in pairs(room.hostEntities[l_2_0].entities) do
        if entity:is(Alice) then
          local health = entity:get(HealthComponent)
          health:setHealth(l_2_2)
        end
      end
    end
    do return end
    if l_2_1 == "TIME_DISTORTION" then
      local inverted = (16 - l_2_2) / 16
      DFHack.setTimeDilation(inverted)
      MOAIFmodEventMgr.setGlobalPitch(inverted)
    elseif l_2_1 == "DAY_NIGHT_SPEED" then
      l_2_0.universe.state.state.dayNightSpeed = l_2_2
    elseif l_2_1 == "HEARTS_PER_DAY" then
      l_2_0.state.HEARTS_PER_DAY = l_2_2
    elseif l_2_1 == "ENABLE_DEBUG_BUTTONS" then
      l_2_0.state.ENABLE_DEBUG_BUTTONS = l_2_2
    elseif l_2_1 == "BOOMERANGS_HACK_THROWER" then
      l_2_0.universe.state.state.BOOMERANGS_HACK_THROWER = l_2_2
    elseif l_2_1 == "LIBRARY_ROOT_PATH" then
      l_2_0.universe.state.state.LIBRARY_ROOT_PATH = l_2_2
    elseif l_2_1 == "glyphsDecoded" then
      l_2_0.universe.state.state.fixedSymbolicFont = l_2_2
      for index,room in ipairs(l_2_0.roomStack) do
        for name,entity in pairs(room.entitiesByName) do
          local label = entity.label
          if not l_2_2 or not Font.STANDARD_PATH then
            entity.label:setStyles(Font.GLYPH_PATH)
          end
        end
      end
    elseif l_2_1 == "queenSpriteGaveHearts" then
      l_2_0.universe.state.state.queenSpriteGaveHearts = l_2_2
    elseif l_2_1 == "completeTheGame" then
      l_2_0.running = false
    end
  end
  l_2_0.state[l_2_1] = l_2_2
end

PrimaryHost.setState = function(l_3_0, l_3_1)
  Host.setState(l_3_0, l_3_1)
  local world = l_3_0.universe.worlds[l_3_0.state.entryWorld]
  l_3_0:insertRoom(world, l_3_0.state.entryRoomPath)
  l_3_0.glyphsDecoded = l_3_0.universe.state.state.fixedSymbolicFont
  l_3_0.queenSpriteGaveHearts = l_3_0.universe.state.state.queenSpriteGaveHearts
  l_3_0.maxHealth = l_3_0.state.maxHealth
  l_3_0.TIME_DISTORTION = l_3_0.state.TIME_DISTORTION
  l_3_0.INFO_OPACITY = l_3_0.state.INFO_OPACITY
  l_3_0.DAY_NIGHT_SPEED = l_3_0.universe.state.state.dayNightSpeed or 0
  l_3_0.HEARTS_PER_DAY = l_3_0.state.HEARTS_PER_DAY
  l_3_0.ENABLE_DEBUG_BUTTONS = l_3_0.state.ENABLE_DEBUG_BUTTONS
  l_3_0.BOOMERANGS_HACK_THROWER = l_3_0.state.BOOMERANGS_HACK_THROWER
  if not l_3_0.state.LIBRARY_ROOT_PATH then
    l_3_0.LIBRARY_ROOT_PATH = l_3_0.universe:getLibraryRootPath()
  end
  l_3_0.shiftedFont = Font.load(Font.SHIFTED_PATH)
  l_3_0.shiftedFont:setUVOffsets(l_3_0.shiftedFont.uOffset, l_3_0.shiftedFont.vOffset)
  if EnableDebugVisuals then
    l_3_0.INFO_OPACITY = 1
  end
end

PrimaryHost.handleMenu = function(l_4_0, l_4_1, l_4_2)
  if not l_4_0.focalEntity or l_4_0.focusAway then
    return 
  end
  local controller = l_4_0.focalEntity:get(ControllerComponent)
  local interface = l_4_0.focalEntity:get(InterfaceComponent)
  if controller:consumeNewMotive("OpenMenu") then
    local menu = GameMenuGui.new(nil, l_4_0.focalEntity, l_4_2)
    interface:pushInterface(menu)
    if MOAIFmodEventMgr then
      MOAIFmodEventMgr.pauseSoundCategory("Ambience", true)
      MOAIFmodEventMgr.pauseSoundCategory("SFX", true)
      MOAIFmodEventMgr.pauseSoundCategory("Music", true)
    end
    l_4_0.universe:setPaused(true)
    repeat
      if not menu.dismissed then
        l_4_1:tick()
        interface:tick()
        coroutine.yield()
      else
        l_4_0.universe:setPaused(false)
        if MOAIFmodEventMgr then
          MOAIFmodEventMgr.pauseSoundCategory("Ambience", false)
          MOAIFmodEventMgr.pauseSoundCategory("SFX", false)
          MOAIFmodEventMgr.pauseSoundCategory("Music", false)
        end
        interface:removeInterface(menu)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PrimaryHost.gameOver = function(l_5_0)
  l_5_0.running = false
end

PrimaryHost.insertRoom = function(l_6_0, l_6_1, l_6_2, l_6_3, ...)
  local topRoom = l_6_0.roomStack[#l_6_0.roomStack]
  if topRoom then
    for entity in pairs(topRoom.hostEntities[l_6_0].entities) do
      if entity.host == l_6_0 and entity.hostStackIndex == #l_6_0.roomStack then
        entity:insertAction(CommonActions.Suspend.new())
      end
    end
  end
  local room = Host.insertRoom(l_6_0, l_6_1, l_6_2, l_6_3, ...)
  local x, y, direction = l_6_0:getAvatarSpawnInfo(room)
  local alice = Entity.create("Content/Game/Global/Entities/Alice", room:getLayerByOrder(0), x, y, l_6_0.state.name, direction, l_6_0.state, l_6_0)
  if not l_6_3 then
    room:markHostEntity(alice, l_6_0, #l_6_0.roomStack)
  end
  l_6_0:setFocalEntity(alice)
  l_6_0.driver:driveEntity(alice)
  if l_6_0.state.bondedSprite then
    local bob = Entity.create("Content/Game/Global/Entities/RedSprite", room:getLayerByOrder(0), x, y, l_6_0.state.bondedSprite)
    bob:bond(alice)
    if not l_6_3 then
      room:markHostEntity(bob, l_6_0, #l_6_0.roomStack)
    end
  end
  if l_6_0.universe.state.state.fixedSymbolicFont then
    for name,entity in pairs(room.entitiesByName) do
      entity.label:setStyles(Font.STANDARD_PATH)
    end
  end
  room.entityCreatedEvent:register(function(l_1_0)
    if self.universe.state.state.fixedSymbolicFont then
      l_1_0.label:setStyles(Font.STANDARD_PATH)
    end
   end)
  do
    local GameRoom = require("Room").cache:load("Content/Game/Global/Rooms/GameRoom")
    if room:is(GameRoom) then
      room:fade(GameRoom.FADE_IN, room.FADE_IN_DURATION)
    end
    l_6_0.exitingRoom = false
    return room
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PrimaryHost.removeRoom = function(l_7_0, l_7_1)
  Host.removeRoom(l_7_0, l_7_1)
  if not l_7_1 or #l_7_0.roomStack < l_7_1 then
    local topRoom = l_7_0.roomStack[#l_7_0.roomStack]
    if topRoom then
      for entity in pairs(topRoom.hostEntities[l_7_0].entities) do
        if entity.hostStackIndex == #l_7_0.roomStack then
          if entity.action and entity.action:is(CommonActions.Suspend) then
            entity.action.complete = true
          end
          if entity:is(Alice) then
            l_7_0:setFocalEntity(entity)
            l_7_0.driver:driveEntity(entity)
          end
        end
      end
    end
  end
end

PrimaryHost.handleRoomExit = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  if not l_8_0.exitingRoom then
    if not l_8_1:is(Alice) then
      return 
    end
    local room = l_8_1:room()
    if room ~= l_8_0.roomStack[#l_8_0.roomStack] then
      return 
    end
    local GameRoom = require("Room").cache:load("Content/Game/Global/Rooms/GameRoom")
    if room:is(GameRoom) then
      l_8_1:halt(true)
      local health = l_8_1:get(HealthComponent)
      health.invincible = true
      health.invincibleTime = 0.5
      room:fade(GameRoom.FADE_OUT, 0.5, l_8_0, {l_8_1, l_8_2, l_8_3, l_8_4, l_8_5, 0.5})
    else
      l_8_0:doRoomExit(l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
      l_8_0.exitingRoom = true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PrimaryHost.doRoomExit = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
  l_9_0.state.entryRoomPath = l_9_2
  l_9_0.state.entryArea = l_9_3
  l_9_0.state.entryLengthRatio = l_9_4
  l_9_0.state.entryDirection = l_9_5
  Host.handleRoomExit(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
  local name = l_9_2
  do
    local separator = name:find("/")
    repeat
      if separator then
        name = name:sub(separator + 1)
        separator = name:find("/")
      else
        separator = name:find(",")
        if separator then
          name = name:sub(1, separator - 1)
        end
        l_9_0.universe.state:addCheckpoint(name)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PrimaryHost.enterPrototype = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  local source = (l_10_3.disassembly:getSource())
  local path = nil
  if #l_10_3.path == 0 then
    path = "Content/Game/Global/Rooms/ClassRoom," .. source
  else
    path = "Content/Game/Global/Rooms/PrototypeRoom," .. l_10_2 .. ":"
    path = path .. source
    for i,childIndex in ipairs(l_10_3.path) do
      path = path .. ":" .. childIndex
    end
  end
  local room = l_10_0:insertRoom(l_10_1, path)
  if l_10_4 then
    local machine = room.pcMachineMap[l_10_4]
    local machineX, machineY = machine:getPosition()
    l_10_0.focalEntity:setPosition(machineX - 100, machineY)
  end
  local portalX, portalY = room.sizeX * 0.5, room.sizeY * 0.5
  if #l_10_3.path ~= 0 then
    portalX, portalY = l_10_0.focalEntity:getPosition()
    portalX = portalX - 150
  end
  local exitPortal = Entity.create("Content/Game/MachineRooms/Entities/ExitPortal", l_10_0.focalEntity.layer, portalX, portalY)
  exitPortal:setUser(l_10_0.focalEntity)
end

PrimaryHost.enterCodeRoom = function(l_11_0, l_11_1, ...)
  return l_11_0:insertRoom(l_11_1, "Content/Game/Global/Rooms/CodeRoom", nil, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PrimaryHost.cutToWizard = function(l_12_0, l_12_1)
  local wizard = l_12_0.universe.hosts.wizard
  wizard:startScene(l_12_1)
  l_12_0.focusAway = true
  l_12_0.switchFocusEvent:dispatch(wizard)
end

PrimaryHost.cutBack = function(l_13_0, l_13_1)
  local room = l_13_0.focalEntity:room()
  room:startScene(l_13_1)
  l_13_0.focusAway = false
  l_13_0.switchFocusEvent:dispatch(l_13_0)
end

PrimaryHost.getAvatarSpawnInfo = function(l_14_0, l_14_1)
  if l_14_0.state.entryArea then
    local collision = l_14_1.collisionAreasByName[l_14_0.state.entryArea]
    if collision and #collision.points ~= 0 and #collision.points == 2 then
      local sourceX, sourceY = unpack(collision.points[1])
      local targetX, targetY = unpack(collision.points[2])
      sourceX, sourceY = sourceX + collision.offsetX, sourceY + collision.offsetY
      targetX, targetY = targetX + collision.offsetX, targetY + collision.offsetY
      local dX, dY = targetX - (sourceX), targetY - (sourceY)
      local entryLengthRatio = 0.5
      local posX, posY = sourceX + dX * entryLengthRatio, sourceY + dY * entryLengthRatio
      if not l_14_0.state.entryDirection then
        local direction = Direction.DIR_S
      end
      local dirX, dirY = Direction.dirToVector(direction)
      if not l_14_1.SPAWN_ENTRANCE_OFFSET then
        local spawnEntranceOffset = l_14_0.SPAWN_ENTRANCE_OFFSET
      end
      posX, posY = posX + dirX * spawnEntranceOffset, posY + dirY * spawnEntranceOffset
      return posX, posY, direction
    end
  end
  if not l_14_1.entitiesByName["Hero Spawner"] then
    local heroSpawner = l_14_1.entitiesByName["Chamber1:Hero Spawner"]
  end
  if heroSpawner then
    local heroX, heroY = heroSpawner:getPosition()
    return heroX, heroY, Direction.DIR_S
  end
  return l_14_1.sizeX * 0.5, l_14_1.sizeY * 0.5, Direction.DIR_S
end

return PrimaryHost

