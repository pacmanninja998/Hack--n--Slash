-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\WireStart.lua 

local Class = require("Class")
local Entity = require("Entity")
local WireStart = Class.create(Entity, "WireStart")
local SpriteComponent = require("Components.SpriteComponent")
WireStart.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(WireStart).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/Outlet/Outlet", "Floor")
  l_1_0:setLabelText("")
  l_1_0.prop:setScl(0.25)
end

return WireStart

