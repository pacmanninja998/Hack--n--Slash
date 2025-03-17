-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\LabRuins\PortRock.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "PortRock")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
LayoutEntity.password = ""
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DorkForest/LabRuins/LabRuins", l_1_4)
  l_1_0:setLabelText("")
  PhysicsComponent.new(l_1_0, {category = PhysicsComponent.DYNAMIC_CATEGORY, bodyType = MOAIBox2DBody.STATIC, rect = {-32, 64, 32, 128}})
  SoundComponent.new(l_1_0)
  l_1_0.charCheckers = {}
  l_1_0.hackOffsetY = -192
  l_1_0.passwordGateOpen = false
end

LayoutEntity.isHackable = function(l_2_0)
  return true
end

LayoutEntity.setCharChecker = function(l_3_0, l_3_1, l_3_2)
  l_3_0.charCheckers[l_3_1] = l_3_2
end

LayoutEntity.onFieldSet = function(l_4_0, l_4_1, l_4_2)
  if l_4_1 == "password" then
    l_4_0:checkPassword()
  end
end

LayoutEntity.checkPassword = function(l_5_0, l_5_1)
  if l_5_0.passwordGateOpen then
    return 
  end
  local fullMatch = true
  local match = false
  local checkLength = 0
  for i,checker in ipairs(l_5_0.charCheckers) do
    checkLength = checkLength + 1
    if l_5_0.password and string.len(l_5_0.password) < checkLength then
      checker:get(AnimatorComponent):playOnce("Bad")
      fullMatch = false
      for i,checker in (for generator) do
      end
      match = checker:checkChar(string.sub(l_5_0.password, i, i))
      if fullMatch then
        fullMatch = match
      end
    end
    if not l_5_1 then
      if fullMatch then
        l_5_0:get(SoundComponent):playCue("SFX/Hackable_Objects/Password_Green", nil, 0.5)
      else
        l_5_0:get(SoundComponent):playCue("SFX/Hackable_Objects/Password_Red", nil, 0.5)
      end
    end
    if fullMatch and not l_5_0.passwordGateOpen then
      l_5_0.passwordGateOpen = true
      l_5_0:get(SoundComponent):playCue("SFX/Objects/PasswordGate_Open", nil, 0.5)
      for _,checker in ipairs(l_5_0.charCheckers) do
        checker:hide()
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return LayoutEntity

