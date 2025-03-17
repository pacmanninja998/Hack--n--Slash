-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\EmptySpacer.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local EmptySpacer = Class.create(StatementHardware, "EmptySpacer")
EmptySpacer.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, statement, codeRoom)
  local dirX, dirY = Direction.dirToVector(l_1_5)
  if not l_1_6 then
    l_1_6 = 0
  end
  local spaceX, spaceY = l_1_6 * dirX, l_1_6 * dirY
  l_1_0:setEnd(l_1_5, l_1_2 + spaceX, l_1_3 + spaceY)
  l_1_0:setEnd(Direction.rotate(l_1_5, -2), l_1_2 + spaceX, l_1_3 + spaceY)
  l_1_0:setEnd(Direction.rotate(l_1_5, 2), l_1_2 + spaceX, l_1_3 + spaceY)
end

return EmptySpacer

