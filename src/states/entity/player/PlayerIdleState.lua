--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player, dungeon)
    -- calling with a dot to specify PlayerIdleState as self
    EntityIdleState.init(self, player)
    self.dungeon = dungeon
    self.lifting = false
end

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if self.lifting then
        return
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.entity:checkForPotPickup(self, self.dungeon)
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end