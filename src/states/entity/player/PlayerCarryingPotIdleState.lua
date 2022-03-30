--[[
    GD50
    Legend of Zelda

    Author: Vitor Xavier
    xavier1vitor@gmail.com
]]

PlayerIdleCarryingState = Class{__includes = BaseState}

function PlayerIdleCarryingState:init(entity, dungeon)
    self.entity = entity
    self.entity.heldPot.x = math.floor(self.entity.x)
    self.entity.heldPot.y = math.floor(self.entity.y - self.entity.height / 2)
    self.entity:changeAnimation('carrying-idle-' .. self.entity.direction)
    
    self.dungeon = dungeon
end

function PlayerIdleCarryingState:enter(params)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleCarryingState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carrying-pot-walk')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local pot = Projectile(
            GAME_OBJECT_DEFS['pot'],
            self.entity.heldPot.x,
            self.entity.heldPot.y,
            self.entity.heldPot.frame,
            self.entity.direction
        )
        table.insert(self.dungeon.currentRoom.objects, pot)
        self.entity.heldPot = nil
        self.entity:changeState('idle')
    end
end

function PlayerIdleCarryingState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    love.graphics.draw(gTextures[self.entity.heldPot.texture], gFrames[self.entity.heldPot.texture][self.entity.heldPot.frame], 
    self.entity.heldPot.x, self.entity.heldPot.y)
end