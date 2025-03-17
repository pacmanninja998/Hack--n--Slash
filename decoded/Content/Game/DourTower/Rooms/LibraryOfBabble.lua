-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\LibraryOfBabble.lua 

local Class = require("Class")
local Room = require("Room")
local GameRoom = Room.cache:load("Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local Layout = require("Layout")
local Music = require("Music")
local Book = Entity.cache:load("Content/Game/DourTower/Entities/LibraryOfBabble/Book")
local LibraryRug = Entity.cache:load("Content/Game/DourTower/Entities/LibraryRug")
local LibraryOfBabble = Class.create(GameRoom, "LibraryOfBabble")
LibraryOfBabble.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Music:playMusic("Music/Music/Library_Cue1", false)
  Music:setReverb("Medium")
  local CHAMBER_RADIUS = 375
  local CHAMBER_RADIUS_INNER = CHAMBER_RADIUS * math.cos(math.pi / 6)
  if not l_1_3 then
    l_1_3 = "Content/Game/DourTower/Rooms/TowerLevel1"
  end
  local state = l_1_1.universe.state.state
  if not state.checkedOutBooks then
    state.checkedOutBooks = {Data/Content/Game/DourTower/Rooms/PrincessChambers.lua = true, Data/Content/Game/DourTower/Rooms/PrincessChambersCopy.lua = true}
  end
  local stack = {}
  if not l_1_3:find(";") then
    l_1_3 = l_1_3 .. ";/"
  end
  for path in l_1_3:gmatch("[^;]+") do
    table.insert(stack, path)
  end
  local fileSystem = l_1_1.universe.state.fileSystem
  local rootSubpath = stack[#stack]
  local directory = l_1_1.universe:getLibraryRootPath() .. rootSubpath
  table.remove(stack)
  local directories, files = fileSystem:getAssetListing(directory)
  local LIBRARY_PATH = "Content/Game/DourTower/Rooms/LibraryOfBabble"
  local layer = 0
  local chamberX, chamberY = 0, 0
  local x0, y0, x1, y1 = 0, 0, 0, 0
  local chambers = {}
  local directoryCursor, fileCursor = 1, 1
  local windingSide, sourceDirection = nil, nil
  local sideChambers = 0
  repeat
    if directoryCursor <= #directories or fileCursor <= #files then
      local chamberData = {x = chamberX, y = chamberY, prefix = "Chamber" .. #chambers + 1 .. ":"}
      x0 = math.min(x0, chamberX - CHAMBER_RADIUS)
      y0 = math.min(y0, chamberY - CHAMBER_RADIUS_INNER)
      x1 = math.max(x1, chamberX + CHAMBER_RADIUS)
      y1 = math.max(y1, chamberY + CHAMBER_RADIUS_INNER)
      chamberData[chamberData.prefix .. "StairWall"] = true
      if l_1_1.universe.state.state.attackedLibrary then
        chamberData[chamberData.prefix .. "LibraryFire"] = true
      end
      local hasLeftStairs, hasRightStairs = false, false
      if #chambers == 0 then
        local previousPath, predecessorExit, rightEntrance = stack[1], nil, true
        if #stack ~= 1 then
          previousPath = LIBRARY_PATH .. "," .. table.concat(stack, ";")
          predecessorExit, rightEntrance = l_1_0:getPredecessorExit(l_1_1.universe:getLibraryRootPath() .. stack[#stack], directory, fileSystem)
        end
        if rightEntrance then
          chamberData[chamberData.prefix .. "StairsRt_Up"] = {targetLayout = previousPath, targetExit = predecessorExit}
          hasRightStairs = true
        else
          chamberData[chamberData.prefix .. "StairsLft_Up"] = {targetLayout = previousPath, targetExit = predecessorExit}
          hasLeftStairs = true
        end
      elseif not hasRightStairs and directoryCursor <= #directories then
        chamberData[chamberData.prefix .. "StairsRt_Down"] = {targetLayout = LIBRARY_PATH .. "," .. l_1_3 .. ";" .. rootSubpath .. directories[directoryCursor] .. "/", targetExit = "Chamber1:StairsRt_Up:Trigger"}
        chamberData[chamberData.prefix .. "LibraryRugLft"] = directories[directoryCursor]
        directoryCursor = directoryCursor + 1
        hasRightStairs = true
      end
      if directoryCursor <= #directories then
        chamberData[chamberData.prefix .. "StairsLft_Down"] = {targetLayout = LIBRARY_PATH .. "," .. l_1_3 .. ";" .. rootSubpath .. directories[directoryCursor] .. "/", targetExit = "Chamber1:StairsRt_Up:Trigger"}
        chamberData[chamberData.prefix .. "LibraryRugRt"] = directories[directoryCursor]
        directoryCursor = directoryCursor + 1
        hasLeftStairs = true
      end
    end
    if not hasLeftStairs then
      chamberData[chamberData.prefix .. "StairWallLft"] = true
    end
    if not hasRightStairs then
      chamberData[chamberData.prefix .. "StairWallRt"] = true
    end
    if not hasLeftStairs and not hasRightStairs then
      chamberData[chamberData.prefix .. "Garden"] = true
    end
    local availableShelves = {N = true, NE = true, NW = true, S = true, SE = true, SW = true}
    if sourceDirection then
      availableShelves[sourceDirection] = nil
      chamberData[chamberData.prefix .. "WallDoor_" .. sourceDirection] = true
      chamberData[chamberData.prefix .. "DoorOverlay_" .. sourceDirection] = true
    end
    if not windingSide then
      local targetDirection = (sourceDirection and directoryCursor <= #directories or 6 >= #files - fileCursor) or directoryCursor <= #directories or 6 >= #files - fileCursor or "NW"
    end
    availableShelves[targetDirection] = nil
    chamberData[chamberData.prefix .. "WallDoor_" .. targetDirection] = true
    chamberData[chamberData.prefix .. "DoorOverlay_" .. targetDirection] = true
    sideChambers = sideChambers + 1
    if not sourceDirection then
      chamberX, chamberY = chamberX - CHAMBER_RADIUS * 3 / 2, chamberY + CHAMBER_RADIUS_INNER
      windingSide, sourceDirection = "S", "SE"
      layer = layer + 1
    elseif windingSide == "SW" then
      sourceDirection = "NE"
      chamberX, chamberY = chamberX - CHAMBER_RADIUS * 3 / 2, chamberY - CHAMBER_RADIUS_INNER
      if layer - 1 <= sideChambers then
        windingSide, sideChambers = "S", 0
      elseif windingSide == "S" then
        sourceDirection = "N"
        chamberY = chamberY - 2 * CHAMBER_RADIUS_INNER
        if layer <= sideChambers then
          windingSide, sideChambers = "SE", 0
        elseif windingSide == "SE" then
          sourceDirection = "NW"
          chamberX, chamberY = chamberX + CHAMBER_RADIUS * 3 / 2, chamberY - CHAMBER_RADIUS_INNER
          if layer <= sideChambers then
            windingSide, sideChambers = "NE", 0
          elseif windingSide == "NE" then
            sourceDirection = "SW"
            chamberX, chamberY = chamberX + CHAMBER_RADIUS * 3 / 2, chamberY + CHAMBER_RADIUS_INNER
            if layer <= sideChambers then
              windingSide, sideChambers = "N", 0
            elseif windingSide == "N" then
              sourceDirection = "S"
              chamberY = chamberY + 2 * CHAMBER_RADIUS_INNER
              if layer <= sideChambers then
                windingSide, sideChambers = "NW", 0
              elseif windingSide == "NW" then
                sourceDirection = "SE"
                chamberX, chamberY = chamberX - CHAMBER_RADIUS * 3 / 2, chamberY + CHAMBER_RADIUS_INNER
                if layer < sideChambers then
                  windingSide, sideChambers = "SW", 0
                  layer = layer + 1
                end
              end
            end
          end
        end
      end
    end
    for direction in pairs(availableShelves) do
      chamberData[chamberData.prefix .. "WallBooks_" .. direction] = true
      if fileCursor <= #files then
        chamberData[chamberData.prefix .. "Book_" .. direction] = directory .. files[fileCursor]
        fileCursor = fileCursor + 1
      end
    end
    table.insert(chambers, chamberData)
  else
    local sizeX, sizeY = x1 - x0, y1 - y0
    local centerX, centerY = x0 + sizeX * 0.5, y0 + sizeY * 0.5
    Class.super(LibraryOfBabble).init(l_1_0, sizeX, sizeY, l_1_1, l_1_2, l_1_3)
    local chamberLayout = Layout.load("Content/Game/DourTower/Layouts/LibraryOfBabble")
    do
      local chamberSizeX, chamberSizeY = chamberLayout:getPixelSize()
      for index,chamberData in ipairs(chambers) do
        local chunksets, entities, collisionAreas = {}, {}, {}
        local offsetX, offsetY = -x0 + chamberData.x - chamberSizeX * 0.5, -y0 + chamberData.y - chamberSizeY * 0.5
        chamberLayout:applyToRoom(l_1_0, offsetX, offsetY, chunksets, entities, collisionAreas, chamberData.prefix)
        for index,entityRef in ipairs(entities) do
          local entityData = chamberData[entityRef.entity.name]
          if not entityData then
            entityRef.entity:destroy()
            for index,entityRef in (for generator) do
            end
            if entityRef.entity:is(Book) then
              entityRef.entity:setBookPath(entityData)
              for index,entityRef in (for generator) do
              end
              if entityRef.entity:is(LibraryRug) then
                local RUG_TEXT_SCALE = 0.4
                local RUG_TEXT_COLOR = {0.8, 0.66, 0.39, 1}
                entityRef.entity:setLabel(entityData, RUG_TEXT_SCALE, RUG_TEXT_COLOR)
              end
            end
            for index,collisionArea in ipairs(collisionAreas) do
              local collisionName = collisionArea.name
              local subpartIndex = (collisionName:find(":", #chamberData.prefix + 1))
              local collisionType = nil
              if subpartIndex then
                collisionType = collisionName:sub(subpartIndex + 1)
                collisionName = collisionName:sub(1, subpartIndex - 1)
              end
              local entityData = chamberData[collisionName]
              if not entityData then
                collisionArea:destroy()
                for index,collisionArea in (for generator) do
                end
                if collisionType == "Volume" then
                  local direction, slope = Direction.DIR_W, 0.8
                  if collisionName:sub(-#"Rt_Down") == "Rt_Down" or collisionName:sub(-#"Lft_Up") == "Lft_Up" then
                    direction, slope = Direction.DIR_E, 0.8
                  end
                  do
                    local stairs = Entity.create("Content/Game/Global/Entities/Stairs", (l_1_0:getLayerByOrder(0)), nil, nil, nil, collisionArea, direction, slope)
                    stairs:setLabelText("")
                  end
                  for index,collisionArea in (for generator) do
                  end
                  if collisionType == "Trigger" then
                    l_1_0:defineCollisionExit(collisionArea.name, entityData.targetLayout, entityData.targetExit)
                  end
                end
              end
              l_1_0.referenceCamDepth = math.min(2000, sizeY / (2 * math.tan(math.pi / 6)))
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

LibraryOfBabble.getPredecessorExit = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local predecessorDirectories = l_2_3:getAssetListing(l_2_1)
  local predecessorCursor = 1
  local chamber = 2
  repeat
    if predecessorCursor <= #predecessorDirectories then
      local rightDirectory = predecessorDirectories[predecessorCursor]
      if l_2_1 .. rightDirectory .. "/" == l_2_2 then
        return "Chamber" .. chamber .. ":StairsLft_Down:Trigger", false
      end
      predecessorCursor = predecessorCursor + 1
      if predecessorCursor <= #predecessorDirectories then
        local leftDirectory = predecessorDirectories[predecessorCursor]
        if l_2_1 .. leftDirectory .. "/" == l_2_2 then
          return "Chamber" .. chamber .. ":StairsRt_Down:Trigger", true
        end
      end
      predecessorCursor = predecessorCursor + 1
      chamber = chamber + 1
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return LibraryOfBabble

