-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\Book.lua 

local Class = require("Class")
local Entity = require("Entity")
local Action = require("Action")
local CommonActions = require("CommonActions")
local EntityRef = require("EntityRef")
local Math = require("DFCommon.Math")
local Shader = require("Shader")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
local Book = Class.create(Entity, "Book")
Book.Teleport = Class.create(Action, "Book.Teleport")
Book.Teleport.START_SCALE = 1.2
Book.Teleport.FINAL_SCALE = 0.1
Book.Teleport.START_SHAKE = 0.2
Book.Teleport.FINAL_SHAKE = 0
Book.Teleport.TELEPORT_TIME = 1
Book.Teleport.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(Book.Teleport).init(l_1_0, l_1_1, l_1_2)
  l_1_0.portal, l_1_0.target = l_1_1, l_1_2
end

Book.Teleport.start = function(l_2_0, l_2_1)
  Class.super(Book.Teleport).start(l_2_0, l_2_1)
  l_2_0.elapsed = 0
  l_2_0.target:forceAction(CommonActions.PlayAnimation.new("Disappear", 1, 20))
  l_2_0.cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
  l_2_0.entity:room():insertPostEffect(l_2_0.cameraShake)
  l_2_0.quakeCue = MOAIFmodEventMgr.playEvent2D("SFX/Cutscenes/WizardTower_Earthquake")
end

Book.Teleport.stop = function(l_3_0)
  l_3_0.entity:room():removePostEffect(l_3_0.cameraShake)
  l_3_0.quakeCue:stop()
  l_3_0.portal:destroy()
end

Book.Teleport.tick = function(l_4_0)
  l_4_0.elapsed = l_4_0.elapsed + MOAISim.getStep()
  local t = l_4_0.elapsed / l_4_0.TELEPORT_TIME
  if t >= 1 then
    l_4_0.entity:encypher(l_4_0.target)
    return false
  end
  l_4_0.portal.prop:setScl(Math.lerp(l_4_0.START_SCALE, l_4_0.FINAL_SCALE, t))
  local shake = Math.lerp(l_4_0.START_SHAKE, l_4_0.FINAL_SHAKE, t)
  l_4_0.cameraShake:setFragmentUniformFloat("shaderDuration", shake)
  return true
end

Book.Trap = Class.create(Action, "Book.Trap")
Book.Trap.START_SCALE = 0.1
Book.Trap.FINAL_SCALE = 1
Book.Trap.START_SHAKE = 0.1
Book.Trap.FINAL_SHAKE = 0.2
Book.Trap.SCALE_TIME = 2
Book.Trap.PULL_ACCELERATION = 10
Book.Trap.init = function(l_5_0, l_5_1)
  Class.super(Book.Trap).init(l_5_0, l_5_1)
  l_5_0.target = EntityRef.new(l_5_1)
end

Book.Trap.start = function(l_6_0, l_6_1)
  Class.super(Book.Trap).start(l_6_0, l_6_1)
  l_6_0.elapsed = 0
  l_6_0.velocity = 0
  local portalX, portalY = l_6_0.entity:getPosition()
  l_6_0.portal = Entity.create("Content/Game/Global/Entities/Effects/Portal", l_6_0.entity.layer, portalX, portalY)
  l_6_0.cameraShake = Shader.load("Content/Game/Global/Shaders/CameraShake")
  l_6_0.entity:room():insertPostEffect(l_6_0.cameraShake)
  l_6_0.quakeCue = MOAIFmodEventMgr.playEvent2D("SFX/Cutscenes/WizardTower_Earthquake")
end

Book.Trap.stop = function(l_7_0)
  l_7_0.entity:room():removePostEffect(l_7_0.cameraShake)
  l_7_0.quakeCue:stop()
end

Book.Trap.tick = function(l_8_0)
  if not l_8_0.target:isValid() then
    return false
  end
  local targetX, targetY = l_8_0.target.entity:getPosition()
  local entityX, entityY = l_8_0.entity:getPosition()
  local deltaX, deltaY = entityX - targetX, entityY - targetY
  local dist = math.sqrt(deltaX * deltaX + deltaY * deltaY)
  if dist < 1 then
    l_8_0.entity:queueAction(Book.Teleport.new(l_8_0.portal, l_8_0.target.entity))
    return false
  end
  local nx, ny = deltaX / dist, deltaY / dist
  local vx, vy = nx * l_8_0.velocity, ny * l_8_0.velocity
  l_8_0.target.entity:get(PhysicsComponent):setLinearVelocity(vx, vy)
  l_8_0.velocity = l_8_0.velocity + l_8_0.PULL_ACCELERATION * MOAISim.getStep()
  local shake = Math.lerp(l_8_0.START_SHAKE, l_8_0.FINAL_SHAKE, math.min(1, l_8_0.elapsed / l_8_0.SCALE_TIME))
  l_8_0.cameraShake:setFragmentUniformFloat("shaderDuration", shake)
  l_8_0.elapsed = l_8_0.elapsed + MOAISim.getStep()
  local scale = Math.lerp(l_8_0.START_SCALE, l_8_0.FINAL_SCALE, math.min(1, l_8_0.elapsed / l_8_0.SCALE_TIME))
  l_8_0.portal.prop:setScl(scale)
  return true
end

Book.init = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4)
  Class.super(Book).init(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4)
  local sprite = SpriteComponent.new(l_9_0, "Interactions/Props/Book/Book")
  PhysicsComponent.new(l_9_0, {rect = {-32, -32, 32, 32}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  InteractionComponent.new(l_9_0)
  sprite.prop:setPriority(100)
  l_9_0:room():markShadowedEntity(l_9_0)
end

Book.setRoomPath = function(l_10_0, l_10_1)
  l_10_0.path = l_10_1
end

Book.trapHostEntity = function(l_11_0)
  for i,entity in ipairs(l_11_0.layer.entities) do
    if entity.host then
      l_11_0:forceAction(Book.Trap.new(entity))
      return 
    end
  end
end

Book.encypher = function(l_12_0, l_12_1)
  l_12_1.host.state.encyphered = true
  l_12_1.host:handleRoomExit(l_12_1, l_12_0.path)
  local fullPath = "Data/" .. l_12_0.path .. ".lua"
  local fileSystem = l_12_0:universe().state.fileSystem
  local roomData = fileSystem:loadFile(fullPath)
  local encipheredData = DFHack.encipherBuffer(roomData, tostring(math.random()))
  fileSystem:storeFile(fullPath, encipheredData)
end

return Book

