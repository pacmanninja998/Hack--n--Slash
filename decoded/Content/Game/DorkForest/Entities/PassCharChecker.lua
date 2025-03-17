-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\PassCharChecker.lua 

local Entity = require("Entity")
local PassCharChecker = require("Class").create(Entity, "PassCharChecker")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
PassCharChecker.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/PassCharChecker/PassCharChecker")
  PhysicsComponent.new(l_1_0, {category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC, rect = {-32, 0, 32, 128}})
  AnimatorComponent.new(l_1_0, true)
  l_1_0:get(AnimatorComponent):registerEventCallback(l_1_0, "Destroy", l_1_0.onHideAnimDone)
  l_1_0:get(AnimatorComponent):playOnce("Bad")
  l_1_0.char = nil
end

PassCharChecker.setChar = function(l_2_0, l_2_1)
  l_2_0.char = l_2_1
end

PassCharChecker.checkChar = function(l_3_0, l_3_1)
  if string.lower(l_3_1) == string.lower(l_3_0.char) then
    if not l_3_0:universe().state.state.hidePasswordFeedback then
      l_3_0:get(AnimatorComponent):playOnce("Good")
    else
      l_3_0:get(AnimatorComponent):playOnce("Bad")
    end
    return true
  else
    l_3_0:get(AnimatorComponent):playOnce("Bad")
    return false
  end
end

PassCharChecker.hide = function(l_4_0)
  l_4_0:get(AnimatorComponent):playOnce("Hide")
end

PassCharChecker.onHideAnimDone = function(l_5_0)
  local minX, minY, maxX, maxY = l_5_0:getWorldBounds()
  Entity.create("Content/Game/Global/Entities/Effects/DustPoof", l_5_0.layer, (minX + maxX) / 2, minY)
  l_5_0:destroy()
end

return PassCharChecker

