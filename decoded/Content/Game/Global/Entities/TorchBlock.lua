-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\TorchBlock.lua 

local Entity = require("Entity")
local PushableBlock = Entity.cache:load("Content/Game/Global/Entities/PushableBlock")
local TorchBlock = require("Class").create(PushableBlock, "TorchBlock")
local PhysicsComponent = require("Components.PhysicsComponent")
TorchBlock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  PushableBlock.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.torch = Entity.create("Content/Game/Global/Entities/Torch", l_1_1, l_1_2, l_1_3, l_1_4 .. "_torch", true)
  l_1_0.torch.prop:setAttrLink(MOAIProp.INHERIT_TRANSFORM, l_1_0.prop, MOAIBox2DBody.TRANSFORM_TRAIT)
  l_1_0.torch.prop:setLoc(0, 0)
end

return TorchBlock

