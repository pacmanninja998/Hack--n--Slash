-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Hosts\WizardHost.lua 

local Host = require("Host")
local Entity = require("Entity")
local WizardHost = require("Class").create(Host, "WizardHost")
WizardHost.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Host.init(l_1_0, l_1_1, l_1_2, l_1_3)
end

WizardHost.setState = function(l_2_0, l_2_1)
  Host.setState(l_2_0, l_2_1)
  if l_2_1.encyphered then
    return 
  end
  local world = l_2_0.universe.worlds[l_2_0.state.entryWorld]
  l_2_0:insertRoom(world, l_2_0.state.entryRoomPath)
end

WizardHost.insertRoom = function(l_3_0, l_3_1, l_3_2, l_3_3, ...)
  local room = Host.insertRoom(l_3_0, l_3_1, l_3_2, l_3_3, ...)
  local x, y = l_3_0:getAvatarSpawnInfo(room)
  local christo = Entity.create("Content/Game/Global/Entities/Christo", room:getLayerByOrder(0), x, y, "Christo", l_3_0.state)
  if not l_3_3 then
    room:markHostEntity(christo, l_3_0, #l_3_0.roomStack)
  end
  l_3_0:setFocalEntity(christo)
  l_3_0.driver:driveEntity(christo)
  do
    local eve = Entity.create("Content/Game/Global/Entities/RedSprite", room:getLayerByOrder(0), x, y, "Eve")
    if not l_3_3 then
      room:markHostEntity(eve, l_3_0, #l_3_0.roomStack)
      return room
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

WizardHost.startScene = function(l_4_0, l_4_1)
  local room = l_4_0.focalEntity:room()
  room:startScene(l_4_1)
end

WizardHost.getAvatarSpawnInfo = function(l_5_0, l_5_1)
  local wizardSpawner = l_5_1.entitiesByName["Wizard spawner"]
  if wizardSpawner then
    return wizardSpawner:getPosition()
  end
  return l_5_1.sizeX * 0.5, l_5_1.sizeY * 0.5
end

return WizardHost

