-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\StateGraphGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local SpriteGui = Gui.load("Content/Game/Global/Gui/SpriteGui")
local LabelGui = Gui.load("Content/Game/Global/Gui/LabelGui")
local SpriteSheet = require("SpriteSheet")
local StateGraphGui = Class.create(Gui, "StateGraphGui")
StateGraphGui.Node = Class.create(Gui, "StateGraphGui.Node")
StateGraphGui.Node.NODE_SIZE = 64
StateGraphGui.Node.LINK_WIDTH = 24
StateGraphGui.Node.DEPTH_DISTANCE = 128
StateGraphGui.Node.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0, l_1_1)
  l_1_0.cursor, l_1_0.version, l_1_0.childIndex = l_1_2, l_1_3, l_1_4
  l_1_0.label = LabelGui.new(l_1_0, l_1_0.cursor.state.versions[l_1_0.version].tag)
  l_1_0.sprite = SpriteGui.new(l_1_0, SpriteSheet.load("UI/SaveStateViewer/SaveStateViewer"), "Node")
  l_1_0.sprite:position(-l_1_0.NODE_SIZE * 0.5, -l_1_0.NODE_SIZE * 0.5, l_1_0.NODE_SIZE * 0.5, l_1_0.NODE_SIZE * 0.5)
  l_1_0.label:position(l_1_0.NODE_SIZE, -l_1_0.NODE_SIZE * 0.5, l_1_0.NODE_SIZE + 512, l_1_0.NODE_SIZE * 0.5)
  l_1_0.label:show(false)
  l_1_0.cursor.versionNodes[l_1_3] = l_1_0
  l_1_0.sprite.spriteProp:setPriority(l_1_0.DEPTH_DISTANCE + l_1_0.NODE_SIZE)
  l_1_0.label.textBox:setPriority(l_1_0.DEPTH_DISTANCE + l_1_0.NODE_SIZE * 2)
  l_1_0.childNodes = {}
  l_1_0.totalWidth = 0
  local children = l_1_0.cursor.childMap[l_1_3]
  if children then
    for index,child in pairs(children) do
      local childNode = StateGraphGui.Node.new(l_1_0, l_1_0.cursor, child, index)
      table.insert(l_1_0.childNodes, childNode)
      l_1_0.totalWidth = l_1_0.totalWidth + childNode.totalWidth
    end
    local offset = -l_1_0.totalWidth * 0.5
    for index,node in pairs(l_1_0.childNodes) do
      local x, y = offset + node.totalWidth * 0.5, l_1_0.DEPTH_DISTANCE
      node:position(x, y, x, y)
      local dist = math.sqrt(x * x + y * y)
      local link = SpriteGui.new(l_1_0, SpriteSheet.load("UI/SaveStateViewer/SaveStateViewer"), "Link", {stretch = true})
      local theta = math.atan2(y, x)
      local linkWidth, linkHeight = link.spritesheet:getDimensions("Link")
      link.spriteProp:setScl(1, dist / linkHeight)
      link.spriteProp:setPriority(0)
      link.spriteProp:setRot(0, 0, theta * 180 / math.pi - 90)
      link.prop:setPriority(-1)
      offset = offset + node.totalWidth
    end
  else
    l_1_0.totalWidth = l_1_0.DEPTH_DISTANCE
  end
  return nodeProp, totalWidth
end

StateGraphGui.Node.setSelected = function(l_2_0, l_2_1)
  if l_2_1 then
    l_2_0.sprite:setSprite(l_2_0.sprite.spritesheet, "NodeSelected")
    l_2_0.label:show(true)
  else
    l_2_0.sprite:setSprite(l_2_0.sprite.spritesheet, "Node")
    l_2_0.label:show(false)
  end
end

StateGraphGui.Cursor = Class.create(Gui, "StateGraphGui.Cursor")
StateGraphGui.Cursor.MOVE_SPEED = 25
StateGraphGui.Cursor.init = function(l_3_0, l_3_1, l_3_2)
  Gui.init(l_3_0, l_3_1)
  l_3_0.state = l_3_2
  l_3_0.childMap = {}
  l_3_0.versionNodes = {}
  for i,version in ipairs(l_3_0.state.versions) do
    local previous = version.previousVersion
    if previous then
      local previousChildren = l_3_0.childMap[previous]
      if not previousChildren then
        previousChildren = {}
        l_3_0.childMap[previous] = previousChildren
      end
      table.insert(previousChildren, i)
    end
  end
  l_3_0.rootNode = StateGraphGui.Node.new(l_3_0, l_3_0, 1)
  l_3_0:select(l_3_2.activeVersion)
  l_3_0:snapToTarget()
end

StateGraphGui.Cursor.tick = function(l_4_0)
  local x, y = l_4_0.rootNode.prop:getLoc()
  local dx, dy = -l_4_0.targetX - x, -l_4_0.targetY - y
  if dx == 0 and dy == 0 then
    return 
  end
  local length = math.sqrt(dx * dx + dy * dy)
  if length < l_4_0.MOVE_SPEED then
    l_4_0:snapToTarget()
  else
    local nx, ny = dx / length, dy / length
    l_4_0.rootNode.prop:setLoc(x + nx * l_4_0.MOVE_SPEED, y + ny * l_4_0.MOVE_SPEED)
  end
end

StateGraphGui.Cursor.select = function(l_5_0, l_5_1)
  if l_5_0.selectedNode then
    l_5_0.selectedNode:setSelected(false)
  end
  if l_5_1 then
    l_5_0.selectedNode = l_5_0.versionNodes[l_5_1]
  end
  if l_5_0.selectedNode then
    l_5_0.selectedNode:setSelected(true)
    local ancestor = l_5_0.selectedNode
    local x, y = 0, 0
    repeat
      if ancestor ~= l_5_0.rootNode then
        local locX, locY = ancestor.prop:getLoc()
        x, y = x + locX, y + locY
        ancestor = ancestor.parent
      else
        l_5_0.targetX, l_5_0.targetY = x, y
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StateGraphGui.Cursor.snapToTarget = function(l_6_0)
  l_6_0.rootNode.prop:setLoc(-l_6_0.targetX, -l_6_0.targetY)
end

StateGraphGui.Cursor.handleMotive = function(l_7_0, l_7_1, l_7_2)
  l_7_0:playCue("UI/Hacking_UI/HackingUI_ToggleParameter")
  if l_7_1 == "Up" then
    local version = l_7_0.selectedNode.version
    do
      local children = l_7_0.childMap[version]
      if children then
        l_7_0:select(children[1])
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    elseif l_7_1 == "Down" and l_7_0.selectedNode ~= l_7_0.rootNode then
      l_7_0:select(l_7_0.selectedNode.parent.version)
      do return end
      do
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if l_7_1 == "Left" and l_7_0.selectedNode ~= l_7_0.rootNode then
          local siblings = l_7_0.childMap[l_7_0.selectedNode.parent.version]
          if l_7_0.selectedNode.childIndex > 1 then
            l_7_0:select(siblings[l_7_0.selectedNode.childIndex - 1])
          end
          do return end
          do
             -- DECOMPILER ERROR: unhandled construct in 'if'

            if l_7_1 == "Right" and l_7_0.selectedNode ~= l_7_0.rootNode then
              local siblings = l_7_0.childMap[l_7_0.selectedNode.parent.version]
              if l_7_0.selectedNode.childIndex < #siblings then
                l_7_0:select(siblings[l_7_0.selectedNode.childIndex + 1])
              end
              do return end
              Gui.handleMotive(l_7_0, l_7_1, l_7_2)
            end
          end
        end
      end
    end
  end
end

StateGraphGui.init = function(l_8_0, l_8_1, l_8_2)
  Gui.init(l_8_0, l_8_1, true)
  l_8_0.layer:setSortMode(MOAILayer.SORT_VECTOR_ASCENDING)
  l_8_0.layer:setSortScale(0, -1, 0, 1)
  l_8_0.cursor = StateGraphGui.Cursor.new(l_8_0, l_8_2)
end

StateGraphGui.resize = function(l_9_0, l_9_1, l_9_2)
  local centerX, centerY = l_9_1 * 0.5, l_9_2 * 0.5
  l_9_0.cursor:position(centerX, centerY, centerX, centerY)
end

StateGraphGui.getSelectedVersion = function(l_10_0)
  return l_10_0.cursor.selectedNode.version
end

StateGraphGui.handleFocusGain = function(l_11_0)
  if l_11_0.root.focus == l_11_0 then
    l_11_0.root:setFocus(l_11_0.cursor)
  end
end

return StateGraphGui

