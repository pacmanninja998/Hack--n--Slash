-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\Door.lua 

local Class = require("Class")
local Entity = require("Entity")
local Action = require("Action")
local Direction = require("Direction")
local Shader = require("Shader")
local Delegate = require("DFMoai.Delegate")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
local Door = Class.create(Entity, "Door")
Door.OpenAction = require("Class").create(Action, "Door.OpenAction")
Door.OpenAction.DEFAULT_DURATION = 0.5
Door.OpenAction.init = function(l_1_0, l_1_1)
  Action.init(l_1_0)
  if not l_1_1 or not 0 then
    l_1_0.duration = Door.OpenAction.DEFAULT_DURATION
  end
  l_1_0.elapsed = 0
end

Door.OpenAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  if l_2_0.duration > 0 then
    local xPos, yPos, zPos = l_2_0.entity.prop:getLoc()
    local xRot, yRot, zRot = l_2_0.entity.prop:getRot()
    local xScl, yScl, zScl = l_2_0.entity.prop:getScl()
    l_2_0.easeDriver = l_2_0.entity.prop:seek(xPos, yPos, zPos, 0, yRot, zRot, Door.OPEN_SCALE, Door.OPEN_SCALE, 1, l_2_0.duration, MOAIEaseType.SMOOTH)
  end
end

Door.OpenAction.tick = function(l_3_0)
  return not l_3_0.easeDriver or l_3_0.easeDriver:getTimesExecuted() < 1
end

Door.OpenAction.stop = function(l_4_0)
  l_4_0.entity.isOpen = true
  Action.stop(l_4_0)
end

Door.CloseAction = require("Class").create(Action, "Door.CloseAction")
Door.CloseAction.DEFAULT_DURATION = 0.5
Door.CloseAction.init = function(l_5_0, l_5_1)
  Action.init(l_5_0)
  if not l_5_1 or not 0 then
    l_5_0.duration = Door.CloseAction.DEFAULT_DURATION
  end
end

Door.CloseAction.start = function(l_6_0, l_6_1)
  Action.start(l_6_0, l_6_1)
  if l_6_0.duration > 0 then
    local xPos, yPos, zPos = l_6_0.entity.prop:getLoc()
    local xRot, yRot, zRot = l_6_0.entity.prop:getRot()
    local xScl, yScl, zScl = l_6_0.entity.prop:getScl()
    l_6_0.easeDriver = l_6_0.entity.prop:seek(xPos, yPos, zPos, 90, yRot, zRot, Door.CLOSED_SCALE, Door.CLOSED_SCALE, 1, l_6_0.duration, MOAIEaseType.LINEAR)
  end
  l_6_0.entity.isOpen = false
end

Door.CloseAction.tick = function(l_7_0)
  return not l_7_0.easeDriver or l_7_0.easeDriver:getTimesExecuted() < 1
end

Door.OPEN_SCALE = 0.5
Door.CLOSED_SCALE = 0.05
Door.init = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  Entity.init(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4)
  PhysicsComponent.new(l_8_0, 0, 0, PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  SpriteComponent.new(l_8_0, "Particles/Textures/SwirlCore/SwirlCore")
  SoundComponent.new(l_8_0)
  l_8_0.isOpen = false
  local physics = l_8_0:get(PhysicsComponent)
  physics.fixture = physics.body:addCircle(0, 0, 48)
  physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
  physics.fixture:setSensor(true)
  l_8_0.portalShader = Shader.load("Content/Game/Global/Shaders/Portal")
  l_8_0:setDefaultShader(l_8_0.portalShader)
  local sprite = l_8_0:get(SpriteComponent)
  sprite.prop:setPriority(-200)
  l_8_0.prop:setScl(Door.OPEN_SCALE)
  l_8_0.onExit = Delegate.new()
  l_8_0:get(PhysicsComponent):setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY, l_8_0.onHitDynamic, l_8_0, MOAIBox2DArbiter.BEGIN)
  l_8_0:get(SoundComponent):playCue("SFX/Objects/CodePortal_Loop", true)
end

Door.open = function(l_9_0, l_9_1)
  if not l_9_0.isOpen then
    l_9_0:forceAction(l_9_0.OpenAction.new(l_9_1))
  end
end

Door.close = function(l_10_0, l_10_1)
  if l_10_0.isOpen then
    l_10_0:forceAction(l_10_0.CloseAction.new(l_10_1))
  end
end

Door.onHitDynamic = function(l_11_0, l_11_1)
  local Alice = Entity.cache:load("Content/Game/Global/Entities/Alice")
  l_11_0:room():queueUpdate(function()
    if self.isOpen and entity and entity.host and entity:is(Alice) then
      self.onExit:dispatch()
      entity:teleportInCodeRoom(self, nil)
    end
   end)
end

return Door

