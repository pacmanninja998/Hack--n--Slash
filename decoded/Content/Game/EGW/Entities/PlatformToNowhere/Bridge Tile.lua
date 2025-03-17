-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\EGW\Entities\PlatformToNowhere\Bridge Tile.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Bridge Tile")
local SpriteComponent = require("Components.SpriteComponent")
local PlatformComponent = require("Components.PlatformComponent")
local SoundComponent = require("Components.SoundComponent")
local Shader = require("Shader")
LayoutEntity.TRANSITION_TIME = 0.25
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/EGW/PlatformToNowhere/PlatformToNowhere", l_1_4)
  l_1_0:get(SpriteComponent).prop:setPriority(-256)
  SoundComponent.new(l_1_0, {})
  l_1_0.platformShader = Shader.load("Content/Game/Global/Shaders/GlowyPlatform")
  l_1_0:setDefaultShader(l_1_0.platformShader)
  l_1_0:get(SpriteComponent).material:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE)
  local collisionArea = l_1_1.room.collisionAreasByName[l_1_4]
  if collisionArea then
    collisionArea:setSensor(true)
    PlatformComponent.new(l_1_0, collisionArea, false, false, false, nil, true)
  end
  l_1_0:setLabelText(l_1_4:sub(#"Bridge Tile "))
  local sizeX, sizeY = l_1_0:get(SpriteComponent):getSize()
  l_1_0.label:setOffset(0, sizeY * 0.5)
  l_1_0.opacity = 0
  l_1_0.delta = 0
  l_1_0.remainingTicks = 0
  l_1_0:disable()
end

LayoutEntity.setTargetOpacity = function(l_2_0, l_2_1, l_2_2)
  local totalDelta = l_2_1 - l_2_0.opacity
  l_2_0.remainingTicks = math.ceil(l_2_2 / MOAISim.getStep())
  l_2_0.delta = totalDelta / l_2_0.remainingTicks
end

LayoutEntity.tick = function(l_3_0)
  Entity.tick(l_3_0)
  if l_3_0.remainingTicks > 0 then
    l_3_0.remainingTicks = l_3_0.remainingTicks - 1
    l_3_0.opacity = l_3_0.opacity + l_3_0.delta
    l_3_0:setAlpha(l_3_0.opacity)
  end
end

LayoutEntity.enable = function(l_4_0)
  l_4_0:get(SoundComponent):playCue("SFX/Objects/Bridge_Appear", nil, 0.5)
  l_4_0:setTargetOpacity(1, l_4_0.TRANSITION_TIME)
  l_4_0:get(PlatformComponent):setActive(true)
end

LayoutEntity.disable = function(l_5_0)
  l_5_0:setTargetOpacity(0, l_5_0.TRANSITION_TIME)
  l_5_0:get(PlatformComponent):setActive(false)
end

return LayoutEntity

