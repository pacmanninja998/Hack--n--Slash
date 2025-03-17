-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware.lua 

local Action = require("Action")
local Class = require("Class")
local Entity = require("Entity")
local Decompiler = require("Decompiler")
local Direction = require("Direction")
local SpriteSheet = require("SpriteSheet")
local Room = require("Room")
local CollisionArea = require("CollisionArea")
local Delegate = require("DFMoai.Delegate")
local Math = require("DFCommon.Math")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local InteractionComponent = require("Components.InteractionComponent")
local FunctionComponent = require("Components.FunctionComponent")
local PlatformComponent = require("Components.PlatformComponent")
local StatementHardware = Class.create(Entity, "StatementHardware")
{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.ForPrep] = "ForPrepHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.GenericForLoop] = "GenericForLoopHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Call] = "CallHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.NewTable] = "NewTableHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Closure] = "ClosureHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Argument] = "ArgumentHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.GetUpvalue] = "GetUpvalueHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Upvalue] = "GetUpvalueHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.LoadConstant] = "LoadConstantHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Constant] = "LoadConstantHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.GetGlobal] = "GetGlobalHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.GetTable] = "GetTableHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.SetTable] = "SetTableHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.SetList] = "SetListHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Length] = "LengthHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Not] = "NotHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Move] = "MoveHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Add] = "AddHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Subtract] = "SubtractHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Multiply] = "MultiplyHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Divide] = "DivideHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Power] = "PowerHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Modulus] = "ModulusHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Self] = "SelfHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Jump] = "JumpHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Concatenate] = "ConcatenateHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

{Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}[Decompiler.Return] = "ReturnHardware"
 -- DECOMPILER ERROR: Confused about usage of registers!

StatementHardware.statementHardwareNames = {Decompiler.LoadNil = "LoadNilHardware", Decompiler.LoadBool = "LoadBoolHardware", Decompiler.EqualityConditional = "EqualityConditionalHardware", Decompiler.LessThanConditional = "LessThanConditionalHardware", Decompiler.LessThanOrEqualConditional = "LessThanOrEqualConditionalHardware", Decompiler.TestConditional = "TestConditionalHardware", Decompiler.TestSetConditional = "TestSetConditionalHardware", Decompiler.ForLoop = "ForLoopHardware"}
StatementHardware.loadHardwareClass = function(l_1_0)
  return Entity.cache:load("Content/Game/Global/Entities/StatementHardware/" .. l_1_0)
end

StatementHardware.createHardware = function(l_2_0, ...)
  return Entity.create("Content/Game/Global/Entities/StatementHardware/" .. l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

StatementHardware.getHardwareName = function(l_3_0)
  if (not l_3_0:is(Decompiler.LoadConstant) or not l_3_0.constant) and l_3_0:is(Decompiler.Constant) then
    local constantStatement = not l_3_0:is(Decompiler.LoadConstant) and not l_3_0:is(Decompiler.Constant) or l_3_0
  end
  do
    if constantStatement then
      local constantValue = constantStatement:getConstant()
      if type(constantValue) == "boolean" then
        return "LoadBooleanConstantHardware"
      else
        if type(constantValue) == "number" then
          return "LoadNumberConstantHardware"
        else
          if type(constantValue) == "string" then
            return "LoadStringConstantHardware"
          end
          do return end
          return StatementHardware.statementHardwareNames[l_3_0:class()]
        end
      end
    end
  end
end

StatementHardware.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5, l_4_6, l_4_7)
  if not l_4_4 and l_4_6 then
    if l_4_6:is(Decompiler.Statement) then
      l_4_4 = string.format("Statement %d", l_4_6.pc)
    else
      l_4_4 = l_4_6:printCode()
    end
  end
  Entity.init(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  l_4_0.facingDir = l_4_5
  l_4_0.statement = l_4_6
  l_4_0.codeRoom = l_4_7
  l_4_0.ends = {}
  l_4_0.children = {}
  l_4_0.nextHardwares = {}
  l_4_0.prevHardwares = {}
  l_4_0.editable = true
  l_4_0:setLabelText("")
  if l_4_0.statement then
    l_4_0:filterHardware()
  end
end

StatementHardware.filterHardware = function(l_5_0)
  if l_5_0.statement.registerNames then
    for i,name in ipairs(l_5_0.statement.registerNames) do
      if name == "magicSealActive" then
        l_5_0.editable = false
      end
    end
  end
end

StatementHardware.isHackable = function(l_6_0)
  if l_6_0.editable then
    return l_6_0.onFieldSet
  end
end

StatementHardware.startOffset = function(l_7_0, l_7_1)
  return 0, 0
end

StatementHardware.execShaderFn = function(l_8_0, l_8_1, ...)
  l_8_1(l_8_0, ...)
  local HackPort = StatementHardware.loadHardwareClass("HackPort")
  local InputTube = StatementHardware.loadHardwareClass("InputTube")
  do
    local OutputMonitor = StatementHardware.loadHardwareClass("OutputMonitor")
    for _,child in ipairs(l_8_0.children) do
      if child:is(HackPort) or child:is(InputTube) or child:is(OutputMonitor) then
        l_8_1(child, ...)
      end
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

StatementHardware.setDefaultShader = function(l_9_0, l_9_1)
  l_9_0:execShaderFn(Entity.setDefaultShader, l_9_1)
end

StatementHardware.setCurrentShader = function(l_10_0, l_10_1)
  l_10_0:execShaderFn(Entity.setCurrentShader, l_10_1)
end

StatementHardware.resetShader = function(l_11_0)
  l_11_0:execShaderFn(Entity.resetShader)
end

StatementHardware.getBounds = function(l_12_0)
  local minX, minY, maxX, maxY = l_12_0:getWorldBounds()
  local IOCrystal = StatementHardware.loadHardwareClass("IOCrystal")
  for _,child in ipairs(l_12_0.children) do
    if not child:is(IOCrystal) then
      local childMinX, childMinY, childMaxX, childMaxY = child:getBounds()
      minX, minY, maxX, maxY = math.min(minX, childMinX), math.min(minY, childMinY), math.max(maxX, childMaxX), math.max(maxY, childMaxY)
    end
  end
  return minX, minY, maxX, maxY
end

StatementHardware.move = function(l_13_0, l_13_1, l_13_2)
  local posX, posY = l_13_0:getPosition()
  l_13_0:setPosition(posX + l_13_1, posY + l_13_2, true)
  for dir,endPoint in pairs(l_13_0.ends) do
    if endPoint then
      endPoint.x, endPoint.y = endPoint.x + l_13_1, endPoint.y + l_13_2
    end
  end
  for _,child in ipairs(l_13_0.children) do
    child:move(l_13_1, l_13_2)
  end
end

StatementHardware.setEnd = function(l_14_0, l_14_1, l_14_2, l_14_3)
  if type(l_14_2) == "number" and type(l_14_3) == "number" then
    l_14_0.ends[l_14_1] = {x = l_14_2, y = l_14_3}
  else
    if (type(l_14_2) == "table" or type(l_14_2) == "boolean") and not l_14_3 then
      l_14_0.ends[l_14_1] = l_14_2
    elseif not l_14_2 and not l_14_3 then
      l_14_0.ends[l_14_1] = nil
    end
  end
end

StatementHardware.getEnd = function(l_15_0, l_15_1)
  local endPoint = l_15_0.ends[l_15_1]
  if endPoint == nil then
    local animator = l_15_0:get(AnimatorComponent)
    if animator then
      local jointX, jointY = animator:getJointLoc(Direction.dirToName(l_15_1), true)
      if jointX and jointY then
        local worldX, worldY = l_15_0.prop:modelToWorld(jointX, jointY, 0)
        endPoint = {x = worldX, y = worldY}
      end
    end
  end
  return endPoint
end

StatementHardware.addChild = function(l_16_0, l_16_1)
  table.insert(l_16_0.children, l_16_1)
  l_16_1.parent = l_16_0
  return l_16_1
end

StatementHardware.appendRaw = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, ...)
  local endPoint = l_17_0:getEnd(l_17_3)
  if endPoint then
    local posX, posY = endPoint.x, endPoint.y
    local hardwareEntity = StatementHardware.createHardware(l_17_2, l_17_0.layer, posX, posY, ...)
    if l_17_4 then
      l_17_4:addChild(hardwareEntity)
    end
    l_17_0:setNextHardware(l_17_3, hardwareEntity, l_17_1)
    do
      local Wire = StatementHardware.loadHardwareClass("Wire")
      if l_17_0:is(Wire) and hardwareEntity:is(Wire) and l_17_0.endDir and hardwareEntity.startDir and l_17_0.endDir ~= Direction.rotate(hardwareEntity.startDir, 4) then
        local patch = StatementHardware.createHardware("Wire", l_17_0.layer, posX, posY, l_17_0.name .. " wire patch")
        if l_17_4 then
          l_17_4:addChild(patch)
        end
        l_17_0:setPatch(patch, l_17_0.endDir)
      end
      return hardwareEntity
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

StatementHardware.append = function(l_18_0, l_18_1, l_18_2, l_18_3, ...)
  return l_18_0:appendRaw(false, l_18_1, l_18_2, l_18_3, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

StatementHardware.attachInput = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4, l_19_5, l_19_6, l_19_7)
  local hardwarePosX, hardwarePosY = l_19_0:getPosition()
  local posX, posY = hardwarePosX, hardwarePosY
  local statement = Decompiler.getSourceStatement(l_19_3[l_19_4])
  if not l_19_5 then
    l_19_5 = l_19_0.statement.pc
  end
  if l_19_1 and l_19_2 and type(l_19_1) == "number" and type(l_19_2) == "number" then
    posX = posX + l_19_1
    posY = posY + l_19_2
  elseif not l_19_2 and (not l_19_1 or type(l_19_1) == "string") then
    local jointName = l_19_1 or "input"
    local animator = l_19_0:get(AnimatorComponent)
    if animator then
      local jointX, jointY = animator:getJointLoc(jointName, true)
      if jointX and jointY then
        posX, posY = l_19_0.prop:modelToWorld(jointX, jointY, 0)
      end
    end
  end
  local priority = l_19_0:get(SpriteComponent).prop:getPriority()
  local rootY = hardwarePosY - priority
  local ioCrystal = nil
  if l_19_6 then
    ioCrystal = l_19_0:addChild(StatementHardware.createHardware("IOCrystal", l_19_0.layer, posX, posY, l_19_0.name .. " input crystal", Direction.DIR_S, statement, l_19_0.codeRoom, true, l_19_3, l_19_4, l_19_5, l_19_7))
  else
    local tube = l_19_0:addChild(StatementHardware.createHardware("InputTube", l_19_0.layer, posX, posY, l_19_0.name .. " input tube", Direction.DIR_S, statement, l_19_0.codeRoom, true, l_19_3, l_19_4, l_19_5, l_19_7))
    tube:get(SpriteComponent).prop:setPriority(posY - rootY + 1)
    ioCrystal = tube.ioCrystal
  end
  local crystalX, crystalY = ioCrystal:getPosition()
  ioCrystal:get(SpriteComponent).prop:setPriority(crystalY - rootY + 2)
  local r, g, b = nil, nil, nil
  local outputCrystal = l_19_0.codeRoom.statementOutputCrystalMap[statement]
  if outputCrystal then
    r, g, b = outputCrystal:getColor()
  else
    l_19_0.codeRoom:appendIO(statement, l_19_0)
    outputCrystal = l_19_0.codeRoom.statementOutputCrystalMap[statement]
    assert(outputCrystal)
    r, g, b = outputCrystal:getColor()
  end
  outputCrystal.inputCrystals:addEntity(ioCrystal)
  if not r or not g or not b then
    r, g, b = 0, 0, 0
  end
  ioCrystal:setColor(r, g, b)
  return ioCrystal
end

StatementHardware.attachOutput = function(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4, l_20_5, l_20_6, l_20_7, l_20_8)
  local hardwarePosX, hardwarePosY = l_20_0:getPosition()
  local posX, posY = hardwarePosX, hardwarePosY
  if not l_20_3 or not l_20_4 or not l_20_3[l_20_4] then
    local statement = l_20_0.statement
  end
  statement = Decompiler.getSourceStatement(statement)
  local OutputMonitor = StatementHardware.loadHardwareClass("OutputMonitor")
  local monitorOffset = 0
  if l_20_1 and l_20_2 and type(l_20_1) == "number" and type(l_20_2) == "number" then
    posX = posX + l_20_1
    posY = posY + l_20_2
  elseif not l_20_2 then
    if not l_20_1 then
      local jointName = l_20_1 and type(l_20_1) ~= "string" or "output"
    end
    local animator = l_20_0:get(AnimatorComponent)
    do
      if animator then
        local jointX, jointY = animator:getJointLoc(jointName, true)
        if jointX and jointY then
          posX, posY = l_20_0.prop:modelToWorld(jointX, jointY, 0)
        end
        do return end
        if type(l_20_1) == "table" and l_20_1.is and l_20_1:is(OutputMonitor) then
          local monitorEnd = l_20_1:getEnd(Direction.DIR_E)
          posX, posY = monitorEnd.x, monitorEnd.y
          l_20_7 = false
          monitorOffset = 2
        end
      end
    end
  end
  local priority = l_20_0:get(SpriteComponent).prop:getPriority()
  local rootY = hardwarePosY - priority
  local ioCrystal, monitor = nil, nil
  if l_20_6 then
    ioCrystal = l_20_0:addChild(StatementHardware.createHardware("IOCrystal", l_20_0.layer, posX, posY, l_20_0.name .. " output crystal", Direction.DIR_S, statement, l_20_0.codeRoom, false, l_20_3, l_20_4, l_20_5))
  else
    monitor = l_20_0:addChild(StatementHardware.createHardware("OutputMonitor", l_20_0.layer, posX, posY, l_20_0.name .. " output monitor", Direction.DIR_S, statement, l_20_0.codeRoom, false, l_20_3, l_20_4, l_20_5, l_20_7))
    if l_20_7 then
      monitor:get(SpriteComponent).prop:setPriority(posY - rootY + 1 + monitorOffset)
    else
      monitor:get(SpriteComponent).prop:setPriority(posY - rootY - 1 + monitorOffset)
      ioCrystal = monitor.ioCrystal
    end
    local crystalX, crystalY = ioCrystal:getPosition()
    ioCrystal:get(SpriteComponent).prop:setPriority(crystalY - rootY + 2)
    if l_20_8 then
      local sclX, sclY = ioCrystal.prop:getScl()
      ioCrystal.prop:setScl(sclX * l_20_8, sclY * l_20_8)
    end
    for i,otherCrystal in ipairs(l_20_0.codeRoom.outputCrystals) do
      assert(otherCrystal.statement ~= statement)
    end
    table.insert(l_20_0.codeRoom.outputCrystals, ioCrystal)
    assert(not l_20_0.codeRoom.statementOutputCrystalMap[statement])
    l_20_0.codeRoom.statementOutputCrystalMap[statement] = ioCrystal
    local hue = l_20_0.codeRoom.curCrystalHue
    l_20_0.codeRoom.curCrystalHue = (l_20_0.codeRoom.curCrystalHue + l_20_0.codeRoom.crystalHueInterval) % 1
    do
      local r, g, b = Math.hsl2rgb(hue, 1, 0.5)
      ioCrystal:setColor(r, g, b)
      return ioCrystal, monitor
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StatementHardware.attachFloatingText = function(l_21_0, l_21_1, l_21_2)
  if not l_21_2 then
    l_21_2 = "display"
  end
  local animator = l_21_0:get(AnimatorComponent)
  if animator then
    local jointX, jointY = animator:getJointLoc(l_21_2, true)
    if jointX and jointY then
      local textX, textY = l_21_0.prop:modelToWorld(jointX, jointY, 0)
      l_21_0.floatingText = l_21_0:addChild(StatementHardware.createHardware("OperatorText", l_21_0.layer, textX, textY, l_21_0.name .. " text: " .. l_21_1, Direction.DIR_S, l_21_0.statement, l_21_0.codeRoom, l_21_1))
      local posX, posY = l_21_0:getPosition()
      local priority = l_21_0:get(SpriteComponent).prop:getPriority()
      local rootY = posY - priority
      l_21_0.floatingText:get(SpriteComponent).prop:setPriority(textY - rootY + 1000)
    end
  end
end

StatementHardware.attachHackPort = function(l_22_0, l_22_1)
  if not l_22_1 then
    l_22_1 = "hack"
  end
  local animator = l_22_0:get(AnimatorComponent)
  if animator then
    local jointX, jointY = animator:getJointLoc(l_22_1)
    if jointX and jointY then
      local hackPortX, hackPortY = l_22_0.prop:modelToWorld(jointX, jointY, 0)
      l_22_0.hackPort = l_22_0:addChild(StatementHardware.createHardware("HackPort", l_22_0.layer, hackPortX, hackPortY, l_22_0.name .. " HackPort"))
      local posX, posY = l_22_0:getPosition()
      local priority = l_22_0:get(SpriteComponent).prop:getPriority()
      local rootY = posY - priority
      l_22_0.hackPort:get(SpriteComponent).prop:setPriority(hackPortY - rootY)
    end
  end
end

StatementHardware.labelHardware = function(l_23_0, l_23_1)
  if l_23_0.statement then
    local text = l_23_0.statement:printLabel(l_23_1)
    if text then
      l_23_0:setLabelText(text)
      local animator = l_23_0:get(AnimatorComponent)
      if animator then
        local jointX, jointY = animator:getJointLoc("label")
        if jointX and jointY then
          l_23_0.label.textBox:setLoc(jointX, jointY)
        else
          jointX, jointY = animator:getJointLoc("display")
          if jointX and jointY then
            l_23_0.label.textBox:setLoc(jointX, jointY)
          end
        end
      end
    end
    for i,child in ipairs(l_23_0.children) do
      child:labelHardware(l_23_1)
    end
  end
end

StatementHardware.setHitboxBody = function(l_24_0, l_24_1, l_24_2)
  if not l_24_1 then
    l_24_1 = "body"
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_24_0:get(AnimatorComponent):enableHitboxBody(true, l_24_2)
end

StatementHardware.placeStartWires = function(l_25_0, l_25_1, l_25_2)
  local startEnd = l_25_0:getEnd(Direction.DIR_N)
  local diffX, diffY = startEnd.x - l_25_1, startEnd.y - l_25_2
  if diffY < 0 and diffX > 0 then
    local scaleY = -diffY / 64
    l_25_0.verticalStartWire = StatementHardware.createHardware("Wire", l_25_0.layer, l_25_1, l_25_2, l_25_0.name .. " verticalStartWire", Direction.DIR_N, Direction.DIR_S, scaleY, {0, 1, 1, 1})
    l_25_0:addChild(l_25_0.verticalStartWire)
    local scaleX = diffX / 64
    l_25_0.horizontalStartWire = l_25_0.verticalStartWire:append("Wire", Direction.DIR_E, l_25_0, l_25_0.name .. " horizontalStartWire", Direction.DIR_W, Direction.DIR_E, scaleX, {0, 1, 1, 1})
    l_25_0.horizontalStartWire:setNextHardware(Direction.DIR_E, l_25_0, true)
    return diffX, diffY
  end
end

StatementHardware.placeEndWires = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4)
  if not l_26_3 or not l_26_4 then
    local endPoint = l_26_0:getEnd(Direction.DIR_S)
    l_26_3, l_26_4 = endPoint.x, endPoint.y
  end
  if not l_26_2 then
    l_26_1, l_26_2 = l_26_1 or -32, -64
  end
  local scaleX = -(l_26_1) / 64
  l_26_0.horizontalEndWire = StatementHardware.createHardware("Wire", l_26_0.layer, l_26_3, l_26_4, l_26_0.name .. " horizontalEndWire", Direction.DIR_E, Direction.DIR_W, scaleX, {1, 1, 0, 1})
  l_26_0:addChild(l_26_0.horizontalEndWire)
  local scaleY = -l_26_2 / 64
  l_26_0.verticalEndWire = l_26_0.horizontalEndWire:append("Wire", Direction.DIR_S, l_26_0, l_26_0.name .. " verticalEndWire", Direction.DIR_N, Direction.DIR_S, scaleY, {1, 1, 0, 1})
  l_26_0:setEnd(Direction.DIR_S, l_26_0.verticalEndWire:getEnd(Direction.DIR_S))
  return l_26_0.verticalEndWire
end

StatementHardware.getNextHardware = function(l_27_0, l_27_1)
  local EmptySpacer = StatementHardware.loadHardwareClass("EmptySpacer")
  do
    local nextHardware = l_27_0.nextHardwares[l_27_1]
    repeat
      repeat
        repeat
          if nextHardware and nextHardware:is(EmptySpacer) then
            local newNextHardware = nextHardware.nextHardwares[l_27_1]
            if newNextHardware then
              nextHardware = newNextHardware
            else
              for _,cardinalDir in ipairs(Direction.CARDINALS) do
                newNextHardware = nextHardware.nextHardwares[cardinalDir]
                if newNextHardware then
                  nextHardware = newNextHardware
              else
                end
              end
            else
              return nextHardware
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StatementHardware.getPrevHardware = function(l_28_0, l_28_1)
  local EmptySpacer = StatementHardware.loadHardwareClass("EmptySpacer")
  do
    local prevHardware = l_28_0.prevHardwares[l_28_1]
    repeat
      if prevHardware and prevHardware:is(EmptySpacer) then
        prevHardware = prevHardware.prevHardwares[l_28_1]
      else
        return prevHardware
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StatementHardware.setNextHardware = function(l_29_0, l_29_1, l_29_2, l_29_3)
  if not l_29_3 or not l_29_2 then
    l_29_2 = l_29_2:getStartHardware()
  end
  if not l_29_3 or not l_29_0 then
    local prevHardware = l_29_0:getEndHardware()
  end
  prevDirection = Direction.rotate(l_29_1, 4)
  assert((not prevHardware.nextHardwares[l_29_1] and not l_29_2.prevHardwares[prevDirection]))
  prevHardware.nextHardwares[l_29_1] = l_29_2
  l_29_2.prevHardwares[prevDirection] = prevHardware
end

StatementHardware.getStartHardware = function(l_30_0)
  return l_30_0.verticalStartWire or l_30_0
end

StatementHardware.getEndHardware = function(l_31_0)
  return l_31_0.verticalEndWire or l_31_0
end

StatementHardware.giveWireArrow = function(l_32_0, l_32_1, l_32_2)
  if l_32_0.horizontalEndWire then
    l_32_1:setParent(l_32_0.horizontalEndWire)
  end
end

return StatementHardware

