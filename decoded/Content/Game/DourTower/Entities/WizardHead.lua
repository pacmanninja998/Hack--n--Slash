-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\WizardHead.lua 

local Class = require("Class")
local Entity = require("Entity")
local WizardHead = Class.create(Entity, "WizardHead")
local AnimatorComponent = require("Components.AnimatorComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
local CommonActions = require("CommonActions")
local EntityRef = require("EntityRef")
local Shader = require("Shader")
WizardHead.Appear = Class.create(CommonActions.PlayAnimation, "WizardHead.Appear")
WizardHead.Appear.init = function(l_1_0)
  Class.super(WizardHead.Appear).init(l_1_0, "Appear")
end

WizardHead.Appear.start = function(l_2_0, l_2_1)
  Class.super(WizardHead.Appear).start(l_2_0, l_2_1)
  l_2_0.cue = l_2_0.entity:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Appear")
end

WizardHead.Appear.stop = function(l_3_0)
  Class.super(WizardHead.Appear).stop(l_3_0)
  l_3_0.entity:get(SoundComponent):stopCue(l_3_0.cue)
end

WizardHead.Disappear = Class.create(CommonActions.PlayAnimation, "WizardHead.Disappear")
WizardHead.Disappear.init = function(l_4_0)
  Class.super(WizardHead.Disappear).init(l_4_0, "Disappear")
end

WizardHead.Disappear.start = function(l_5_0, l_5_1)
  Class.super(WizardHead.Disappear).start(l_5_0, l_5_1)
  l_5_0.cue = l_5_0.entity:get(SoundComponent):playCue("SFX/Characters/Wizard/Wizard_Teleport_Disappear")
end

WizardHead.Disappear.stop = function(l_6_0)
  Class.super(WizardHead.Disappear).stop(l_6_0)
  l_6_0.entity:get(SoundComponent):stopCue(l_6_0.cue)
  l_6_0.entity.prop:setVisible(false)
  l_6_0.entity:destroy()
end

WizardHead.TEXT_COLOR = {0.82745098039216, 0.99607843137255, 1}
WizardHead.OFFSET_X = 200
WizardHead.OFFSET_Y = 20
WizardHead.init = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  Class.super(WizardHead).init(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  SpriteComponent.new(l_7_0, "Characters/Wizard_Head/Wizard_Head")
  l_7_0:setDefaultShader(Shader.load("Content/Game/Global/Shaders/GlowyPlatform"))
  AnimatorComponent.new(l_7_0, AnimatorComponent.DIRECTION_MODE_DIRECTIONLESS)
  SoundComponent.new(l_7_0)
  l_7_0.trackedEntity = EntityRef.new()
  l_7_0.idle = "Breathe"
end

WizardHead.trackEntity = function(l_8_0, l_8_1)
  l_8_0.trackedEntity:setEntity(l_8_1)
end

WizardHead.appear = function(l_9_0)
  l_9_0:queueAction(WizardHead.Appear.new())
end

WizardHead.disappear = function(l_10_0)
  l_10_0:queueAction(WizardHead.Disappear.new())
end

WizardHead.setFace = function(l_11_0, l_11_1)
  if l_11_1 then
    l_11_0.idle = "Breathe_" .. l_11_1
  else
    l_11_0.idle = "Breathe"
  end
end

WizardHead.tick = function(l_12_0)
  Class.super(WizardHead).tick(l_12_0)
  if l_12_0.trackedEntity:isValid() then
    local posX, posY = l_12_0.trackedEntity.entity:getPosition()
    local targetX, targetY = posX + l_12_0.OFFSET_X, posY + l_12_0.OFFSET_Y
    l_12_0:setPosition(targetX, targetY)
  end
  if not l_12_0.action then
    l_12_0:get(AnimatorComponent):play(l_12_0.idle)
  end
end

return WizardHead

