-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\EQMachine.lua 

local Class = require("Class")
local Entity = require("Entity")
local CompareMachine = Entity.cache:load("Content/Game/MachineRooms/Entities/CompareMachine")
local EQMachine = Class.create(CompareMachine, "EQMachine")
EQMachine.addEditableField("COMPARISON", Class.EnumSchema.new("==", "~="))
return EQMachine

