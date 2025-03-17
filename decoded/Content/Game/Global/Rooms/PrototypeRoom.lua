-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Rooms\PrototypeRoom.lua 

local Class = require("Class")
local Room = require("Room")
local MachineRoom = Room.cache:load("Content/Game/Global/Rooms/MachineRoom")
local Disassembly = require("Disassembly")
local Entity = require("Entity")
local EntitySet = require("EntitySet")
local PrototypeLayout = require("PrototypeLayout")
local SpriteSheet = require("SpriteSheet")
local Crystal = Entity.cache:load("Content/Game/MachineRooms/Entities/Crystal")
local ExpressionMachine = Entity.cache:load("Content/Game/MachineRooms/Entities/ExpressionMachine")
local Pedestal = Entity.cache:load("Content/Game/MachineRooms/Entities/Pedestal")
local InteractionComponent = require("Components.InteractionComponent")
local InventoryComponent = require("Components.InventoryComponent")
local SceneComponent = require("Components.SceneComponent")
local PrototypeRoom = Class.create(MachineRoom, "PrototypeRoom")
PrototypeRoom.OUTLET_POSITION = {600, 0}
PrototypeRoom.MACHINE_SPACER = 75
PrototypeRoom.PEDESTAL_OFFSET = 200
PrototypeRoom.PEDESTAL_SPACING = 150
PrototypeRoom.LANE_OFFSET = PrototypeRoom.OUTLET_POSITION[1] + 300
PrototypeRoom.LANE_SPACING = 32
PrototypeRoom.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  if not l_1_3 then
    l_1_3 = "destroy:@Data/Content/Game/DourTower/Entities/WizardBat_Roof.lua:2"
  end
  l_1_0.streams = {}
  l_1_0.streamActivationCounts = {}
  local pathParts = {}
  for part in l_1_3:gmatch("[^:]+") do
    table.insert(pathParts, part)
  end
  local name = pathParts[1]
  l_1_0.sourcePath = pathParts[2]
  if l_1_0.sourcePath:sub(1, 1) == "@" then
    l_1_0.sourcePath = l_1_0.sourcePath:sub(2)
  end
  local fn = loadfile(l_1_0.sourcePath)
  local disassembly = Disassembly.new(fn)
  l_1_0.prototype = disassembly.prototype
  l_1_0.disassemblyPath = {}
  for i = 3, #pathParts do
    local childIndex = tonumber(pathParts[i])
    table.insert(l_1_0.disassemblyPath, childIndex)
    l_1_0.prototype = l_1_0.prototype.children[childIndex]
  end
  l_1_0.layout = PrototypeLayout.new(l_1_0.prototype)
  local outletSheet = SpriteSheet.load("Interactions/Props/CodeRoomHardware/Outlet/Outlet")
  local hardwareSheet = SpriteSheet.load("Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  local MACHINE_SCALE = 0.25
  local outletX, outletY = unpack(l_1_0.OUTLET_POSITION)
  local outletJointX, outletJointY = outletSheet:getJoint("S", "Floor")
  local currentX, currentY = outletX + outletJointX * MACHINE_SCALE, outletY - outletJointY * MACHINE_SCALE
  local wires = {}
  local runWire = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
    table.insert(wires, {name = l_1_0, source = {l_1_1, l_1_2}, target = {l_1_3, l_1_4}})
   end
  local pedestals = {}
  for i = 0, #l_1_0.prototype.prototype.protos - 1 do
    table.insert(pedestals, {class = "Content/Game/MachineRooms/Entities/FunctionPedestal", index = i})
  end
  for i = 0, l_1_0.prototype.prototype.numparams - 1 do
    table.insert(pedestals, {class = "Content/Game/MachineRooms/Entities/ArgumentPedestal", index = i})
  end
  for i = 0, l_1_0.prototype.prototype.nups - 1 do
    table.insert(pedestals, {class = "Content/Game/MachineRooms/Entities/UpvaluePedestal", index = i})
  end
  for i = 0, #l_1_0.prototype.prototype.constants - 1 do
    local constant = l_1_0.prototype.prototype.constants[i + 1]
    if type(constant) == "boolean" then
      table.insert(pedestals, {class = "Content/Game/MachineRooms/Entities/BooleanConstantPedestal", index = i})
    else
      if type(constant) == "number" then
        table.insert(pedestals, {class = "Content/Game/MachineRooms/Entities/NumberConstantPedestal", index = i})
      else
        if type(constant) == "string" then
          table.insert(pedestals, {class = "Content/Game/MachineRooms/Entities/StringConstantPedestal", index = i})
        end
      end
    end
  end
  local blockPositions = {}
  local expressionPlacements = {}
  local jumps = {}
  for i,block in ipairs(l_1_0.layout.orderedBlockLayouts) do
    blockPositions[block.entry] = {currentX, currentY}
    for j,expression in ipairs(block.expressionLayouts) do
      if expression.expression:is(Disassembly.JMP) then
        table.insert(jumps, {source = {currentX, currentY}, sourceBlockIndex = i, targetBlock = expression.expression.jumpTargets[1]})
        currentY = currentY + l_1_0.MACHINE_SPACER
        for j,expression in (for generator) do
        end
        expressionPlacements[expression] = {currentX, currentY}
        local info = ExpressionMachine.EXPRESSION_INFO[expression.expression:class()]
        local machineX, machineY = hardwareSheet:getDimensions(info.machine)
        machineX, machineY = machineX * MACHINE_SCALE, machineY * MACHINE_SCALE
        local pivotX, pivotY = hardwareSheet:getPivot(info.machine)
        pivotX, pivotY = pivotX * MACHINE_SCALE, machineY - pivotY * MACHINE_SCALE
        local entryJointX, entryJointY = hardwareSheet:getJoint("N", info.machine)
        entryJointX, entryJointY = entryJointX * MACHINE_SCALE, -entryJointY * MACHINE_SCALE
        runWire("NS", currentX, currentY, currentX, currentY + entryJointY)
        runWire("Center", currentX, currentY + entryJointY, currentX, currentY + entryJointY)
        runWire("WE", currentX, currentY + entryJointY, currentX + entryJointX, currentY + entryJointY)
        local continues = true
        if expression.expression:is(Disassembly.FORPREP) then
          continues = false
        else
          if expression.expression:is(Disassembly.LOADBOOL) and expression.expression.jumpTargets[1] then
            continues = false
          end
        end
        local exitJointX, exitJointY = nil, nil
        if continues then
          exitJointX, exitJointY = hardwareSheet:getJoint("S", info.machine)
          if exitJointX and exitJointY then
            exitJointX, exitJointY = exitJointX * MACHINE_SCALE, -exitJointY * MACHINE_SCALE
            runWire("WE", currentX, currentY + exitJointY, currentX + exitJointX, currentY + exitJointY)
            runWire("Center", currentX, currentY + exitJointY, currentX, currentY + exitJointY)
            runWire("NS", currentX, currentY + exitJointY, currentX, currentY + exitJointY + l_1_0.MACHINE_SPACER)
          end
        end
        local branchJointX, branchJointY = hardwareSheet:getJoint("E", info.machine)
        if branchJointX and branchJointY then
          branchJointX, branchJointY = branchJointX * MACHINE_SCALE, -branchJointY * MACHINE_SCALE
        end
        if not continues then
          table.insert(jumps, {source = {currentX + branchJointX, currentY + branchJointY}, sourceBlockIndex = i, targetBlock = expression.expression.jumpTargets[1]})
          currentY = currentY + l_1_0.MACHINE_SPACER
        else
          if expression.expression:is(Disassembly.LOADBOOL) and #expression.expression.jumpTargets ~= 0 then
            table.insert(jumps, {source = {currentX + branchJointX, currentY + branchJointY}, sourceBlockIndex = i, targetBlock = expression.expression.jumpTargets[1]})
          else
            if expression.expression:is(Disassembly.FORLOOP) then
              table.insert(jumps, {source = {currentX + branchJointX, currentY + branchJointY}, sourceBlockIndex = i, targetBlock = expression.expression.jumpTargets[2]})
              table.insert(jumps, {source = {currentX, currentY + exitJointY + l_1_0.MACHINE_SPACER}, sourceBlockIndex = i, targetBlock = expression.expression.jumpTargets[1]})
            else
              if expression.expression:is(Disassembly.TestExpression) or expression.expression:is(Disassembly.TFORLOOP) then
                local failJump = l_1_0.prototype.expressions[expression.expression.jumpTargets[1] + 1]
                table.insert(jumps, {source = {currentX + branchJointX, currentY + branchJointY}, sourceBlockIndex = i, targetBlock = failJump.jumpTargets[1]})
                table.insert(jumps, {source = {currentX, currentY + exitJointY + l_1_0.MACHINE_SPACER}, sourceBlockIndex = i, targetBlock = expression.expression.jumpTargets[2]})
              end
            end
          end
        end
        currentY = currentY + (exitJointY or entryJointY) + l_1_0.MACHINE_SPACER
      end
    end
    local lane = 0
    for i,jump in ipairs(jumps) do
      local nextOrderedBlock = l_1_0.layout.orderedBlockLayouts[jump.sourceBlockIndex + 1]
      if not nextOrderedBlock or nextOrderedBlock.entry ~= jump.targetBlock then
        local laneX = l_1_0.LANE_OFFSET + l_1_0.LANE_SPACING * lane
        local startX, startY = unpack(jump.source)
        local targetX, targetY = unpack(blockPositions[jump.targetBlock])
        lane = lane + 1
        runWire("WE", startX, startY, laneX, startY)
        runWire("Center", laneX, startY, laneX, startY)
        runWire("NS", laneX, startY, laneX, targetY)
        runWire("Center", laneX, targetY, laneX, targetY)
        runWire("WE", targetX, targetY, laneX, targetY)
        runWire("Center", targetX, targetY, targetX, targetY)
      end
    end
    local sizeX, sizeY = currentX + 200, currentY + 200
    if sizeY < (#pedestals + 1) * l_1_0.PEDESTAL_SPACING then
      sizeY = (#pedestals + 1) * l_1_0.PEDESTAL_SPACING
    end
    Class.super(PrototypeRoom).init(l_1_0, l_1_1, l_1_2, l_1_3, sizeX, sizeY, name)
    if l_1_0.referenceCamDepth > 1000 then
      l_1_0.referenceCamDepth = 1000
    end
    local gameplay = l_1_0:getLayerByOrder(0)
    do
      local pedestalOffset = sizeY - l_1_0.PEDESTAL_SPACING
      for i,pedestal in ipairs(pedestals) do
        local pedestalEntity = Entity.create(pedestal.class, gameplay, l_1_0.PEDESTAL_OFFSET, pedestalOffset)
        pedestalEntity:setIndex(l_1_0.layout, pedestal.index)
        pedestalOffset = pedestalOffset - l_1_0.PEDESTAL_SPACING
      end
      Entity.create("Content/Game/Global/Entities/Locator", gameplay, outletX - 100, sizeY - outletY, "Hero Spawner")
      Entity.create("Content/Game/MachineRooms/Entities/WireStart", gameplay, outletX, sizeY - outletY)
      for i,wire in ipairs(wires) do
        local sourceX, sourceY = unpack(wire.source)
        local wireEntity = Entity.create("Content/Game/MachineRooms/Entities/Wire", gameplay, sourceX, sizeY - sourceY)
        local targetX, targetY = unpack(wire.target)
        wireEntity:setTarget(wire.name, targetX - sourceX, targetY - sourceY)
      end
      l_1_0.pcMachineMap = {}
      for expression,position in pairs(expressionPlacements) do
        local posX, posY = unpack(position)
        posY = sizeY - posY
        local name = tostring(expression.expression.pc) .. ": " .. expression.expression.instruction:GET_OPCODE_NAME()
        local class = "Content/Game/MachineRooms/Entities/ExpressionMachine"
        local expressionInfo = ExpressionMachine.EXPRESSION_INFO[expression.expression:class()]
        if expressionInfo.subclass then
          class = expressionInfo.subclass
        end
        local machine = Entity.create(class, gameplay, posX, posY, name)
        machine:setExpressionLayout(expression)
        l_1_0.pcMachineMap[expression.expression.pc] = machine
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PrototypeRoom.activateStreams = function(l_2_0, l_2_1, l_2_2, l_2_3)
  do
    local count = l_2_0.streamActivationCounts[l_2_2]
    if not l_2_3 then
      if not count then
        return 
      end
      if count == 1 then
        l_2_0.streams[l_2_2]:fade()
        l_2_0.streams[l_2_2] = nil
        l_2_0.streamActivationCounts[l_2_2] = nil
      else
        l_2_0.streamActivationCounts[l_2_2] = count - 1
      end
    elseif not count then
      local gameplay = l_2_0:getLayerByOrder(0)
      local originEntities = {}
      local targetEntities = {}
      for i,entity in ipairs(gameplay.entities) do
        if entity:is(Crystal) and entity.colorIndex == l_2_2 then
          if entity.isOrigin then
            table.insert(originEntities, entity)
            for i,entity in (for generator) do
            end
            table.insert(targetEntities, entity)
          end
        end
        local stream = Entity.create("Content/Game/MachineRooms/Entities/Stream", gameplay, 0, 0)
        stream:setCrystals(l_2_0.layout, l_2_2, originEntities, targetEntities, l_2_1)
        l_2_0.streams[l_2_2] = stream
        count = 0
      end
      l_2_0.streamActivationCounts[l_2_2] = count + 1
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PrototypeRoom.savePrototype = function(l_3_0)
  local fn = loadfile(l_3_0.sourcePath)
  local freshDisassembly = DFHack.getDisassembly(fn)
  local previous = freshDisassembly.proto
  local replacement = l_3_0.prototype.prototype
  if #l_3_0.disassemblyPath ~= 0 then
    local parent = freshDisassembly.proto
    for i = 1, #l_3_0.disassemblyPath - 1 do
      local childIndex = l_3_0.disassemblyPath[i]
      parent = parent.protos[childIndex]
    end
    local protoIndex = l_3_0.disassemblyPath[#l_3_0.disassemblyPath]
    previous = parent.protos[protoIndex]
    parent.protos[protoIndex] = replacement
  else
    freshDisassembly.proto = replacement
  end
  for i,proto in ipairs(previous.protos) do
    replacement.protos[i] = previous.protos[i]
  end
  local reassembled = DFHack.reassemble(freshDisassembly)
  local fileSystem = l_3_0:universe().state.fileSystem
  fileSystem:storeFile(l_3_0.sourcePath, reassembled)
end

PrototypeRoom.onBobCreated = function(l_4_0, l_4_1)
  Class.super(PrototypeRoom).onBobCreated(l_4_0, l_4_1)
  l_4_0.bobStatementEntities = EntitySet.new()
  l_4_1.sensor.entityEnterEvent:register(l_4_0.onBobSensorEntityEnter, l_4_0)
  l_4_1.sensor.entityLeaveEvent:register(l_4_0.onBobSensorEntityLeave, l_4_0)
end

PrototypeRoom.onBobSensorEntityEnter = function(l_5_0, l_5_1)
  local alice = l_5_0:getAlice()
  if not alice.state.beganCodePuzzles then
    return 
  end
  if not l_5_1:is(ExpressionMachine) and not l_5_1:is(Pedestal) then
    return 
  end
  if not l_5_0:findSceneExpressionName(l_5_1) then
    return 
  end
  l_5_0.bobStatementEntities:addEntity(l_5_1)
  local bob = l_5_0:getBob()
  if not bob.excitingEntity:isValid() then
    l_5_0:pickBobScene()
  end
end

PrototypeRoom.onBobSensorEntityLeave = function(l_6_0, l_6_1)
end

PrototypeRoom.pickBobScene = function(l_7_0)
  local alice = l_7_0:getAlice()
  if not alice.state.expressionScenes then
    alice.state.expressionScenes = {}
  end
  local bob = l_7_0:getBob()
  local bobX, bobY = bob:getPosition()
  local closest, closestDistSq = nil, nil
  for entity in pairs(l_7_0.bobStatementEntities.entities) do
    local name = l_7_0:findSceneExpressionName(entity)
    if not alice.state.expressionScenes[name] then
      local entityX, entityY = entity:getPosition()
      local dx, dy = entityX - bobX, entityY - bobY
      local distSq = dx * dx + dy * dy
      if not closest or distSq < closestDistSq then
        closest, closestDistSq = entity, distSq
      end
    end
  end
  if closest then
    bob:beExcited(closest)
    bob:get(InteractionComponent):setEnabled(true)
    bob:get(InteractionComponent).interactEvent:register(l_7_0.onBobInteract, l_7_0)
  end
end

PrototypeRoom.findSceneExpressionName = function(l_8_0, l_8_1)
  for className,handler in pairs(l_8_0.bobSceneHandlers) do
    if l_8_1.expression:is(Disassembly[className]) then
      return className
    end
  end
end

PrototypeRoom.onBobInteract = function(l_9_0, l_9_1)
  local bob = l_9_0:getBob()
  local alice = l_9_0:getAlice()
  local hardwareEntity = bob.excitingEntity.entity
  local name = l_9_0:findSceneExpressionName(hardwareEntity)
  alice:get(SceneComponent):play(function(l_1_0)
    bob:beExcited()
    bob:get(InteractionComponent).interactEvent:unregister(self.onBobInteract, self)
    bob:get(InteractionComponent):stopInteract(interactor)
    bob:get(InteractionComponent):setEnabled(false)
    alice:halt(true)
    self.bobSceneHandlers[name](self, l_1_0, hardwareEntity)
    alice:halt(false)
    alice.state.expressionScenes[name] = true
    if self.bobStatementEntities.count ~= 0 then
      self:pickBobScene()
    end
   end)
end

PrototypeRoom.wearHat = function(l_10_0, l_10_1)
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

PrototypeRoom.onBobArgumentScene = function(l_11_0, l_11_1, l_11_2)
  local alicePortrait = l_11_1:addAlicePortrait()
  local bobPortrait = l_11_1:addCharacter("Portraits/Bob/Bob")
  l_11_1:speakLineLeft(alicePortrait, "What do you think this is?", "Spooked")
  l_11_1:speakLineRight(bobPortrait, "It's a data crystal.", "Talk")
  l_11_1:speakLineLeft(alicePortrait, "...did you just make that term up?", "NonPlussed")
  l_11_1:speakLineRight(bobPortrait, "...Yeah. It's a good name, though, don't you think?", "Talk2")
  l_11_1:speakLineLeft(alicePortrait, "Let me take a closer look...", "Default3")
  l_11_0:wearHat(l_11_1)
  l_11_1:speakLineLeft(alicePortrait, "It looks like it's an 'arg,' whatever that is. It's labeled \"" .. l_11_2.label.text .. ".\"", "Snobby")
  l_11_1:speakLineRight(bobPortrait, "I wonder what an 'arg' is.", "Talk3")
  l_11_1:speakLineRight(alicePortrait, "Judging by the crystal colors, it's probably an input of some kind to the machine.", "Snobby")
  l_11_1:speakLineLeft(bobPortrait, "And it doesn't have a port to hacked, so it must come from outside the algorithm.", "Excited")
  l_11_1:speakLineRight(bobPortrait, "So, yeah, data crystal's a good name for it.", "Talk3")
  l_11_1:speakLineLeft(alicePortrait, "Why's that?", "Spooked")
  l_11_1:speakLineRight(bobPortrait, "It sounds cool. That's critical in a name.", "Sly")
end

PrototypeRoom.onBobConstantScene = function(l_12_0, l_12_1, l_12_2)
  local alice = l_12_0:getAlice()
  local alicePortrait = l_12_1:addAlicePortrait()
  local bobPortrait = l_12_1:addCharacter("Portraits/Bob/Bob")
  l_12_1:speakLineLeft(alicePortrait, "Ooh, this one has a port.", "Spooked")
  l_12_1:speakLineRight(bobPortrait, "Yes! Hack it! ...No, wait!", "Sing")
  l_12_1:speakLineLeft(alicePortrait, "...Why?", "Surprised")
  l_12_1:speakLineRight(bobPortrait, "Put the hat on first and tell me what it says!", "Excited")
  l_12_0:wearHat(l_12_1)
  l_12_1:speakLineLeft(alicePortrait, "It says... " .. l_12_2.label.text .. ".", "Default4")
  l_12_1:speakLineRight(bobPortrait, "Based on the color, it looks like this thing is hooked up to the machines. I bet we can change that value and change how the machines work.", "Judgemental")
  l_12_1:speakLineLeft(alicePortrait, "Do I have permission to hack it yet?", "Snobby")
  l_12_1:speakLineRight(bobPortrait, "Sure. Go ahead!", "Talk3")
end

PrototypeRoom.onBobGetTableScene = function(l_13_0, l_13_1, l_13_2)
  local alicePortrait = l_13_1:addAlicePortrait()
  local bobPortrait = l_13_1:addCharacter("Portraits/Bob/Bob")
  l_13_1:speakLineRight(bobPortrait, "Hmm...", "NoWay")
  l_13_1:speakLineLeft(alicePortrait, "Got any ideas what this machine is?", "Talk2")
  l_13_1:speakLineRight(bobPortrait, "...maybe. What do you see with your third eye?", "Talk2")
  l_13_0:wearHat(l_13_1)
  l_13_1:speakLineLeft(alicePortrait, "It says " .. l_13_2.label.text .. ".", "Snobby")
  l_13_1:speakLineRight(bobPortrait, "Cryptic. Maybe it's pulling a property out of that crystal?", "Talk3")
  l_13_1:speakLineLeft(alicePortrait, "And stuffing the result into that crystal? It looks like that crystal gets used by other machines.", "Default3")
end

PrototypeRoom.onBobAddScene = function(l_14_0, l_14_1, l_14_2)
  local alicePortrait = l_14_1:addAlicePortrait()
  local bobPortrait = l_14_1:addCharacter("Portraits/Bob/Bob")
  l_14_1:speakLineRight(bobPortrait, "I've got this one! It takes those two crystals and adds them together!", "Excited")
  l_14_1:speakLineLeft(alicePortrait, "Do you want me to check it with my hat?", "Spooked")
  l_14_1:speakLineRight(bobPortrait, "$ALICE, I'm pretty sure I know what an adding machine for a magical algorithm room that secretly underpins our reality looks like.", "Judgemental")
end

PrototypeRoom.onBobConditionalScene = function(l_15_0, l_15_1, l_15_2)
  local alicePortrait = l_15_1:addAlicePortrait()
  local bobPortrait = l_15_1:addCharacter("Portraits/Bob/Bob")
  l_15_1:speakLineRight(bobPortrait, "Check it out! This one splits into two paths!", "Excited")
  l_15_1:speakLineLeft(alicePortrait, "How do you think it chooses a path?", "Spooked")
  l_15_1:speakLineRight(bobPortrait, "Well, it reads from those two crystals...", "Talk")
  l_15_1:speakLineLeft(alicePortrait, "Maybe it compares them to figure out which way to direct the flow.", "Default4")
  l_15_1:speakLineRight(bobPortrait, "Sure, That sounds good.", "Talk2")
end

PrototypeRoom.onBobMultiplyScene = function(l_16_0, l_16_1, l_16_2)
  local alicePortrait = l_16_1:addAlicePortrait()
  local bobPortrait = l_16_1:addCharacter("Portraits/Bob/Bob")
  l_16_1:speakLineRight(bobPortrait, "This one's easy. Multiplies the crystals.", "Judgemental")
  l_16_1:speakLineLeft(alicePortrait, "You seem pretty confident.", "Default")
  l_16_1:speakLineRight(bobPortrait, "I'm gifted with machines. They speak to me.", "Talk")
  l_16_1:speakLineLeft(alicePortrait, "Since when?", "Talk2")
  l_16_1:speakLineRight(bobPortrait, "<c:8>What's that, machine? ...Yeah, you're right.</>", "Sly")
  l_16_1:speakLineLeft(alicePortrait, "...", "NonPlussed")
  l_16_1:speakLineRight(bobPortrait, "You wouldn't understand, $ALICE. It's a machine thing.", "Talk")
end

PrototypeRoom.onBobReturnScene = function(l_17_0, l_17_1, l_17_2)
  local alicePortrait = l_17_1:addAlicePortrait()
  local bobPortrait = l_17_1:addCharacter("Portraits/Bob/Bob")
  l_17_1:speakLineLeft(alicePortrait, "It looks like this is the end of the algorithm", "Spooked")
  l_17_1:speakLineRight(bobPortrait, "This machine looks special. What do you think it does?", "Excited")
  l_17_0:wearHat(l_17_1)
  l_17_1:speakLineLeft(alicePortrait, "\"Return\"... I'm guessing it returns the result of the algorithm?", "Talk2")
  l_17_1:speakLineRight(bobPortrait, "We can't mess with this machine, but we can mess with the stuff that feeds into it.", "Judgemental")
  l_17_1:speakLineLeft(alicePortrait, "Now we just have to figure out what we want it to return.", "Talk")
end

PrototypeRoom.onBobConcatenateScene = function(l_18_0, l_18_1, l_18_2)
  local alicePortrait = l_18_1:addAlicePortrait()
  local bobPortrait = l_18_1:addCharacter("Portraits/Bob/Bob")
  l_18_1:speakLineRight(bobPortrait, "This machine looks crazy", "Sing")
  l_18_1:speakLineLeft(alicePortrait, "Both of the crystals correspond to those crysals over there.", "Default2")
  l_18_0:wearHat(l_18_1)
  l_18_1:speakLineLeft(alicePortrait, "It looks like they both contain text.", "Talk")
  l_18_1:speakLineRight(bobPortrait, "Maybe this thing combines them together?", "Talk3")
end

PrototypeRoom.onBobForPrepScene = function(l_19_0, l_19_1, l_19_2)
  local alicePortrait = l_19_1:addAlicePortrait()
  local bobPortrait = l_19_1:addCharacter("Portraits/Bob/Bob")
  l_19_1:speakLineRight(bobPortrait, "This one follows a weird path!", "Excited")
  l_19_1:speakLineLeft(alicePortrait, "And it has an output crystal.", "Default4")
  l_19_0:wearHat(l_19_1)
  l_19_1:speakLineLeft(alicePortrait, "It looks like that crystal gets a range of values", "Default2")
  l_19_1:speakLineRight(bobPortrait, "What's with the wire that loops back, though?", "Talk3")
  l_19_1:speakLineLeft(alicePortrait, "I'm not sure. I think maybe this crystal gets a different value every time it loops around.", "Spooked")
end

PrototypeRoom.onBobModulusScene = function(l_20_0, l_20_1, l_20_2)
  local alicePortrait = l_20_1:addAlicePortrait()
  local bobPortrait = l_20_1:addCharacter("Portraits/Bob/Bob")
  l_20_1:speakLineRight(bobPortrait, "What do you think 'mod' is short for?", "Excited")
  l_20_0:wearHat(l_20_1)
  l_20_1:speakLineLeft(alicePortrait, "Modulus... do you know what that means?", "Default2")
  l_20_1:speakLineRight(bobPortrait, "Oh, modulus! It's a mathematical concept analogous to division, but instead of producing the quotient, it produces the remainder.", "Judgemental")
  l_20_1:speakLineLeft(alicePortrait, "How do you know so much math?", "Spooked")
  l_20_1:speakLineRight(bobPortrait, "Sprites are way into math. Here's a fun fact about the modulo operator: you can easily test whether a number is even or odd by computing the number modulo 2.", "Excited")
  l_20_1:speakLineLeft(alicePortrait, "Ah! Because an even number would be divisible by 2 and have a remainder of 0, but an odd number would have a remainder of 1!", "Snobby")
  l_20_1:speakLineRight(bobPortrait, "Yep. If something modulo a certain number is 0, then it's evenly divisible by that number.", "Talk")
  l_20_1:speakLineLeft(alicePortrait, "This seems like a complicated machine.", "HappyLaugh")
end

PrototypeRoom.onBobCallScene = function(l_21_0, l_21_1, l_21_2)
  local alicePortrait = l_21_1:addAlicePortrait()
  local bobPortrait = l_21_1:addCharacter("Portraits/Bob/Bob")
  l_21_1:speakLineRight(bobPortrait, "This looks like one of those machines that interacts with things outside this algorithm.", "Excited")
  l_21_0:wearHat(l_21_1)
  l_21_1:speakLineLeft(alicePortrait, "Hmm... it looks like it's fed the name of something and passes some data crystals to it.", "Default2")
  l_21_1:speakLineRight(bobPortrait, "Oh! Oh! I bet it's calling another algorithm! The crystals it's sending must be that algorithm's arguments!", "Sing")
  l_21_1:speakLineLeft(alicePortrait, "That sounds... totally reasonable, $BOB. I think you might be right.", "HappyLaugh")
end

PrototypeRoom.onBobClosureScene = function(l_22_0, l_22_1, l_22_2)
  local alicePortrait = l_22_1:addAlicePortrait()
  local bobPortrait = l_22_1:addCharacter("Portraits/Bob/Bob")
  l_22_1:speakLineRight(bobPortrait, "What's a 'closure?'", "Talk2")
  l_22_1:speakLineLeft(alicePortrait, "I have no idea.", "Spooked")
  l_22_0:wearHat(l_22_1)
  l_22_1:speakLineLeft(alicePortrait, "Hmm... it looks like it's connected to that pedestal over there.", "Default2")
  l_22_1:speakLineRight(bobPortrait, "The display on that pedestal looks the same as the displays that take us into these rooms.", "Sly")
  l_22_1:speakLineLeft(alicePortrait, "Do you think it leads to another algorithm?", "Talk2")
  l_22_1:speakLineRight(bobPortrait, "Maybe a closure is an algorithm's pet algorithm!", "Sing")
end

{Register = PrototypeRoom.onBobArgumentScene, Constant = PrototypeRoom.onBobConstantScene, TestExpression = PrototypeRoom.onBobConditionalScene, GETTABLE = PrototypeRoom.onBobGetTableScene, ADD = PrototypeRoom.onBobAddScene, MUL = PrototypeRoom.onBobMultiplyScene, RETURN = PrototypeRoom.onBobReturnScene, CONCAT = PrototypeRoom.onBobConcatenateScene}.FORPREP = PrototypeRoom.onBobForPrepScene
 -- DECOMPILER ERROR: Confused about usage of registers!

{Register = PrototypeRoom.onBobArgumentScene, Constant = PrototypeRoom.onBobConstantScene, TestExpression = PrototypeRoom.onBobConditionalScene, GETTABLE = PrototypeRoom.onBobGetTableScene, ADD = PrototypeRoom.onBobAddScene, MUL = PrototypeRoom.onBobMultiplyScene, RETURN = PrototypeRoom.onBobReturnScene, CONCAT = PrototypeRoom.onBobConcatenateScene}.MOD = PrototypeRoom.onBobModulusScene
 -- DECOMPILER ERROR: Confused about usage of registers!

{Register = PrototypeRoom.onBobArgumentScene, Constant = PrototypeRoom.onBobConstantScene, TestExpression = PrototypeRoom.onBobConditionalScene, GETTABLE = PrototypeRoom.onBobGetTableScene, ADD = PrototypeRoom.onBobAddScene, MUL = PrototypeRoom.onBobMultiplyScene, RETURN = PrototypeRoom.onBobReturnScene, CONCAT = PrototypeRoom.onBobConcatenateScene}.CallExpression = PrototypeRoom.onBobCallScene
 -- DECOMPILER ERROR: Confused about usage of registers!

{Register = PrototypeRoom.onBobArgumentScene, Constant = PrototypeRoom.onBobConstantScene, TestExpression = PrototypeRoom.onBobConditionalScene, GETTABLE = PrototypeRoom.onBobGetTableScene, ADD = PrototypeRoom.onBobAddScene, MUL = PrototypeRoom.onBobMultiplyScene, RETURN = PrototypeRoom.onBobReturnScene, CONCAT = PrototypeRoom.onBobConcatenateScene}.CLOSURE = PrototypeRoom.onBobClosureScene
 -- DECOMPILER ERROR: Confused about usage of registers!

PrototypeRoom.bobSceneHandlers = {Register = PrototypeRoom.onBobArgumentScene, Constant = PrototypeRoom.onBobConstantScene, TestExpression = PrototypeRoom.onBobConditionalScene, GETTABLE = PrototypeRoom.onBobGetTableScene, ADD = PrototypeRoom.onBobAddScene, MUL = PrototypeRoom.onBobMultiplyScene, RETURN = PrototypeRoom.onBobReturnScene, CONCAT = PrototypeRoom.onBobConcatenateScene}
return PrototypeRoom

