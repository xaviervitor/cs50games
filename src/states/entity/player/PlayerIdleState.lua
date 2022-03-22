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
end

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- create hitbox based on where the player is and facing
        local direction = self.entity.direction
        local hitboxX, hitboxY
        local hitboxWidth, hitboxHeight = 8, 8
        
        if direction == 'left' then
            hitboxX = self.entity.x - hitboxWidth
            hitboxY = self.entity.y + self.entity.height / 2
        elseif direction == 'right' then
            hitboxX = self.entity.x + self.entity.width
            hitboxY = self.entity.y + self.entity.height / 2
        elseif direction == 'up' then
            hitboxX = self.entity.x + self.entity.width / 4
            hitboxY = self.entity.y - hitboxHeight
        else
            hitboxX = self.entity.x + self.entity.width / 4
            hitboxY = self.entity.y + self.entity.height
        end
        
        -- separate hitbox for the player's sword; will only be active during this state
        local pickupHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

        -- check if hitbox collides with any objects in the scene
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object:collides(pickupHitbox) then
                gSounds['hit-enemy']:play()
                self.entity:changeState('carrying-idle', {
                    object = object 
                })
            end
        end
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end