-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\UniverseStateGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local UniverseStateGui = Class.create(Gui, "UniverseStateGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local ListGui = Gui.load("Content/Game/Global/Gui/ListGui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local StateGraphGui = Gui.load("Content/Game/Global/Gui/StateGraphGui")
local SpriteSheet = require("SpriteSheet")
local EntityRef = require("EntityRef")
local SceneComponent = require("Components.SceneComponent")
local HealthComponent = require("Components.HealthComponent")
UniverseStateGui.SELECTION_COLOR = {0.44705882352941, 0.99607843137255, 0.9921568627451}
UniverseStateGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Class.super(UniverseStateGui).init(l_1_0, l_1_1)
  l_1_0.universe = l_1_2
  l_1_0.entityRef = EntityRef.new(l_1_3)
  l_1_0.sprite = SpriteSheet.load("UI/SaveStateViewer/SaveStateViewer")
  l_1_0.state = "opening"
  l_1_0.background = SpriteGui.new(l_1_0, l_1_0.sprite, "Open", {loop = false})
  l_1_0.graph = StateGraphGui.new(l_1_0, l_1_0.universe.state)
  l_1_0.graph:show(false)
  l_1_0.close = false
  MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/StateSave_Open", false)
  l_1_0:setFocus(l_1_0.graph)
end

UniverseStateGui.resize = function(l_2_0, l_2_1, l_2_2)
  Class.super(UniverseStateGui).resize(l_2_0, l_2_1, l_2_2)
  l_2_0.background:position(0, 0, l_2_1, l_2_2)
  l_2_0.graph:position(l_2_1 * 0.25, l_2_2 * 0.25, l_2_1 * 0.75, l_2_2)
end

UniverseStateGui.handleMotive = function(l_3_0, l_3_1, l_3_2)
  if l_3_1 == "Dismiss" and l_3_0.entityRef:isValid() then
    local health = l_3_0.entityRef.entity:get(HealthComponent)
    do
      if health and health.curHealth > 0 then
        MOAIFmodEventMgr.playEvent2D("UI/Hacking_UI/StateSave_Close", false)
        l_3_0.graph:show(false)
        l_3_0.close = true
      end
      do return end
      if not l_3_0.close and (l_3_1 == "Select" or l_3_1 == "Interact") then
        local version = l_3_0.graph:getSelectedVersion()
        local state = l_3_0.universe.state:synthesizeVersionState(version)
        local hasAmulet = false
        for index,item in ipairs(state.hosts.primary.inventory) do
          if item.path == "Content/Game/Global/Items/StateAmulet" then
            hasAmulet = true
        else
          end
        end
        local entity = l_3_0.entityRef.entity
        if entity and not entity:get(SceneComponent).currentRoutine then
          entity:get(SceneComponent):play(function(l_1_0)
          local alicePortrait = l_1_0:addAlicePortrait()
          local bobPortrait = l_1_0:addCharacter("Portraits/Bob/Bob")
          if hasAmulet then
            if entity.state.curHealth > 0 then
              l_1_0:speakLineRight(bobPortrait, "We're going to travel through timespace?", "Excited")
              local menu = l_1_0:createMenu(entity.state, "artifactDialog", alicePortrait)
              menu:addRepeatOption("cancel", "On second thought...")
              menu:addRepeatOption("confirm", "Yep!")
              local option = menu:choose()
              if option == "cancel" then
                l_1_0:speakLineRight(alicePortrait, "On second thought.... let's hang out here for a bit longer.", "FreakedOut")
                self.close = true
              elseif option == "confirm" then
                l_1_0:speakLineRight(alicePortrait, "Yep! Here we go!", "HappyLaugh")
                self:activateVersion(version)
              else
                self:activateVersion(version)
              end
            else
              l_1_0:speakLineRight(bobPortrait, "Whoa! If we rewind too far, we won't even have the amulet! We might not even have met each other!", "OMG")
              local menu = l_1_0:createMenu(entity.state, "artifactDialog", alicePortrait)
              menu:addRepeatOption("cancel", "Yeah, you're right. Let's not go back that far.")
              menu:addRepeatOption("confirm", "Trust me. I know what I'm doing.")
              local option = menu:choose()
              if option == "cancel" then
                l_1_0:speakLineRight(alicePortrait, "Yeah, you're right. Let's not go back that far.")
              elseif option == "confirm" then
                l_1_0:speakLineRight(alicePortrait, "Trust me. I know what I'm doing.", "Snobby")
                l_1_0:speakLineLeft(bobPortrait, "Alright, then I'll see you on the other side!", "Sly")
                self:activateVersion(version)
              end
            end
          end
            end)
        else
          l_3_0:activateVersion(version)
        end
      else
        Class.super(UniverseStateGui).handleMotive(l_3_0, l_3_1, l_3_2)
      end
    end
  end
end

UniverseStateGui.activateVersion = function(l_4_0, l_4_1)
  l_4_0.versionActivated = true
  l_4_0.universe:activateVersion(l_4_1)
end

UniverseStateGui.run = function(l_5_0)
  l_5_0.background:setSprite(l_5_0.sprite, "Default", nil, true)
  l_5_0.graph:show(true)
  l_5_0.state = "running"
end

UniverseStateGui.tick = function(l_6_0)
  Class.super(UniverseStateGui).tick(l_6_0)
  if l_6_0.state == "opening" and l_6_0.background:finished() then
    l_6_0:run()
  end
  if l_6_0.state == "running" and l_6_0.close then
    l_6_0.background:setSprite(l_6_0.sprite, "Close", nil, false)
    l_6_0.state = "closing"
  end
  if l_6_0.state == "closing" and l_6_0.background:finished() then
    l_6_0.dismissed = true
  end
end

return UniverseStateGui

