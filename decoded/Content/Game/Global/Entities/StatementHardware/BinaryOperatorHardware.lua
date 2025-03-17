-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\BinaryOperatorHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local BinaryOperatorHardware = Class.create(StatementHardware, "BinaryOperatorHardware")
BinaryOperatorHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine05", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0:attachInput("input 1", nil, l_1_0.statement, "left")
  l_1_0:attachOutput()
  l_1_0:attachInput("input 3", nil, l_1_0.statement, "right")
  l_1_0:attachFloatingText(l_1_8)
  local jointX, jointY = l_1_0:get(AnimatorComponent):getJointLoc("equals", true)
  if jointX and jointY then
    jointX, jointY = l_1_0.prop:modelToWorld(jointX, jointY, 0)
    l_1_0.equalsSign = l_1_0:addChild("OperatorText", l_1_0.layer, jointX, jointY, l_1_0.name .. " equals sign", Direction.DIR_S, l_1_6, l_1_7, "Equal")
  end
  l_1_0:placeEndWires(-wireDiffX)
end

return BinaryOperatorHardware

