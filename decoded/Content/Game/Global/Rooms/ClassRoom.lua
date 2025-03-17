-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Rooms\ClassRoom.lua 

local Class = require("Class")
local Room = require("Room")
local MachineRoom = Room.cache:load("Content/Game/Global/Rooms/MachineRoom")
local CollisionArea = require("CollisionArea")
local Direction = require("Direction")
local Disassembly = require("Disassembly")
local Entity = require("Entity")
local Font = require("Font")
local Layout = require("Layout")
local FunctionComponent = require("Components.FunctionComponent")
local ClassRoom = Class.create(MachineRoom, "ClassRoom")
ClassRoom.SIGNPOST_DIAMETER = 300
ClassRoom.MINIMUM_SIGNPOST_RADIUS = 300
ClassRoom.ROOM_COLOR = {0.76470588235294, 0.5843137254902, 0.55686274509804, 1}
ClassRoom.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  if not l_1_3 then
    l_1_3 = "@Data/Content/Game/DourTower/Entities/WizardBat_Roof.lua"
  end
  if l_1_3:sub(1, 1) == "@" then
    l_1_3 = l_1_3:sub(2)
  end
  local prototype = loadfile(l_1_3)
  local disassembly = Disassembly.new(prototype)
  local shortName = l_1_3
  for part in l_1_3:gmatch("[^/]+") do
    shortName = part
  end
  local classMethods = {}
  local lastExpression = disassembly.prototype.expressions[#disassembly.prototype.expressions - 1]
  if lastExpression and lastExpression:is(Disassembly.RETURN) and #lastExpression.results > 0 then
    local firstReturn = lastExpression.results[1]
    for i,expression in ipairs(disassembly.prototype.expressions) do
      if expression:is(Disassembly.SETTABLE) and expression.target == firstReturn and expression.value:is(Disassembly.CLOSURE) and expression.key:is(Disassembly.Constant) and type(expression.key:getConstant()) == "string" then
        local methodName = expression.key:getConstant()
        table.insert(classMethods, {name = methodName, prototype = expression.value.childPrototype})
      end
    end
  end
  local radius = l_1_0.MINIMUM_SIGNPOST_RADIUS
  local signpostArc = 0
  if #classMethods ~= 0 then
    signpostArc = 2 * math.pi / #classMethods
    local signpostRadius = l_1_0.SIGNPOST_DIAMETER / (2 * math.tan(signpostArc * 0.5))
    if radius < signpostRadius then
      radius = signpostRadius
    end
  end
  local totalDiameter = 2 * radius + l_1_0.SIGNPOST_DIAMETER
  Class.super(ClassRoom).init(l_1_0, l_1_1, l_1_2, l_1_3, totalDiameter, totalDiameter)
  local centerX, centerY = l_1_0.sizeX * 0.5, totalDiameter * 0.5 + l_1_0.borders.S
  local gameplay = l_1_0:getLayerByOrder(0)
  Entity.create("Content/Game/DourTower/Entities/NamePlaque", gameplay, l_1_0.sizeX * 0.5, l_1_0.sizeY - l_1_0.borders.N * 0.5, "Room name", Direction.DIR_S, shortName, 1, l_1_0.ROOM_COLOR, 128, Font.TITLE_PATH)
  local spawner = Entity.create("Content/Game/Global/Entities/Locator", gameplay, centerX, centerY + 200, "Hero Spawner")
  local theta = 0
  for i = 1, #classMethods do
    local methodInfo = classMethods[i]
    local x, y = centerX + radius * math.sin(theta), centerY + radius * math.cos(theta)
    local signpost = Entity.create("Content/Game/MachineRooms/Entities/Signpost", gameplay, x, y + 100, methodInfo.name)
    signpost:get(FunctionComponent):setPrototype(methodInfo.prototype)
    theta = theta + signpostArc
  end
end

ClassRoom.savePrototype = function(l_2_0)
end

return ClassRoom

