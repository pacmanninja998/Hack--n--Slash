-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Items\BombItem.lua 

local Item = require("Item")
local Delegate = require("DFMoai.Delegate")
local Action = require("Action")
local Entity = require("Entity")
local SpriteSheet = require("SpriteSheet")
local PhysicsComponent = require("Components.PhysicsComponent")
local SoundComponent = require("Components.SoundComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
local BombItem = require("Class").create(Item, "BombItem")
BombItem.PlaceBombAction = require("Class").create(Action, "BombItem.PlaceBombAction")
BombItem.PlaceBombAction.init = function(l_1_0, l_1_1)
  l_1_0.item = l_1_1
  l_1_0.bombPlacedEvent = Delegate.new()
end

BombItem.PlaceBombAction.start = function(l_2_0, l_2_1)
  Action.start(l_2_0, l_2_1)
  local posX, posY = l_2_0.entity:getPosition()
  local dirX, dirY = l_2_0.entity:get(AnimatorComponent):getDirVector()
  local bomb = Entity.create("Content/Game/Global/Entities/Bomb", l_2_0.entity.layer, posX + 32 * dirX, posY + 32 * dirY)
  l_2_0.bombPlacedEvent:dispatch(bomb)
end

BombItem.getAction = function(l_3_0, l_3_1)
  return BombItem.PlaceBombAction.new(l_3_1, l_3_0.state)
end

BombItem.getDescription = function(l_4_0)
  return "Breakpoint bombs"
end

BombItem.getSprite = function(l_5_0)
  return "UI/ItemIcons/Bomb/Bomb", "Bomb"
end

return BombItem

