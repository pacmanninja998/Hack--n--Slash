-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\GlyphRoomFakeWall.lua 

local Entity = require("Entity")
local FakeWall = Entity.cache:load("Content/Game/Global/Entities/FakeWall")
local GlyphRoomFakeWall = require("Class").create(FakeWall, "GlyphRoomFakeWall")
local SpriteSheet = require("SpriteSheet")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
GlyphRoomFakeWall.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  FakeWall.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, "Interactions/Props/FakeWall/FakeWall", "GlyphRoomFakeWall")
  l_1_0:get(SpriteComponent).prop:setPriority(-128)
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY + PhysicsComponent.HIGH_CATEGORY, nil, MOAIBox2DBody.STATIC)
  local strutSheet = SpriteSheet.load("Interactions/Props/GlyphWallStrut/GlyphWallStrut")
  local propOffsets = {-328, 56}
  l_1_0.strutProps = {}
  for i = 1, 2 do
    local strutProp = MOAIProp.new()
    table.insert(l_1_0.strutProps, strutProp)
    strutProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
    local deck, index = strutSheet:getDeck("GlyphWallStrut", 1, false)
    strutProp:setDeck(deck)
    strutProp:setIndex(index)
    l_1_0:attachProp(strutProp)
    strutProp:setLoc(160, propOffsets[i])
    strutProp:setPriority(-40)
  end
  l_1_0:get(PhysicsComponent).body:addRect(0, -513, 136, 230)
  l_1_0:get(PhysicsComponent).body:addRect(136, -404, 180, -260)
  l_1_0:get(PhysicsComponent).body:addRect(136, -20, 180, 121)
end

return GlyphRoomFakeWall

