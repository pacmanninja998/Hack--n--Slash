-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\CreditsRoom\Rooms\CreditsRoom.lua 

local Math = require("DFCommon.Math")
local Class = require("Class")
local Room = require("Room")
local CreditsRoom = Room.classFromLayout("Content/Game/CreditsRoom/Layouts/CreditsRoom", "CreditsRoom", "Content/Game/Global/Rooms/GameRoom")
local SceneComponent = require("Components.SceneComponent")
local AnimatorComponent = require("Components.AnimatorComponent")
CreditsRoom.onInit = function(l_1_0)
  l_1_0:defineLogicTrigger("West exit", function(l_1_0, l_1_1)
    self:onTeleport(l_1_1, "West exit", "East exit")
   end, nil, true)
  l_1_0:defineLogicTrigger("East exit", function(l_2_0, l_2_1)
    self:onTeleport(l_2_1, "East exit", "West exit")
   end, nil, true)
  l_1_0:getEntity("Team").pressedEvent:register(l_1_0.onTeamPressurePlatePressed, l_1_0)
  l_1_0:getEntity("Studio").pressedEvent:register(l_1_0.onStudioPressurePlatePressed, l_1_0)
  l_1_0:getEntity("MadePossibleBy").pressedEvent:register(l_1_0.onMadePossibleByPressurePlatePressed, l_1_0)
  l_1_0:getEntity("TeamThanks").pressedEvent:register(l_1_0.onTeamThanksPressurePlatePressed, l_1_0)
  l_1_0:getEntity("SpecialThanks").pressedEvent:register(l_1_0.onSpecialThanksPressurePlatePressed, l_1_0)
end

CreditsRoom.onTeamPressurePlatePressed = function(l_2_0, l_2_1, l_2_2)
  if not l_2_2 then
    return 
  end
  local alice = l_2_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    l_1_0:displayTitleCard(15, "<c:72FEFDFF>HACK 'N' SLASH TEAM</></title>\nBrandon Dillon                                 Project Lead\nMatt Hansen                              Executive Producer\nSu Liu                                   Assistant Producer\nDuncan Boehle                      Lead Gameplay Programmer\nPaul Du Bois                         Additional Programming\nMark Hamer                     Art Director / Lead Animator\nRazmig Mavlian      Background Designer / Background Artist\nSay Oh                                               Artist\nRay Crook                                          Animator\nLydia Choy                      VFX Artist / Voice of Alice\nErin Eldridge                                        Writer\nPaul O'Rourke                     Sound Designer / Composer\nBrian Correia                              Additional Audio\nAnthony Banks                                     QA Tester\nTony Lo                                           QA Tester\nVictor Romero                                     QA Tester<title>\n")
    alice:halt(false)
   end)
end

CreditsRoom.onStudioPressurePlatePressed = function(l_3_0, l_3_1, l_3_2)
  if not l_3_2 then
    return 
  end
  local alice = l_3_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    l_1_0:displayTitleCard(15, "<c:72FEFDFF>DOUBLE FINE PRODUCTIONS</></title>\nTim Schafer\t                              President and CEO\nJustin Bailey                                          COO\nIsa Stamos                               VP of Development\nGreg Rice                        Senior Publishing Manager\nDaniel Pangelina                                QA Manager\nBrian Min                                   Audio Director\nChris Remo                                 Web Development\nAmarisse Sullivan                     Office Administrator\nDenise Gollaher                         Operations Manager\nBarry Drake                                     Accountant\nJustin Honegger                         Desktop Technician\nAaron Hayes                               Tech Ops Manager\nAdrian Melian                                  Studio Tech\nOliver Franzke                                 Studio Tech\nPaul Du Bois                                   Studio Tech<title>\n")
    alice:halt(false)
   end)
end

CreditsRoom.onMadePossibleByPressurePlatePressed = function(l_4_0, l_4_1, l_4_2)
  if not l_4_2 then
    return 
  end
  local alice = l_4_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    l_1_0:displayTitleCard(10, "<c:72FEFDFF>HACK 'N' SLASH\nWAS MADE POSSIBLE BY</></title>\n\nIndie Fund\nHumble Bundle\nHemisphere Games\nmake all LLC\nAppAbove Games\nAdam and Rebekah Saltsman\nThe Behemoth\nMorgan Webb\nRob Reid<title>\n")
    alice:halt(false)
   end)
end

CreditsRoom.onTeamThanksPressurePlatePressed = function(l_5_0, l_5_1, l_5_2)
  if not l_5_2 then
    return 
  end
  local alice = l_5_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    l_1_0:displayTitleCard(2, "<c:72FEFDFF>THE TEAM WOULD LIKE TO THANK</>")
    l_1_0:displayTitleCard(5, "</>Max\nDale\nStormtrooper\nTeebo\nRancor\nMochi\nRosco\nCadet\nKuma\nWaffle<title>")
    l_1_0:displayTitleCard(5, "</>Mark Boehle\nLisa Boehle\nAnna Boehle<title>")
    l_1_0:displayTitleCard(5, "</>Michele and Ruby</title>")
    l_1_0:displayTitleCard(5, "</>Razmig Mavlian would like to thank everyone<title>")
    l_1_0:displayTitleCard(5, "</>Mary Hull\nSarah Hull\nBrad Hull\nRon O'Rourke\nAndrew O'Rourke\nTony O'Rourke<title>")
    l_1_0:displayTitleCard(5, "</>Roger Hansen\nSandi Hansen\nAndrew Hansen\nKristen Russell\nFleury\nOtis McGoaterson\nStatsy \"Mr. S\"<title>")
    l_1_0:displayTitleCard(5, "</>Mom\nDad\nDrew Skillman\nShawn Choy<title>")
    l_1_0:displayTitleCard(5, "</>NOKturne\nChance<title>")
    l_1_0:displayTitleCard(5, "</>Hongying Lin\nTao Liu\nReed and friends<title>")
    l_1_0:displayTitleCard(5, "</>Crystal and Ares<title>")
    l_1_0:displayTitleCard(5, "</>Keri\nTia (Cake)\nTerra (Kicks)\nJack C. Bailey<title>")
    l_1_0:displayTitleCard(5, "</>Barb and Tim Rice\nCari\nMatt\nAdaline Friesleben<title")
    l_1_0:displayTitleCard(5, "</>Derek Brand\nChris Schultz\nMalena Annable\n\nfor their help on the original AF prototype<title>")
    l_1_0:displayTitleCard(5, "</>\n<c:72FEFDFF>Shannon</>\nMatt Alderman\n#shenanigans<title>")
    l_1_0:displayTitleCard(5, "</>All of Double Fine's Awesome Fans<title>")
    alice:halt(false)
   end)
end

CreditsRoom.onSpecialThanksPressurePlatePressed = function(l_6_0, l_6_1, l_6_2)
  if not l_6_2 then
    return 
  end
  local alice = l_6_0:getAlice()
  alice:get(SceneComponent):play(function(l_1_0)
    alice:halt(true)
    l_1_0:displayTitleCard(15, "<c:72FEFDFF>SPECIAL THANKS</></title>\nFangamer\n2 Player Productions\nThe entire team at Double Fine Productions\n\nFMOD Ex Sound System\nCopyright \194\169 2001-2014 Firelight Technologies Pty, ltf.\nAll rights reserved.<title>")
    l_1_0:displayTitleCard(5, "THANKS FOR PLAYING!")
    alice:halt(false)
   end)
end

CreditsRoom.onTeleport = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if not l_7_1.host then
    return 
  end
  local posX, posY = l_7_1:getPosition()
  local collisionArea = l_7_0.collisionAreasByName[l_7_2]
  local p1X, p1Y = collisionArea.points[1][1], collisionArea.points[1][2]
  local p2X, p2Y = collisionArea.points[2][1], collisionArea.points[2][2]
  local ratio = math.max(0, math.min(1, Math.project(p1X, p1Y, p2X, p2Y, posX, posY)))
  local dirX, dirY = l_7_1:get(AnimatorComponent):getDirVector()
  local collision = l_7_0.collisionAreasByName[l_7_3]
  local sourceX, sourceY = unpack(collision.points[1])
  local targetX, targetY = unpack(collision.points[2])
  local dX, dY = targetX - sourceX, targetY - sourceY
  local newPosX, newPosY = sourceX + dX * ratio, sourceY + dY * ratio
  newPosX, newPosY = newPosX + dirX * 32, newPosY + dirY * 32
  l_7_1:setPosition(newPosX, newPosY, true)
end

CreditsRoom.fade = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4)
  if l_8_1 == l_8_0.FADE_IN then
    local alice = l_8_0:getAlice()
    alice.host:doRoomExit(alice, "Content/Game/CrackerCavern/Rooms/CaveLab")
  end
end

return CreditsRoom

