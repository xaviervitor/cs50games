--[[
    GD50
    Legend of Zelda

    Author: Vitor Xavier
    xavier1vitor@gmail.com
]]

PlayerWalkCarryingState = Class{__includes = EntityWalkState}

function PlayerWalkCarryingState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkCarryingState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('carrying-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('carrying-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('carrying-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('carrying-walk-down')
    else
        self.entity:changeState('carrying-idle')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
end

function PlayerWalkCarryingState:render()
    EntityWalkState.render(self)
    
    love.graphics.draw(gTextures[GAME_OBJECT_DEFS['pot'].texture], gFrames[GAME_OBJECT_DEFS['pot'].texture][GAME_OBJECT_DEFS['pot'].frame], 
    self.entity.x, self.entity.y - self.entity.height / 2)
end