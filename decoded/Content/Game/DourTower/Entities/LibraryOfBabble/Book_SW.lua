-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryOfBabble\Book_SW.lua 

local Class = require("Class")
local Entity = require("Entity")
local Book = Entity.cache:load("Content/Game/DourTower/Entities/LibraryOfBabble/Book")
local Book_SW = Class.create(Book, "Book_SW")
Book_SW.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Book_SW).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, "Book_SW")
end

return Book_SW

