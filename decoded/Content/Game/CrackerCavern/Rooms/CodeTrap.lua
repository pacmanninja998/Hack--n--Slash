-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Rooms\CodeTrap.lua 

local CodeTrap = require("Room").classFromLayout("Content/Game/CrackerCavern/Layouts/CodeTrap", "CodeTrap", "Content/Game/Global/Rooms/GameRoom")
CodeTrap.onInit = function(l_1_0)
  l_1_0.locked = false
  l_1_0:setUpDoor("UnhackableGateDoor (north)", true)
  l_1_0:setUpDoor("UnhackableGateDoor (south)", true)
  l_1_0:defineLogicTrigger("Trap trigger", l_1_0.onTrapTrigger, l_1_0)
end

CodeTrap.setUpDoor = function(l_2_0, l_2_1, l_2_2)
  local door = l_2_0:getEntity(l_2_1)
  door.openedEvent:register(function(l_1_0)
    self:getCollisionArea(name):setActive(not l_1_0)
   end)
  door.OPEN = l_2_2
end

CodeTrap.onTrapTrigger = function(l_3_0)
  l_3_0:getEntity("UnhackableGateDoor (north)").OPEN = false
  l_3_0:getEntity("UnhackableGateDoor (south)").OPEN = false
  l_3_0.locked = true
end

return CodeTrap

