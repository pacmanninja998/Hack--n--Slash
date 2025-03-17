-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Rooms\Staircase.lua 

local Class = require("Class")
local Room = require("Room")
local Staircase = Room.classFromLayout("Content/Game/DourTower/Layouts/Staircase", "Staircase", "Content/Game/Global/Rooms/GameRoom")
local Direction = require("Direction")
local Entity = require("Entity")
local CollisionArea = require("CollisionArea")
local Music = require("Music")
Staircase.init = function(l_1_0, ...)
  Class.super(Staircase).init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Staircase.onInit = function(l_2_0)
  local gameplayLayer = l_2_0:getLayerByOrder(0)
  l_2_0.stairs = Entity.create("Content/Game/Global/Entities/Stairs", gameplayLayer, nil, nil, nil, l_2_0:getCollisionArea("Stairs"), Direction.DIR_E, 0.8)
  Music:setReverb("Exterior")
  l_2_0:defineLogicTrigger("Entrance trigger", l_2_0.onEntranceTrigger, l_2_0)
  l_2_0:getCollisionArea("Eve trigger"):setActive(false)
  l_2_0:getCollisionArea("Exit trigger"):setActive(false)
end

return Staircase

