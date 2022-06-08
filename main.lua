-- requires
spcanv = require "spritecanvas"

-- global tables
pObjects = {} --contains most things
pBullets = {} --contains...bullets (please index instead of using keys)
plr = {} --player gameplay data (should usually be inside pObjects)
keys = {} --keyboard inputs table

-- constants & shortcuts
radUp = -math.pi/2
gfx = love.graphics

function love.load()
    -- setup window
    love.window.setTitle("C6H6")
    wWidth, wHeight = gfx.getDimensions()

    gfx.setNewFont(12)
    gfx.setColor(0.5,0.5,0.5)

    -- setup cursor
    -- arguably i should just use an empty one and draw at the mouse position, but i think this has its own charm
    spcanv.start(32,32)
    gfx.setColor(0.5,0.5,0.5)
    gfx.line(8,16,24,16)
    gfx.line(16,8,16,24)
    gfx.setColor(1,1,1)
    gfx.circle("fill", 16,16, 2)
    crosshair = love.mouse.newCursor(spcanv.finish(), 16,16)
    love.mouse.setCursor(crosshair)

    -- GAME STARTS --
    -- setup player
    spawnPlayer(wWidth*0.5, wHeight*0.5, 16, 4, 2.5)
    -- counter for bullets to keep instantiation clean?
    bulletCount = 0    
end


function love.update(dt)
    -- player movement
    if keys.w or keys.up then plr.yVel = -plr.speed
    elseif keys.s or keys.down then plr.yVel = plr.speed
    else plr.yVel = 0 end

    if keys.a or keys.left then plr.xVel = -plr.speed
    elseif keys.d or keys.right then plr.xVel = plr.speed
    else plr.xVel = 0 end 

    -- player velocity handling
    local velMagnitude = math.sqrt(math.pow(plr.xVel/plr.speed,2) + math.pow(plr.yVel/plr.speed,2))
    if velMagnitude > 0 then
        plr.x = plr.x + (plr.xVel / velMagnitude)
        plr.y = plr.y + (plr.yVel / velMagnitude)
    end

    -- shuut bullet
    if love.mouse.isDown(1) and plr["shotcooldown"] <= 0 then
        -- TODO aiming at mouse cursor (angle calculation)
        --spawnSimpleBullet(plr, 4, math.pi, 500)
        plr["shotcooldown"] = 250
    elseif plr["shotcooldown"] > 0 then
        plr["shotcooldown"] = plr["shotcooldown"] - (dt*1000)
    end

    -- bullet handling...
    --for i,b in ipairs(pBullets) do
        --oh no
    --end
end


function love.draw()

    -- debug text
    gfx.setColor(0.5,0.5,0.5)
    gfx.print(plr.x..","..plr.y, 0,0)
    gfx.print(bulletCount, 0,32)

    -- game UI
    gfx.setColor(plr.color)
    gfx.circle("line", 0, wHeight, 128)

    gfx.setColor(0.2,0.8,0.2)
    gfx.print(plr.hp, 0,16)

    -- player sprites
    gfx.setColor(plr.color)
    gfx.circle("fill", plr.x, plr.y, plr.hitbox)
    gfx.circle("line", plr.x, plr.y, plr.size)

    -- player mini UI
    gfx.setColor(0.2,0.8,0.2)
    gfx.arc("line", "open", plr.x, plr.y, plr.size*1.5, radUp-math.pi/6, radUp+math.pi/6, 8)
end

function love.keypressed(key)
    keys[key] = true
end

function love.keyreleased(key)
    keys[key] = false
end

-- creates the player('s data)
function spawnPlayer(x, y, size, hitbox, speed)
    -- X, Y, XVel, YVel, HP, SPD, ...?
    pObjects["player"] = plr
    plr["key"] = "player"
    plr["x"] = x
    plr["y"] = y
    plr["size"] = size
    plr["hitbox"] = hitbox
    plr["xVel"] = 0
    plr["yVel"] = 0
    plr["hp"] = 20.0
    plr["speed"] = speed
    plr["color"] = {1,1,1,1}
    plr["shotcooldown"] = 0
end

-- creates a simple bullet
-- origin: who shoots it (must have x and y fields)
-- vel: travel speed (px per second?)
-- angle: travel direction (radians)
-- decay: ms before despawning (optional - bullets despawn automatically when they exit the screen)
function spawnSimpleBullet(origin, vel, angle, decay)
    bullet = {}
    bulletCount = bulletCount + 1 --serves as ID
    pObjects[bulletCount] = bullet
    bullet["origin"] = origin
    bullet["x"] = origin.x
    bullet["y"] = origin.y
    bullet["vel"] = vel
    bullet["angle"] = angle
    bullet["decay"] = decay or 5000
end

function despawnObj(thing)
    table.remove(thing.key)
end

function despawnBul(id)
    table.remove(id)
end