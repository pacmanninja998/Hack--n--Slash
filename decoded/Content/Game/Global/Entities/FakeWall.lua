-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\FakeWall.lua 

local Entity = require("Entity")
local Action = require("Action")
local Math = require("DFCommon.Math")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local MoveAction = require("Class").create(Action, "MoveAction")
MoveAction.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Action.init(l_1_0)
  l_1_0.destX, l_1_0.destY = l_1_1, l_1_2
  l_1_0.duration = l_1_3
end

MoveAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  l_2_0.elapsed = 0
  l_2_0.initX, l_2_0.initY = l_2_0.entity:getPosition(), l_2_0.entity
end

MoveAction.tick = function(l_3_0)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  local progress = l_3_0.elapsed / l_3_0.duration
  if progress < 1 then
    local posX, posY = Math.lerp(l_3_0.initX, l_3_0.destX, progress), Math.lerp(l_3_0.initY, l_3_0.destY, progress)
    l_3_0.entity:setPosition(posX, posY)
    return true
  else
    l_3_0.entity:setPosition(l_3_0.destX, l_3_0.destY)
    return false
  end
end

local FakeWall = require("Class").create(Entity, "FakeWall")
FakeWall.init = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5, l_4_6, l_4_7)
  Entity.init(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  SpriteComponent.new(l_4_0, l_4_6, l_4_7)
end

FakeWall.move = function(l_5_0, l_5_1, l_5_2, l_5_3)
  l_5_0:forceAction(MoveAction.new(l_5_1, l_5_2, l_5_3))
end

return FakeWall

