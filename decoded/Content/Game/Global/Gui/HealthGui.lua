-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\HealthGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local HealthGui = Class.create(Gui, "HealthGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local SpriteSheet = require("SpriteSheet")
local HealthComponent = require("Components.HealthComponent")
HealthGui.PIP_SIZE = 160
HealthGui.PIP_SPACING = -HealthGui.PIP_SIZE * 0.25
HealthGui.init = function(l_1_0, l_1_1, l_1_2)
  Gui.init(l_1_0, l_1_1)
  l_1_0.entity = l_1_2
  l_1_0.pips = {}
  l_1_0.label = LabelGui.new(l_1_0, "", {justifyHorizontal = MOAITextBox.LEFT_JUSTIFY, justifyVertical = MOAITextBox.RIGHT_JUSTIFY, height = 72})
  local health = l_1_0.entity:get(HealthComponent)
  health.onDamaged:register(l_1_0.onDamaged, l_1_0)
  health.onKilled:register(l_1_0.onKilled, l_1_0)
  health.onInvincible:register(l_1_0.onInvincible, l_1_0)
  health.onMaxHealthChanged:register(l_1_0.onMaxHealthChanged, l_1_0)
  l_1_0:updatePips()
end

HealthGui.onDamaged = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_0:updatePips()
end

HealthGui.onKilled = function(l_3_0)
end

HealthGui.onInvincible = function(l_4_0, l_4_1)
end

HealthGui.onMaxHealthChanged = function(l_5_0, l_5_1)
  l_5_0:updatePips()
end

HealthGui.updatePips = function(l_6_0)
  local dirty = false
  local health = l_6_0.entity:get(HealthComponent)
  if health.maxHealth < 10 then
    for index = 1, #l_6_0.pips do
      local name = "Empty"
      if index <= health.curHealth then
        name = "Full"
      end
      local pip = l_6_0.pips[index]
      if name ~= pip.name then
        pip:setSprite(pip.spritesheet, name)
      end
    end
    for index = #l_6_0.pips + 1, health.maxHealth do
      local name = "Empty"
      if index <= health.curHealth then
        name = "Full"
      end
      local pip = SpriteGui.new(l_6_0, SpriteSheet.load("UI/HealthPip/HealthPip"), name)
      table.insert(l_6_0.pips, pip)
      dirty = true
    end
    for index = #l_6_0.pips, health.maxHealth + 1, -1 do
      l_6_0.pips[index]:destroy()
      table.remove(l_6_0.pips, index)
      dirty = true
    end
    l_6_0.label:show(false)
  else
    for index = #l_6_0.pips, 1, -1 do
      l_6_0.pips[index]:destroy()
      table.remove(l_6_0.pips, index)
      dirty = true
    end
    l_6_0.label:setText(string.format("<title>%d/%d</title>", health.curHealth, health.maxHealth))
    l_6_0.label:show(true)
  end
  if dirty then
    l_6_0:requestResize()
  end
end

HealthGui.resize = function(l_7_0, l_7_1, l_7_2)
  Gui.resize(l_7_0, l_7_1, l_7_2)
  for index = 1, #l_7_0.pips do
    local offset = (l_7_0.PIP_SIZE + l_7_0.PIP_SPACING) * (index - 1)
    l_7_0.pips[index]:position(offset, 0, offset + l_7_0.PIP_SIZE, l_7_0.PIP_SIZE)
  end
  l_7_0.label:position(16, 16, l_7_1, l_7_2)
end

return HealthGui

