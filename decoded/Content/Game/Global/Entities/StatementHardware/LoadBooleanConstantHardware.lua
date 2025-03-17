-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\LoadBooleanConstantHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local LoadConstantHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware/LoadConstantHardware")
local LoadBooleanConstantHardware = Class.create(LoadConstantHardware, "LoadBooleanConstantHardware")
LoadBooleanConstantHardware.addBooleanField("VALUE", false)
return LoadBooleanConstantHardware

