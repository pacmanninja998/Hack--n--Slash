-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\LockPortBlock.lua 

local Entity = require("Entity")
local PortBlock = Entity.cache:load("Content/Game/Global/Entities/PortBlock")
local LockPortBlock = require("Class").create(PortBlock, "LockPortBlock")
LockPortBlock.addBooleanField("OPEN", false)
return LockPortBlock

