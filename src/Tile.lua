--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety, shiny)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.shiny = shiny

    -- timer used to switch the shiny rect's color
    self.shinyHighlighted = false

    -- set our Timer class to turn shiny highlight on and off
    Timer.every(0.05, function()
        self.shinyHighlighted = not self.shinyHighlighted
    end)
end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)
    if self.shiny and self.shinyHighlighted then
        love.graphics.setBlendMode('add')
        love.graphics.setColor(188/255, 105/255, 0/255, 48/255)
        love.graphics.rectangle('fill', 
        self.x + x + 2, self.y + y + 2, 32, 32, 7)
        love.graphics.setBlendMode('alpha')
    end

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    if self.shiny and self.shinyHighlighted then
        love.graphics.setBlendMode('add')
        love.graphics.setColor(188/255, 105/255, 0/255, 48/255)
        love.graphics.rectangle('fill', 
        self.x + x, self.y + y, 32, 32, 7)
        love.graphics.setBlendMode('alpha')
    end
end