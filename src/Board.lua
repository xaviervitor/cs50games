--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(level, x, y)
    self.level = level
    self.x = x
    self.y = y
    self.matches = {}
    self.validColors = {1, 4, 6, 9, 11, 12, 14, 17}

    -- values from 1 to 6 with weight expressed as quantities. if a value x is 
    -- repeated y times, it means that x has a weight of y.
    -- example: if value 2 is repeated 8 times in the list, value 2 has weight 8. 
    self.varietyValues = {
        1, 1, 1, 1, 1, 1, 1, 1, 
        1, 1, 1, 1, 1, 1, 1, 1, 
        1, 1, 1, 1, 1, 1, 1, 1, 
        1, 1, 1, 1, 1, 1, 1, 1, 
        2, 2, 2, 2, 2, 2, 2, 2, 
        3, 3, 3, 3, 4, 4, 5, 6
    }
    -- sums of weights of tile varieties referring to levels.
    -- at level 3, varieties 1, 2 and 3 can appear on the board. in this 
    -- case, in position x of the table we will have the sum of the weights of 
    -- the varieties 1, 2 and 3 (w1 + w2 + w3 = 32 + 8 + 4 = 44)
    self.varietyWeightSums = {32, 40, 44, 46, 47, 48}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
           local weightedRandom = self:getWeightedRandom(self.level, self.varietyValues, self.varietyWeightSums)
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], 
                Tile(tileX, tileY, self.validColors[math.random(8)], weightedRandom, false))
        end
    end

    while self:calculateMatches() or #self:checkPotentialMatches() == 0 do
        -- recursively initialize if matches were returned or if there isn't 
        -- any possible matches so we always have a matchless board with possible
        -- at least one possible match on start
        self:initializeTiles()
    end
end

function Board:getWeightedRandom(level, values, weightSums)
    return values[math.random(weightSums[math.min(level, 6)])]
end

function Board:checkPotentialMatches()
    local matches = {}
    for y = 1, 8 do
        for x = 1, 8 do
            local tile = self.tiles[y][x]
            -- swipe right
            if x + 1 <= 8 then
                local rightTile = self.tiles[y][x + 1]
                self.tiles[y][x] = rightTile
                self.tiles[y][x + 1] = tile
                local rMatches = self:calculateMatches()
                if rMatches ~= false then
                    for k, v in pairs(rMatches) do
                        table.insert(matches, v)
                    end
                end
                self.tiles[y][x] = tile
                self.tiles[y][x + 1] = rightTile
            end
            -- swipe down
            if y + 1 <= 8 then
                local downTile = self.tiles[y + 1][x]
                self.tiles[y][x] = downTile
                self.tiles[y + 1][x] = tile
                local dMatches = self:calculateMatches()
                if dMatches ~= false then
                    for k, v in pairs(dMatches) do
                        table.insert(matches, v)
                    end
                end
                self.tiles[y][x] = tile
                self.tiles[y + 1][x] = downTile
            end
        end
    end
    return matches
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do

                        -- add each tile to the match that's in that match
                        local tile = self.tiles[y][x2]
                        if tile.shiny then
                            for column = 1, 8 do
                                table.insert(match, self.tiles[y][column])
                            end                            
                        end
                        table.insert(match, tile)
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                local tile = self.tiles[y][x]
                if tile.shiny then
                    for column = 1, 8 do
                        table.insert(match, self.tiles[y][column])
                    end                            
                end
                table.insert(match, tile)
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        local tile = self.tiles[y2][x]
                        if tile.shiny then
                            for row = 1, 8 do
                                table.insert(match, self.tiles[row][x])
                            end                            
                        end
                        table.insert(match, tile)
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                local tile = self.tiles[y][x]
                if tile.shiny then
                    for row = 1, 8 do
                        table.insert(match, self.tiles[row][x])
                    end                            
                end
                table.insert(match, tile)
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then
                local weightedRandom = self:getWeightedRandom(self.level, self.varietyValues, self.varietyWeightSums)
                -- new tile with random color and variety
                local tile = Tile(x, y, self.validColors[math.random(8)], weightedRandom, (math.random(96) == 1))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end