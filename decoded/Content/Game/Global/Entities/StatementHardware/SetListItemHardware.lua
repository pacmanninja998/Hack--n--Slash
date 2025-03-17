-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\SetListItemHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local Decompiler = require("Decompiler")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SetListItemHardware = Class.create(StatementHardware, "SetListItemHardware")
SetListItemHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine03", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0.listIndex = Decompiler.LFIELDS_PER_FLUSH * l_1_0.statement.block + l_1_8
  l_1_0.value = l_1_0.statement.values[l_1_8]
  l_1_0:attachInput("input 1", nil, l_1_0.statement, "targetTable")
  l_1_0:attachInput("input 3", nil, l_1_0.statement.values, l_1_8)
  l_1_0:placeEndWires(-wireDiffX)
end

SetListItemHardware.labelHardware = function(l_2_0, l_2_1)
  StatementHardware.labelHardware(l_2_0, l_2_1)
  local text = Decompiler.makeIOStr(l_2_1, l_2_0.statement.targetTable, "table") .. "[" .. tostring(l_2_0.listIndex) .. "] = " .. Decompiler.makeIOStr(l_2_1, l_2_0.value, "value")
  if text then
    l_2_0:setLabelText(text)
  end
end

return SetListItemHardware

