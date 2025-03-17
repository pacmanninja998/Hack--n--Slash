-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\DebugGui.lua 

local Gui = require("Gui")
local DebugGui = require("Class").create(Gui, "FloatTextGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
DebugGui.init = function(l_1_0, l_1_1)
  Gui.init(l_1_0, l_1_1)
  l_1_0.label = LabelGui.new(l_1_0, nil, {height = 32, justifyVertical = MOAITextBox.LEFT_JUSTIFY})
end

DebugGui.resize = function(l_2_0, l_2_1, l_2_2)
  Gui.resize(l_2_0, l_2_1, l_2_2)
  l_2_0.label:position(0.025 * l_2_1, 0.025 * l_2_2, 0.95 * l_2_1, 0.95 * l_2_2)
end

DebugGui.tick = function(l_3_0)
  local debugText = ""
  debugText = debugText .. l_3_0:makeSoundText()
  debugText = debugText .. "\n\n\n" .. l_3_0:makePhysicsText()
  l_3_0.label:setText(debugText)
end

DebugGui.makeSoundText = function(l_4_0)
  local sOutput = ""
   -- DECOMPILER ERROR: No list found. Setlist fails

  local tMemoryInfo = {}
   -- DECOMPILER ERROR: No list found. Setlist fails

  local tSpecificStats = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  sOutput = MOAIFmodEventMgr.debugGetMemoryInfo() .. "<c:FFFFFFFF>Memory\nCurrently Allocated: " .. tostring(tMemoryInfo[1]) .. " Max Allocated: " .. tostring(tMemoryInfo[2]) .. "\nCodecs allocated for streaming: " .. tostring(tSpecificStats[1]) .. "\nFile buffers and structures: " .. tostring(tSpecificStats[2]) .. "\nSound objects and internals: " .. tostring(tSpecificStats[3])
  sOutput = sOutput .. "</>\n\n\n"
  if not MOAIFmodEventMgr then
    return 
  end
  sOutput = sOutput .. "<c:B3FFB3FF>Currently playing"
   -- DECOMPILER ERROR: No list found. Setlist fails

  local tAllSound = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  for _,rSoundEvent in MOAIFmodEventMgr.debugGetAllEventInstances()(tAllSound) do
    if not rSoundEvent:getParameter("musicstate") then
      local parameter = rSoundEvent:isPaused() or ""
    end
    sOutput = sOutput .. "\nEvent: " .. rSoundEvent:getName() .. " " .. parameter
  end
  sOutput = sOutput .. "</>\n\n\n"
  sOutput = sOutput .. "<c:B3FFB3FF>Currently paused:"
  for _,rSoundEvent in ipairs(tAllSound) do
    if rSoundEvent:isPaused() then
      sOutput = sOutput .. "\nEvent: " .. rSoundEvent:getName()
    end
  end
  sOutput = sOutput .. "</>\n\n\n"
  sOutput = sOutput .. "<c:B3B3FFFF>Currently ducked categories:"
   -- DECOMPILER ERROR: No list found. Setlist fails

  local tAllDuckedCategories = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  for _,sDuckedCategory in MOAIFmodEventMgr.debugGetAllDuckedCategories()(tAllDuckedCategories) do
    sOutput = sOutput .. "\n" .. sDuckedCategory .. " at volume: " .. MOAIFmodEventMgr.getSoundCategoryVolume(sDuckedCategory, true)
  end
  sOutput = sOutput .. "</>"
  return sOutput
end

DebugGui.makePhysicsText = function(l_5_0)
  local sOutput = "Physics colors:\n\n"
  do
    local PhysicsComponent = require("Components.PhysicsComponent")
    for categoryIndex,categoryBit in ipairs(PhysicsComponent.CATEGORIES) do
      local categoryName = PhysicsComponent.CATEGORY_NAMES[categoryBit]
      local categoryColor = PhysicsComponent.CATEGORY_COLORS[categoryBit]
      if type(categoryColor) == "table" then
        local r, g, b, a = unpack(categoryColor)
        if not a then
          r, g, b, a = r or 1, g or 1, b or 1, 1
          r, g, b, a = math.floor(255 * (r)), math.floor(255 * (g)), math.floor(255 * (b)), math.floor(255 * a)
          sOutput = sOutput .. string.format("%2d: <c:%02X%02X%02X%02X>%s</c>: %d\n", categoryIndex, r, g, b, a, categoryName, categoryBit)
        end
      end
      return sOutput
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return DebugGui

