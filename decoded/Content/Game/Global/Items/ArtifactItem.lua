-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\ArtifactItem.lua 

local Class = require("Class")
local Action = require("Action")
local Item = require("Item")
local ArtifactItem = Class.create(Item, "ArtifactItem")
local ArtifactGui = require("Gui").load("Content/Game/Global/Gui/ArtifactGui")
local CommonActions = require("CommonActions")
local InterfaceComponent = require("Components.InterfaceComponent")
ArtifactItem.Action = Class.create(CommonActions.Pose, "ArtifactItem.Action")
ArtifactItem.Action.init = function(l_1_0, l_1_1)
  Class.super(ArtifactItem.Action).init(l_1_0)
  l_1_0.item = l_1_1
end

ArtifactItem.Action.start = function(l_2_0, l_2_1)
  local type = l_2_0.item:getSpriteName(l_2_1)
  l_2_0.animation, l_2_0.inAnimation = "Hold_" .. type, "PullOut_" .. type
  Class.super(ArtifactItem.Action).start(l_2_0, l_2_1)
  l_2_0.gui = ArtifactGui.new(nil, l_2_0.entity, l_2_0.item)
  l_2_0.entity:get(InterfaceComponent):pushInterface(l_2_0.gui)
end

ArtifactItem.Action.tick = function(l_3_0)
  if l_3_0.gui and l_3_0.gui.dismissed then
    l_3_0.entity:get(InterfaceComponent):removeInterface(l_3_0.gui)
    l_3_0.gui = nil
    l_3_0.active = false
  end
  return Class.super(ArtifactItem.Action).tick(l_3_0)
end

ArtifactItem.Action.stop = function(l_4_0)
  Class.super(ArtifactItem.Action).stop(l_4_0)
  if l_4_0.gui then
    l_4_0.entity:get(InterfaceComponent):removeInterface(l_4_0.gui)
    l_4_0.gui = nil
  end
end

ArtifactItem.synthesizeHostArtifact = function(l_5_0)
  return {global = false, field = l_5_0}
end

ArtifactItem.getField = function(l_6_0, l_6_1)
  if l_6_0.state.global then
    return l_6_0.state.field, l_6_1:universe().state
  else
    return l_6_0.state.field, l_6_1.host
  end
end

ArtifactItem.getValue = function(l_7_0, l_7_1)
  local field, container = l_7_0:getField(l_7_1)
  if container then
    return container[field]
  end
end

ArtifactItem.getSpriteName = function(l_8_0, l_8_1)
  local value = l_8_0:getValue(l_8_1)
  if type(value) == "boolean" then
    return "Sphere"
  else
    if type(value) == "string" then
      return "Pyramid"
    else
      if type(value) == "number" then
        return "Cylinder"
      else
        return "Cube"
      end
    end
  end
end

ArtifactItem.getAction = function(l_9_0, l_9_1)
  return ArtifactItem.Action.new(l_9_0)
end

ArtifactItem.getSprite = function(l_10_0, l_10_1)
  return "UI/ArtifactIcons/ArtifactIcons", l_10_0:getSpriteName(l_10_1)
end

ArtifactItem.getDescription = function(l_11_0)
  return "A strange artifact labeled \"" .. l_11_0.state.field .. "\"."
end

return ArtifactItem

