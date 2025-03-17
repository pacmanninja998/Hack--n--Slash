-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\FloatingTile.lua 

local Entity = require("Entity")
local Action = require("Action")
local Math = require("DFCommon.Math")
local Shader = require("Shader")
local SpriteComponent = require("Components.SpriteComponent")
local PlatformComponent = require("Components.PlatformComponent")
local SoundComponent = require("Components.SoundComponent")
local Platform = Entity.cache:load("Content/Game/Global/Entities/Platform")
local FloatingTile = require("Class").create(Platform, "FloatingTile")
FloatingTile.EnableAction = require("Class").create(Action, "FloatingTile.EnableAction")
FloatingTile.EnableAction.TRANSITION_TIME = 0.5
FloatingTile.EnableAction.init = function(l_1_0, l_1_1, l_1_2)
  Action.init(l_1_0)
  l_1_0.enable = l_1_1
  if not l_1_2 then
    l_1_0.duration = l_1_0.TRANSITION_TIME
  end
  l_1_0.endOpacity = l_1_0.enable and 1 or 0
  l_1_0.startOpacity = 1 - l_1_0.endOpacity
  l_1_0.elapsed = 0
end

FloatingTile.EnableAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  if l_2_0.enable then
    l_2_0.entity:get(PlatformComponent):setActive(true)
    l_2_0.entity:get(SoundComponent):playCue("SFX/Objects/Bridge_Appear", nil, 0.5)
  else
    l_2_0.entity:get(SoundComponent):playCue("SFX/Objects/Bridge_Disappear", nil, 0.5)
  end
end

FloatingTile.EnableAction.tick = function(l_3_0)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  if l_3_0.elapsed < l_3_0.duration then
    local progress = Math.pinPct(l_3_0.elapsed / l_3_0.duration)
    l_3_0.entity:setAlpha(Math.lerp(l_3_0.startOpacity, l_3_0.endOpacity, progress))
    return true
  end
end

FloatingTile.EnableAction.stop = function(l_4_0)
  Action.stop(l_4_0)
  if not l_4_0.enable then
    l_4_0.entity:get(PlatformComponent):setActive(false)
  end
  l_4_0.entity:setAlpha(l_4_0.endOpacity)
  l_4_0.entity.enabled = l_4_0.enable
end

FloatingTile.init = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  Entity.init(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  local collisionArea = l_5_1.room:getCollisionArea(l_5_4)
  collisionArea:setSensor(true)
  PlatformComponent.new(l_5_0, collisionArea, false, false, false, nil, true)
  SoundComponent.new(l_5_0, {})
  SpriteComponent.new(l_5_0, "Layouts/Game/CrackerCavern/CaveStash/CaveStash", l_5_5)
  l_5_0:get(SpriteComponent).prop:setPriority(-128)
  l_5_0:setLabelText("")
  l_5_0.platformShader = Shader.load("Content/Game/Global/Shaders/GlowyPlatform")
  l_5_0:setDefaultShader(l_5_0.platformShader)
  l_5_0:get(SpriteComponent).material:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE)
  l_5_0.enabled = true
end

FloatingTile.enable = function(l_6_0, l_6_1, l_6_2)
  local enableAction = l_6_0:isDoing(FloatingTile.EnableAction)
  if l_6_1 ~= l_6_0.enabled or enableAction and enableAction.enable ~= l_6_1 then
    l_6_0:forceAction(FloatingTile.EnableAction.new(l_6_1, l_6_2))
  end
end

return FloatingTile

