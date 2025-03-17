-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\MagicGate\GateSpikes_W.lua 

local Class = require("Class")
local Entity = require("Entity")
local GatePart = Entity.cache:load("Content/Game/DourTower/Entities/MagicGate/GatePart")
local Direction = require("Direction")
local GateSpikes_W = Class.create(GatePart, "GateSpikes_W")
GateSpikes_W.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(GateSpikes_W).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, Direction.DIR_W)
end

return GateSpikes_W

