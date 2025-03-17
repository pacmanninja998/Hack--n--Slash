-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DorkForest\Entities\SpookyPath\Campfire.lua 

local Entity = require("Entity")
local LayoutEntity = require("Class").create(Entity, "Campfire")
local SpriteComponent = require("Components.SpriteComponent")
local SoundComponent = require("Components.SoundComponent")
LayoutEntity.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  SpriteComponent.new(l_1_0, "Layouts/Game/DorkForest/SpookyPath/SpookyPath", "Campfire")
  SoundComponent.new(l_1_0)
  l_1_0:setLabelText("")
  l_1_0.effectCue = l_1_0:get(SoundComponent):playCue("SFX/SourcePoints/SpookyPath_BoilingPot", true, 0.5)
end

return LayoutEntity

