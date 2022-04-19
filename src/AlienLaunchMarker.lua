--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

AlienLaunchMarker = Class{}

function AlienLaunchMarker:init(world)
    self.world = world

    -- starting coordinates for launcher used to calculate launch vector
    self.baseX = 90
    self.baseY = VIRTUAL_HEIGHT - 100

    -- shifted coordinates when clicking and dragging launch alien
    self.shiftedX = self.baseX
    self.shiftedY = self.baseY

    -- whether our arrow is showing where we're aiming
    self.aiming = false

    -- whether we launched the alien and should stop rendering the preview
    self.launched = false

    -- our alien we will eventually spawn
    self.aliens = {}
end

function AlienLaunchMarker:update(dt)
    
    -- perform everything here as long as we haven't launched yet
    if not self.launched then

        -- grab mouse coordinates
        local x, y = push:toGame(love.mouse.getPosition())
        
        -- if we click the mouse and haven't launched, show arrow preview
        if love.mouse.wasPressed(1) and not self.launched then
            self.aiming = true

        -- if we release the mouse, launch an Alien
        elseif love.mouse.wasReleased(1) and self.aiming then
            self.launched = true

            self:spawnAlien(self.shiftedX, self.shiftedY, (self.baseX - self.shiftedX) * 10, (self.baseY - self.shiftedY) * 10, 0.4, 1)

            -- we're no longer aiming
            self.aiming = false

        -- re-render trajectory
        elseif self.aiming then
            
            self.shiftedX = math.min(self.baseX + 30, math.max(x, self.baseX - 30))
            self.shiftedY = math.min(self.baseY + 30, math.max(y, self.baseY - 30))
        end
    end
end

function AlienLaunchMarker:render()
    if not self.launched then
        
        -- render base alien, non physics based
        love.graphics.draw(gTextures['aliens'], gFrames['aliens'][9], 
            self.shiftedX - 17.5, self.shiftedY - 17.5)

        if self.aiming then
            
            -- render arrow if we're aiming, with transparency based on slingshot distance
            local impulseX = (self.baseX - self.shiftedX) * 10
            local impulseY = (self.baseY - self.shiftedY) * 10

            -- draw 18 circles simulating trajectory of estimated impulse
            local trajX, trajY = self.shiftedX, self.shiftedY
            local gravX, gravY = self.world:getGravity()

            -- http://www.iforce2d.net/b2dtut/projected-trajectory
            for i = 1, 90 do
                
                -- magenta color that starts off slightly transparent
                love.graphics.setColor(255/255, 80/255, 255/255, ((255 / 24) * i) / 255)
                
                -- trajectory X and Y for this iteration of the simulation
                trajX = self.shiftedX + i * 1/60 * impulseX
                trajY = self.shiftedY + i * 1/60 * impulseY + 0.5 * (i * i + i) * gravY * 1/60 * 1/60

                -- render every fifth calculation as a circle
                if i % 5 == 0 then
                    love.graphics.circle('fill', trajX, trajY, 3)
                end
            end
        end
        
        love.graphics.setColor(1, 1, 1, 1)
    else
        for k, alien in pairs(self.aliens) do
            alien:render()
        end
    end
end

function AlienLaunchMarker:getLaunchedAlien()
    return self.aliens[1]
end

function AlienLaunchMarker:spawnAlien(x, y, velocityX, velocityY, restitution, angularDamping)
    -- spawn new alien in the world, passing in user data of player
    local alien = Alien(self.world, 'round', x, y, 'Player')
    
    -- apply the difference between current X,Y and base X,Y as launch vector impulse
    alien.body:setLinearVelocity(velocityX, velocityY)
    
    -- make the alien pretty bouncy
    alien.fixture:setRestitution(restitution)
    alien.body:setAngularDamping(angularDamping)
    
    table.insert(self.aliens, alien)
end

function AlienLaunchMarker:splitAlien()
    local launchedAlien = self:getLaunchedAlien()
    local alienX = launchedAlien.body:getX()
    local alienY = launchedAlien.body:getY()
    local alienLinearVelocityX, alienLinearVelocityY = launchedAlien.body:getLinearVelocity()
    local alienRestitution = launchedAlien.fixture:getRestitution()
    local alienAngularDamping = launchedAlien.body:getAngularDamping()

    -- Calculates the velocity vector angle and uses it to calculate the
    -- new aliens offset x and y, resulting in the two new aliens
    -- spawning in the sides of the central alien, perpendicular with his
    -- linear velocity vector angle.
    local angle = getVelocityAngle(alienLinearVelocityX, alienLinearVelocityY)
    local distanceConstant = 17.5

    local leftAlienX = alienX - distanceConstant * math.cos(angle)
    local leftAlienY = alienY - distanceConstant * math.sin(angle)

    local rightAlienX = alienX + distanceConstant * math.cos(angle)
    local rightAlienY = alienY + distanceConstant * math.sin(angle)
    
    local leftAlienLinearVelocityX, leftAlienLinearVelocityY = rotateVector(alienLinearVelocityX, alienLinearVelocityY, -10 * DEGREES_TO_RADIANS)
    local rightAlienLinearVelocityX, rightAlienLinearVelocityY = rotateVector(alienLinearVelocityX, alienLinearVelocityY, 10 * DEGREES_TO_RADIANS)

    -- left alien
    self:spawnAlien(
        leftAlienX,
        leftAlienY,
        leftAlienLinearVelocityX,
        leftAlienLinearVelocityY,
        alienRestitution,
        alienAngularDamping
    )
    -- right alien
    self:spawnAlien(
        rightAlienX,
        rightAlienY,
        rightAlienLinearVelocityX,
        rightAlienLinearVelocityY,
        alienRestitution,
        alienAngularDamping
    )
end

function getVelocityAngle(aVectorX, aVectorY)
    -- y axis vector. The B vector needs to flip if the A vector
    -- is in quadrants I or IV (aVectorX > 0), because this function returns 
    -- a angle between 0° and 180° instead of 0° to 360°.
    --
    -- without flipping B (reference) vector
    --      0°/180°
    --    135°  *135°*
    --   90°  ()   90°
    --    45°   *45°*
    --      0°/180°
    --
    -- flipping B (reference) vector
    --      0°/180°
    --    135°   *45°*
    --   90°  ()   90°
    --    45°   *135°*
    --      0°/180°
    --
    -- after flipping the reference vector, 

    local bVectorX = 0
    local bVectorY = (aVectorX > 0) and -1 or 1

    -- angle between two vectors formula
    -- cos(theta) = u * v / || u || * || v ||
    
    -- 1: find vectors dot product (u * v)
    local dotProduct = aVectorX * bVectorX + aVectorY * bVectorY
    -- 2: find vectors magnitude || u || and || v ||
    local aVectorMagnitude = math.sqrt(math.pow(aVectorX, 2) + math.pow(aVectorY, 2))
    local bVectorMagnitude = math.sqrt(math.pow(bVectorX, 2) + math.pow(bVectorY, 2))
    
    -- 3: to find theta, take the inverse of cos(theta) on both sides
    -- cos(theta) = u * v / || u || * || v ||
    -- theta = arccos(u * v / || u || * || v ||)
    return math.acos(dotProduct / aVectorMagnitude * bVectorMagnitude)
end

function rotateVector(x, y, angle)
    -- 2d vector rotation formula
    -- x2 = cos(theta) * x1 - sin(theta) * y1
    -- y2 = sin(theta) * x1 + cos(theta) * y1
    local rotatedX = math.cos(angle) * x - math.sin(angle) * y
    local rotatedY = math.sin(angle) * x + math.cos(angle) * y
    return rotatedX, rotatedY
end