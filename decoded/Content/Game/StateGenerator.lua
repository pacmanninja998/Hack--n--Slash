-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\StateGenerator.lua 

local StateGenerator = require("Class").create("StateGenerator")
local ArtifactItem = require("Item").load("Content/Game/Global/Items/ArtifactItem")
StateGenerator.CRITICAL_PATH_LAYOUT_ORDER = {{"DorkForest", "CaveTrap"}, {"DorkForest", "BobTrap"}, {"DorkForest", "SpookyPath"}, {"DorkForest", "SpriteClearing"}, {"DorkForest", "CentralForest"}, {"DorkForest", "SleepingSwamp"}, {"DorkForest", "LabRuins"}, {"DorkForest", "InnerForest"}, {"DweebKeep", "GeneralCells"}, {"DweebKeep", "DungeonLobby"}, {"DweebKeep", "DungeonLobbySouthHallway"}, {"DweebKeep", "WardenEntranceHallway"}, {"DweebKeep", "DungeonLobbyNorthHallway"}, {"DweebKeep", "SecurityGate"}, {"DweebKeep", "SecurityGateHallway"}, {"DweebKeep", "Armory"}, {"DweebKeep", "ArmoryWestHallway"}, {"DweebKeep", "ArmoryEastHallway"}, {"DweebKeep", "InnerPrisonLock"}, {"DweebKeep", "InnerPrisonLobby"}, {"DweebKeep", "IdasCell"}, {"DweebKeep", "HalcyonsCell"}, {"DweebKeep", "GlyphRoom"}, {"DweebKeep", "WardenEntrance"}, {"DweebKeep", "SecretTunnel"}, {"CrackerCavern", "InfiniteWoods"}, {"CrackerCavern", "CaveEntrance"}, {"CrackerCavern", "CaveLab"}, {"CrackerCavern", "CodePuzzle1"}, {"CrackerCavern", "CodePuzzle2"}, {"CrackerCavern", "CodePuzzle3"}, {"CrackerCavern", "CodePuzzle4"}, {"CrackerCavern", "CaveStash"}, {"CreditsRoom", "CreditsRoom"}, {"DourTower", "MagicGate"}, {"DourTower", "TowerLevel1"}, {"DourTower", "LibraryOfBabble"}, {"DourTower", "Staircase1"}, {"DourTower", "TowerLevel2"}, {"DourTower", "Staircase2"}, {"DourTower", "TowerLevel3"}, {"DourTower", "Staircase3"}, {"DourTower", "TowerLevel4"}, {"DourTower", "Staircase4"}, {"DourTower", "TowerLevel5"}, {"DourTower", "LibraryRoof"}, {"DourTower", "DRMRoof"}, {"DourTower", "PrincessChambers"}, {"Global", "ClassRoom"}, {"Global", "PrototypeRoom"}}
StateGenerator.getCriticalPathIndex = function(l_1_0, l_1_1)
  for index = 1, #StateGenerator.CRITICAL_PATH_LAYOUT_ORDER do
    local testAct, testRoom = unpack(StateGenerator.CRITICAL_PATH_LAYOUT_ORDER[index])
    if testAct == l_1_0 and testRoom == l_1_1 then
      return index
    end
  end
  return 1
end

StateGenerator.synthesizeGlobalState = function(l_2_0, l_2_1, l_2_2)
  local state = {}
  state.prisoners = {"Ida", "Chicco", "Halcyon"}
  state.forestHealAmount = -999
  state.menuScreen = {tab = 1, cursor = {1, 1}}
  state.modified = {}
  state.worlds = {}
  state.checkedOutBooks = {Data/Content/Game/DourTower/Rooms/PrincessChambers.lua = true}
  local world = {}
  world.roomStates = {}
  state.worlds.Urf = world
  if l_2_0 == "Debug" or l_2_0 == "EGW" then
    state.fixedSymbolicFont = true
  end
  local pathIndex = StateGenerator.getCriticalPathIndex(l_2_0, l_2_1)
  if StateGenerator.getCriticalPathIndex("DorkForest", "LabRuins") < pathIndex then
    state.forestHealAmount = 0
  end
  if StateGenerator.getCriticalPathIndex("DweebKeep", "GeneralCells") < pathIndex then
    state.forestHealAmount = -1000000000
    state.hidePasswordFeedback = true
    table.insert(state.prisoners, l_2_2)
  end
  if StateGenerator.getCriticalPathIndex("DweebKeep", "GlyphRoom") < pathIndex then
    state.fixedSymbolicFont = true
  end
  if state.fixedSymbolicFont then
    state.shiftedFontUV = {0, 0}
  else
    state.shiftedFontUV = {14, -30}
  end
  world.roomStates["Content/Game/CrackerCavern/Rooms/CaveEntrance"] = {}
  if StateGenerator.getCriticalPathIndex("CrackerCavern", "CaveEntrance") < pathIndex then
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveEntrance"].UnhackableGateDoor = {OPEN = false}
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveEntrance"].GateDoor = {OPEN = true}
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveEntrance"]["Triggered trap"] = true
  else
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveEntrance"].UnhackableGateDoor = {OPEN = true}
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveEntrance"].GateDoor = {OPEN = false}
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveEntrance"]["Triggered trap"] = false
  end
  world.roomStates["Content/Game/CrackerCavern/Rooms/CaveLab"] = {}
  if StateGenerator.getCriticalPathIndex("CrackerCavern", "CaveLab") < pathIndex then
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveLab"]["Visited before"] = true
  else
    world.roomStates["Content/Game/CrackerCavern/Rooms/CaveLab"]["Visited before"] = false
  end
  if StateGenerator.getCriticalPathIndex("DourTower", "MagicGate") < pathIndex then
    world.roomStates["Content/Game/DourTower/Rooms/MagicGate"] = {gateOpenAmount = 350}
  end
  if StateGenerator.getCriticalPathIndex("DourTower", "TowerLevel1") < pathIndex then
    world.roomStates["Content/Game/DourTower/Rooms/TowerLevel1"] = {neutralized = true}
  end
  if StateGenerator.getCriticalPathIndex("DourTower", "TowerLevel2") < pathIndex then
    world.roomStates["Content/Game/DourTower/Rooms/TowerLevel2"] = {timerFired = true}
  end
  if StateGenerator.getCriticalPathIndex("DourTower", "TowerLevel3") < pathIndex then
    world.roomStates["Content/Game/DourTower/Rooms/TowerLevel3"] = {passedTrap = true}
  end
  if StateGenerator.getCriticalPathIndex("DourTower", "TowerLevel4") < pathIndex then
    world.roomStates["Content/Game/DourTower/Rooms/TowerLevel4"] = {sawTrap = true}
  end
  if StateGenerator.getCriticalPathIndex("DourTower", "DRMRoof") < pathIndex then
    state.encypheredPrincessChambers = true
  end
  world.roomStates["Content/Game/CrackerCavern/Rooms/CaveStash"] = {FakeWallMoved = false}
  return state
end

StateGenerator.snythesizePrimaryHostState = function(l_3_0, l_3_1, l_3_2)
  local state = {}
  state.hostPath = "Content/Game/Hosts/PrimaryHost"
  state.trapped = true
  state.entryWorld = "Urf"
  state.entryRoomPath = "Content/Game/" .. l_3_0 .. "/Rooms/" .. l_3_1
  state.maxHealth, state.curHealth = 3, 3
  state.name = l_3_2
  state.inventory = {}
  state.artifacts = {}
  state.discoveredValues = {}
  state.fileSystemState = {}
  do
    local pathIndex = StateGenerator.getCriticalPathIndex(l_3_0, l_3_1)
    if StateGenerator.getCriticalPathIndex("DorkForest", "CaveTrap") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/HackItem", state = {exposed = true, plugUsed = true}})
      state.trapped = false
    end
    if StateGenerator.getCriticalPathIndex("DorkForest", "BobTrap") < pathIndex then
      state.bondedSprite = "Bob"
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if StateGenerator.getCriticalPathIndex("DorkForest", "SpriteClearing") >= pathIndex or StateGenerator.getCriticalPathIndex("DorkForest", "SpriteClearing") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/StateAmulet"})
    end
    if StateGenerator.getCriticalPathIndex("DorkForest", "InnerForest") < pathIndex then
      state.maxHealth, state.curHealth = 10, 5
      table.remove(state.inventory, 1)
      state.trapped = true
    end
    if StateGenerator.getCriticalPathIndex("DweebKeep", "GeneralCells") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/ThirdEyeHat"})
      state.trapped = false
      state.hoodless = true
    end
    if StateGenerator.getCriticalPathIndex("DweebKeep", "Armory") < pathIndex then
      table.insert(state.inventory, 1, {path = "Content/Game/Global/Items/HackItem", state = {exposed = true, plugUsed = true}})
      table.insert(state.inventory, {path = "Content/Game/Global/Items/ThrowBoomerang"})
    end
    if StateGenerator.getCriticalPathIndex("DweebKeep", "InnerPrisonLobby") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/ArtifactItem", state = ArtifactItem.synthesizeHostArtifact("INFO_OPACITY")})
      table.insert(state.inventory, {path = "Content/Game/Global/Items/ArtifactItem", state = ArtifactItem.synthesizeHostArtifact("TIME_DISTORTION")})
    end
    if StateGenerator.getCriticalPathIndex("DweebKeep", "IdasCell") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/IdaCommunicator"})
    end
    if StateGenerator.getCriticalPathIndex("DweebKeep", "HalcyonsCell") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/HalcyonLampItem"})
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if StateGenerator.getCriticalPathIndex("DweebKeep", "GlyphRoom") >= pathIndex or StateGenerator.getCriticalPathIndex("CrackerCavern", "CaveLab") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/MagicLoupe"})
      state.beganCodePuzzles = true
    end
    if StateGenerator.getCriticalPathIndex("DourTower", "MagicGate") <= pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/BombItem"})
    end
    if StateGenerator.getCriticalPathIndex("DourTower", "TowerLevel1") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/LibraryBookItem", state = {filePath = "Data/Content/Game/DourTower/Rooms/TowerLevel2.lua"}})
    end
    if StateGenerator.getCriticalPathIndex("DourTower", "TowerLevel3") < pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/LibraryBookItem", state = {filePath = "Data/Content/Game/DourTower/Rooms/TowerLevel4.lua"}})
    end
    if StateGenerator.getCriticalPathIndex("DourTower", "LibraryRoof") < pathIndex then
      state.escapedRoof = true
    end
    if StateGenerator.getCriticalPathIndex("DourTower", "DRMRoof") <= pathIndex then
      table.insert(state.inventory, {path = "Content/Game/Global/Items/LibraryBookItem", state = {filePath = "Data/Content/Game/DourTower/Rooms/PrincessChambersCopy.lua"}})
      state.sawEntrapment = true
      state.tookBook = true
    end
    if l_3_0 == "EGW" then
      state.inventory = {{path = "Content/Game/Global/Items/HackItem", state = {exposed = true, plugUsed = true}}, {path = "Content/Game/Global/Items/ThirdEyeHat"}}
    end
    state.equipped = {}
    state.equipped.secondary = {}
    for i,item in ipairs(state.inventory) do
      if i == 1 and item.path == "Content/Game/Global/Items/HackItem" then
        state.equipped.primary = i
        for i,item in (for generator) do
        end
        if #state.equipped.secondary < 4 then
          table.insert(state.equipped.secondary, i)
          for i,item in (for generator) do
          end
          state.equipped.secondary[4] = i
        end
        return state
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StateGenerator.synthesizeWizardState = function(l_4_0, l_4_1)
  local state = {}
  state.hostPath = "Content/Game/Hosts/WizardHost"
  state.entryWorld = "Urf"
  state.entryRoomPath = "Content/Game/DourTower/Rooms/TowerLevel5"
  return state
end

StateGenerator.synthesizeInitialState = function(l_5_0, l_5_1, l_5_2)
  local globalState = StateGenerator.synthesizeGlobalState(l_5_0, l_5_1, l_5_2)
  local hostState = StateGenerator.snythesizePrimaryHostState(l_5_0, l_5_1, l_5_2)
  local wizardState = StateGenerator.synthesizeWizardState(l_5_0, l_5_1)
  globalState.hosts = {primary = hostState, wizard = wizardState}
  return globalState
end

StateGenerator.generateDescription = function(l_6_0)
  local description = {}
  local activeData = l_6_0.versions[l_6_0.activeVersion]
  description.name = activeData.state.hosts.primary.name
  description.hoodless = activeData.state.hosts.primary.hoodless
  description.age = activeData.age
  local day, month, year, hour, minute, second = MOAISim.getDateTime()
  description.date = {day = day, month = month, year = year, hour = hour, minute = minute, second = second}
  return description
end

return StateGenerator

