--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ExpMenuState = Class{__includes = BaseState}

function ExpMenuState:init(pokemonStats, onClose)
    self.pokemonStats = pokemonStats

    self.onClose = onClose or function() end

    self.expMenu = Menu {
        showCursor = false,
        x = VIRTUAL_WIDTH - 192,
        y = VIRTUAL_HEIGHT - 128,
        width = 192,
        height = 128,
        items = {
            {
                text = 'HP: ' .. self.pokemonStats.oldHP .. ' + ' .. self.pokemonStats.HPIncrease .. ' = ' .. self.pokemonStats.newHP,
            },
            {
                text = 'Attack: ' .. self.pokemonStats.oldAttack .. ' + ' .. self.pokemonStats.attackIncrease .. ' = ' .. self.pokemonStats.newAttack,
            },
            {
                text = 'Defense: ' .. self.pokemonStats.oldDefense .. ' + ' .. self.pokemonStats.defenseIncrease .. ' = ' .. self.pokemonStats.newDefense,
            },
            {
                text = 'Speed: ' .. self.pokemonStats.oldSpeed .. ' + ' .. self.pokemonStats.speedIncrease .. ' = ' .. self.pokemonStats.newSpeed,
            }
        }
    }
end

function ExpMenuState:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateStack:pop()
        self.onClose()
    end
end

function ExpMenuState:render()
    self.expMenu:render()
end