-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\LoadNumberConstantHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local LoadConstantHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware/LoadConstantHardware")
local LoadNumberConstantHardware = Class.create(LoadConstantHardware, "LoadNumberConstantHardware")
LoadNumberConstantHardware.addIntegerField("VALUE", 0)
return LoadNumberConstantHardware

