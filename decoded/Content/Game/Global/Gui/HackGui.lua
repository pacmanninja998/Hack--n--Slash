-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\Global\Gui\HackGui.lua 

local Class = require("Class")
local Gui = require("Gui")
local Direction = require("Direction")
local Entity = require("Entity")
local EditGui = Gui.load("Content/Game/Global/Gui/EditGui")
local EntityRef = require("EntityRef")
local HackGui = Class.create(Gui, "HackGui")
HackGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  Gui.init(l_1_0, l_1_1)
  l_1_0.targetEntity = EntityRef.new(l_1_2)
  l_1_0.corner = l_1_4
  l_1_0:playCue("UI/Hacking_UI/HackingUI_Overview")
  l_1_0.editGui = EditGui.new(l_1_0, l_1_2.name, l_1_3)
  l_1_0.editGui.dismissEvent:register(l_1_0.onEditDismiss, l_1_0)
  local class = l_1_2:class()
  local ancestor = class
  local lastSchemas = nil
  repeat
    if ancestor then
      if not ancestor.schemas then
        local patchSchema = false
        for key,value in pairs(ancestor) do
          if key ~= "class" and key ~= "COLLIDE_MASK" and key ~= "DEBUG_LABEL_HUE" then
            if type(value) == "number" then
              ancestor.addIntegerField(key, value)
              patchSchema = true
              for key,value in (for generator) do
              end
              if type(value) == "boolean" then
                ancestor.addBooleanField(key, value)
                patchSchema = true
                for key,value in (for generator) do
                end
                if type(value) == "string" then
                  ancestor.addStringField(key, value)
                  patchSchema = true
                end
              end
            end
            if patchSchema then
              if lastSchemas then
                setmetatable(lastSchemas, {__index = ancestor.schemas})
              end
              lastSchemas = ancestor.schemas
            else
              lastSchemas = ancestor.schemas
            end
          end
          local mt = getmetatable(ancestor)
          if mt then
            ancestor = mt.__index
          end
        else
          local fields = {}
          do
            local ancestor = class
            repeat
              if ancestor then
                local schemas = rawget(ancestor, "schemas")
                if schemas then
                  for field,schema in pairs(schemas) do
                    table.insert(fields, field)
                  end
                end
                local mt = getmetatable(ancestor)
                if mt then
                  ancestor = mt.__index
                end
              else
                table.sort(fields)
                for i,field in ipairs(fields) do
                  local schema = class.schemas[field]
                  local instanceValue = rawget(l_1_2, field)
                  if instanceValue then
                    rawset(l_1_2, field, nil)
                    l_1_2[field] = instanceValue
                  end
                end
                for i,field in ipairs(fields) do
                  local schema = class.schemas[field]
                  l_1_0.editGui:addField(l_1_2, field, schema)
                end
                l_1_0:setFocus(l_1_0.editGui)
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HackGui.onChildRequestResize = function(l_2_0)
  l_2_0:resize(l_2_0.sizeX, l_2_0.sizeY)
end

HackGui.onEditDismiss = function(l_3_0)
  l_3_0.dismissed = true
end

HackGui.resize = function(l_4_0, l_4_1, l_4_2)
  Gui.resize(l_4_0, l_4_1, l_4_2)
  local editX, editY = l_4_0.editGui:measure(l_4_1, l_4_2)
  local posX, posY = nil, nil
  if l_4_0.corner == Direction.DIR_NW then
    posX, posY = 0, l_4_2 - editY
  else
    if l_4_0.corner == Direction.DIR_NE then
      posX, posY = l_4_1 - editX, l_4_2 - editY
    else
      if l_4_0.corner == Direction.DIR_SW then
        posX, posY = 0, 0
      else
        if l_4_0.corner == Direction.DIR_SE then
          posX, posY = l_4_1 - editX, 0
        else
          if l_4_0.targetEntity:isValid() then
            local x, y = 0, 0
            if l_4_0.targetEntity.entity:is(Entity) then
              x, y = l_4_0:getEntityClientLoc(l_4_0.targetEntity.entity)
            end
            local u, v = x / l_4_1, 1 - y / l_4_2
            if v < 0.5 then
              if u < 0.5 then
                posX, posY = l_4_1 - editX, 0
              else
                posX, posY = 0, 0
              end
            elseif u < 0.5 then
              posX, posY = l_4_1 - editX, l_4_2 - editY
            else
              posX, posY = 0, l_4_2 - editY
            end
          end
        end
      end
    end
  end
  posY = math.max(0, posY)
  l_4_0.editGui:position(posX, posY, posX + editX, posY + editY)
end

return HackGui

