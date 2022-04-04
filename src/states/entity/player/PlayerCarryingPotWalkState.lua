--[[
    GD50
    Legend of Zelda

    Author: Vitor Xavier
    xavier1vitor@gmail.com
]]

PlayerWalkCarryingState = Class{__includes = EntityWalkState}

function PlayerWalkCarryingState:init(entity, dungeon)
    self.entity = entity
    --player walks slower when carrying the pot
    self.entity.walkSpeed = self.entity.walkSpeed / self.entity.heldPot.weight
    
    self.dungeon = dungeon
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
        self.entity.walkSpeed = self.entity.walkSpeed * self.entity.heldPot.weight
        self.entity:changeState('carrying-pot-idle')
    end

    self.entity.heldPot.x = math.floor(self.entity.x)
    self.entity.heldPot.y = math.floor(self.entity.y - self.entity.height / 2)
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local pot = Projectile(
            GAME_OBJECT_DEFS['pot'],
            self.entity.heldPot.x,
            self.entity.heldPot.y,
            self.entity.heldPot.frame,
            self.entity.direction,
            self.dungeon
        )
        table.insert(self.dungeon.currentRoom.objects, pot)
        self.entity.walkSpeed = self.entity.walkSpeed * self.entity.heldPot.weight
        self.entity.heldPot = nil
        self.entity:changeState('idle')
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)
end

function PlayerWalkCarryingState:render()
    EntityWalkState.render(self)
    
    love.graphics.draw(gTextures[self.entity.heldPot.texture], gFrames[self.entity.heldPot.texture][self.entity.heldPot.frame], 
    self.entity.heldPot.x, self.entity.heldPot.y)
end