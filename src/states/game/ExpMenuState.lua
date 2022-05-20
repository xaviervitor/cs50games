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
    self.onSelect = function()
        gStateStack:pop()
        self.onClose()
    end 
    self.expMenu = Menu {
        x = VIRTUAL_WIDTH - 192,
        y = VIRTUAL_HEIGHT - 128,
        width = 192,
        height = 128,
        items = {
            {
                text = 'HP: ' .. self.pokemonStats.oldHP .. ' + ' .. self.pokemonStats.HPIncrease .. ' = ' .. self.pokemonStats.newHP,
                onSelect = self.onSelect
            },
            {
                text = 'Attack: ' .. self.pokemonStats.oldAttack .. ' + ' .. self.pokemonStats.attackIncrease .. ' = ' .. self.pokemonStats.newAttack,
                onSelect = self.onSelect
            },
            {
                text = 'Defense: ' .. self.pokemonStats.oldDefense .. ' + ' .. self.pokemonStats.defenseIncrease .. ' = ' .. self.pokemonStats.newDefense,
                onSelect = self.onSelect
            },
            {
                text = 'Speed: ' .. self.pokemonStats.oldSpeed .. ' + ' .. self.pokemonStats.speedIncrease .. ' = ' .. self.pokemonStats.newSpeed,
                onSelect = self.onSelect
            }
        }
    }
end

function ExpMenuState:update(dt)
    self.expMenu:update(dt)
end

function ExpMenuState:render()
    self.expMenu:render()
end