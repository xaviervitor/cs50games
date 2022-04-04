--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    
end

function Player:checkForPotPickup(state, dungeon)
    -- create hitbox based on where the player is and facing
    local direction = self.direction
    local hitboxX, hitboxY
    local hitboxWidth, hitboxHeight = 8, 8

    if direction == 'left' then
        hitboxX = self.x - hitboxWidth
        hitboxY = self.y + self.height / 2
    elseif direction == 'right' then
        hitboxX = self.x + self.width
        hitboxY = self.y + self.height / 2
    elseif direction == 'up' then
        hitboxX = self.x + self.width / 4
        hitboxY = self.y - hitboxHeight
    else
        hitboxX = self.x + self.width / 4
        hitboxY = self.y + self.height
    end

    -- separate hitbox for the player's sword; will only be active during this state
    local pickupHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- check if hitbox collides with any objects in the scene
    for k, object in pairs(dungeon.currentRoom.objects) do
        if object:collides(pickupHitbox) and object.type == 'pot' and not object.shattering and not object.destroyed then
            self:pickupPot(state, object, dungeon, k)
        end
    end
end

function Player:pickupPot(state, object, dungeon, k)
    self:changeAnimation('object-lift-' .. self.direction)
    
    if self.direction == 'left' or self.direction == 'right' then
        object.y = math.floor(self.y + self.height - object.height)
    elseif self.direction == 'up' or self.direction == 'down' then
        object.x = math.floor(self.x)
    end

    state.lifting = true
    Timer.after(0.2, function()
        object.y = math.floor(self.y - self.height / 2)
        Timer.after(0.2, function()
            object.x = math.floor(self.x)
            Timer.after(0.1, function()
                self.heldPot = object
                table.remove(dungeon.currentRoom.objects, k)
                state.lifting = false
                self:changeState('carrying-pot-idle')
            end)
        end)
    end)
end