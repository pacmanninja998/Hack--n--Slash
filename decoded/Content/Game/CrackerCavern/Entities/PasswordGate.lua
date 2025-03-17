-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\PasswordGate.lua 

local Entity = require("Entity")
local LockedGate = Entity.cache:load("Content/Game/Global/Entities/LockedGate")
local FunctionComponent = require("Components.FunctionComponent")
local InteractionComponent = require("Components.InteractionComponent")
local PasswordGate = require("Class").create(LockedGate, "PasswordGate")
PasswordGate.addStringField("PASSWORD", "")
PasswordGate.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  LockedGate.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  l_1_0:get(InteractionComponent):setEnabled(false)
  l_1_0.LOCKED = false
  l_1_0.fnSign = nil
  l_1_0.firstGate = nil
end

PasswordGate.setFunctionSign = function(l_2_0, l_2_1)
  l_2_0.fnSign = l_2_1
  local fnComponent = l_2_0.fnSign:get(FunctionComponent)
  fnComponent.functionChangedEvent:register(l_2_0.onSignFunctionChanged, l_2_0)
  l_2_0:onSignFunctionChanged(fnComponent.fn)
end

PasswordGate.onSignFunctionChanged = function(l_3_0, l_3_1)
  l_3_0:onFieldSet("PASSWORD", l_3_0.PASSWORD)
end

PasswordGate.onFieldSet = function(l_4_0, l_4_1, l_4_2)
  if l_4_1 == "PASSWORD" and l_4_0.fnSign then
    local fnComponent = l_4_0.fnSign:get(FunctionComponent)
    if fnComponent then
      local correctPassword = false
      if l_4_0.firstGate then
        correctPassword = fnComponent:exec(l_4_0.firstGate.PASSWORD, l_4_2)
      else
        correctPassword = fnComponent:exec(l_4_2)
      end
      l_4_0:setOpen(correctPassword)
      l_4_0:updateLightColors()
    end
  end
end

return PasswordGate

