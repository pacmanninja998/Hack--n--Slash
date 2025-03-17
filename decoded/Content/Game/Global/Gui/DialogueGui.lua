-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\DialogueGui.lua 

local Delegate = require("DFMoai.Delegate")
local Class = require("Class")
local Gui = require("Gui")
local DialogueGui = Class.create(Gui, "DialogueGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local PromptGui = Gui.load("Content/Game/Global/Gui/PromptGui")
local SpriteSheet = require("SpriteSheet")
local EntityRef = require("EntityRef")
local Shader = require("Shader")
DialogueGui.CONTENTS_RECT = {210, 110, 1720, 420}
DialogueGui.PROMPT_SCALE = 0.75
DialogueGui.init = function(l_1_0, l_1_1, l_1_2)
  Class.super(DialogueGui).init(l_1_0, l_1_1, l_1_2)
  l_1_0.ref = EntityRef.new(l_1_2)
  l_1_0.sprite = SpriteSheet.load("UI/DialogueBox/DialogueBox")
  l_1_0.leftSprite = SpriteSheet.load("UI/DialogueBox/DialogueBox")
  l_1_0.rightSprite = SpriteSheet.load("UI/DialogueBox/DialogueBox")
  l_1_0.leftFrame = SpriteGui.new(l_1_0, l_1_0.leftSprite, "Left", {loop = true})
  l_1_0.rightFrame = SpriteGui.new(l_1_0, l_1_0.rightSprite, "Right", {loop = true})
  l_1_0.leftFrame.spriteProp:setVisible(false)
  l_1_0.rightFrame.spriteProp:setVisible(false)
  l_1_0.centerSprite = SpriteSheet.load("UI/DialogueBox/DialogueBox")
  l_1_0.centerFrame = SpriteGui.new(l_1_0, l_1_0.centerSprite, "Left", {loop = true})
  l_1_0.centerFrame.spriteProp:setVisible(false)
  l_1_0.skipEvent = Delegate.new()
  l_1_0.dialogueFrame = SpriteGui.new(l_1_0, l_1_0.sprite, "Left", {loop = true})
  l_1_0.label = LabelGui.new(l_1_0.dialogueFrame, "", {justifyHorizontal = MOAITextBox.LEFT_JUSTIFY, justifyVertical = MOAITextBox.LEFT_JUSTIFY})
  l_1_0.list = ListGui.new(l_1_0.dialogueFrame)
  l_1_0.prompts = {}
  l_1_0:setFocus(l_1_0.label)
  l_1_0.isRunning = true
  l_1_0.dialogueSpriteShader = Shader.create("Content/Game/Global/Shaders/DialogueSprite")
  l_1_0.dialogueBoxShader = Shader.create("Content/Game/Global/Shaders/DialogueBox")
  l_1_0.leftFrame:setDefaultShader(l_1_0.dialogueSpriteShader)
  l_1_0.rightFrame:setDefaultShader(l_1_0.dialogueSpriteShader)
  l_1_0.centerFrame:setDefaultShader(l_1_0.dialogueSpriteShader)
  l_1_0.dialogueFrame:setDefaultShader(l_1_0.dialogueBoxShader)
end

DialogueGui.setLeftSprite = function(l_2_0, l_2_1, l_2_2)
  l_2_0.leftSprite = l_2_1
  l_2_0.leftFrame:setSprite(l_2_0.leftSprite, l_2_2, nil, true)
  l_2_0.dialogueFrame:setSprite(l_2_0.sprite, "Left", nil, true)
  l_2_0.leftFrame.spriteProp:setVisible(true)
  l_2_0.rightFrame.spriteProp:setVisible(false)
  l_2_0.centerFrame.spriteProp:setVisible(false)
end

DialogueGui.setRightSprite = function(l_3_0, l_3_1, l_3_2)
  l_3_0.rightSprite = l_3_1
  l_3_0.rightFrame:setSprite(l_3_0.rightSprite, l_3_2, nil, true)
  l_3_0.dialogueFrame:setSprite(l_3_0.sprite, "Right", nil, true)
  l_3_0.rightFrame.spriteProp:setVisible(true)
  l_3_0.leftFrame.spriteProp:setVisible(false)
  l_3_0.centerFrame.spriteProp:setVisible(false)
end

DialogueGui.addPrompt = function(l_4_0, l_4_1)
  if l_4_0.ref:isValid() then
    local gui = PromptGui.new(l_4_0, l_4_0.ref.entity, l_4_1)
    gui:show(false)
    table.insert(l_4_0.prompts, gui)
  end
  l_4_0:redoLayout()
end

DialogueGui.displayLine = function(l_5_0, l_5_1, l_5_2)
  l_5_0.spooled = true
  l_5_0.label:setText(l_5_1)
  l_5_0.label:spool()
  repeat
    repeat
      if l_5_0.isRunning and not l_5_2 then
        coroutine.yield()
      until not l_5_0.label:isDone()
      l_5_0:playCue("UI/Hacking_UI/Scrolling_Text")
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DialogueGui.displayOptions = function(l_6_0, l_6_1)
  l_6_0.spooled = false
  l_6_0.list = ListGui.new(l_6_0.dialogueFrame)
  l_6_0:setFocus(l_6_0.list)
  for _,option in ipairs(l_6_1) do
    l_6_0.list:insert(LabelGui.new(l_6_0.list, option))
  end
  l_6_0:redoLayout()
  repeat
    if l_6_0.isRunning then
      coroutine.yield()
    else
      return l_6_0.list.selectionIndex
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DialogueGui.resize = function(l_7_0, l_7_1, l_7_2)
  Gui.resize(l_7_0, l_7_1, l_7_2)
  l_7_0.dialogueFrame:position(0, 0, l_7_1, l_7_2)
  local x0, y0, x1, y1 = unpack(l_7_0.CONTENTS_RECT)
  l_7_0.label:position(x0, y0, x1, y1)
  l_7_0.list:position(x0, y0, x1, y1)
  l_7_0.leftFrame:position(-l_7_1 * 0.5, l_7_2 * 0.5, l_7_1, l_7_2)
  l_7_0.rightFrame:position(l_7_1 * 0.5, l_7_2 * 0.5, l_7_1, l_7_2)
  l_7_0.centerFrame:position(0, 0, l_7_1, l_7_2)
  local totalX = 0
  local maxY = 0
  local promptWidths = {}
  for index,prompt in ipairs(l_7_0.prompts) do
    local promptX, promptY = prompt:measure(l_7_1, l_7_2)
    promptX, promptY = promptX * l_7_0.PROMPT_SCALE, promptY * l_7_0.PROMPT_SCALE
    promptWidths[index] = promptX
    totalX = totalX + promptX
    if maxY < promptY then
      maxY = promptY
    end
  end
  local xOffset = x0 + 0.5 * (x1 - x0 - (totalX))
  local yOffset = y0 + 0.5 * (y1 - y0 - maxY)
  for index,prompt in ipairs(l_7_0.prompts) do
    prompt:position(xOffset, yOffset, xOffset + promptWidths[index], yOffset + maxY)
    xOffset = xOffset + promptWidths[index]
  end
end

DialogueGui.handleMotive = function(l_8_0, l_8_1, l_8_2)
  if l_8_1 == "Select" then
    if not l_8_0.label:isDone() then
      l_8_0.label:revealAll()
    else
      l_8_0.isRunning = false
    end
  elseif l_8_1 == "Dismiss" then
    l_8_0.skipEvent:dispatch()
    l_8_0.isRunning = false
  else
    Class.super(DialogueGui).handleMotive(l_8_0, l_8_1, l_8_2)
  end
end

DialogueGui.tick = function(l_9_0)
  Class.super(DialogueGui).tick(l_9_0)
  if l_9_0.label:isDone() then
    if l_9_0.label:more() and l_9_0.spooled then
      l_9_0.label:nextPage(false)
      l_9_0.label:spool()
    else
      for index,prompt in ipairs(l_9_0.prompts) do
        prompt:show(true)
      end
    end
  end
end

return DialogueGui

