-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Actions\BeHackedAction.lua 

local Action = require("Action")
local BeHackedAction = require("Class").create(Action, "BeHackedAction")
local Entity = require("Entity")
local HackAction = Action.load("Content/Game/Global/Actions/HackAction")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteComponent = require("Components.SpriteComponent")
local Shader = require("Shader")
BeHackedAction.init = function(l_1_0, l_1_1, l_1_2)
  Action.init(l_1_0)
  l_1_0.source = l_1_1
  l_1_0.hackAction = l_1_2
  l_1_0.hackingShader = Shader.load("Content/Game/Global/Shaders/Hacking")
  l_1_0.beingHackedShader = Shader.load("Content/Game/Global/Shaders/BeingHacked")
end

BeHackedAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  local physics = l_2_0.entity:get(PhysicsComponent)
  if physics then
    physics:setLinearVelocity(0, 0)
  end
  l_2_0.effect = Entity.create("Content/Game/Global/Entities/Effects/BeingHacked", l_2_0.entity.layer, l_2_0.entity:getPosition())
  l_2_0.entity:setCurrentShader(l_2_0.beingHackedShader)
  l_2_0.source:setCurrentShader(l_2_0.hackingShader)
  l_2_0.source:room():queueUpdate(function()
    self.source:get(SoundComponent):playCue("SFX/Characters/Alice/Alice_Hack", nil, 0.5)
   end)
end

BeHackedAction.tick = function(l_3_0)
  local sourceHackAction = l_3_0.source.action
  repeat
    if sourceHackAction then
      if sourceHackAction == l_3_0.hackAction then
        do return end
      end
      sourceHackAction = sourceHackAction.pausedAction
    elseif not sourceHackAction then
      return false
    end
    if l_3_0.source == l_3_0.entity and sourceHackAction.hackInterface.dismissed then
      return false
    end
    local targetSprite = l_3_0.entity:get(SpriteComponent)
    if targetSprite then
      local deck, index = targetSprite.sheet:getDeck(targetSprite.name, targetSprite.frame, targetSprite.looping)
      if deck then
        local x0, y0, x1, y1, x2, y2, x3, y3 = deck:getUVQuad(index)
        local u0, v0, u1, v1 = x0, y0, x2, y2
        local uScale = u1 - u0
        local vScale = v1 - v0
        targetSprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {u0, v0, uScale, vScale})
      end
    end
    local sourceSprite = l_3_0.source:get(SpriteComponent)
    do
      local deckB, indexB = sourceSprite.sheet:getDeck(sourceSprite.name, sourceSprite.frame, sourceSprite.looping)
      if deckB then
        local xb0, yb0, xb1, yb1, xb2, yb2, xb3, yb3 = deckB:getUVQuad(indexB)
        local ub0, vb0, ub1, vb1 = xb0, yb0, xb2, yb2
        local uScaleB = ub1 - ub0
        local vScaleB = vb1 - vb0
        sourceSprite.material:setShaderValue("UVParams", MOAIMaterial.VALUETYPE_VEC4, {ub0, vb0, uScaleB, vScaleB})
      end
      return true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BeHackedAction.stop = function(l_4_0)
  if l_4_0.source.action and l_4_0.source.action:is(HackAction) then
    l_4_0.source:forceAction(nil)
  end
  l_4_0.effect:destroy()
  l_4_0.entity:resetShader()
  l_4_0.source:resetShader()
  Action.stop(l_4_0)
end

return BeHackedAction

