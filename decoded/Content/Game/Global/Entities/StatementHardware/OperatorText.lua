-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\OperatorText.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local OperatorText = Class.create(StatementHardware, "OperatorText")
OperatorText.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, nil, nil)
  l_1_0.prop:setScl(0.25)
  l_1_0.prop:forceUpdate()
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/WhiteFloatingText/WhiteFloatingText")
  l_1_0:setFrame(l_1_8)
end

OperatorText.setFrame = function(l_2_0, l_2_1)
  l_2_0:get(SpriteComponent):setSprite(l_2_1)
end

return OperatorText

