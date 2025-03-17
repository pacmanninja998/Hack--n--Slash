-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\Stump.lua 

local Entity = require("Entity")
local Stump = require("Class").create(Entity, "Stump")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
Stump.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/Stump/Stump")
  PhysicsComponent.new(l_1_0, 64, 48, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC, false)
  l_1_0.attachedEntity = nil
  l_1_0.oldSpritePriority = nil
end

Stump.getAttachedEntity = function(l_2_0)
  return l_2_0.attachedEntity
end

Stump.attachEntity = function(l_3_0, l_3_1)
  if l_3_0.attachedEntity then
    l_3_0.attachedEntity:get(SpriteComponent).prop:setPriority(l_3_0.oldSpritePriority)
  end
  l_3_0.attachedEntity = l_3_1
  if l_3_1 then
    l_3_0.oldSpritePriority = l_3_1:get(SpriteComponent).prop:getPriority()
    l_3_1:get(SpriteComponent).prop:setPriority(36)
  end
end

return Stump

