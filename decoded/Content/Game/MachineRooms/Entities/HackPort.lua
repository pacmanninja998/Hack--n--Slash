-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\HackPort.lua 

local Class = require("Class")
local Entity = require("Entity")
local HackPort = Class.create(Entity, "HackPort")
local SpriteSheet = require("SpriteSheet")
local SpriteComponent = require("Components.SpriteComponent")
HackPort.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(HackPort).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local sprite = SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/HackPort/HackPort")
  sprite.prop:setPriority(-100)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  l_1_0:setLabelText("")
end

return HackPort

