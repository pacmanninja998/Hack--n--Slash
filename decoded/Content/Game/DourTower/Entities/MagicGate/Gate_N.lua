-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\MagicGate\Gate_N.lua 

local Class = require("Class")
local Entity = require("Entity")
local GatePart = Entity.cache:load("Content/Game/DourTower/Entities/MagicGate/GatePart")
local Direction = require("Direction")
local Gate_N = Class.create(GatePart, "Gate_N")
Gate_N.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Gate_N).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, Direction.DIR_N)
end

return Gate_N

