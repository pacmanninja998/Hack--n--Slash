-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\WavelengthPortBlock.lua 

local Entity = require("Entity")
local Action = require("Action")
local PortBlock = Entity.cache:load("Content/Game/Global/Entities/PortBlock")
local WavelengthPortBlock = require("Class").create(PortBlock, "WavelengthPortBlock")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local BeHackedAction = Action.load("Content/Game/Global/Actions/BeHackedAction")
WavelengthPortBlock.addIntegerField("WAVELENGTH", 380, 380, 750)
WavelengthPortBlock.isHackable = function(l_1_0, l_1_1)
  return true
end

WavelengthPortBlock.tick = function(l_2_0)
  PortBlock.tick(l_2_0)
  l_2_0:get(SpriteComponent):setSpriteSheet("Interactions/Props/Port/Port")
  l_2_0:get(SpriteComponent):setSprite("South")
  l_2_0:get(AnimatorComponent):play("South")
  local physics = l_2_0:get(PhysicsComponent)
  physics.fixture:destroy()
  physics.fixture = physics:addRect(-32, -48, 32, 16)
  if not l_2_0.waveSound then
    l_2_0.waveSound = MOAIFmodEventMgr.playEvent2D("SFX/Objects/LaserPuzzle_HalcyonCell")
  end
  if l_2_0.waveSound and l_2_0:isDoing(BeHackedAction) then
    l_2_0.waveSound:setParameter("Filter", 1)
  elseif l_2_0.waveSound then
    l_2_0.waveSound:setParameter("Filter", 0)
  end
end

WavelengthPortBlock.preDestroy = function(l_3_0)
  if l_3_0.waveSound then
    l_3_0.waveSound:stop()
  end
end

return WavelengthPortBlock

