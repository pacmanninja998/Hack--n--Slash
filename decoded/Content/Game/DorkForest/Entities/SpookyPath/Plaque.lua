-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\SpookyPath\Plaque.lua 

local Entity = require("Entity")
local Delegate = require("DFMoai.Delegate")
local LayoutEntity = require("Class").create(Entity, "Plaque")
local SceneComponent = require("Components.SceneComponent")
local SpriteComponent = require("Components.SpriteComponent")
local InteractionComponent = require("Components.InteractionComponent")
local FunctionComponent = require("Components.FunctionComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DorkForest/SpookyPath/SpookyPath", "Plaque")
  PhysicsComponent.new(l_1_0, {rect = {-32, -32, 16, 16}, category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC})
  l_1_0:setLabelText("")
  FunctionComponent.new(l_1_0, l_1_4)
  InteractionComponent.new(l_1_0)
  l_1_0:get(InteractionComponent).interactEvent:register(l_1_0.onInteract, l_1_0)
  l_1_0.interactEndEvent = Delegate.new()
end

LayoutEntity.isProtected = function(l_2_0)
  return false
end

LayoutEntity.onInteract = function(l_3_0, l_3_1)
  l_3_1:get(SceneComponent):play(function(l_1_0)
    interactor:halt(true)
    local interacted = self:get(FunctionComponent):examine(l_1_0, interactor)
    interactor:halt(false)
    if not interacted then
      self.interactEndEvent:dispatch(l_1_0)
    end
    self:get(InteractionComponent):stopInteract(interactor)
   end)
end

return LayoutEntity

