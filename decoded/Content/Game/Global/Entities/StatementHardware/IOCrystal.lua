-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\IOCrystal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local EntitySet = require("EntitySet")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local IOCrystal = Class.create(StatementHardware, "IOCrystal")
IOCrystal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10, l_1_11, l_1_12)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.bInput = l_1_8
  l_1_0.statementParent = l_1_9
  l_1_0.statementKey = l_1_10
  if not l_1_11 then
    l_1_0.pc = l_1_0.statement.pc
  end
  PhysicsComponent.new(l_1_0, 16, 32, PhysicsComponent.DYNAMIC_CATEGORY, PhysicsComponent.SENSOR_CATEGORY, MOAIBox2DBody.DYNAMIC, true)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/Crystal/Crystal")
  AnimatorComponent.new(l_1_0, true)
  InteractionComponent.new(l_1_0)
  l_1_0:get(PhysicsComponent).fixture:setDebugColor(1, 0, 0, 0)
  local interact = l_1_0:get(InteractionComponent)
  interact:setEnabled(false)
  interact.sensorEvent:register(l_1_0.onSensorEvent, l_1_0)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:setRot(0, 0, l_1_12)
  l_1_0.prop:forceUpdate()
  l_1_0.color = {1, 1, 1}
  l_1_0.inputCrystals = EntitySet.new()
  l_1_0.ioStreams = EntitySet.new()
  l_1_0.inSensor = false
end

IOCrystal.setColor = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0.prop:setColor(l_2_1, l_2_2, l_2_3)
  l_2_0.color = {l_2_1, l_2_2, l_2_3}
end

IOCrystal.getColor = function(l_3_0)
  return l_3_0.color[1], l_3_0.color[2], l_3_0.color[3]
end

IOCrystal.onInteract = function(l_4_0, l_4_1)
  l_4_0:cycleInputs()
  l_4_0:get(InteractionComponent):stopInteract(l_4_1)
end

IOCrystal.cycleInputs = function(l_5_0)
  if l_5_0.bInput then
    local outputIndex = nil
    for i,outputCrystal in ipairs(l_5_0.codeRoom.outputCrystals) do
      if outputCrystal.statement == l_5_0.statement then
        outputIndex = i
      end
    end
    if outputIndex then
      local fnValid = false
      repeat
        repeat
          if not fnValid then
            outputIndex = outputIndex % #l_5_0.codeRoom.outputCrystals + 1
            local nextOutputCrystal = l_5_0.codeRoom.outputCrystals[outputIndex]
          until not nextOutputCrystal.pc or nextOutputCrystal.pc < l_5_0.pc
          l_5_0:setColor(nextOutputCrystal:getColor())
          l_5_0.statement = nextOutputCrystal.statement
          l_5_0.statementParent[l_5_0.statementKey] = l_5_0.statement
          l_5_0.codeRoom:onStatementChanged(l_5_0)
          fnValid = true
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IOCrystal.enableIOStreams = function(l_6_0, l_6_1, l_6_2)
  if l_6_2 then
    if l_6_0.ioStreams.count > 0 then
      for _,entity in pairs(l_6_0.ioStreams.entities) do
        entity:fade(true)
      end
    elseif l_6_0.bInput then
      local outputCrystal = l_6_0.codeRoom.statementOutputCrystalMap[l_6_0.statement]
      outputCrystal:enableIOStreams(l_6_1, true)
    else
      local posX, posY = l_6_0:getPosition()
      for _,inputCrystal in pairs(l_6_0.inputCrystals.entities) do
        local ioStream = Entity.create("Content/Game/Global/Entities/StatementHardware/IOStream", l_6_0.layer, posX, posY, nil, l_6_0, inputCrystal, l_6_1, l_6_0.color)
        l_6_0.ioStreams:addEntity(ioStream)
      end
    end
  else
    for _,entity in pairs(l_6_0.ioStreams.entities) do
      entity:fade(false)
    end
  end
end
end

IOCrystal.labelHardware = function(l_7_0, l_7_1)
  StatementHardware.labelHardware(l_7_0, l_7_1)
  l_7_0:setLabelText("")
end

IOCrystal.onSensorEvent = function(l_8_0, l_8_1, l_8_2)
  l_8_0.inSensor = l_8_2
  if l_8_2 then
    l_8_0:enableIOStreams(l_8_1, true)
  end
end

return IOCrystal

