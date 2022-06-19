-- requires
local objS = require "objSystems"
-- contains most of the specific behaviors/handlers for things that should be called on love.update
-- each object/bullet type should have a spawn and an update function
local objBehaviors = {}

-- creates the player('s data)
-- handling for this object will probably just be done in love.update
function objBehaviors.spawnPlayer(x, y, size, hitbox, speed)
    local player = objS.createObject(x, y, "player", {1,1,1,1}, size)
    player["xVel"] = 0 --px/s
    player["yVel"] = 0 --px/s
    player["angle"] = 0 --rad
    player["hitbox"] = hitbox
    player["hp"] = 25.0
    player["maxhp"] = 25.0
    player["firerate"] = 5.0 --shot/s
    player["invtime"] = 500 --ms
    player["speed"] = speed --px/s
    player["color"] = {1,1,1,1}
    player["shotcooldown"] = 0 --ms
    return player
end

-- creates a simple bullet
-- origin: who shoots it (must have x and y fields, used for hit calc)
-- vel: travel speed (px per second?)
-- angle: travel direction (radians)
-- decay: ms before despawning (optional - bullets despawn automatically when they exit the screen)
-- color: guess (optional - 4 float table)
-- size: width (optional - px)
function objBehaviors.spawnSimpleBullet(origin, vel, angle, decay, color, size)
    local bullet = objS.createBullet(origin, "simple", decay, color, size)
    bullet["vel"] = vel
    bullet["angle"] = angle
    return bullet
end
function objBehaviors.updateSimpleBullet(bu, BID, dt)
    if bu.decay <= 0 then objS.despawnBul(BID) end
    local dx = math.cos(bu.angle) * bu.vel * dt
    local dy = math.sin(bu.angle) * bu.vel * dt
    bu.x = bu.x + dx
    bu.y = bu.y + dy
    bu.decay = bu.decay - (dt*1000)
end

-- creates H2 enemy (does not shoot, simply attempts to collide with the player)
function objBehaviors.spawnH2(x, y, size, hitbox, hp, speed)
    local h2 = objS.createObject(x, y, "H2", {1,0.8,0.8,1}, size)
    h2["hitbox"] = hitbox
    h2["hp"] = hp
    h2["speed"] = speed
    return h2
end
function objBehaviors.updateH2(obj, dt)
    -- this is going to be slow as fuck isn't it
    for BID, bu in pairs(pBullets) do
        --mostly for testing atm
        if objS.checkCollideBullet(obj,bul) then H2hit = true end
    end
end

return objBehaviors