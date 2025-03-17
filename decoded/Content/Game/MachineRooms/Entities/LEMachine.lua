-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\MachineRooms\Entities\LEMachine.lua 

local Class = require("Class")
local Entity = require("Entity")
local CompareMachine = Entity.cache:load("Content/Game/MachineRooms/Entities/CompareMachine")
local LEMachine = Class.create(CompareMachine, "LEMachine")
LEMachine.addEditableField("COMPARISON", Class.EnumSchema.new("<=", ">="))
return LEMachine

