-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\GlyphHackBlock.lua 

local Entity = require("Entity")
local PortBlock = Entity.cache:load("Content/Game/Global/Entities/PortBlock")
local GlyphHackBlock = require("Class").create(PortBlock, "GlyphHackBlock")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
GlyphHackBlock.addIntegerField("OFFSET", 0)
GlyphHackBlock.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  PortBlock.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0:get(SpriteComponent):setSpriteSheet("Interactions/Props/GlyphHackBlock/GlyphHackBlock")
  local anim = l_1_5 == Direction.DIR_W and "Side" or "Front"
  l_1_0:get(AnimatorComponent):play(anim, 0)
  local physics = l_1_0:get(PhysicsComponent)
  physics.fixture:destroy()
  if anim == "Side" then
    physics.fixture = physics.body:addPolygon({-20, -80, 2, -50, 2, 42, -70, 32, -70, -80})
    physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
    physics.fixture:setSensor(false)
    physics:addRect(2, -50, 56, 42)
    l_1_0:get(SpriteComponent).prop:setPriority(-42)
  else
    physics.fixture = physics.body:addPolygon({66, -64, 66, -16, 50, 24, -54, 24, -70, -16, -70, -64})
    physics.fixture:setFilter(physics.category, physics.collidesWithCategories)
    physics.fixture:setSensor(false)
    physics:addRect(-54, 24, 50, 58)
    l_1_0:get(SpriteComponent).prop:setPriority(-58)
  end
end

return GlyphHackBlock

