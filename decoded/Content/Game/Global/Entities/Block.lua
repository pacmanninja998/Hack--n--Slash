-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\Block.lua 

local Entity = require("Entity")
local Block = require("Class").create(Entity, "Block")
local PhysicsComponent = require("Components.PhysicsComponent")
local SpriteComponent = require("Components.SpriteComponent")
Block.addBooleanField("destroyed", false)
Block.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  if HackStartAct == "EGW" then
    SpriteComponent.new(l_1_0, "Interactions/Props/Block_Dungeon/Block_Dungeon")
  else
    SpriteComponent.new(l_1_0, "Interactions/Props/Block/Block")
  end
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.STATIC)
  l_1_0:get(SpriteComponent):setSprite("Block")
  l_1_0.prop:setScl(0.25)
  l_1_0:setLabelText("")
end

Block.onFieldSet = function(l_2_0, l_2_1, l_2_2)
  if l_2_1 == "destroyed" and l_2_2 then
    l_2_0:crumble()
  end
end

Block.isHackable = function(l_3_0)
  return false
end

Block.crumble = function(l_4_0)
  l_4_0:destroy()
end

return Block

