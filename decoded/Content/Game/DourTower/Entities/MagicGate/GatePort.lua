-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\MagicGate\GatePort.lua 

local Class = require("Class")
local Entity = require("Entity")
local GatePort = Class.create(Entity, "GatePort")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
GatePort.addIntegerField("OPEN_AMOUNT", 0, 0, 350)
GatePort.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DourTower/MagicGate/MagicGate", l_1_4)
  PhysicsComponent.new(l_1_0, {rect = {-32, -16, 32, 32}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_1_0.schemas.OPEN_AMOUNT:registerValueSetHandler(l_1_0, l_1_0.PROTECTED_onOpenAmountChanged, l_1_0)
end

GatePort.PROTECTED_onOpenAmountChanged = function(l_2_0, l_2_1)
  local room = l_2_0:room()
  if l_2_0.OPEN_AMOUNT > 10 then
    room:triggerTraps()
    local activateGateTraps = false
    if l_2_0.OPEN_AMOUNT == 350 then
      activateGateTraps = true
    end
    room:activateGateTraps(activateGateTraps)
  end
end

GatePort.isHackable = function(l_3_0)
  return true
end

GatePort.tick = function(l_4_0)
  Class.super(GatePort).tick(l_4_0)
  if l_4_0.OPEN_AMOUNT == 350 then
    l_4_0.closing = l_4_0.OPEN_AMOUNT <= 10
    if not l_4_0.closing then
      return 
    end
    l_4_0.OPEN_AMOUNT = l_4_0.OPEN_AMOUNT - 1
    if l_4_0.OPEN_AMOUNT == 0 then
      l_4_0.closing = false
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return GatePort

