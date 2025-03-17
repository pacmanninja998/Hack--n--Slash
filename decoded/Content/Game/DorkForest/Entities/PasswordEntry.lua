-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\PasswordEntry.lua 

local Entity = require("Entity")
local PasswordEntry = require("Class").create(Entity, "PasswordEntry")
local AnimatorComponent = require("Components.AnimatorComponent")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local SpriteSheet = require("SpriteSheet")
PasswordEntry.password = ""
PasswordEntry.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Interactions/Props/Placeholder/PasswordEntry/PasswordEntry")
  PhysicsComponent.new(l_1_0, 128, 128, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  SoundComponent.new(l_1_0, {})
  l_1_0.portProp = MOAIProp.new()
  l_1_0.portProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  l_1_0.portSheet = SpriteSheet.load("Interactions/Props/Placeholder/Port/Port")
  local firstName = next(l_1_0.portSheet.data.animations, nil)
  local deck, index = l_1_0.portSheet:getDeck(firstName, 1, false)
  l_1_0.portProp:setDeck(deck)
  l_1_0.portProp:setIndex(index)
  l_1_0.portProp:setScl(4, 4)
  l_1_0:attachProp(l_1_0.portProp)
  l_1_0.charCheckers = {}
  l_1_0.hidden = false
  l_1_0.hackOffsetY = -192
end

PasswordEntry.isHackable = function(l_2_0)
  return true
end

PasswordEntry.setCharChecker = function(l_3_0, l_3_1, l_3_2)
  l_3_0.charCheckers[l_3_1] = l_3_2
end

PasswordEntry.onFieldSet = function(l_4_0, l_4_1, l_4_2)
  if l_4_1 == "password" then
    l_4_0:checkPassword()
  end
end

PasswordEntry.checkPassword = function(l_5_0, l_5_1)
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
        if not l_5_0:universe().state.state.hidePasswordFeedback then
          l_5_0:get(SoundComponent):playCue("SFX/Hackable_Objects/Password_Green", nil, 0.5)
        else
          l_5_0:get(SoundComponent):playCue("SFX/Hackable_Objects/Password_Red", nil, 0.5)
        end
      else
        l_5_0:get(SoundComponent):playCue("SFX/Hackable_Objects/Password_Red", nil, 0.5)
      end
    end
    if fullMatch and string.len(l_5_0.password) == table.getn(l_5_0.charCheckers) and l_5_0.hidden == false then
      l_5_0:get(SoundComponent):playCue("SFX/Objects/PasswordGate_Open", nil, 0.5)
      l_5_0.hidden = true
      for _,checker in ipairs(l_5_0.charCheckers) do
        checker:hide()
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return PasswordEntry

