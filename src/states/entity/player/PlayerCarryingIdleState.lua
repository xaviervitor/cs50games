--[[
    GD50
    Legend of Zelda

    Author: Vitor Xavier
    xavier1vitor@gmail.com
]]

PlayerIdleCarryingState = Class{__includes = EntityIdleState}

-- function PlayerIdleCarryingState:init(player, dungeon, object)
--     self.player = player
--     self.dungeon = dungeon

--     -- render offset for spaced character sprite
--     self.player.offsetY = 5
--     self.player.offsetX = 8

--     -- create hitbox based on where the player is and facing
--     local direction = self.player.direction
--     local hitboxX, hitboxY, hitboxWidth, hitboxHeight

--     if direction == 'left' then
--         hitboxWidth = 8
--         hitboxHeight = 16
--         hitboxX = self.player.x - hitboxWidth
--         hitboxY = self.player.y + 2
--     elseif direction == 'right' then
--         hitboxWidth = 8
--         hitboxHeight = 16
--         hitboxX = self.player.x + self.player.width
--         hitboxY = self.player.y + 2
--     elseif direction == 'up' then
--         hitboxWidth = 16
--         hitboxHeight = 8
--         hitboxX = self.player.x
--         hitboxY = self.player.y - hitboxHeight
--     else
--         hitboxWidth = 16
--         hitboxHeight = 8
--         hitboxX = self.player.x
--         hitboxY = self.player.y + self.player.height
--     end

--     -- separate hitbox for the player's sword; will only be active during this state
--     self.swordHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

--     -- sword-left, sword-up, etc
--     self.player:changeAnimation('sword-' .. self.player.direction)
-- end

function PlayerIdleCarryingState:enter(params)
    self.entity:changeAnimation('carrying-idle-' .. self.entity.direction)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleCarryingState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carrying-walk')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- throw object
        self.entity:changeState('idle')
    end
end

function PlayerIdleCarryingState:render()
    EntityIdleState.render(self)
    
    love.graphics.draw(gTextures[GAME_OBJECT_DEFS['pot'].texture], gFrames[GAME_OBJECT_DEFS['pot'].texture][GAME_OBJECT_DEFS['pot'].frame], 
    self.entity.x, self.entity.y - self.entity.height / 2)
end