-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\IdasCell\ThirdField.lua 

local Entity = require("Entity")
local Field = Entity.cache:load("Content/Game/DweebKeep/Entities/IdasCell/Field")
local LayoutEntity = require("Class").create(Field, "ThirdField")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Field.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
end

return LayoutEntity

