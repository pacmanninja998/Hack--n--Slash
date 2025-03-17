-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\WantedPortrait.lua 

local Entity = require("Entity")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local WantedPortrait = require("Class").create(Entity, "WantedPortrait")
WantedPortrait.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.character = l_1_5 or "Hero"
  SpriteComponent.new(l_1_0, "Interactions/Props/Portraits/Portraits", l_1_0.character)
  if l_1_0.character == "ORC" then
    l_1_0.renderAsPhysics = true
  end
  l_1_0.prop:setScl(0.4)
  l_1_0:setLabelText("")
end

return WantedPortrait

