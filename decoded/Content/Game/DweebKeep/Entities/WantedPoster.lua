-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\WantedPoster.lua 

local Entity = require("Entity")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local WantedPoster = require("Class").create(Entity, "WantedPoster")
WantedPoster.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.character = l_1_5 or "Hero"
  if not l_1_6 then
    l_1_0.text = l_1_0.character
  end
  SpriteComponent.new(l_1_0, "Interactions/Props/Posters/Posters", l_1_0.character)
  PhysicsComponent.new(l_1_0, 64, 64, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC, true)
  l_1_0.namePlaque = Entity.create("Content/Game/DourTower/Entities/NamePlaque", l_1_0.layer, l_1_2, l_1_3 - 56, l_1_0.name .. " plaque", Direction.DIR_S, l_1_0.text, 0.7, {0.33725490196078, 0.25882352941176, 0.15294117647059})
  l_1_0.prop:setScl(0.4)
  l_1_0:get(SpriteComponent).prop:setPriority(-128)
  l_1_0:setLabelText(l_1_5)
end

WantedPoster.setCharacter = function(l_2_0, l_2_1)
  if l_2_0.character ~= l_2_1 then
    l_2_0.character = l_2_1
    l_2_0:get(SpriteComponent):setSprite(l_2_0.character)
    if l_2_0.portrait then
      l_2_0.portrait.character = l_2_1
      l_2_0.portrait:get(SpriteComponent):setSprite(l_2_0.character)
    end
  end
end

return WantedPoster

