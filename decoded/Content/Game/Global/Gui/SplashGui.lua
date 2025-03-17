-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\SplashGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local SplashGui = Class.create(Gui, "SplashGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local ShaderGui = Gui.load("Content/Game/Global/Gui/ShaderGui")
local PromptGui = Gui.load("Content/Game/Global/Gui/PromptGui")
SplashGui.PROMPT_FADE_TIME = 1
SplashGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  Class.super(SplashGui).init(l_1_0, l_1_1)
  l_1_0.duration, l_1_0.hold = l_1_4, l_1_5
  if l_1_2 then
    l_1_0.background = SpriteGui.new(l_1_0, l_1_2)
    l_1_0.background:setDefaultShader(l_1_3)
  else
    l_1_0.background = ShaderGui.new(l_1_0, l_1_3)
  end
  l_1_0.elapsed = 0
  l_1_0:updateElapsed()
end

SplashGui.setEntity = function(l_2_0, l_2_1)
  if l_2_0.hold then
    l_2_0.prompt = PromptGui.new(l_2_0, l_2_1, "Select")
    l_2_0.prompt:show(false)
    l_2_0:updateElapsed()
    l_2_0:requestResize()
  end
end

SplashGui.tick = function(l_3_0)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  l_3_0:updateElapsed()
end

SplashGui.dismiss = function(l_4_0)
  l_4_0.dismissed = true
end

SplashGui.updateElapsed = function(l_5_0)
  if l_5_0.background.material then
    l_5_0.background.material:setShaderValue("titleDuration", MOAIMaterial.VALUETYPE_FLOAT, l_5_0.elapsed / l_5_0.duration)
  end
  if l_5_0.duration < l_5_0.elapsed then
    if not l_5_0.hold then
      l_5_0:dismiss()
    elseif l_5_0.prompt then
      local opacity = math.min(1, (l_5_0.elapsed - l_5_0.duration) / l_5_0.PROMPT_FADE_TIME)
      l_5_0.prompt:show(true)
      l_5_0.prompt:setColor(1, 1, 1, opacity)
    end
  end
end

SplashGui.handleMotiveStart = function(l_6_0, l_6_1)
  if l_6_1 == "Select" or l_6_1 == "Dismiss" or l_6_1 == "OpenMenu" then
    l_6_0:dismiss()
  else
    Class.super(SplashGui).handleMotiveStart(l_6_0, l_6_1)
  end
end

SplashGui.resize = function(l_7_0, l_7_1, l_7_2)
  Class.super(SplashGui).resize(l_7_0, l_7_1, l_7_2)
  l_7_0.background:position(0, 0, l_7_1, l_7_2)
  if l_7_0.prompt then
    local promptX, promptY = 0, 0
    if l_7_0.prompt.spritesheet then
      promptX, promptY = l_7_0.prompt:measure(l_7_1, l_7_2)
    end
    local promptCenterX, promptCenterY = l_7_1 * 0.5, l_7_2 * 0.25
    l_7_0.prompt:position(promptCenterX - promptX * 0.5, promptCenterY - promptY * 0.5, promptCenterX + promptX * 0.5, promptCenterY + promptY * 0.5)
  end
end

return SplashGui

