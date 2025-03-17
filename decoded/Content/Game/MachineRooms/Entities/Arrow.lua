-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\Arrow.lua 

local Class = require("Class")
local Entity = require("Entity")
local Arrow = Class.create(Entity, "Arrow")
local SpriteComponent = require("Components.SpriteComponent")
Arrow.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Arrow).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/WireArrow/WireArrow", "E")
  sprite.prop:setPriority(1000)
  l_1_0:setLabelText("")
end

Arrow.start = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_0.vx, l_2_0.vy, l_2_0.duration = l_2_2, l_2_3, l_2_4
  local angle = math.atan2(l_2_3, l_2_2)
  l_2_0.prop:setRot(0, 0, math.deg(angle))
  l_2_0.elapsed = 0
  l_2_0.prop:setAttrLink(MOAIProp.INHERIT_COLOR, l_2_1.prop, MOAIProp.COLOR_TRAIT)
  l_2_0.prop:forceUpdate()
end

Arrow.tick = function(l_3_0)
  Class.super(Arrow).tick(l_3_0)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  if l_3_0.duration < l_3_0.elapsed then
    l_3_0:destroy()
    return 
  end
  local x, y = l_3_0:getPosition()
  x, y = x + l_3_0.vx * MOAISim.getStep(), y + l_3_0.vy * MOAISim.getStep()
  l_3_0:setPosition(x, y)
end

return Arrow

