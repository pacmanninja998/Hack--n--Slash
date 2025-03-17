-- Decompiled using luadec 2.0.2 by sztupy (http://winmo.sztupy.hu)
-- Command line was: C:\Users\pacmanninja998\Downloads\luadec51_2.0.2_win32\decode\Content\Game\DweebKeep\Entities\SpinningBlade.lua 

local Entity = require("Entity")
local SpinningBlade = require("Class").create(Entity, "SpinningBlade")
local SpriteComponent = require("Components.SpriteComponent")
local PhysicsComponent = require("Components.PhysicsComponent")
local HealthComponent = require("Components.HealthComponent")
local SpriteSheet = require("SpriteSheet")
local Direction = require("Direction")
SpinningBlade.ANGULAR_VELOCITY = 60
SpinningBlade.OFFSET = 0
SpinningBlade.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9, l_1_10, l_1_11, l_1_12)
  Entity.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0.innerRadius = l_1_6 or 256
  l_1_0.outerRadius = l_1_7 or 300
  l_1_0.segments = l_1_8 or 32
  if not l_1_9 then
    l_1_0.ANGULAR_VELOCITY = SpinningBlade.ANGULAR_VELOCITY
  end
  l_1_0.OFFSET = SpinningBlade.OFFSET
  l_1_0.initialOffset = l_1_10 or 0
  l_1_0.spriteFrame = l_1_11 or "30degrees"
  l_1_0.bladeAngle = l_1_12 or 60
  PhysicsComponent.new(l_1_0, 0, 0, PhysicsComponent.DYNAMIC_CATEGORY, nil, MOAIBox2DBody.STATIC)
  local physics = l_1_0:get(PhysicsComponent)
  l_1_0.bladeSheet = SpriteSheet.load("Interactions/Props/Placeholder/SpinningBlade/SpinningBlade")
  l_1_0.bladeProps = {}
  for i = 1, l_1_0.segments do
    local startAngle = (i - 1) * (2 * math.pi / l_1_0.segments)
    local endAngle = startAngle + math.rad(l_1_0.bladeAngle)
    local avgAngle = (startAngle + endAngle) / 2
    local avgRadius = (l_1_0.innerRadius + l_1_0.outerRadius) / 2
    local fixtureCoords = {}
    local fixtureSegmentAngle = (endAngle - startAngle) / 4
    for i = 1, 4 do
      angle1 = startAngle + (i - 1) * fixtureSegmentAngle
      angle2 = angle1 + fixtureSegmentAngle
      fixtureCoords[i] = {}
      table.insert(fixtureCoords[i], l_1_0.innerRadius * math.cos(angle1))
      table.insert(fixtureCoords[i], l_1_0.innerRadius * math.sin(angle1))
      table.insert(fixtureCoords[i], l_1_0.outerRadius * math.cos(angle1))
      table.insert(fixtureCoords[i], l_1_0.outerRadius * math.sin(angle1))
      table.insert(fixtureCoords[i], l_1_0.outerRadius * math.cos(angle2))
      table.insert(fixtureCoords[i], l_1_0.outerRadius * math.sin(angle2))
      table.insert(fixtureCoords[i], l_1_0.innerRadius * math.cos(angle2))
      table.insert(fixtureCoords[i], l_1_0.innerRadius * math.sin(angle2))
    end
    local fixtures = {}
    for i,coords in ipairs(fixtureCoords) do
      fixtures[i] = physics.body:addPolygon(fixtureCoords[i])
    end
    for i,fixture in ipairs(fixtures) do
      fixture:setDebugColor(1, 0, 0.8)
      fixture:setDebugPenWidth(2)
      fixture:setCollisionHandler(function(l_1_0, l_1_1, l_1_2, l_1_3)
        local hitBody = l_1_2:getBody()
        self:onHitDynamic(hitBody.entity, l_1_0, l_1_1, l_1_2, l_1_3)
         end, MOAIBox2DArbiter.POST_SOLVE, PhysicsComponent.DYNAMIC_CATEGORY)
    end
    local centerX, centerY = avgRadius * math.cos(avgAngle), avgRadius * math.sin(avgAngle)
    local prop = MOAIProp.new()
    table.insert(l_1_0.bladeProps, prop)
    prop:setPriority(0)
    prop:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
    l_1_0:attachProp(prop)
    local deck, index = l_1_0.bladeSheet:getDeck(l_1_0.spriteFrame, 1, false)
    if deck then
      prop:setDeck(deck)
      prop:setIndex(index)
      prop:setLoc(centerX, centerY)
      prop:setRot(0, 0, math.deg(avgAngle) - 90)
      prop:setScl(0.8, 0.8)
    end
  end
  l_1_0.elapsed = 0
end

SpinningBlade.onHitDynamic = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  if l_2_1 then
    local health = l_2_1:get(HealthComponent)
    if health then
      local contactNormX, contactNormY = l_2_5:getContactNormal()
      local knockBackMag = 512
      health:damage(1, l_2_0.entity, -knockBackMag * contactNormX, -knockBackMag * contactNormY, 0.05, 0.3, 1)
    end
  end
end

SpinningBlade.tick = function(l_3_0)
  local angle = l_3_0.initialOffset + l_3_0.OFFSET + l_3_0.elapsed * l_3_0.ANGULAR_VELOCITY
  l_3_0:setAngle(angle)
  l_3_0.elapsed = l_3_0.elapsed + MOAISim.getStep()
  Entity.tick(l_3_0)
end

SpinningBlade.onFieldSet = function(l_4_0, l_4_1, l_4_2)
  if l_4_1 == "OFFSET" and tonumber(l_4_2) then
    l_4_0[l_4_1] = l_4_2
  end
end

SpinningBlade.setAngle = function(l_5_0, l_5_1)
  local posX, posY = l_5_0:getPosition()
  l_5_0:get(PhysicsComponent).body:setTransform(posX, posY, l_5_1)
end

return SpinningBlade

