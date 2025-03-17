-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\PrincessChambersCopy.lua 

local Class = require("Class")
local Room = require("Room")
local PrincessChambers = Room.classFromLayout("Content/Game/DourTower/Layouts/PrincessChambers", "PrincessChambers", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local Math = require("DFCommon.Math")
local Music = require("Music")
local SceneComponent = require("Components.SceneComponent")
PrincessChambers.onInit = function(l_1_0)
  l_1_0:enableWater()
end

return PrincessChambers

