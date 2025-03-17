-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Debug\Rooms\MultiRoomTest.lua 

local Room = require("Room")
local MultiRoomTest = Room.classFromLayout("Content/Game/Debug/Layouts/MultiRoomTest", "MultiRoomTest")
local Layout = require("Layout")
MultiRoomTest.onInit = function(l_1_0)
  l_1_0.freeCamera = true
  l_1_0.activeLayouts = {}
  l_1_0:addLayout(1)
  l_1_0:addLayout(2)
end

MultiRoomTest.addLayout = function(l_2_0, l_2_1)
  local layoutPath = nil
  if l_2_1 % 2 == 1 then
    layoutPath = "Content/Game/Debug/Layouts/MultiRoomA"
  else
    layoutPath = "Content/Game/Debug/Layouts/MultiRoomB"
  end
  local layout = Layout.load(layoutPath)
  local x, y = l_2_1 * 512, 0
  local chunksets, entities, areas = {}, {}, {}
  layout:applyToRoom(l_2_0, x, y, chunksets, entities, areas)
  local leftTrigger, rightTrigger = l_2_0:getTriggerNames(l_2_1)
  l_2_0:defineLogicTrigger(leftTrigger, function()
    self:onLeftTrigger(index)
   end, nil, true)
  l_2_0:defineLogicTrigger(rightTrigger, function()
    self:onRightTrigger(index)
   end, nil, true)
  l_2_0.activeLayouts[l_2_1] = {chunksets, entities, areas}
end

MultiRoomTest.removeLayout = function(l_3_0, l_3_1)
  local chunksets, entities, areas = unpack(l_3_0.activeLayouts[l_3_1])
  for i,chunkset in ipairs(chunksets) do
    chunkset:setRenderLayer()
    chunkset:setPartition()
  end
  for i,ref in ipairs(entities) do
    if ref.entity then
      ref.entity:destroy()
    end
  end
  for i,area in ipairs(areas) do
    area:destroy()
  end
  l_3_0.activeLayouts[l_3_1] = nil
end

MultiRoomTest.onLeftTrigger = function(l_4_0, l_4_1)
  local expired = l_4_1 + 2
  if l_4_0.activeLayouts[expired] then
    l_4_0:removeLayout(expired)
  end
  local new = l_4_1 - 2
  if new > 0 and not l_4_0.activeLayouts[new] then
    l_4_0:addLayout(new)
  end
end

MultiRoomTest.onRightTrigger = function(l_5_0, l_5_1)
  local expired = l_5_1 - 2
  if l_5_0.activeLayouts[expired] then
    l_5_0:removeLayout(expired)
  end
  local new = l_5_1 + 2
  if not l_5_0.activeLayouts[new] then
    l_5_0:addLayout(new)
  end
end

MultiRoomTest.getTriggerNames = function(l_6_0, l_6_1)
  if l_6_1 % 2 == 1 then
    return "Left trigger (A)", "Right trigger (A)"
  else
    return "Left trigger (B)", "Right trigger (B)"
  end
end

return MultiRoomTest

