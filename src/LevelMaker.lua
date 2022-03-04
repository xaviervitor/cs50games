--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    -- disregard the last 3 columns, clearing them for the flagpole
    for x = 1, width - 3 do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()

                            return false
                        end
                    }
                )
            end
        end
    end

    -- generating the last 3 columns with just ground for the flagpole
    for x = width - 2, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        tileID = TILE_ID_GROUND

        for y = 7, height do
            table.insert(tiles[y],
                Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
        end

        -- chance to generate bushes
        if math.random(8) == 1 then
            table.insert(objects,
                GameObject {
                    texture = 'bushes',
                    x = (x - 1) * TILE_SIZE,
                    y = (6 - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                    collidable = false
                }
            )
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    local keyX, keyY = generateKeyPosition(map, objects)
    local lockX, lockY = generateLockPosition(map, objects)
    
    local randomColor = math.random(#KEYS)

    -- spawn a key
    table.insert(objects,
        GameObject {
            texture = 'keys-and-locks',
            x = (keyX),
            y = (keyY),
            width = 16,
            height = 16,

            frame = KEYS[randomColor],
            collidable = true,
            consumable = true,
            hit = false,
            solid = false,

            onConsume = function(player)
                gSounds['pickup']:play()
                player.key = {
                    texture = 'keys-and-locks',
                    x = player.x,
                    y = player.y,
                    width = 16,
                    height = 16,
                    frame = KEYS[randomColor]
                }
            end
        }
    )
    -- spawn a key lock
    table.insert(objects,
        GameObject {
            texture = 'keys-and-locks',
            x = (lockX),
            y = (lockY),
            width = 16,
            height = 16,

            frame = LOCKS[randomColor],
            collidable = true,
            hit = false,
            solid = true,

            onCollide = function(obj, player)
                if not obj.hit then
                    obj.hit = true
                end
                gSounds['powerup-reveal']:play()
                player.key = nil

                -- flagpole
                table.insert(objects,
                    GameObject {
                        texture = 'flagpoles',
                        x = (width - 2) * TILE_SIZE,
                        y = (4 - 1) * TILE_SIZE,
                        width = 16,
                        height = 48,

                        frame = math.random(#FLAGPOLES),
                        collidable = true,
                        hit = false,
                        solid = false,

                        onCollide = function(obj, player)
                            if not obj.hit then
                                obj.hit = true
                            end
                            gSounds['pickup']:play()
                            return false
                        end
                    }
                )
                -- flag
                local randomFlagFrame = math.random(#FLAGS)
                table.insert(objects,
                    GameObject {
                        texture = 'flags',
                        x = (width - 2) * TILE_SIZE + TILE_SIZE / 2,
                        y = (4 - 1) * TILE_SIZE + TILE_SIZE / 2,
                        width = 16,
                        height = 16,

                        frame = FLAGS[randomFlagFrame],
                        animation = Animation {
                            frames = {FLAGS[randomFlagFrame], FLAGS[randomFlagFrame] + 1},
                            interval = 0.25
                        },
                        collidable = true,
                        hit = false,
                        solid = false,

                        onCollide = function(obj, player)
                            if not obj.hit then
                                obj.hit = true
                            end
                            gSounds['pickup']:play()
                            return false
                        end
                    }
                )

                return true
            end
        }
    )

    return GameLevel(entities, objects, map)
end

function generateKeyPosition(map, objects)
    local x = math.random(1, math.floor(map.width / 2)) - 1
    local y = 6 - 1
    while aboveAbyss(map, x, y + 1) do
        if x == math.floor(map.width / 2) then
            x = 1
        else
            x = x + 1
        end
    end
    if insidePillar(map, x, y) then
        y = y - 2
    end

    return x * TILE_SIZE, y * TILE_SIZE
end

function generateLockPosition(map, objects)
    -- disregard the last 3 columns, clearing them for the flagpole
    local validMapWidth = map.width - 3
    local x = math.random(math.floor(map.width / 2 + 1), validMapWidth) - 1
    local y = 4 - 1
    while aboveAbyss(map, x, y + 3) do
        if x == validMapWidth - 1 then
            x = math.floor(map.width / 2 + 1) 
        else
            x = x + 1
        end
    end
    if insidePillar(map, x, y + 1) then
        y = y - 2
    end
    removeCollidingBlock(objects, x, y)
    
    return x * TILE_SIZE, y * TILE_SIZE
end

function insidePillar(map, x, y)
    if map:pointToTile(x * TILE_SIZE, y * TILE_SIZE).id == TILE_ID_GROUND then
        return true
    end
    return false
end

function aboveAbyss(map, x, y)
    if map:pointToTile(x * TILE_SIZE, y * TILE_SIZE).id == TILE_ID_EMPTY then
        return true
    end
    return false
end

function removeCollidingBlock(objects, x, y)
    local target = {
        x = x * TILE_SIZE + TILE_SIZE / 2, 
        y = y * TILE_SIZE + TILE_SIZE / 2,
        width = 1,
        height = 1
    }
    for k, obj in pairs(objects) do
        if obj.texture == 'jump-blocks' and obj:collides(target) then
            table.remove(objects, k)
        end
    end
end