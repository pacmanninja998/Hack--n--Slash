-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\MovingPlatform.lua 

local Entity = require("Entity")
local MovingPlatform = require("Class").create(Entity, "MovingPlatform")
local Math = require("DFCommon.Math")
local Direction = require("Direction")
local SpriteComponent = require("Components.SpriteComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local PlatformComponent = require("Components.PlatformComponent")
local LogoComponent = require("Components.LogoComponent")
MovingPlatform.DEFAULT_SEEK_SPEED = 100
MovingPlatform.MOVE_SPEED = 64
MovingPlatform.addEditableField("ROUTINE", LogoComponent.createBehaviorSchema())
MovingPlatform.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10, l_1_11)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.ROUTINE = {{TYPE = "IDLE", SECONDS = 1}}
  l_1_0.width, l_1_0.height = l_1_7 or 1, l_1_8 or 1
  if not l_1_9 then
    l_1_9 = "Interactions/Props/Placeholder/MovingPlatform/MovingPlatform"
  end
  SpriteComponent.new(l_1_0, l_1_9, l_1_10)
  if l_1_7 ~= 0 and l_1_8 ~= 0 then
    l_1_0.prop:setScl(l_1_7 / 2, l_1_8 / 2)
    PhysicsComponent.new(l_1_0, 64 * l_1_7, 64 * l_1_8, PhysicsComponent.LOW_CATEGORY, nil, MOAIBox2DBody.DYNAMIC, true)
    PlatformComponent.new(l_1_0, l_1_0:get(PhysicsComponent), false)
    l_1_0:get(PhysicsComponent):setReceivesPlatformVel(false)
  end
  AnimatorComponent.new(l_1_0, false, l_1_5, Direction.DIR_E)
  LogoComponent.new(l_1_0, l_1_11)
  l_1_0:get(LogoComponent).behaviorCompleteEvent:register(l_1_0.onBehaviorComplete, l_1_0)
  l_1_0.visible = l_1_6
  if not l_1_10 then
    if l_1_0.visible then
      l_1_0:get(AnimatorComponent):play("Arrow", 0)
    else
      l_1_0:get(AnimatorComponent).directionMode = AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS
      l_1_0:get(AnimatorComponent):play("Invisible", 0)
    end
  end
  l_1_0.targetX, l_1_0.targetY, l_1_0.seekSpeed = nil
end

MovingPlatform.setTarget = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  local posX, posY = l_2_0:getPosition()
  if l_2_1 ~= posX or l_2_2 ~= posY then
    if l_2_4 then
      l_2_0:setPosition(l_2_1, l_2_2)
    else
      l_2_0.targetX, l_2_0.targetY = l_2_1, l_2_2
      if not l_2_3 then
        l_2_0.seekSpeed = l_2_0.DEFAULT_SEEK_SPEED
      end
    end
  end
end

MovingPlatform.tick = function(l_3_0)
  Entity.tick(l_3_0)
  if l_3_0.targetX and l_3_0.targetY and l_3_0.seekSpeed then
    local posX, posY = l_3_0:getPosition()
    local diffX, diffY = l_3_0.targetX - posX, l_3_0.targetY - posY
    local normX, normY = Math.normalize(diffX, diffY)
    local seekVelX, seekVelY = l_3_0.seekSpeed * normX, l_3_0.seekSpeed * normY
    local stepX, stepY = seekVelX * MOAISim.getStep(), seekVelY * MOAISim.getStep()
    if (math.abs(diffX) <= math.abs(stepX) and math.abs(diffY) <= math.abs(stepY)) or diffX == 0 and diffY == 0 then
      l_3_0:setPosition(l_3_0.targetX, l_3_0.targetY)
      l_3_0:get(PhysicsComponent):setLinearVelocity(0, 0)
      l_3_0.targetX, l_3_0.targetY, l_3_0.seekSpeed = nil
    else
      l_3_0:get(PhysicsComponent):setLinearVelocity(seekVelX, seekVelY)
    end
  elseif not l_3_0.action then
    l_3_0:onBehaviorComplete()
  end
end

MovingPlatform.onBehaviorComplete = function(l_4_0)
  l_4_0:get(LogoComponent):setBehavior(l_4_0.ROUTINE)
end

return MovingPlatform

