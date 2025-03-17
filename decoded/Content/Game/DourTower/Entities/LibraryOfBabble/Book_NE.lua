-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DourTower\Entities\LibraryOfBabble\Book_NE.lua 

local Class = require("Class")
local Entity = require("Entity")
local Book = Entity.cache:load("Content/Game/DourTower/Entities/LibraryOfBabble/Book")
local Book_NE = Class.create(Book, "Book_NE")
Book_NE.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Class.super(Book_NE).init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, "Book_NE")
end

return Book_NE

