-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CrackerCavern\Entities\OverrideGate.lua 

local Entity = require("Entity")
local JailGate = Entity.cache:load("Content/Game/Global/Entities/JailGate")
local FunctionComponent = require("Components.FunctionComponent")
local OverrideGate = require("Class").create(JailGate, "OverrideGate")
OverrideGate.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  JailGate.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  l_1_0.fnSign = nil
  l_1_0.hackableLightProp = MOAIProp.new()
  l_1_0.hackableLightProp:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  local deck, index = l_1_0.lightSheet:getDeck("GateLight", 1, false)
  l_1_0.hackableLightProp:setDeck(deck)
  l_1_0.hackableLightProp:setIndex(index)
  l_1_0:attachProp(l_1_0.hackableLightProp)
  l_1_0.hackableLightProp:setLoc(l_1_0.lightXPos, -16)
  l_1_0.hackableLightProp:setPriority(16)
  l_1_0.hackableLightProp:setColor(0, 1, 0)
end

OverrideGate.onFunctionChanged = function(l_2_0)
  if l_2_0.fnSign then
    local fnComponent = l_2_0.fnSign:get(FunctionComponent)
    if fnComponent and fnComponent:hasFunction() then
      if fnComponent:exec() then
        l_2_0.hackableLightProp:setColor(0, 1, 0)
      else
        l_2_0.hackableLightProp:setColor(1, 0, 0)
      end
    end
  end
end

OverrideGate.setFunctionSign = function(l_3_0, l_3_1)
  l_3_0.fnSign = l_3_1
  l_3_0.fnSign:get(FunctionComponent).functionChangedEvent:register(l_3_0.onFunctionChanged, l_3_0)
  l_3_0:onFunctionChanged()
end

OverrideGate.onFieldSet = function(l_4_0, l_4_1, l_4_2)
  JailGate.onFieldSet(l_4_0, l_4_1, l_4_2)
  if l_4_1 == "LOCKED" and not l_4_2 and l_4_0.fnSign then
    local fnComponent = l_4_0.fnSign:get(FunctionComponent)
    if fnComponent and fnComponent:hasFunction() and not fnComponent:exec() then
      l_4_0.LOCKED = true
    end
  end
end

return OverrideGate

