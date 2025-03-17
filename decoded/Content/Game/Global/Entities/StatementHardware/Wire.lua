-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\Wire.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local Wire = Class.create(StatementHardware, "Wire")
Wire.ENABLE_WIRE_COLORS = false
Wire.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_6, nil, nil)
  if math.abs(l_1_6 - l_1_5) ~= 4 then
    assert(not l_1_5 or not l_1_6, "Wires must be entirely horizontal or entirely vertical")
    if l_1_8 and (EnableDebugVisuals or Wire.ENABLE_WIRE_COLORS) then
      l_1_0.prop:setColor(unpack(l_1_8))
    end
    l_1_0.patches = {}
    l_1_0:setLengthScale(l_1_7)
    SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/WhiteWire/WhiteWire")
    AnimatorComponent.new(l_1_0, true, l_1_6)
    do
      local animName = nil
      if l_1_5 and l_1_6 then
        animName = Direction.dirToName(l_1_5) .. Direction.dirToName(l_1_6)
        l_1_0.startDir, l_1_0.endDir = l_1_5, l_1_6
      else
        animName = "Center"
      end
      l_1_0:get(AnimatorComponent):play(animName, 0)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Wire.setLengthScale = function(l_2_0, l_2_1)
  if not l_2_1 then
    l_2_1 = 1
  end
  if l_2_0.facingDir == Direction.DIR_N or l_2_0.facingDir == Direction.DIR_S then
    l_2_0.prop:setScl(0.25, 0.25 * l_2_1)
  else
    l_2_0.prop:setScl(0.25 * l_2_1, 0.25)
  end
  l_2_0.prop:forceUpdate()
  for dir,patch in pairs(l_2_0.patches) do
    local endPoint = l_2_0:getEnd(dir)
    if endPoint then
      patch:setPosition(endPoint.x, endPoint.y)
    end
  end
end

Wire.setPatch = function(l_3_0, l_3_1, l_3_2)
  assert(not l_3_0.patches[l_3_2])
  l_3_0.patches[l_3_2] = l_3_1
end

return Wire

