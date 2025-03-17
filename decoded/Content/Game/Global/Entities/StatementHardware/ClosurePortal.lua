-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\ClosurePortal.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local Room = require("Room")
local CollisionArea = require("CollisionArea")
local Shader = require("Shader")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local HealthComponent = require("Components.HealthComponent")
local PlatformComponent = require("Components.PlatformComponent")
local SoundComponent = require("Components.SoundComponent")
local ClosurePortal = Class.create(StatementHardware, "ClosurePortal")
ClosurePortal.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.CodeRoom = Room.cache:load("Content/Game/Global/Rooms/CodeRoom")
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.SENSOR_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  SpriteComponent.new(l_1_0, "Particles/Textures/SwirlCore/SwirlCore")
  SoundComponent.new(l_1_0)
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture = physics.body:addCircle(0, 0, 48)
  physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
  physics.fixture:setSensor(true)
  physics:setCollisionHandler(PhysicsComponent.DYNAMIC_CATEGORY, l_1_0.onHitDynamic, l_1_0, MOAIBox2DArbiter.BEGIN)
  local sprite = l_1_0:get(SpriteComponent)
  sprite.prop:setPriority(-200)
  l_1_0.prop:setScl(0.5)
  l_1_0.codeRoomData = {fnData = {fnParent = l_1_0.statement.decompiler.disassembly.protos, fnKey = l_1_0.statement.functionIndex + 1, fnParentDecompiler = l_1_0.statement.decompiler}, type = l_1_0.CodeRoom.TYPE_KEYVAL_DIS, name = l_1_8, parent = l_1_7}
  l_1_0.fnName = ""
  if type(l_1_8) == "string" then
    l_1_0.fnName = l_1_8
  end
  l_1_0.portalShader = Shader.load("Content/Game/Global/Shaders/Portal")
  l_1_0:setDefaultShader(l_1_0.portalShader)
end

ClosurePortal.isProtected = function(l_2_0)
  if l_2_0.fnName:find("PROTECTED") then
    return true
  end
end

ClosurePortal.onHitDynamic = function(l_3_0, l_3_1)
  if l_3_0.action then
    return 
  end
  if not l_3_1.teleportInCodeRoom then
    return 
  end
  if l_3_0:isProtected() then
    l_3_1:get(HealthComponent):damageKnockback(1, l_3_0, 400)
  else
    l_3_1:teleportInCodeRoom(l_3_0, l_3_0.codeRoomData, 2)
  end
end

ClosurePortal.labelHardware = function(l_4_0, l_4_1)
  StatementHardware.labelHardware(l_4_0, l_4_1)
  l_4_0:setLabelText(l_4_0.fnName)
end

ClosurePortal.tick = function(l_5_0)
  StatementHardware.tick(l_5_0)
  local protectionAmount = 0
  if l_5_0:isProtected() then
    protectionAmount = 0.8
  end
  l_5_0:get(SpriteComponent).material:setShaderValue("protectionAmount", MOAIMaterial.VALUETYPE_FLOAT, protectionAmount)
end

return ClosurePortal

