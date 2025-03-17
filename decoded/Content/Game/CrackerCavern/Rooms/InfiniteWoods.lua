-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\InfiniteWoods.lua 

local Math = require("DFCommon.Math")
local Graphics = require("DFCommon.Graphics")
local Room = require("Room")
local Layout = require("Layout")
local Class = require("Class")
local Music = require("Music")
local CollisionArea = require("CollisionArea")
local Entity = require("Entity")
local EntityRef = require("EntityRef")
local ChunkSet = require("ChunkSet")
local Font = require("Font")
local Direction = require("Direction")
local PhysicsComponent = require("Components.PhysicsComponent")
local GameRoom = Room.cache:load("Content/Game/Global/Rooms/GameRoom")
local ProgressLine = Class.create(nil, "ProgressLine")
ProgressLine.MAKE_FIXTURE = false
ProgressLine.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.startEntityRef = EntityRef.new(l_1_1)
  l_1_0.startScale = l_1_2
  l_1_0.endEntityRef = EntityRef.new(l_1_3)
  l_1_0.endScale = l_1_4
  l_1_0.direction = l_1_5
  l_1_0.name = l_1_6
  l_1_0.text = l_1_7
  l_1_0.words = {}
  if type(l_1_0.text) == "string" then
    for word in string.gmatch(l_1_0.text, "%S+") do
      table.insert(l_1_0.words, word)
    end
  end
  l_1_0.wordTexts = {}
  l_1_0:updateEndpoints()
end

ProgressLine.updateEndpoints = function(l_2_0, l_2_1)
  if l_2_0.startEntityRef:isValid() then
    l_2_0.startX, l_2_0.startY = l_2_0.startEntityRef.entity:getPosition(), l_2_0.startEntityRef.entity
  end
  if l_2_0.endEntityRef:isValid() then
    l_2_0.endX, l_2_0.endY = l_2_0.endEntityRef.entity:getPosition(), l_2_0.endEntityRef.entity
  end
  if l_2_1 then
    l_2_0.startScale = l_2_0.startScale * l_2_1
    l_2_0.endScale = l_2_0.endScale * l_2_1
  end
  if l_2_0.body then
    l_2_0.body:destroy()
    l_2_0.fixture = nil
  end
  if l_2_0.startEntityRef:isValid() then
    if ProgressLine.MAKE_FIXTURE then
      l_2_0.body = l_2_0.startEntityRef.entity.layer.world:addBody(MOAIBox2DBody.STATIC)
      local fixtures = l_2_0.body:addEdges({l_2_0.startX, l_2_0.startY, l_2_0.endX, l_2_0.endY})
      if fixtures and #fixtures == 1 then
        l_2_0.fixture = fixtures[1]
        l_2_0.fixture:setFilter(PhysicsComponent.SENSOR_CATEGORY, PhysicsComponent.NONE_CATEGORY)
        l_2_0.fixture:setSensor(true)
        l_2_0.fixture:setDebugColor(1, 1, 1, 0)
      end
    end
    local wordDir = Direction.DIR_S
    if math.abs(Direction.diff(l_2_0.direction, Direction.DIR_N)) >= 2 then
      wordDir = l_2_0.direction
    else
      wordDir = Direction.rotate(l_2_0.direction, 4)
    end
    for i,word in ipairs(l_2_0.words) do
      local progress = i / (#l_2_0.words + 1)
      local wordX, wordY = Math.lerp(l_2_0.startX, l_2_0.endX, progress), Math.lerp(l_2_0.startY, l_2_0.endY, progress)
      local wordName = l_2_0.name .. " Word Text " .. tostring(i)
      local scale = l_2_0:calcProgress(wordX, wordY)
      local fontSize = 3 * scale
      local font = Font.TITLE_PATH
      local color = {1, 1, 1, 1}
      do
        if l_2_0.wordTexts[i] then
          local wordText = l_2_0.wordTexts[i]
          wordText:setStyles(fontSize, color, font)
        end
        for i,word in (for generator) do
        end
        local wordText = Entity.create("Content/Game/DourTower/Entities/NamePlaque", l_2_0.startEntityRef.entity.layer, wordX, wordY, wordName, wordDir, word, fontSize, color, nil, font, true)
        l_2_0.wordTexts[i] = wordText
      end
    end
    l_2_0.length = Math.length(l_2_0.endX - l_2_0.startX, l_2_0.endY - l_2_0.startY)
     -- Warning: missing end command somewhere! Added here
  end
end

ProgressLine.calcProgress = function(l_3_0, l_3_1, l_3_2, l_3_3)
  local progress, distance, projX, projY = Math.projectAndDist(l_3_0.startX, l_3_0.startY, l_3_0.endX, l_3_0.endY, l_3_1, l_3_2)
  local lerpedScale = Math.lerp(l_3_0.startScale, l_3_0.endScale, Math.pinPct(progress))
  if progress < 0 then
    distance = Math.length(l_3_1 - l_3_0.startX, l_3_2 - l_3_0.startY)
  elseif progress > 1 then
    distance = Math.length(l_3_1 - l_3_0.endX, l_3_2 - l_3_0.endY)
  end
  if l_3_3 then
    local lerpedMaxDist = l_3_3 * lerpedScale
    local weight = math.max(0, lerpedMaxDist - distance)
    local weightedScale = lerpedScale * weight
    return weightedScale, weight, projX, projY
  else
    return lerpedScale, progress
  end
end

ProgressLine.destroy = function(l_4_0)
  if l_4_0.body then
    l_4_0.body:destroy()
    l_4_0.fixture = nil
  end
  if l_4_0.wordTexts then
    for i,wordText in ipairs(l_4_0.wordTexts) do
      wordText:destroy()
    end
  end
end

local InfiniteWoods = Class.create(GameRoom, "InfiniteWoods")
InfiniteWoods.SCALE_FACTOR = 8
InfiniteWoods.LAYOUT_SIZE = 4096
InfiniteWoods.MAX_CAM_DIST = 3400
InfiniteWoods.MAX_LINE_DIST = math.sqrt(2) * InfiniteWoods.LAYOUT_SIZE / 4
InfiniteWoods.INIT_PERSPECTIVE_SCALE = 0.26
InfiniteWoods.SPAWN_ENTRANCE_OFFSET = 128
InfiniteWoods.INIT_EXIT_DIR = Direction.DIR_W
InfiniteWoods.INIT_LAYOUT_DIR = Direction.DIR_SW
InfiniteWoods.PREFIX_SEPARATOR = ": "
InfiniteWoods.BASE_LAYOUT_PATH = "Content/Game/CrackerCavern/InfiniteWoods/Layouts/"
InfiniteWoods.CORRECT_PATH = "W,SW,W,NW,N,NW,W,SW,S,SE,E,NE"
InfiniteWoods.EXIT_ROOM = "Content/Game/CrackerCavern/Rooms/CaveEntrance"
InfiniteWoods.FINAL_LAYOUT = "CAVE"
InfiniteWoods.PATH_LINE_WIDTH = 8
InfiniteWoods.CORRECT_PATH_COLOR = {1, 1, 1, 1}
InfiniteWoods.INCORRECT_PATH_COLOR = {0.1, 0.1, 0.1, 1}
InfiniteWoods.NE_COLLISION_AREAS = {{collisionType = CollisionArea.COLLISION_TYPE_LINE, name = "Wall 1", points = {{0.1875, 0}, {0.71875, 0.59375}, {1, 0.6328125}}}, {collisionType = CollisionArea.COLLISION_TYPE_LINE, name = "Wall 2", points = {{1, 0.6796875}, {0.71875, 0.71875}, {0.6796875, 1}}}, {collisionType = CollisionArea.COLLISION_TYPE_LINE, name = "Wall 3", points = {{0.6328125, 1}, {0.59375, 0.71875}, {0, 0.1875}}}, {collisionType = CollisionArea.COLLISION_TYPE_LINE, name = "Entrance", points = {{0.25, 0.5}, {0.5, 0.25}}}, {collisionType = CollisionArea.COLLISION_TYPE_LINE, name = "Exit", points = {{0.53125, 0.71875}, {0.71875, 0.53125}}}, {collisionType = CollisionArea.COLLISION_TYPE_LINE, name = "Left Branch", points = {{0.59375, 0.78125}, {0.71875, 0.78125}}}, {collisionType = CollisionArea.COLLISION_TYPE_LINE, name = "Right Branch", points = {{0.78125, 0.59375}, {0.78125, 0.71875}}}}
InfiniteWoods.NE_PLACEMENTS = {{dir = 5, loc = {0.25, 0.25}, name = "Hero Spawner", path = "Content/Game/Global/Entities/Locator"}, {dir = 5, loc = {0.65625, 1}, name = "Left Exit", path = "Content/Game/Global/Entities/Locator"}, {dir = 5, loc = {1, 0.65625}, name = "Right Exit", path = "Content/Game/Global/Entities/Locator"}, {dir = 5, loc = {0, 0}, name = "Entrance", path = "Content/Game/Global/Entities/Locator"}, {dir = 5, loc = {0.65625, 0.65625}, name = "Split", path = "Content/Game/Global/Entities/Locator"}}
InfiniteWoods.appendPathStr = function(l_5_0, l_5_1, l_5_2)
  local exitDirName, layoutDirName = Direction.dirToName(l_5_1), Direction.dirToName(l_5_2)
  if (l_5_0 and l_5_0 ~= "") or not exitDirName .. "," .. layoutDirName then
    return l_5_0 .. "," .. exitDirName .. "," .. layoutDirName
  end
end

InfiniteWoods.getPathDirs = function(l_6_0)
  local exitDirName, layoutDirName = string.match(l_6_0, "([NESW]+),([NESW]+)$")
  if exitDirName and layoutDirName then
    return Direction.nameToDir(exitDirName), Direction.nameToDir(layoutDirName)
  end
end

InfiniteWoods.getParentPathStr = function(l_7_0)
  local parent = string.match(l_7_0, "^(.*),[NESW]+,[NESW]+$")
  return parent or ""
end

InfiniteWoods.isEntityAxisAligned = function(l_8_0, l_8_1)
  local velX, velY = l_8_0:get(PhysicsComponent):getLinearVelocity()
  local normX, normY = Math.normalize(velX, velY)
  local dirX, dirY = Direction.dirToVector(l_8_1)
  local angle = math.deg(math.acos(normX * dirX + normY * dirY))
  return angle < 90
end

InfiniteWoods.getChildLayoutDirs = function(l_9_0)
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  return {{}, {Direction.rotate(l_9_0, 2).rotate(l_9_0, 1), l_9_0}, {}, {Direction.rotate(l_9_0, -2).rotate(l_9_0, -1), l_9_0}}
end

InfiniteWoods.getChildLayoutPaths = function(l_10_0, l_10_1)
  local childDirs = InfiniteWoods.getChildLayoutDirs(l_10_1)
  for i,dirs in ipairs(childDirs) do
    childDirs[i] = InfiniteWoods.appendPathStr(l_10_0, dirs[1], dirs[2])
  end
  return childDirs
end

InfiniteWoods.ROT_MATRICES = {90 = {{0, -1}, {1, 0}}, 180 = {{-1, 0}, {0, -1}}, 270 = {{0, 1}, {-1, 0}}}
InfiniteWoods.transformPoint = function(l_11_0, l_11_1, l_11_2, l_11_3)
  local transformed = {l_11_0[1] - l_11_1, l_11_0[2] - l_11_1}
  local rotMatrix = InfiniteWoods.ROT_MATRICES[l_11_2]
  if rotMatrix then
    transformed = {transformed[1] * rotMatrix[1][1] + transformed[2] * rotMatrix[1][2], transformed[1] * rotMatrix[2][1] + transformed[2] * rotMatrix[2][2]}
  end
  transformed = {l_11_3 * (transformed[1] + l_11_1), l_11_3 * (transformed[2] + l_11_1)}
  return transformed
end

InfiniteWoods.init = function(l_12_0, l_12_1, ...)
  GameRoom.init(l_12_0, InfiniteWoods.LAYOUT_SIZE / 2, InfiniteWoods.LAYOUT_SIZE / 2, l_12_1, ...)
  l_12_0.textureCache = {}
  l_12_0.layoutNames = {InfiniteWoods.FINAL_LAYOUT}
  for i,cardinal in ipairs(Direction.CARDINALS) do
    local layoutDirName = Direction.dirToName(Direction.rotate(cardinal, 1))
    table.insert(l_12_0.layoutNames, layoutDirName)
  end
  for i,layoutName in ipairs(l_12_0.layoutNames) do
    local layout = Layout.load(InfiniteWoods.BASE_LAYOUT_PATH .. layoutName)
    for _,layoutLayer in ipairs(layout.data.layers) do
      if layoutLayer.chunkset then
        local chunkData = ChunkSet.cache:load(layoutLayer.chunkset)
        if chunkData then
          local index = 1
          for chunkY = 0, chunkData.chunksetDimensions[2] - 1 do
            for chunkX = 0, chunkData.chunksetDimensions[1] - 1 do
              local texturePath = chunkData.chunks[index]
              if texturePath then
                local texture = Graphics.loadTexture(texturePath)
                l_12_0.textureCache[texturePath] = texture
              end
              index = index + 1
            end
          end
        end
      end
    end
  end
  Music:playMusic("Music/Music/InfiniteWoods_Cue1")
  Music:playAmbient("Ambience/Ambience/SpookyPath_Ambience")
  Music:setReverb("Exterior")
  l_12_0.curPathStr = ""
  l_12_0.betweenLayouts = true
  l_12_0.pathLayoutMap = {}
  l_12_0.progressLineSet = {}
  local startLocatorName = Direction.dirToName(Direction.rotate(l_12_0.INIT_LAYOUT_DIR, 4)) .. " Entrance"
  l_12_0.firstPathStr = l_12_0:addLayout(nil, startLocatorName, l_12_0.INIT_EXIT_DIR, l_12_0.INIT_LAYOUT_DIR, 1, l_12_0.curPathStr, nil)
  do
    local dirX, dirY = Direction.dirToVector(l_12_0.INIT_LAYOUT_DIR)
    dirX, dirY = dirX / math.abs(dirX), dirY / math.abs(dirY)
    l_12_0.originX, l_12_0.originY = dirX * InfiniteWoods.LAYOUT_SIZE, dirY * InfiniteWoods.LAYOUT_SIZE
    l_12_0.sizeX, l_12_0.sizeY = InfiniteWoods.LAYOUT_SIZE, InfiniteWoods.LAYOUT_SIZE
    l_12_0.referenceCamDepth = l_12_0.MAX_CAM_DIST
    l_12_0.perspectiveScale = InfiniteWoods.INIT_PERSPECTIVE_SCALE
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

InfiniteWoods.onAliceCreated = function(l_13_0, l_13_1)
  Class.super(InfiniteWoods).onAliceCreated(l_13_0, l_13_1)
  local finalExitName = l_13_0.CORRECT_PATH .. l_13_0.PREFIX_SEPARATOR .. "Exit"
  if l_13_1.host and l_13_1.host.state and l_13_1.host.state.entryArea == finalExitName then
    Trace(TT_Info, "Came from CaveEntrance")
  end
end

InfiniteWoods.addLayout = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6, l_14_7)
  if not l_14_5 then
    l_14_5 = 1
  end
  local exitDirName = Direction.dirToName(l_14_3)
  local pathStr = l_14_0.appendPathStr(l_14_6, l_14_3, l_14_4)
  local layoutDirName = Direction.dirToName(l_14_4)
  if pathStr == InfiniteWoods.CORRECT_PATH then
    layoutDirName = InfiniteWoods.FINAL_LAYOUT
  end
  local entranceDir = Direction.rotate(l_14_4, 4)
  local leftBranchDir = Direction.rotate(l_14_4, -1)
  local rightBranchDir = Direction.rotate(l_14_4, 1)
  local entranceDirName = Direction.dirToName(entranceDir)
  local leftBranchDirName = Direction.dirToName(leftBranchDir)
  local rightBranchDirName = Direction.dirToName(rightBranchDir)
  local layout = (Layout.load(InfiniteWoods.BASE_LAYOUT_PATH .. layoutDirName))
  local gameplayLayerData = nil
  for i,layerData in ipairs(layout.data.layers) do
    if layerData.order == 0 then
      gameplayLayerData = layerData
  else
    end
  end
  if not gameplayLayerData then
    return 
  end
  local pointRot = 360 - 90 * (l_14_4 - Direction.DIR_NE) / 2
  for i,collisionAreaTemplate in ipairs(InfiniteWoods.NE_COLLISION_AREAS) do
    local collisionAreaData = {collisionType = collisionAreaTemplate.collisionType, name = collisionAreaTemplate.name, points = {}}
    for j,pointTemplate in ipairs(collisionAreaTemplate.points) do
      local transformedPoint = InfiniteWoods.transformPoint(pointTemplate, 0.5, pointRot, InfiniteWoods.LAYOUT_SIZE)
      table.insert(collisionAreaData.points, transformedPoint)
    end
    table.insert(gameplayLayerData.collisionAreas, collisionAreaData)
  end
  for i,placementTemplate in ipairs(InfiniteWoods.NE_PLACEMENTS) do
    local placementData = {dir = placementTemplate.dir, loc = InfiniteWoods.transformPoint(placementTemplate.loc, 0.5, pointRot, InfiniteWoods.LAYOUT_SIZE), path = placementTemplate.path}
    if placementTemplate.name == "Entrance" then
      placementData.name = entranceDirName .. " Entrance"
    elseif placementTemplate.name == "Right Exit" then
      placementData.name = rightBranchDirName .. " Exit"
    elseif placementTemplate.name == "Left Exit" then
      placementData.name = leftBranchDirName .. " Exit"
    else
      placementData.name = placementTemplate.name
    end
    table.insert(gameplayLayerData.placements, placementData)
  end
  local curEndX, curEndY = 0, 0
  if l_14_1 then
    curEndX, curEndY = l_14_0:getEntity(l_14_1):getPosition()
  end
  local newOffsetX, newOffsetY = nil, nil
  local placement = layout:findPlacement(l_14_2)
  assert(placement)
  newOffsetX, newOffsetY = l_14_5 * placement.loc[1], l_14_5 * placement.loc[2]
  local offsetX, offsetY = curEndX - newOffsetX, curEndY - newOffsetY
  local chunksets, entities, areas = {}, {}, {}
  layout:applyToRoom(l_14_0, offsetX, offsetY, chunksets, entities, areas, pathStr .. l_14_0.PREFIX_SEPARATOR, l_14_5, true)
  local heroSpawnLocator = l_14_0:getEntity(pathStr .. l_14_0.PREFIX_SEPARATOR .. "Hero Spawner")
  if not l_14_0.entitiesByName["Hero Spawner"] then
    local spawnerX, spawnerY = heroSpawnLocator:getPosition()
    Entity.create("Content/Game/Global/Entities/Locator", heroSpawnLocator.layer, spawnerX, spawnerY, "Hero Spawner")
  end
  local entranceLocator = l_14_0:getEntity(pathStr .. l_14_0.PREFIX_SEPARATOR .. entranceDirName .. " Entrance")
  local exitRightLocator = l_14_0:getEntity(pathStr .. l_14_0.PREFIX_SEPARATOR .. rightBranchDirName .. " Exit")
  local exitLeftLocator = l_14_0:getEntity(pathStr .. l_14_0.PREFIX_SEPARATOR .. leftBranchDirName .. " Exit")
  local splitLocator = l_14_0:getEntity(pathStr .. l_14_0.PREFIX_SEPARATOR .. "Split")
  local entranceCollisionName = pathStr .. l_14_0.PREFIX_SEPARATOR .. "Entrance"
  local exitCollisionName = pathStr .. l_14_0.PREFIX_SEPARATOR .. "Exit"
  local leftBranchCollisionName = pathStr .. l_14_0.PREFIX_SEPARATOR .. "Left Branch"
  local rightBranchCollisionName = pathStr .. l_14_0.PREFIX_SEPARATOR .. "Right Branch"
  l_14_0:defineLogicTrigger(entranceCollisionName, function(l_1_0, l_1_1)
    self:onEntranceTrigger(l_1_1, exitDir, layoutDir, pathStr, parentPathStr, parentDir)
   end, nil, true)
  if pathStr == l_14_0.CORRECT_PATH then
    l_14_0:defineCollisionExit(exitCollisionName, l_14_0.EXIT_ROOM, "InfiniteWoodsExit")
  else
    l_14_0:defineLogicTrigger(exitCollisionName, function(l_2_0, l_2_1)
    self:onExitTrigger(l_2_1, exitDir, layoutDir, pathStr, parentPathStr, parentDir)
   end, nil, true)
  end
  local entranceCollision = l_14_0:getCollisionArea(entranceCollisionName)
  local exitCollision = l_14_0:getCollisionArea(exitCollisionName)
  entranceCollision:setDebugPenWidth(InfiniteWoods.PATH_LINE_WIDTH)
  exitCollision:setDebugPenWidth(InfiniteWoods.PATH_LINE_WIDTH)
  if l_14_0.CORRECT_PATH:find(pathStr) == 1 then
    entranceCollision:setDebugColor(unpack(InfiniteWoods.CORRECT_PATH_COLOR))
    exitCollision:setDebugColor(unpack(InfiniteWoods.CORRECT_PATH_COLOR))
  else
    entranceCollision:setDebugColor(unpack(InfiniteWoods.INCORRECT_PATH_COLOR))
    exitCollision:setDebugColor(unpack(InfiniteWoods.INCORRECT_PATH_COLOR))
  end
  local leftBranchCollision = l_14_0:getCollisionArea(leftBranchCollisionName)
  local rightBranchCollision = l_14_0:getCollisionArea(rightBranchCollisionName)
  leftBranchCollision:setSensor(true)
  rightBranchCollision:setSensor(true)
  leftBranchCollision:setDebugPenWidth(InfiniteWoods.PATH_LINE_WIDTH)
  rightBranchCollision:setDebugPenWidth(InfiniteWoods.PATH_LINE_WIDTH)
  local leftBranchPathStr = pathStr .. "," .. leftBranchDirName
  local rightBranchPathStr = pathStr .. "," .. rightBranchDirName
  if l_14_0.CORRECT_PATH:find(leftBranchPathStr) == 1 then
    leftBranchCollision:setDebugColor(unpack(InfiniteWoods.CORRECT_PATH_COLOR))
  else
    leftBranchCollision:setDebugColor(unpack(InfiniteWoods.INCORRECT_PATH_COLOR))
  end
  if l_14_0.CORRECT_PATH:find(rightBranchPathStr) == 1 then
    rightBranchCollision:setDebugColor(unpack(InfiniteWoods.CORRECT_PATH_COLOR))
  else
    rightBranchCollision:setDebugColor(unpack(InfiniteWoods.INCORRECT_PATH_COLOR))
  end
  local centerText, rightText, leftText = nil, nil, nil
  local centerProgressLine = ProgressLine.new(entranceLocator, l_14_5 * 1, splitLocator, l_14_5 * 1 / 3, l_14_4, pathStr .. l_14_0.PREFIX_SEPARATOR .. " centerProgressLine", centerText)
  local rightProgressLine = ProgressLine.new(splitLocator, l_14_5 * 1 / 3, exitRightLocator, l_14_5 * 1 / 8, rightBranchDir, pathStr .. l_14_0.PREFIX_SEPARATOR .. " rightProgressLine", rightText)
  local leftProgressLine = ProgressLine.new(splitLocator, l_14_5 * 1 / 3, exitLeftLocator, l_14_5 * 1 / 8, leftBranchDir, pathStr .. l_14_0.PREFIX_SEPARATOR .. " leftProgressLine", leftText)
  local progressLines = {centerProgressLine, rightProgressLine, leftProgressLine}
  l_14_0.pathLayoutMap[pathStr] = {chunksets, entities, areas, progressLines}
  for i,progressLine in ipairs(progressLines) do
    l_14_0.progressLineSet[progressLine] = progressLine
  end
  if not l_14_7 then
    local gameplayLayer = l_14_0:getLayerByOrder(0)
    local exitPoint1X, exitPoint1Y = entranceLocator:getPosition()
    local exitPoint2X, exitPoint2Y = unpack(l_14_0.collisionAreasByName[pathStr .. l_14_0.PREFIX_SEPARATOR .. "Wall 3"].points[3])
    local exitPoints = {{exitPoint2X + offsetX, exitPoint2Y + offsetY}, {exitPoint1X, exitPoint1Y}}
    local forestExit = CollisionArea.new(gameplayLayer, "CentralForestExit", exitPoints, CollisionArea.COLLISION_TYPE_LINE, 0, 0, nil, l_14_5)
    gameplayLayer:addCollisionArea(forestExit)
    table.insert(areas, forestExit)
    l_14_0:defineCollisionExit("CentralForestExit", "Content/Game/DorkForest/Rooms/CentralForest", "InfiniteWoodsExit")
    local wallPointX, wallPointY = unpack(l_14_0.collisionAreasByName[pathStr .. l_14_0.PREFIX_SEPARATOR .. "Wall 1"].points[1])
    local wallPoints = {{exitPoint1X, exitPoint1Y}, {wallPointX + offsetX, wallPointY + offsetY}}
    local forestExit = CollisionArea.new(gameplayLayer, "Entrance Wall", wallPoints, CollisionArea.COLLISION_TYPE_LINE, 0, 0, nil, l_14_5)
    gameplayLayer:addCollisionArea(forestExit)
    table.insert(areas, forestExit)
  end
  return pathStr
end

InfiniteWoods.removeLayout = function(l_15_0, l_15_1)
  local layoutSet = l_15_0.pathLayoutMap[l_15_1]
  if layoutSet then
    local chunksets, entities, areas, progressLines = unpack(layoutSet)
    local chunksetSet = {}
    for i,chunkset in ipairs(chunksets) do
      chunkset:setRenderLayer()
      chunkset:setPartition()
      chunksetSet[chunkset] = chunkset
    end
    for i,ref in ipairs(entities) do
      if ref.entity then
        ref.entity:destroy()
      end
    end
    for i,area in ipairs(areas) do
      l_15_0.collisionAreasByName[area.name] = nil
      area:destroy()
    end
    for i,progressLine in ipairs(progressLines) do
      l_15_0.progressLineSet[progressLine]:destroy()
      l_15_0.progressLineSet[progressLine] = nil
    end
    for _,layer in ipairs(l_15_0.sortedLayers) do
      for i = #layer.chunksets, 1, -1 do
        local chunkset = layer.chunksets[i]
        if chunksetSet[chunkset] then
          table.remove(layer.chunksets, i)
        end
      end
    end
    l_15_0.pathLayoutMap[l_15_1] = nil
  end
end

InfiniteWoods.onEntranceTrigger = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5, l_16_6)
  if l_16_1 ~= l_16_0:getAlice() then
    return 
  end
  assert(l_16_4 ~= l_16_5)
  local axisAligned = l_16_0.isEntityAxisAligned(l_16_1, l_16_3)
  if axisAligned and l_16_0.curPathStr == l_16_5 then
    if l_16_6 then
      l_16_0:removeLayout(l_16_5)
      local siblingPaths = l_16_0.getChildLayoutPaths(l_16_5, l_16_6)
      for i,siblingPath in ipairs(siblingPaths) do
        if siblingPath ~= l_16_4 then
          l_16_0:removeLayout(siblingPath)
        end
      end
      l_16_0:scale(l_16_0.SCALE_FACTOR, false, false, true)
      if l_16_4 == l_16_0.CORRECT_PATH then
        l_16_0.freeCamera = false
        local cornerLocator = l_16_0:getEntity(l_16_4 .. l_16_0.PREFIX_SEPARATOR .. "CameraCorner")
        local cornerX, cornerY = cornerLocator:getPosition()
        if l_16_3 == Direction.DIR_NE then
          l_16_0.originX, l_16_0.originY = cornerX - l_16_0.sizeX, cornerY - l_16_0.sizeY
        else
          if l_16_3 == Direction.DIR_SE then
            l_16_0.originX, l_16_0.originY = cornerX - l_16_0.sizeX, cornerY
          else
            if l_16_3 == Direction.DIR_SW then
              l_16_0.originX, l_16_0.originY = cornerX, cornerY
            else
              if l_16_3 == Direction.DIR_NW then
                l_16_0.originX, l_16_0.originY = cornerX, cornerY - l_16_0.sizeY
              else
                l_16_0.freeCamera = true
              end
            end
          end
        end
      end
      l_16_0.curPathStr = l_16_4
      l_16_0.betweenLayouts = false
    elseif not axisAligned and l_16_0.curPathStr == l_16_4 then
      if l_16_5 ~= "" then
        l_16_0:scale(1 / l_16_0.SCALE_FACTOR, false, false, true)
        local curEndName = l_16_4 .. l_16_0.PREFIX_SEPARATOR .. Direction.dirToName(Direction.rotate(l_16_3, 4)) .. " Entrance"
        local newEndName = Direction.dirToName(l_16_2) .. " Exit"
        local parentExitDir, parentLayoutDir = l_16_0.getPathDirs(l_16_5)
        assert(parentLayoutDir == l_16_6)
        local grandParentPathStr = (l_16_0.getParentPathStr(l_16_5))
        local grantParentExitDir, grandParentLayoutDir = nil, nil
        if grandParentPathStr ~= "" then
          grantParentExitDir, grandParentLayoutDir = l_16_0.getPathDirs(grandParentPathStr)
        end
        l_16_0:addLayout(curEndName, newEndName, parentExitDir, parentLayoutDir, 1, grandParentPathStr, grandParentLayoutDir)
        local siblingDirs = l_16_0.getChildLayoutDirs(l_16_6)
        for i,dirs in ipairs(siblingDirs) do
          local siblingExitDir, siblingLayoutDir = unpack(dirs)
          local siblingPathStr = l_16_0.appendPathStr(l_16_5, siblingExitDir, siblingLayoutDir)
          if siblingPathStr ~= l_16_4 then
            local curEndName = l_16_5 .. l_16_0.PREFIX_SEPARATOR .. Direction.dirToName(siblingExitDir) .. " Exit"
            local newEndName = Direction.dirToName(Direction.rotate(siblingLayoutDir, 4)) .. " Entrance"
            l_16_0:addLayout(curEndName, newEndName, siblingExitDir, siblingLayoutDir, 0.125, l_16_5, l_16_6)
          end
        end
        l_16_0.freeCamera = true
      else
        l_16_0.freeCamera = false
        local entranceLocator = l_16_0:getEntity(l_16_4 .. l_16_0.PREFIX_SEPARATOR .. Direction.dirToName(Direction.rotate(l_16_3, 4)) .. " Entrance")
        local entranceX, entranceY = entranceLocator:getPosition()
        l_16_0.originX, l_16_0.originY = entranceX - l_16_0.sizeX, entranceY - l_16_0.sizeY
      end
      l_16_0.curPathStr = l_16_5
      l_16_0.betweenLayouts = true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

InfiniteWoods.onExitTrigger = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5, l_17_6)
  if l_17_1 ~= l_17_0:getAlice() then
    return 
  end
  assert(l_17_4 ~= l_17_5 and l_17_0.curPathStr == l_17_4)
  local axisAligned = l_17_0.isEntityAxisAligned(l_17_1, l_17_3)
  if axisAligned and not l_17_0.betweenLayouts then
    local childDirs = l_17_0.getChildLayoutDirs(l_17_3)
    for i,dirs in ipairs(childDirs) do
      local childExitDir, childLayoutDir = unpack(dirs)
      local curEndName = l_17_4 .. l_17_0.PREFIX_SEPARATOR .. Direction.dirToName(childExitDir) .. " Exit"
      local newEndName = Direction.dirToName(Direction.rotate(childLayoutDir, 4)) .. " Entrance"
      l_17_0:addLayout(curEndName, newEndName, childExitDir, childLayoutDir, 0.125, l_17_4, l_17_3)
    end
    l_17_0.betweenLayouts = true
  elseif not axisAligned and l_17_0.betweenLayouts then
    local childDirs = l_17_0.getChildLayoutDirs(l_17_3)
    for i,dirs in ipairs(childDirs) do
      local exitDir, childLayoutDir = unpack(dirs)
      local childPathStr = l_17_0.appendPathStr(l_17_4, exitDir, childLayoutDir)
      l_17_0:removeLayout(childPathStr)
    end
    l_17_0.betweenLayouts = false
  end
end

InfiniteWoods.tick = function(l_18_0)
  l_18_0:updatePerspectiveScale()
  Class.super(InfiniteWoods).tick(l_18_0)
end

InfiniteWoods.updatePerspectiveScale = function(l_19_0, l_19_1)
  local alice = l_19_0:getAlice()
  if alice then
    local playerX, playerY = alice:getPosition()
    if l_19_1 or playerX ~= l_19_0.cachedPlayerX or playerY ~= l_19_0.cachedPlayerY then
      l_19_0.cachedPlayerX, l_19_0.cachedPlayerY = playerX, playerY
      local totalWeight, weightedScaleSum = 0, 0
      for _,progressLine in pairs(l_19_0.progressLineSet) do
        local weightedScale, weight, projX, projY = progressLine:calcProgress(playerX, playerY, l_19_0.MAX_LINE_DIST)
        totalWeight = totalWeight + weight
        weightedScaleSum = weightedScaleSum + weightedScale
      end
      if totalWeight > 0 then
        local weightedScale = (weightedScaleSum) / (totalWeight)
        l_19_0:setPerspectiveScale(weightedScale)
      end
    end
  end
end

InfiniteWoods.setPerspectiveScale = function(l_20_0, l_20_1)
  if factor ~= 1 then
    local prevScale = l_20_0.perspectiveScale
    l_20_0.perspectiveScale = l_20_1
    local scaleFactor = l_20_1 / prevScale
    l_20_0.referenceCamDepth = l_20_0.MAX_CAM_DIST * l_20_1
    l_20_0:getAlice():scale(scaleFactor)
    l_20_0:getBob():scale(scaleFactor)
  end
end

InfiniteWoods.scale = function(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4)
  GameRoom.scale(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4)
  local Effect = Entity.cache:load("Content/Game/Global/Entities/Effect")
  for name,entity in pairs(l_21_0.entitiesByName) do
    if entity:is(Effect) then
      local xScl, yScl = entity.prop:getScl()
      entity.prop:setScl(xScl * l_21_1, yScl * l_21_1)
    end
  end
  for _,progressLine in pairs(l_21_0.progressLineSet) do
    progressLine:updateEndpoints(l_21_1)
  end
  l_21_0:updatePerspectiveScale(true)
end

return InfiniteWoods

