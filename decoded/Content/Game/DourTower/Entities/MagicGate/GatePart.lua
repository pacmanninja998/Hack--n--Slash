-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\MagicGate\GatePart.lua 

local Class = require("Class")
local Entity = require("Entity")
local GatePart = Class.create(Entity, "GatePart")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
GatePart.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Class.super(GatePart).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DourTower/MagicGate/MagicGate", l_1_4)
  l_1_0.direction = l_1_5
  l_1_0:setLabelText("")
  local gatePort = l_1_0:room():getEntity("GatePort")
  gatePort.schemas.OPEN_AMOUNT:registerValueSetHandler(gatePort, l_1_0.onGatePortOpenAmountSet, l_1_0)
end

GatePart.onGatePortOpenAmountSet = function(l_2_0, l_2_1)
  local dirX, dirY = Direction.dirToVector(l_2_0.direction)
  l_2_0.prop:setPiv(-dirX * l_2_1, -dirY * l_2_1)
end

return GatePart

