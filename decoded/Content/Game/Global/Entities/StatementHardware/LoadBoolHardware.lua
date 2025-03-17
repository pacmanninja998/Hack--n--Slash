-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\LoadBoolHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local LoadBoolHardware = Class.create(StatementHardware, "LoadBoolHardware")
LoadBoolHardware.addBooleanField("VALUE", false)
LoadBoolHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine05", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0:attachOutput()
  l_1_0:placeEndWires(-wireDiffX)
  l_1_0.VALUE = l_1_0.statement.boolean == 1
  l_1_0:attachHackPort()
  l_1_0:attachFloatingText(l_1_0.VALUE and "True" or "False")
end

LoadBoolHardware.onFieldSet = function(l_2_0, l_2_1, l_2_2)
  if not l_2_2 or not 1 then
    local newBoolean = l_2_1 ~= "VALUE" or type(l_2_2) ~= "boolean" or 0
  end
  if l_2_0.statement.boolean ~= newBoolean then
    l_2_0.statement.boolean = newBoolean
    l_2_0.floatingText:setFrame(l_2_2 and "True" or "False")
    l_2_0.codeRoom:onStatementChanged(l_2_0)
  end
end

return LoadBoolHardware

