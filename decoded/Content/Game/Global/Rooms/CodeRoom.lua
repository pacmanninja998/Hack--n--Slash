-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Rooms\CodeRoom.lua 

local Class = require("Class")
local CollisionArea = require("CollisionArea")
local Decompiler = require("Decompiler")
local Direction = require("Direction")
local Entity = require("Entity")
local Layout = require("Layout")
local Room = require("Room")
local Font = require("Font")
local Shader = require("Shader")
local EntitySet = require("EntitySet")
local DFUtil = require("DFCommon.Util")
local File = require("DFCommon.File")
local Delegate = require("DFMoai.Delegate")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SceneComponent = require("Components.SceneComponent")
local InventoryComponent = require("Components.InventoryComponent")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local GameRoom = Room.cache:load("Content/Game/Global/Rooms/GameRoom")
local CodeRoom = Room.classFromLayout("Content/Game/Global/Layouts/CodeRoom", "CodeRoom", "Content/Game/Global/Rooms/GameRoom")
CodeRoom.TYPE_CLASS = 1
CodeRoom.TYPE_CLASS_FN = 2
CodeRoom.TYPE_KEYVAL_DIS = 3
CodeRoom.protosEqual = function(l_1_0, l_1_1)
  return l_1_0.linedefined == l_1_1.linedefined
end

CodeRoom.getMatchingDecompiledProto = function(l_2_0, l_2_1, l_2_2)
  if not l_2_2 or not DFUtil.deepCopy(l_2_2) then
    l_2_2 = {}
  end
  if l_2_0.preDecompiledProtos then
    for i,decompiledProto in ipairs(l_2_0.preDecompiledProtos) do
      local disassembly = decompiledProto.disassembly
      if CodeRoom.protosEqual(disassembly, l_2_1) then
        table.insert(l_2_2, i)
        return decompiledProto, l_2_2
        for i,decompiledProto in (for generator) do
        end
        local matchingProto, matchingPath = CodeRoom.getMatchingDecompiledProto(decompiledProto, l_2_1, l_2_2)
        if matchingProto and matchingPath then
          return matchingProto, matchingPath
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CodeRoom.getClassFilePath = function(l_3_0)
  local path = l_3_0.fnData.path
  local ext = ".lua"
  if path and (#path < #ext or not path:find(ext, #path - #ext + 1, true)) then
    path = File.getDataPath(path .. ".lua")
  end
  return path
end

CodeRoom.onInit = function(l_4_0)
  local gameplayLayer = l_4_0:getLayerByOrder(0)
  l_4_0.fnData = l_4_0.roomArg.fnData
  l_4_0.type = l_4_0.roomArg.type
  l_4_0.fnName = type(l_4_0.roomArg.name) == "string" and l_4_0.roomArg.name or "?"
  assert(l_4_0.type)
  l_4_0.parent = l_4_0.roomArg.parent
  local doorPosX, doorPosY = 96, 0
  l_4_0.door = StatementHardware.createHardware("Door", gameplayLayer, doorPosX, doorPosY, "Door")
  l_4_0.door:open(true)
  l_4_0.door.onExit:register(l_4_0.onExit, l_4_0)
  local nameOffsetY = 128
  local namePosX, namePosY = doorPosX, doorPosY + nameOffsetY
  l_4_0.namePlaque = Entity.create("Content/Game/DourTower/Entities/NamePlaque", gameplayLayer, namePosX, namePosY, "Room plaque", Direction.DIR_S, l_4_0.fnName, 1, {0.76470588235294, 0.5843137254902, 0.55686274509804, 1}, 128, Font.TITLE_PATH)
  local nameMinX, nameMinY, nameMaxX, nameMaxY = l_4_0.namePlaque.textBox:getStringBounds(1, #l_4_0.fnName)
  nameMinX, nameMinY = l_4_0.namePlaque.textBox:modelToWorld(nameMinX, nameMinY)
  nameMaxX, nameMaxY = l_4_0.namePlaque.textBox:modelToWorld(nameMaxX, nameMaxY)
  nameMinX, nameMinY, nameMaxX, nameMaxY = nameMinX + namePosX, nameMinY + namePosY, nameMaxX + namePosX, nameMaxY + namePosY
  local nameWidth = nameMaxX - (nameMinX)
  l_4_0.nameShader = Shader.load("Content/Game/Global/Shaders/GlowyPlatform")
  l_4_0.namePlaque:setDefaultShader(l_4_0.nameShader)
  l_4_0.namePlaque.material:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE)
  l_4_0.ioHardwareNames = {LoadConstantHardware = true, LoadBooleanConstantHardware = true, LoadNumberConstantHardware = true, LoadStringConstantHardware = true, GetGlobalHardware = true, ArgumentHardware = true, GetUpvalueHardware = true}
  l_4_0.excludedHardwareNames = {MoveHardware = true, SelfHardware = true}
  l_4_0.outputCrystals = {}
  l_4_0.statementOutputCrystalMap = {}
  l_4_0.curCrystalHue = 0
  l_4_0.crystalHueInterval = 2 / (1 + math.sqrt(5))
  l_4_0.constantHardwares = {}
  l_4_0.hsvTint = {-0.095, -0.11, 0}
  do
    local fn = nil
    if l_4_0.type == l_4_0.TYPE_CLASS_FN then
      fn = l_4_0.fnData.fn
    else
      if l_4_0.type == l_4_0.TYPE_CLASS then
        l_4_0.classPath = l_4_0:getClassFilePath()
        classFactory, error = loadfile(l_4_0.classPath), l_4_0.classPath
        if not error and type(classFactory) == "function" then
          fn = classFactory
        else
          if l_4_0.type == l_4_0.TYPE_KEYVAL_DIS then
            l_4_0.disassembledFn = l_4_0.fnData.fnParent[l_4_0.fnData.fnKey]
            l_4_0.valid = true
          end
        end
      end
      if fn and type(fn) == "function" then
        l_4_0.fn = fn
        local disassembly = DFHack.getDisassembly(l_4_0.fn)
        if disassembly then
          l_4_0.disassembledFn = disassembly.proto
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if l_4_0.type == l_4_0.TYPE_CLASS_FN and l_4_0.disassembledFn.source:sub(1, 1) == "@" then
            l_4_0.classPath = l_4_0.disassembledFn.source:sub(2)
            local classFactory, error = loadfile(l_4_0.classPath)
            if not error and type(classFactory) == "function" then
              local classDisassembly = DFHack.getDisassembly(classFactory)
              if classDisassembly then
                l_4_0.disassembledClassFn = classDisassembly.proto
                l_4_0.decompiledClass = Decompiler.new(l_4_0.disassembledClassFn)
                do
                  local matchingDecompiledProto, decompiledProtoPath = CodeRoom.getMatchingDecompiledProto(l_4_0.decompiledClass, l_4_0.disassembledFn)
                  if matchingDecompiledProto and decompiledProtoPath then
                    l_4_0.decompilation = matchingDecompiledProto
                    l_4_0.valid = true
                  end
                  do return end
                  if l_4_0.type == l_4_0.TYPE_CLASS then
                    l_4_0.disassembledClassFn = l_4_0.disassembledFn
                    l_4_0.valid = true
                  else
                    l_4_0.valid = true
                  end
                end
              end
            end
          end
        end
      end
      if l_4_0.disassembledFn and not l_4_0.decompilation then
        l_4_0.decompilation = Decompiler.new(l_4_0.disassembledFn)
      end
      if l_4_0.disassembledClassFn and not l_4_0.decompiledClass then
        if l_4_0.disassembledClassFn ~= l_4_0.disassembledFn then
          l_4_0.decompiledClass = Decompiler.new(l_4_0.disassembledClassFn)
        else
          l_4_0.decompiledClass = l_4_0.decompilation
        end
      end
      if l_4_0.type == l_4_0.TYPE_CLASS and l_4_0.valid then
        local returnedStatement = nil
        local returnStatement = l_4_0.decompilation.statements[#l_4_0.decompilation.statements]
        if returnStatement:is(Decompiler.Return) and #returnStatement.results == 1 then
          returnedStatement = returnStatement.results[1]
        end
        local keyIndex, closureIndex = 1, 1
        l_4_0.statementEntities = {}
        for i,statement in ipairs(l_4_0.decompilation.statements) do
          if statement:is(Decompiler.SetTable) and statement.targetTable == returnedStatement and statement.key:is(Decompiler.Constant) then
            local keyConstant = statement.key:getConstant()
            if statement.value:is(Decompiler.Closure) then
              local posX, posY = 0, -closureIndex * 256
              local closurePortal = StatementHardware.createHardware("ClosurePortal", gameplayLayer, posX, posY, nil, Direction.DIR_S, statement.value, l_4_0, keyConstant)
              table.insert(l_4_0.statementEntities, closurePortal)
              closureIndex = closureIndex + 1
            end
          end
        end
        l_4_0:labelHardware()
        local minX, minY, maxX, maxY = -96, 0, 0, 0
        for i,keyPlacement in ipairs(l_4_0.statementEntities) do
          local childMinX, childMinY, childMaxX, childMaxY = keyPlacement:getBounds()
          minX, minY, maxX, maxY = math.min(minX, childMinX), math.min(minY, childMinY), math.max(maxX, childMaxX), math.max(maxY, childMaxY)
        end
        local childMinX, childMinY, childMaxX, childMaxY = l_4_0.door:getWorldBounds()
        minX, minY, maxX, maxY = math.min(minX, childMinX), math.min(minY, childMinY), math.max(maxX, childMaxX), math.max(maxY, childMaxY)
        local width = maxX - minX
        if width < nameWidth then
          maxX = maxX + (nameWidth - width)
        end
        local border = 512
        l_4_0.originX, l_4_0.originY = minX - border, minY - border
        l_4_0.sizeX, l_4_0.sizeY = maxX - minX + 2 * border + 64, maxY - minY + 2 * border
        l_4_0:placeWalls(minX - 64, minY - 64, maxX, maxY + 128)
        local roomCenterX = (l_4_0.floorMinX + l_4_0.floorMaxX) / 2
        doorPosY = l_4_0.floorMaxY - 128
        l_4_0.door:setPosition(roomCenterX, doorPosY)
        namePosY = l_4_0.floorMaxY + nameOffsetY
        l_4_0.namePlaque:setPosition(roomCenterX, namePosY)
        do
          local ClosurePortal = StatementHardware.loadHardwareClass("ClosurePortal")
          for i,hardware in ipairs(l_4_0.statementEntities) do
            if hardware:is(ClosurePortal) then
              local closurePosX, closurePosY = hardware:getPosition()
              hardware:setPosition(roomCenterX, closurePosY)
            end
          end
        end
        do return end
        local wireStart = StatementHardware.createHardware("WireStart", gameplayLayer, 256, 64, "WireStart")
        lastHardware = wireStart:append("Wire", Direction.DIR_S, nil, "Wire 1", Direction.DIR_N, Direction.DIR_S)
        l_4_0.statementEntities = {wireStart, lastHardware}
        local hardwareMinX, hardwareMinY, hardwareMaxX, hardwareMaxY = 0, 0, 0, 0
         -- DECOMPILER ERROR: No list found. Setlist fails

         -- DECOMPILER ERROR: Overwrote pending register.

        if l_4_0.valid then
          l_4_0:appendSequence(l_4_0.statementEntities, l_4_0.decompilation.arguments, nil, true)
          l_4_0.ioHardware = {}
          _, hardwareMinX, hardwareMinY, hardwareMaxX, hardwareMaxY = l_4_0:appendSequence(l_4_0.statementEntities, l_4_0.decompilation.statements, nil, true)
        end
        l_4_0:labelHardware()
        local totalMinX, totalMinY, totalMaxX, totalMaxY = nil, nil, nil, nil
        local ioMinX, ioMinY, ioMaxX, ioMaxY = l_4_0.ioHardware[1]:getBounds()
        for i = 2, #l_4_0.ioHardware do
          local minX, minY, maxX, maxY = l_4_0.ioHardware[i]:getBounds()
          ioMinX, ioMinY, ioMaxX, ioMaxY = math.min(ioMinX, minX), math.min(ioMinY, minY), math.max(ioMaxX, maxX), math.max(ioMaxY, maxY)
        end
        local ioSpacing = 64
        if hardwareMinX < ioMaxX + ioSpacing then
          local unitsToMove = ioMaxX + ioSpacing - hardwareMinX
          for i,ioHardware in ipairs(l_4_0.ioHardware) do
            ioHardware:move(0, unitsToMove)
          end
          ioMinY = ioMinY + unitsToMove
          ioMaxY = ioMaxY + unitsToMove
        end
        totalMinX, totalMinY, totalMaxX, totalMaxY = math.min(ioMinX, hardwareMinX), math.min(ioMinY, hardwareMinY), math.max(ioMaxX, hardwareMaxX), math.max(ioMaxY, hardwareMaxY)
        local firstHardwareX, firstHardwareY = l_4_0.statementEntities[1]:getPosition()
        local totalWidth = totalMaxX - totalMinX
        if totalWidth < nameWidth then
          totalMaxX = totalMaxX + (nameWidth - totalWidth)
        end
        local border = 512
        l_4_0.originX, l_4_0.originY = totalMinX - border, totalMinY - border
        l_4_0.sizeX, l_4_0.sizeY = totalMaxX - totalMinX + 2 * border + 64, totalMaxY - totalMinY + 2 * border
        l_4_0:placeWalls(totalMinX - 192, totalMinY - 64, totalMaxX + 128, totalMaxY + 128)
        local roomCenterX = (l_4_0.floorMinX + l_4_0.floorMaxX) / 2
        doorPosX, doorPosY = l_4_0.floorMinX + 128, l_4_0.floorMaxY - 128
        l_4_0.door:setPosition(doorPosX, doorPosY)
        namePosY = l_4_0.floorMaxY + nameOffsetY
        l_4_0.namePlaque:setPosition(roomCenterX, namePosY)
      end
      l_4_0.codeRoomShader = Shader.load("Content/Game/Global/Shaders/CodeRoomChars")
      l_4_0.codeRoomShader:setFragmentUniform("hsvTint", l_4_0.hsvTint)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CodeRoom.fade = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  if MOAIFmodEventMgr then
    if l_5_1 == GameRoom.FADE_IN then
      MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/Split_Screen", false)
    else
      if l_5_1 == GameRoom.FADE_OUT then
        MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/Split_Screen_Exit", false)
      end
    end
  end
end

CodeRoom.onAliceCreated = function(l_6_0, l_6_1)
  Class.super(CodeRoom).onAliceCreated(l_6_0, l_6_1)
  local doorPosX, doorPosY = 0, 0
  if l_6_0.door then
    doorPosX, doorPosY = l_6_0.door:getPosition()
  end
  l_6_1:setPosition(doorPosX, doorPosY)
  l_6_1:setDefaultShader(l_6_0.codeRoomShader)
  local normX, normY = 0, 1
  if l_6_0.roomArg.enterVec then
    normX, normY = unpack(l_6_0.roomArg.enterVec)
  end
  local enterRadius = 96
  l_6_1:teleportOutCodeRoom(doorPosX - enterRadius * normX, doorPosY - enterRadius * normY)
end

CodeRoom.onBobCreated = function(l_7_0, l_7_1)
  Class.super(CodeRoom).onBobCreated(l_7_0, l_7_1)
  l_7_1:setDefaultShader(l_7_0.codeRoomShader)
  l_7_0.bobStatementEntities = EntitySet.new()
  l_7_1.sensor.entityEnterEvent:register(l_7_0.onBobSensorEntityEnter, l_7_0)
  l_7_1.sensor.entityLeaveEvent:register(l_7_0.onBobSensorEntityLeave, l_7_0)
end

CodeRoom.onBobArgumentScene = function(l_8_0, l_8_1, l_8_2)
  local alicePortrait = l_8_1:addAlicePortrait()
  local bobPortrait = l_8_1:addCharacter("Portraits/Bob/Bob")
  l_8_1:speakLineLeft(alicePortrait, "What do you think this is?", "Spooked")
  l_8_1:speakLineRight(bobPortrait, "It's a data crystal.", "Talk")
  l_8_1:speakLineLeft(alicePortrait, "...did you just make that up?", "NonPlussed")
  l_8_1:speakLineRight(bobPortrait, "...Yeah. It's a good name, though, don't you think?", "Talk2")
  l_8_1:speakLineLeft(alicePortrait, "Let me take a closer look...", "Default3")
  l_8_0:wearHat(l_8_1)
  l_8_1:speakLineLeft(alicePortrait, "It looks like it's an 'arg,' whatever that is. I think it's named \"" .. l_8_2.statement:printCode() .. ".\"", "Snobby")
  l_8_1:speakLineRight(bobPortrait, "Maybe 'arg' is short for argument? That name was under \"arguments\" on the signpost.", "Excited")
  l_8_1:speakLineLeft(alicePortrait, "I wonder what an argument is.", "Talk2")
  l_8_1:speakLineRight(bobPortrait, "Judging by the crystal colors, it's probably an input of some kind to the machine.", "Judgemental")
  l_8_1:speakLineLeft(alicePortrait, "And it doesn't have a port to be hacked, so it must come from outside the algorithm.", "Default2")
  l_8_1:speakLineRight(bobPortrait, "So, yeah, data crystal's a good name for it.", "Talk3")
  l_8_1:speakLineLeft(alicePortrait, "Why's that?", "Spooked")
  l_8_1:speakLineRight(bobPortrait, "It sounds cool. That's critical in a name.", "Sly")
end

CodeRoom.onBobConstantScene = function(l_9_0, l_9_1, l_9_2)
  local alice = l_9_0:getAlice()
  alice.state.statementScenes.Constant = true
  alice.state.statementScenes.LoadConstant = true
  local alicePortrait = l_9_1:addAlicePortrait()
  local bobPortrait = l_9_1:addCharacter("Portraits/Bob/Bob")
  l_9_1:speakLineLeft(alicePortrait, "Ooh, this one has a port.", "Spooked")
  l_9_1:speakLineRight(bobPortrait, "Yes! Hack it! ...No, wait!", "Sing")
  l_9_1:speakLineLeft(alicePortrait, "...Why?", "Surprised")
  l_9_1:speakLineRight(bobPortrait, "Put the hat on first and tell me what it says!", "Excited")
  l_9_0:wearHat(l_9_1)
  l_9_1:speakLineLeft(alicePortrait, "It says... " .. l_9_2.constantStatement:printCode() .. ".", "Default4")
  l_9_1:speakLineRight(bobPortrait, "Based on the color, it looks like this thing is hooked up to the machines. I bet we can change that value and change how the machines work.", "Judgemental")
  l_9_1:speakLineLeft(alicePortrait, "Do I have permission to hack it yet?", "Snobby")
  l_9_1:speakLineRight(bobPortrait, "Sure. Go ahead!", "Talk3")
end

CodeRoom.wearHat = function(l_10_0, l_10_1)
  local alice = l_10_0:getAlice()
  local index = alice:get(InventoryComponent):findItemIndex("Content/Game/Global/Items/ThirdEyeHat")
  local hat = alice:get(InventoryComponent).items[index]
  local action = hat:getAction()
  alice:forceAction(action)
  l_10_1.skipping = false
  l_10_1:sleepWhile(function()
    return alice.action == action
   end)
  l_10_1:sleep(1)
  alice.action.forceTakeOff = true
  l_10_1:sleepWhile(function()
    return alice.action
   end)
  l_10_1:sleep(0.5)
end

CodeRoom.onBobGetTableScene = function(l_11_0, l_11_1, l_11_2)
  local alicePortrait = l_11_1:addAlicePortrait()
  local bobPortrait = l_11_1:addCharacter("Portraits/Bob/Bob")
  l_11_1:speakLineRight(bobPortrait, "Hmm...", "NoWay")
  l_11_1:speakLineLeft(alicePortrait, "Got any ideas what this machine is?", "Talk2")
  l_11_1:speakLineRight(bobPortrait, "...maybe. What do you see with your third eye?", "Talk2")
  l_11_0:wearHat(l_11_1)
  l_11_1:speakLineLeft(alicePortrait, "It says " .. l_11_2.statement:printLabel(l_11_0.statementOutputCrystalMap) .. ".", "Snobby")
  l_11_1:speakLineRight(bobPortrait, "Cryptic. Maybe it's pulling " .. l_11_2.statement.key:printCode() .. " out of " .. l_11_2.statement.sourceTable:printCode() .. "?", "Talk3")
  l_11_1:speakLineLeft(alicePortrait, "And stuffing the result into that crystal? It looks like that crystal gets used by other machines.", "Default3")
end

CodeRoom.onBobAddScene = function(l_12_0, l_12_1, l_12_2)
  local alicePortrait = l_12_1:addAlicePortrait()
  local bobPortrait = l_12_1:addCharacter("Portraits/Bob/Bob")
  l_12_1:speakLineRight(bobPortrait, "I've got this one! It takes those two crystals and adds them together!", "Excited")
  l_12_1:speakLineLeft(alicePortrait, "Do you want me to check it with my hat?", "Spooked")
  l_12_1:speakLineRight(bobPortrait, "$ALICE, I'm pretty sure I know what an adding machine for a magical algorithm room that secretly underpins our reality looks like.", "Judgemental")
end

CodeRoom.onBobConditionalScene = function(l_13_0, l_13_1, l_13_2)
  local alicePortrait = l_13_1:addAlicePortrait()
  local bobPortrait = l_13_1:addCharacter("Portraits/Bob/Bob")
  l_13_1:speakLineRight(bobPortrait, "Check it out! This one splits into two paths!", "Excited")
  l_13_1:speakLineLeft(alicePortrait, "How do you think it chooses a path?", "Spooked")
  l_13_1:speakLineRight(bobPortrait, "Well, it reads from those two crystals...", "Talk")
  l_13_1:speakLineLeft(alicePortrait, "Maybe it compares them to figure out which way to direct the flow.", "Default4")
  l_13_1:speakLineRight(bobPortrait, "Sure, That sounds good.", "Talk2")
end

CodeRoom.onBobMultiplyScene = function(l_14_0, l_14_1, l_14_2)
  local alicePortrait = l_14_1:addAlicePortrait()
  local bobPortrait = l_14_1:addCharacter("Portraits/Bob/Bob")
  l_14_1:speakLineRight(bobPortrait, "This one's easy. Multiplies the crystals.", "Judgemental")
  l_14_1:speakLineLeft(alicePortrait, "You seem pretty confident.", "Default")
  l_14_1:speakLineRight(bobPortrait, "I'm gifted with machines. They speak to me.", "Talk")
  l_14_1:speakLineLeft(alicePortrait, "Since when?", "Talk2")
  l_14_1:speakLineRight(bobPortrait, "<c:8>What's that, machine? ...Yeah, you're right.</>", "Sly")
  l_14_1:speakLineLeft(alicePortrait, "...", "NonPlussed")
  l_14_1:speakLineRight(bobPortrait, "You wouldn't understand, $ALICE. It's a machine thing.", "Talk")
end

CodeRoom.onBobReturnScene = function(l_15_0, l_15_1, l_15_2)
  local alicePortrait = l_15_1:addAlicePortrait()
  local bobPortrait = l_15_1:addCharacter("Portraits/Bob/Bob")
  l_15_1:speakLineLeft(alicePortrait, "It looks like this is the end of the algorithm", "Spooked")
  l_15_1:speakLineRight(bobPortrait, "This machine looks special. What do you think it does?", "Excited")
  l_15_0:wearHat(l_15_1)
  l_15_1:speakLineLeft(alicePortrait, "\"Return\"... I'm guessing it returns the result of the algorithm?", "Talk2")
  l_15_1:speakLineRight(bobPortrait, "We can't mess with this machine, but we can mess with the stuff that feeds into it.", "Judgemental")
  l_15_1:speakLineLeft(alicePortrait, "Now we just have to figure out what we want it to return.", "Talk")
end

CodeRoom.onBobConcatenateScene = function(l_16_0, l_16_1, l_16_2)
  local alicePortrait = l_16_1:addAlicePortrait()
  local bobPortrait = l_16_1:addCharacter("Portraits/Bob/Bob")
  l_16_1:speakLineRight(bobPortrait, "This machine looks crazy", "Sing")
  l_16_1:speakLineLeft(alicePortrait, "Both of the crystals correspond to those crysals over there.", "Default2")
  l_16_0:wearHat(l_16_1)
  l_16_1:speakLineLeft(alicePortrait, "It looks like they both contain text.", "Talk")
  l_16_1:speakLineRight(bobPortrait, "Maybe this thing combines them together?", "Talk3")
end

CodeRoom.onBobForPrepScene = function(l_17_0, l_17_1, l_17_2)
  local alicePortrait = l_17_1:addAlicePortrait()
  local bobPortrait = l_17_1:addCharacter("Portraits/Bob/Bob")
  l_17_1:speakLineRight(bobPortrait, "There are paths coming in and out of this one!", "Excited")
  l_17_1:speakLineLeft(alicePortrait, "And it has an output crystal.", "Default4")
  l_17_0:wearHat(l_17_1)
  l_17_1:speakLineLeft(alicePortrait, "It looks like it just copies the value of its input crystal.", "Default2")
  l_17_1:speakLineRight(bobPortrait, "What's with the wire that loops back, though?", "Talk3")
  l_17_1:speakLineLeft(alicePortrait, "I'm not sure. It looks like the arrows just get passed through. I bet it doesn't even copy the input crystal again.", "Spooked")
end

CodeRoom.onBobModulusScene = function(l_18_0, l_18_1, l_18_2)
  local alicePortrait = l_18_1:addAlicePortrait()
  local bobPortrait = l_18_1:addCharacter("Portraits/Bob/Bob")
  l_18_1:speakLineRight(bobPortrait, "What do you think 'mod' is short for?", "Excited")
  l_18_0:wearHat(l_18_1)
  l_18_1:speakLineLeft(alicePortrait, "Modulus... do you know what that means?", "Default2")
  l_18_1:speakLineRight(bobPortrait, "Oh, modulus! It's a mathematical concept analogous to division, but instead of producing the quotient, it produces the remainder.", "Judgemental")
  l_18_1:speakLineLeft(alicePortrait, "How do you know so much math?", "Spooked")
  l_18_1:speakLineRight(bobPortrait, "Sprites are way into math. Here's a fun fact about the modulo operator: you can easily test whether a number is even or odd by computing the number modulo 2.", "Excited")
  l_18_1:speakLineLeft(alicePortrait, "Ah! Because an even number would be divisible by 2 and have a remainder of 0, but an odd number would have a remainder of 1!", "Snobby")
  l_18_1:speakLineRight(bobPortrait, "Yep. If something modulo a certain number is 0, then it's evenly divisible by that number.", "Talk")
  l_18_1:speakLineLeft(alicePortrait, "This seems like a complicated machine.", "HappyLaugh")
end

CodeRoom.onBobCallScene = function(l_19_0, l_19_1, l_19_2)
  local alicePortrait = l_19_1:addAlicePortrait()
  local bobPortrait = l_19_1:addCharacter("Portraits/Bob/Bob")
  l_19_1:speakLineRight(bobPortrait, "This looks like one of those machines that interacts with things outside this algorithm.", "Excited")
  l_19_0:wearHat(l_19_1)
  l_19_1:speakLineLeft(alicePortrait, "Hmm... it looks like it's fed the name of something and passes some data crystals to it.", "Default2")
  l_19_1:speakLineRight(bobPortrait, "Oh! Oh! I bet it's calling another algorithm! The crystals it's sending must be that algorithm's arguments!", "Sing")
  l_19_1:speakLineLeft(alicePortrait, "That sounds... totally reasonable, $BOB. I think you might be right.", "HappyLaugh")
end

{Argument = CodeRoom.onBobArgumentScene, LoadConstant = CodeRoom.onBobConstantScene, Constant = CodeRoom.onBobConstantScene, Conditional = CodeRoom.onBobConditionalScene, GetTable = CodeRoom.onBobGetTableScene, Add = CodeRoom.onBobAddScene, Multiply = CodeRoom.onBobMultiplyScene, Return = CodeRoom.onBobReturnScene}.Concatenate = CodeRoom.onBobConcatenateScene
 -- DECOMPILER ERROR: Confused about usage of registers!

{Argument = CodeRoom.onBobArgumentScene, LoadConstant = CodeRoom.onBobConstantScene, Constant = CodeRoom.onBobConstantScene, Conditional = CodeRoom.onBobConditionalScene, GetTable = CodeRoom.onBobGetTableScene, Add = CodeRoom.onBobAddScene, Multiply = CodeRoom.onBobMultiplyScene, Return = CodeRoom.onBobReturnScene}.ForPrep = CodeRoom.onBobForPrepScene
 -- DECOMPILER ERROR: Confused about usage of registers!

{Argument = CodeRoom.onBobArgumentScene, LoadConstant = CodeRoom.onBobConstantScene, Constant = CodeRoom.onBobConstantScene, Conditional = CodeRoom.onBobConditionalScene, GetTable = CodeRoom.onBobGetTableScene, Add = CodeRoom.onBobAddScene, Multiply = CodeRoom.onBobMultiplyScene, Return = CodeRoom.onBobReturnScene}.Modulus = CodeRoom.onBobModulusScene
 -- DECOMPILER ERROR: Confused about usage of registers!

{Argument = CodeRoom.onBobArgumentScene, LoadConstant = CodeRoom.onBobConstantScene, Constant = CodeRoom.onBobConstantScene, Conditional = CodeRoom.onBobConditionalScene, GetTable = CodeRoom.onBobGetTableScene, Add = CodeRoom.onBobAddScene, Multiply = CodeRoom.onBobMultiplyScene, Return = CodeRoom.onBobReturnScene}.Call = CodeRoom.onBobCallScene
 -- DECOMPILER ERROR: Confused about usage of registers!

CodeRoom.bobSceneHandlers = {Argument = CodeRoom.onBobArgumentScene, LoadConstant = CodeRoom.onBobConstantScene, Constant = CodeRoom.onBobConstantScene, Conditional = CodeRoom.onBobConditionalScene, GetTable = CodeRoom.onBobGetTableScene, Add = CodeRoom.onBobAddScene, Multiply = CodeRoom.onBobMultiplyScene, Return = CodeRoom.onBobReturnScene}
CodeRoom.onBobSensorEntityEnter = function(l_20_0, l_20_1)
  local bob = l_20_0:getBob()
  local alice = l_20_0:getAlice()
  if not alice.state.beganCodePuzzles then
    return 
  end
  if not l_20_1:is(StatementHardware) then
    return 
  end
  if l_20_1:is(StatementHardware.loadHardwareClass("IOCrystal")) then
    return 
  end
  local statementName = l_20_0:findStatementName(l_20_1)
  if not statementName then
    return 
  end
  l_20_0.bobStatementEntities:addEntity(l_20_1)
  if not bob.excitingEntity:isValid() then
    l_20_0:pickBobScene()
  end
end

CodeRoom.findStatementName = function(l_21_0, l_21_1)
  for name,field in pairs(Decompiler) do
    if l_21_0.bobSceneHandlers[name] and l_21_1.statement:is(field) then
      return name
    end
  end
end

CodeRoom.pickBobScene = function(l_22_0)
  local alice = l_22_0:getAlice()
  local bob = l_22_0:getBob()
  if not alice.state.statementScenes then
    alice.state.statementScenes = {}
  end
  for entity in pairs(l_22_0.bobStatementEntities.entities) do
    local statementName = l_22_0:findStatementName(entity)
    if not alice.state.statementScenes[statementName] then
      bob:beExcited(entity)
      bob:get(InteractionComponent):setEnabled(true)
      bob:get(InteractionComponent).interactEvent:register(l_22_0.onBobInteract, l_22_0)
      return 
    end
  end
end

CodeRoom.onBobSensorEntityLeave = function(l_23_0, l_23_1)
end

CodeRoom.onBobInteract = function(l_24_0, l_24_1)
  local bob = l_24_0:getBob()
  local alice = l_24_0:getAlice()
  local hardwareEntity = bob.excitingEntity.entity
  local statementName = l_24_0:findStatementName(hardwareEntity)
  alice:get(SceneComponent):play(function(l_1_0)
    bob:beExcited()
    bob:get(InteractionComponent).interactEvent:unregister(self.onBobInteract, self)
    bob:get(InteractionComponent):stopInteract(interactor)
    bob:get(InteractionComponent):setEnabled(false)
    alice:halt(true)
    self.bobSceneHandlers[statementName](self, l_1_0, hardwareEntity)
    alice:halt(false)
    alice.state.statementScenes[statementName] = true
    if self.bobStatementEntities.count ~= 0 then
      self:pickBobScene()
    end
   end)
end

CodeRoom.labelHardware = function(l_25_0)
  if l_25_0.statementEntities then
    for i,hardware in ipairs(l_25_0.statementEntities) do
      hardware:labelHardware(l_25_0.statementOutputCrystalMap)
    end
  end
  if l_25_0.ioHardware then
    for i,hardware in ipairs(l_25_0.ioHardware) do
      hardware:labelHardware(l_25_0.statementOutputCrystalMap)
    end
  end
end

CodeRoom.placeWalls = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4)
  local SW = Layout.load("Content/Game/CodeRoom/Room/Layouts/SW")
  local S = Layout.load("Content/Game/CodeRoom/Room/Layouts/S")
  local SE = Layout.load("Content/Game/CodeRoom/Room/Layouts/SE")
  local E = Layout.load("Content/Game/CodeRoom/Room/Layouts/E")
  local NE = Layout.load("Content/Game/CodeRoom/Room/Layouts/NE")
  local N = Layout.load("Content/Game/CodeRoom/Room/Layouts/N")
  local NW = Layout.load("Content/Game/CodeRoom/Room/Layouts/NW")
  local W = Layout.load("Content/Game/CodeRoom/Room/Layouts/W")
  local Floor = Layout.load("Content/Game/CodeRoom/Room/Layouts/Floor")
  local SWw, SWh = SW:getPixelSize()
  local Sw, Sh = S:getPixelSize()
  local SEw, SEh = SE:getPixelSize()
  local Ew, Eh = E:getPixelSize()
  local NEw, NEh = NE:getPixelSize()
  local Nw, Nh = N:getPixelSize()
  local NWw, NWh = NW:getPixelSize()
  local Ww, Wh = W:getPixelSize()
  local Fw, Fh = Floor:getPixelSize()
  if not l_26_1 and not l_26_2 then
    l_26_1, l_26_2, l_26_3, l_26_4 = l_26_0.sizeX, l_26_0.sizeY, l_26_0.sizeX, l_26_0.sizeY
  end
  assert(SWh == Sh and Sh == SEh and SEw == Ew and Ew == NEw and NEh == Nh and Nh == NWh and NWw == Ww and Ww == SWw and Sw == Nw and Eh == Wh)
  local tileWidth, tileHeight = Sw, Eh
  assert(Fw == tileWidth and Fh == tileHeight)
  local rawHeight = l_26_4 - l_26_2
  local rawHeightRemainder = math.ceil(rawHeight / tileHeight) * tileHeight - rawHeight
  l_26_2 = l_26_2 - rawHeightRemainder
  l_26_0.widthInTiles, l_26_0.heightInTiles = math.ceil((l_26_3 - l_26_1 - SWw - SEw) / tileWidth), math.ceil((l_26_4 - (l_26_2) - SEh - NEh) / tileHeight)
  for wallIndex = 0, 4 do
    l_26_0.penX, l_26_0.penY = l_26_1 - wallIndex * SWw, l_26_2 + wallIndex * SWh
    SW:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
    l_26_0.penX = l_26_0.penX + SWw
    for x = 1, l_26_0.widthInTiles + wallIndex do
      if wallIndex == 0 then
        S:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
      end
      l_26_0.penX = l_26_0.penX + Sw
    end
    SE:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
    l_26_0.penY = l_26_0.penY + SEh
    for y = 1, l_26_0.heightInTiles do
      E:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
      l_26_0.penY = l_26_0.penY + Eh
    end
    NE:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
    l_26_0.penX = l_26_0.penX - Nw
    for x = 1, l_26_0.widthInTiles + wallIndex do
      N:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
      l_26_0.penX = l_26_0.penX - Nw
    end
    l_26_0.penX = l_26_0.penX + Nw - NWw
    NW:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
    l_26_0.penY = l_26_0.penY - NWh
    for y = 1, l_26_0.heightInTiles do
      W:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
      l_26_0.penY = l_26_0.penY - Wh
    end
  end
  l_26_0.penX, l_26_0.penY = l_26_1 + SWw, l_26_2 + SWh
  l_26_0.floorMinX, l_26_0.floorMinY = l_26_0.penX, l_26_0.penY
  for y = 1, l_26_0.heightInTiles do
    for x = 1, l_26_0.widthInTiles do
      Floor:applyToRoom(l_26_0, l_26_0.penX, l_26_0.penY)
      l_26_0.penX = l_26_0.penX + Fw
    end
    l_26_0.penX, l_26_0.penY = l_26_1 + SWw, l_26_0.penY + Fh
  end
  l_26_0.floorMaxX, l_26_0.floorMaxY = l_26_0.floorMinX + l_26_0.widthInTiles * Fw, l_26_0.penY
  local gameplayLayer = l_26_0:getLayerByOrder(0)
  local collisionPoints = {{l_26_1 + SWw, l_26_2}, {l_26_1 + SWw + l_26_0.widthInTiles * tileWidth, l_26_2}, {l_26_1 + SWw + l_26_0.widthInTiles * tileWidth, l_26_2 + SWh + l_26_0.heightInTiles * tileHeight}, {l_26_1 + SWw, l_26_2 + SWh + l_26_0.heightInTiles * tileHeight}, {l_26_1 + SWw, l_26_2}}
  gameplayLayer:addCollisionArea(CollisionArea.new(gameplayLayer, "Outer wall", collisionPoints, 0))
  return SWw + l_26_0.widthInTiles * tileWidth + SEw, SEh + l_26_0.heightInTiles * tileHeight + NEh
end

CodeRoom.onExit = function(l_27_0)
  l_27_0:onStatementChanged(nil, true)
end

CodeRoom.onStatementChanged = function(l_28_0, l_28_1, l_28_2)
  l_28_0:labelHardware()
  l_28_0.valid = false
  local newStr, newFactoryStr = nil, nil
  if l_28_0.type == l_28_0.TYPE_CLASS or l_28_0.type == l_28_0.TYPE_CLASS_FN then
    newFactoryStr = l_28_0.decompiledClass:printFunction(true)
  else
    newStr = l_28_0.decompilation:printFunction()
    newFactoryStr = "return " .. newStr
  end
  Trace(TT_Info, "\n\nNew function:\n\n%s\n\n", newFactoryStr)
  local newFactory, error = loadstring(newFactoryStr)
  if not error and type(newFactory) == "function" then
    if l_28_0.type == l_28_0.TYPE_CLASS or l_28_0.type == l_28_0.TYPE_CLASS_FN then
      l_28_0.valid = true
      if l_28_2 then
        l_28_0.world.universe.state.fileSystem:storeFile(l_28_0.classPath, newFactoryStr)
      else
        if l_28_0.type == l_28_0.TYPE_KEYVAL_DIS then
          local newFn = newFactory()
          if newFn and type(newFn) == "function" then
            l_28_0.valid = true
            l_28_0.fn = newFn
            if l_28_2 then
              local newDisassembly = DFHack.getDisassembly(newFn)
              local newDecompilation = Decompiler.new(newDisassembly.proto)
              l_28_0.fnData.fnParent[l_28_0.fnData.fnKey] = newDisassembly.proto
              l_28_0.fnData.fnParentDecompiler.preDecompiledProtos[l_28_0.fnData.fnKey] = newDecompilation
            end
          end
        end
      end
    end
    if l_28_0.parent and l_28_0.parent:is(CodeRoom) then
      l_28_0.parent:onStatementChanged(l_28_1)
    end
  end
  if l_28_0.valid then
    l_28_0.factoryStr = newFactoryStr
    l_28_0.door:open()
    if l_28_2 and l_28_0.fnData.onFnChanged then
      l_28_0.fnData.onFnChanged(l_28_0.fnData.firstArg, l_28_0.fn)
    else
      l_28_0.door:close()
      print("ERROR:\n" .. error)
    end
  end
end

CodeRoom.appendSequence = function(l_29_0, l_29_1, l_29_2, l_29_3, l_29_4)
  local lastHardware = l_29_1[#l_29_1]
  if l_29_2 then
    for i,statement in ipairs(l_29_2) do
      local hardwareName = StatementHardware.getHardwareName(statement)
      if not hardwareName then
        print("No hardware for statementClass " .. statement:class():name())
      else
        statement.registerNames = {}
        if not l_29_0.excludedHardwareNames[hardwareName] then
          if statement.targetRegisters then
            for i,registerIndex in ipairs(statement.targetRegisters) do
              table.insert(statement.registerNames, l_29_0.decompilation:getRegisterName(statement.pc, registerIndex, l_29_2))
            end
          end
          if l_29_0.ioHardwareNames[hardwareName] then
            l_29_0:appendIO(statement, lastHardware)
            for i,statement in (for generator) do
            end
            local nextHardware = lastHardware:append(hardwareName, Direction.DIR_S, l_29_3, nil, Direction.DIR_S, statement, l_29_0)
            if nextHardware then
              lastHardware = nextHardware
              table.insert(l_29_1, lastHardware)
            end
          end
        end
      end
      local endSpacer = lastHardware:append("EmptySpacer", Direction.DIR_S, l_29_3, lastHardware.name .. " sequence spacer", Direction.DIR_S)
      if endSpacer then
        lastHardware = endSpacer
        table.insert(l_29_1, lastHardware)
      end
    end
    if l_29_4 then
      local minX, minY, maxX, maxY = lastHardware:getBounds()
      for i = 1, #l_29_1 - 1 do
        local childMinX, childMinY, childMaxX, childMaxY = l_29_1[i]:getBounds()
        minX, minY, maxX, maxY = math.min(minX, childMinX), math.min(minY, childMinY), math.max(maxX, childMaxX), math.max(maxY, childMaxY)
      end
      return lastHardware, minX, minY, maxX, maxY
    else
      return lastHardware
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CodeRoom.appendIO = function(l_30_0, l_30_1, l_30_2)
  local hardwareName = StatementHardware.getHardwareName(l_30_1)
  if hardwareName and l_30_0.ioHardwareNames[hardwareName] then
    local extensionDist = 32
    local lastIO = l_30_0.ioHardware[#l_30_0.ioHardware]
    local Wire = StatementHardware.loadHardwareClass("Wire")
    local EmptySpacer = StatementHardware.loadHardwareClass("EmptySpacer")
    if l_30_2 and not l_30_2:is(Wire) and not l_30_2:is(EmptySpacer) then
      local matchX, matchY = l_30_2:getPosition()
      local lastX, lastY = lastIO:getPosition()
      local diffY = lastY - matchY - 64
      if extensionDist < diffY then
        extensionDist = diffY
      end
    end
    lastIO = lastIO:append("EmptySpacer", Direction.DIR_S, nil, lastIO.name .. " Ext", Direction.DIR_S, extensionDist)
    table.insert(l_30_0.ioHardware, lastIO)
    table.insert(l_30_0.ioHardware, lastIO:append(hardwareName, Direction.DIR_S, nil, nil, Direction.DIR_S, l_30_1, l_30_0))
  else
    assert(false)
  end
end

return CodeRoom

