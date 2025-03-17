-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\DRMRoof\BeamPort.lua 

local Class = require("Class")
local Entity = require("Entity")
local BeamPort = Class.create(Entity, "BeamPort")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
BeamPort.addStringField("DECIPHER_KEY", "")
BeamPort.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  do
    local sprite = SpriteComponent.new(l_1_0, "Layouts/Game/DourTower/DRMRoof/DRMRoof", l_1_4)
     -- DECOMPILER ERROR: Unhandled construct in list

    PhysicsComponent.new(l_1_0, {rect = {}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  end
   -- Warning: undefined locals caused missing assignments!
end

BeamPort.isHackable = function(l_2_0)
  return true
end

return BeamPort

