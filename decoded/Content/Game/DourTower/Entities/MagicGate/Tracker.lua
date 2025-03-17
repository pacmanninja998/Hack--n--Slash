-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\MagicGate\Tracker.lua 

local Class = require("Class")
local Entity = require("Entity")
local Tracker = Class.create(Entity, "Tracker")
local EntityRef = require("EntityRef")
local AnimatorComponent = require("Components.AnimatorComponent")
local SpriteComponent = require("Components.SpriteComponent")
Tracker.LIGHT_SECONDS = 0.25
Tracker.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Tracker).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "FX/FX")
  local animator = AnimatorComponent.new(l_1_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  animator:play("Torch_Light")
  l_1_0.target = EntityRef.new()
  l_1_0.alpha = 0
end

Tracker.trackTarget = function(l_2_0, l_2_1)
  l_2_0.target:setEntity(l_2_1)
end

Tracker.tick = function(l_3_0)
  Class.super(Tracker).tick(l_3_0)
  if l_3_0.target:isValid() then
    l_3_0:setPosition(l_3_0.target.entity:getPosition())
  end
  l_3_0:updateAlpha()
end

Tracker.fire = function(l_4_0)
  local posX, posY = l_4_0:getPosition()
  Entity.create("Content/Game/DourTower/Entities/MagicGate/FireBlast", l_4_0:room():getLayerByOrder(0), posX, posY)
end

Tracker.updateAlpha = function(l_5_0)
  local tick = MOAISim.getStep() / Tracker.LIGHT_SECONDS
  if l_5_0.target:isValid() then
    l_5_0.alpha = math.min(1, l_5_0.alpha + tick)
  else
    l_5_0.alpha = math.max(0, l_5_0.alpha - tick)
    if l_5_0.alpha == 0 then
      l_5_0:destroy()
    end
  end
  l_5_0:setAlpha(l_5_0.alpha)
end

return Tracker

