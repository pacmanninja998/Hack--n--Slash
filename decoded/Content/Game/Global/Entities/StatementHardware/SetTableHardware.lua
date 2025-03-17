-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\SetTableHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local Decompiler = require("Decompiler")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local SetTableHardware = Class.create(StatementHardware, "SetTableHardware")
SetTableHardware.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/GenericHardware/GenericHardware")
  AnimatorComponent.new(l_1_0, true, l_1_5)
  l_1_0:get(AnimatorComponent):play("Machine03", 0)
  l_1_0:setHitboxBody()
  local wireDiffX, wireDiffY = l_1_0:placeStartWires(l_1_2, l_1_3)
  l_1_0:attachInput("input 1", nil, l_1_0.statement, "targetTable")
  l_1_0:attachInput("input 2", nil, l_1_0.statement, "key")
  l_1_0:attachInput("input 3", nil, l_1_0.statement, "value")
  l_1_0:placeEndWires(-wireDiffX)
  if l_1_0.statement.value:is(Decompiler.Closure) and l_1_0.statement.key:is(Decompiler.Constant) then
    local keyStr = tostring(l_1_0.statement.key:getConstant())
    local closureCrystal = l_1_0.codeRoom.statementOutputCrystalMap[l_1_0.statement.value]
    if closureCrystal then
      local closureHardware = closureCrystal
      local ClosureHardware = StatementHardware.loadHardwareClass("ClosureHardware")
      repeat
        if closureHardware and not closureHardware:is(ClosureHardware) then
          closureHardware = closureHardware.parent
        elseif closureHardware and closureHardware:is(ClosureHardware) then
          closureHardware:setFnName(keyStr)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return SetTableHardware

