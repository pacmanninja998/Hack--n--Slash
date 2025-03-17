-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\WorldTree.lua 

local Room = require("Room")
local WorldTree = Room.classFromLayout("Content/Game/DourTower/Layouts/WorldTree", "WorldTree")
local Direction = require("Direction")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local AnimatorComponent = require("Components.AnimatorComponent")
local Music = require("Music")
WorldTree.WEAK_REFS = false
WorldTree.makeRoomData = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local roomData = {}
  if WorldTree.WEAK_REFS then
    setmetatable(roomData, {__mode = "v"})
  end
  roomData.key = l_1_0 or "Root"
  roomData.value = l_1_1
  roomData.roomPath = l_1_2 or "Content/Game/DourTower/Rooms/WorldTree"
  roomData.prevExit = l_1_3
  if not l_1_4 then
    roomData.prevRoomData = {}
  end
  roomData.asdf = "test"
  if WorldTree.WEAK_REFS then
    setmetatable(roomData.prevRoomData, {__mode = "v"})
  end
  return roomData
end

WorldTree.onInit = function(l_2_0)
  local gameplayLayer = l_2_0:getLayerByOrder(0)
  l_2_0.roomData = l_2_0.roomArg
  if l_2_0.roomData.prevRoomData then
    l_2_0:defineCollisionExit("WorldTree entrance", l_2_0.roomData.prevRoomData.roomPath, l_2_0.roomData.prevExit, false, false, l_2_0.roomData.prevRoomData)
  end
  local rootLabelLocator = l_2_0.entitiesByName["Root Label Locator"]
  local rootLabelX, rootLabelY = rootLabelLocator:getPosition()
  local roomKeyString = l_2_0.roomData.key and tostring(l_2_0.roomData.key) or "Root"
  l_2_0.rootLabel = Entity.create("Content/Game/DourTower/Entities/NamePlaque", gameplayLayer, rootLabelX, rootLabelY, "Root Label", Direction.DIR_S, roomKeyString)
  PortBlock = Entity.cache:load("Content/Game/Global/Entities/PortBlock")
  require("Music"):playMusic("Music/Music/WorldTree_Cue1", false)
  if type(l_2_0.roomData.value) == "table" then
    l_2_0.keyNodes = {}
    l_2_0.keyLabels = {}
    local nodeCenterLocator = l_2_0.entitiesByName["Node Center"]
    local nodeCenterX, nodeCenterY = nodeCenterLocator:getPosition()
    local nodeSpacing = 128
    local nodeWidth = 64
    local keyLabelOffset = 64
    local sortedPairs = {}
    for key,value in pairs(l_2_0.roomData.value) do
      table.insert(sortedPairs, {key = key, value = value})
    end
    table.sort(sortedPairs, function(l_1_0, l_1_1)
      return l_1_0.key < l_1_1.key
      end)
    local numKeys = #sortedPairs
    print("Number of keys: " .. tostring(numKeys))
    local totalWidth = numKeys * nodeWidth + (numKeys - 1) * nodeSpacing
    local leftX = nodeCenterX - 0.5 * totalWidth
    local keyNumIndex = 1
    for i,keyValuePair in ipairs(sortedPairs) do
      local key, value = keyValuePair.key, keyValuePair.value
      local keyString = tostring(key)
      print("Adding key of type \"" .. type(key) .. "\", value of type \"" .. type(value) .. "\": " .. keyString)
      local nodeX = leftX + nodeWidth * (keyNumIndex - 0.5) + nodeSpacing * (keyNumIndex - 1)
      local nodeY = nodeCenterY - 32 * (0.5 * numKeys - math.abs(keyNumIndex - 0.5 * (1 + numKeys)))
      table.insert(l_2_0.keyLabels, Entity.create("Content/Game/DourTower/Entities/NamePlaque", gameplayLayer, nodeX, nodeY + keyLabelOffset, "Key Label " .. tostring(keyNumIndex), Direction.DIR_S, keyString, 0.75))
      if type(value) == "table" then
        local keyExitName = "Exit Door " .. tostring(keyNumIndex)
        local exitPoints = {{nodeX - 0.5 * nodeWidth, nodeY}, {nodeX + 0.5 * nodeWidth, nodeY}}
        local keyExit = gameplayLayer:addCollisionArea(CollisionArea.new(gameplayLayer, keyExitName, exitPoints, CollisionArea.COLLISION_TYPE_LINE))
        table.insert(l_2_0.keyNodes, keyExit)
        local nextRoomData = l_2_0.makeRoomData(key, value, l_2_0.roomData.roomPath, keyExitName, l_2_0.roomData)
        l_2_0:defineCollisionExit(keyExitName, l_2_0.roomData.roomPath, "WorldTree entrance", false, false, nextRoomData)
      else
        if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
          local keyPortBlock = Entity.create("Content/Game/Global/Entities/PortBlock", gameplayLayer, nodeX, nodeY, keyString, Direction.DIR_N)
          keyPortBlock[keyString] = value
          keyPortBlock.fieldSetEvent:register(l_2_0.onPortBlockSet, l_2_0)
        else
          print("Don't know how to handle type " .. type(value))
        end
      end
      keyNumIndex = keyNumIndex + 1
    end
    print("")
  end
  local hero = l_2_0:getAlice()
  if hero then
    local spawnX, spawnY, spawnDir = l_2_0:getHeroSpawn()
    local curHeroX, curHeroY = hero:getPosition()
    if curHeroX ~= spawnX or curHeroY ~= spawnY then
      hero:setPosition(spawnX, spawnY)
      hero:get(AnimatorComponent).direction = spawnDir
    end
  end
end

WorldTree.onPortBlockSet = function(l_3_0, l_3_1, l_3_2, l_3_3)
  if l_3_0.roomData.value[l_3_1] ~= nil and type(l_3_0.roomData.value[l_3_1]) == type(l_3_2) then
    l_3_0.roomData.value[l_3_1] = l_3_2
  end
end

return WorldTree

