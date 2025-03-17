-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Entities\StatementHardware\SetClassTableNumberHardware.lua 

local Class = require("Class")
local Entity = require("Entity")
local SetClassTableHardware = Entity.cache:load("Content/Game/Global/Entities/StatementHardware/SetClassTableHardware")
local SetClassTableNumberHardware = Class.create(SetClassTableHardware, "SetClassTableNumberHardware")
SetClassTableNumberHardware.addIntegerField("VALUE", 0)
return SetClassTableNumberHardware

