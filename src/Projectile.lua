--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(def, x, y, frame, direction)
    GameObject.init(self, def, x, y)
    self.frame = frame
    self.direction = direction
    
    self.throwLimit = 4 * TILE_SIZE
    self.fallLimit = self.height

    self.throwDistance = 0
    self.fallDistance = 0
    
    self.throwSpeed = 4
    self.fallSpeed = 0

    self.gravity = 0.128

    self.shattering = false
    self.shatterDuration = 1
    self.shatterTimer = 0
    self.flashTimer = 0
    
    self.destroyed = false
end

function Projectile:update(dt)
    if self.destroyed then
        return
    elseif self.shattering then
        self.flashTimer = self.flashTimer + dt
        self.shatterTimer = self.shatterTimer + dt

        if self.shatterTimer > self.shatterDuration then
            self.destroyed = true
        end
    else
        if self.fallDistance < self.fallLimit then
            self.fallSpeed = self.fallSpeed + self.gravity
            -- keep track of how much distance the projectile has fell
            self.fallDistance = self.fallDistance + self.fallSpeed
            
            self.y = self.y + self.fallSpeed
        end

        if self.throwDistance < self.throwLimit then
            -- keep track of how much distance the projectile has traveled
            self.throwDistance = self.throwDistance + self.throwSpeed
            
            if self.direction == 'left' then
                self.x = self.x - self.throwSpeed
            elseif self.direction == 'right' then
                self.x = self.x + self.throwSpeed
            elseif self.direction == 'down' then
                self.y = self.y + self.throwSpeed
            elseif self.direction == 'up' then
                self.y = self.y - self.throwSpeed
            end
        elseif not self.shattering then 
            self.frame = self.frame + 38 -- columns of tilesheet times two. (19 * 2 = 38)
            self.shattering = true
        end
    end
end

function Projectile:render()
    if self.destroyed then
        return
    end

    if self.shattering and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], 
    math.ceil(self.x), math.ceil(self.y))
    
    love.graphics.setColor(1, 1, 1, 1)
end