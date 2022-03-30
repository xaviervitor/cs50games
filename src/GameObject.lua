--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1
    self.scale = def.scale or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid
    self.weight = def.weight or nil
    self.consumable = def.consumable or false

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end
end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:update(dt)

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states and self.states[self.state].frame or self.frame],
    self.x + self.width * self.scale + adjacentOffsetX, 
    self.y + self.height * self.scale + adjacentOffsetY,
    0, self.scale, self.scale, 
    self.width * self.scale, self.height * self.scale, 0, 0)
end