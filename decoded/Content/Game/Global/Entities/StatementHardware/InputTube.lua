-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\InputTube.lua 

local Class = require("Class")
local Entity = require("Entity")
local Direction = require("Direction")
local StatementHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local InputTube = Class.create(StatementHardware, "InputTube")
InputTube.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10, l_1_11, l_1_12)
  StatementHardware.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  SpriteComponent.new(l_1_0, "Interactions/Props/CodeRoomHardware/Tube/Tube")
  AnimatorComponent.new(l_1_0, true)
  local animName, scale = "Tube", 0.25
  if l_1_12 == 90 then
    animName, scale = "Left", 0.2
  elseif l_1_12 == -90 then
    animName, scale = "Right", 0.2
  end
  l_1_0.prop:setScl(scale)
  l_1_0.prop:forceUpdate()
  l_1_0:get(AnimatorComponent):play(animName, 0)
  local crystalX, crystalY = l_1_2, l_1_3
  local jointX, jointY = l_1_0:get(AnimatorComponent):getJointLoc("crystal", true)
  if jointX and jointY then
    crystalX, crystalY = l_1_0.prop:modelToWorld(jointX, jointY, 0)
  end
  l_1_0.ioCrystal = l_1_0:addChild(StatementHardware.createHardware("IOCrystal", l_1_0.layer, crystalX, crystalY, l_1_0.name .. " IO crystal", Direction.DIR_S, l_1_6, l_1_0.codeRoom, l_1_8, l_1_9, l_1_10, l_1_11, l_1_12))
end

InputTube.labelHardware = function(l_2_0, l_2_1)
  StatementHardware.labelHardware(l_2_0, l_2_1)
  l_2_0:setLabelText("")
end

return InputTube

