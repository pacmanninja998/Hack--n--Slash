-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\SpookyPath\Outhouse.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Outhouse")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local InteractionComponent = require("Components.InteractionComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DorkForest/SpookyPath/SpookyPath", "Outhouse")
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  InteractionComponent.new(l_1_0)
  l_1_0:setLabelText("")
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture = physics:addRect(-36, 12, 16, 28)
  local open = l_1_0:room():getState()[l_1_0.name .. " open"]
  l_1_0:setOpen(open)
  l_1_0:get(InteractionComponent).interactEvent:register(l_1_0.onInteract, l_1_0)
end

LayoutEntity.setOpen = function(l_2_0, l_2_1)
  l_2_0.open = not not l_2_1
  local spriteName = l_2_0.open and "OuthouseOpen" or "Outhouse"
  l_2_0:get(SpriteComponent):setSprite(spriteName)
  local physics = l_2_0:get(PhysicsComponent)
  physics.fixture:setSensor(l_2_0.open)
  l_2_0:room():getState()[l_2_0.name .. " open"] = l_2_0.open
end

LayoutEntity.onInteract = function(l_3_0, l_3_1)
  l_3_0:setOpen(not l_3_0.open)
  l_3_0:get(InteractionComponent):stopInteract(l_3_1)
end

return LayoutEntity

