-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\SpiralPlatform.lua 

local Class = require("Class")
local Entity = require("Entity")
local Action = require("Action")
local EntityRef = require("EntityRef")
local Direction = require("Direction")
local Math = require("DFCommon.Math")
local AnimatorComponent = require("Components.AnimatorComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local LogoComponent = require("Components.LogoComponent")
local CommonLogoInstructions = require("CommonLogoInstructions")
local MovingPlatform = Entity.cache:load("Content/Game/Global/Entities/MovingPlatform")
local SpiralPlatform = Class.create(MovingPlatform, "SpiralPlatform")
SpiralPlatform.SpiralAction = Class.create(CommonLogoInstructions.Base, "SpiralPlatform.SpiralAction")
SpiralPlatform.SpiralAction.EPSILON = 4
SpiralPlatform.SpiralAction.TAN_DAMPING = 0.999
SpiralPlatform.SpiralAction.RAD_DAMPING = 0.9999
SpiralPlatform.SpiralAction.init = function(l_1_0, l_1_1)
  CommonLogoInstructions.Base.init(l_1_0)
  l_1_0.targetName = l_1_1.TARGET_NAME
  l_1_0.tangentVel = l_1_1.TANGENT_VELOCITY or 1
  l_1_0.tangentVel = l_1_0.tangentVel * 64
  l_1_0.radialVel = l_1_1.RADIAL_VELOCITY or 1
  l_1_0.radialVel = l_1_0.radialVel * 16
  l_1_0.spinFactor = l_1_1.SPIN_FACTOR or 1
end

SpiralPlatform.SpiralAction.start = function(l_2_0, l_2_1)
  CommonLogoInstructions.Base.start(l_2_0, l_2_1)
  l_2_0.targetRef = EntityRef.new(l_2_0.entity:room():getEntity(l_2_0.targetName))
end

SpiralPlatform.SpiralAction.tick = function(l_3_0)
  CommonLogoInstructions.Base.tick(l_3_0)
  if l_3_0.targetRef:isValid() then
    local physics = l_3_0.entity:get(PhysicsComponent)
    local targetX, targetY = l_3_0.targetRef.entity:getPosition()
    local posX, posY = l_3_0.entity:getPosition()
    local diffX, diffY = targetX - posX, targetY - posY
    local dist = Math.length(diffX, diffY)
    if dist < l_3_0.EPSILON then
      return false
    else
      local normX, normY = diffX / dist, diffY / dist
      local radialAngle = math.atan2(normY, normX)
      local tangentAngle = radialAngle - l_3_0.spinFactor * (math.pi / 2)
      local velX = math.cos(radialAngle) * l_3_0.radialVel + math.cos(tangentAngle) * l_3_0.tangentVel
      local velY = math.sin(radialAngle) * l_3_0.radialVel + math.sin(tangentAngle) * l_3_0.tangentVel
      physics:setLinearVelocity(velX, velY)
      l_3_0.tangentVel = l_3_0.tangentVel * l_3_0.TAN_DAMPING
      l_3_0.radialVel = l_3_0.radialVel * l_3_0.RAD_DAMPING
      return true
    end
  end
end

SpiralPlatform.DestroyAction = Class.create(CommonLogoInstructions.Base, "SpiralPlatform.DestroyAction")
SpiralPlatform.DestroyAction.start = function(l_4_0, l_4_1)
  CommonLogoInstructions.Base.start(l_4_0, l_4_1)
  l_4_0.entity:destroy()
end

SpiralPlatform.addEditableField("ROUTINE", LogoComponent.createBehaviorSchema({SPIRAL = {TARGET_NAME = Class.StringSchema.new(), TANGENT_VELOCITY = Class.IntegerSchema.new(1), RADIAL_VELOCITY = Class.IntegerSchema.new(1), SPIN_FACTOR = Class.IntegerSchema.new(1)}, DESTROY = {}}))
SpiralPlatform.init = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5, l_5_6)
  MovingPlatform.init(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5, l_5_6, 1, 1, nil, nil, {SPIRAL = SpiralPlatform.SpiralAction, DESTROY = SpiralPlatform.DestroyAction})
end

return SpiralPlatform

