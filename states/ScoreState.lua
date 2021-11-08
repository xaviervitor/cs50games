--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.bronzeMedal = love.graphics.newImage('medal_bronze.png')
    self.silverMedal = love.graphics.newImage('medal_silver.png')
    self.goldMedal = love.graphics.newImage('medal_gold.png')
    if self.score >= 5 and self.score < 10 then
        self.medal = self.bronzeMedal
    elseif self.score >= 10 and self.score < 15 then
        self.medal = self.silverMedal
    elseif self.score >= 15 then
        self.medal = self.goldMedal
    end
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.medal then
        love.graphics.draw(self.medal, VIRTUAL_WIDTH / 2 - self.bronzeMedal:getWidth() / 2, 116)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end