-- requires
local spcanv = require "spritecanvas"
local objB = require "objBehaviors"
local objS = require "objSystems"

-- global table stuff
pObjects = {} --contains most gameplay things; all of them should have x, y fields
pBullets = {} --contains...bullets (please index instead of using keys)
nextOID = 1 --counter for working with pObjects
nextBID = 1 --counter for working with pBullets

--funky debug shit
H2hit = false

-- non-global local global tables (stuff that stays in this one file's code)
local plr = {} --player gameplay data tracked seperately (should usually be inside pObjects)
local keys = {} --keyboard inputs table
local sprites = {} --stores any ImageData needed for later use

-- constants & shortcuts
local radUp = -math.pi/2 --add to angle calculation to make 0 rad = upward
local gfx = love.graphics --i call this a lot

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
    sprites["cur_crosshair"] = love.mouse.newCursor(spcanv.finish(), 16,16)
    love.mouse.setCursor(sprites["cur_crosshair"])

    -- GAME STARTS --
    -- reset counters just in case
    nextBID = 1 --bullets
    nextOID = 1 --objects

    -- setup player
    plr = objB.spawnPlayer(wWidth*0.5, wHeight*0.5, 16, 4, 2.5)
    
end


function love.update(dt)
    -- player movement
    if keys.w or keys.up then plr.yVel = -plr.speed
    elseif keys.s or keys.down then plr.yVel = plr.speed
    else plr.yVel = 0 end

    if keys.a or keys.left then plr.xVel = -plr.speed
    elseif keys.d or keys.right then plr.xVel = plr.speed
    else plr.xVel = 0 end 

    -- aim player "gun" at mouse cursor
    local mousedistx = (love.mouse.getX() - plr.x)
    local mousedisty = (love.mouse.getY() - plr.y)
    plr.angle = math.atan2(mousedisty,mousedistx)

    -- player velocity handling (might change so this applies to all pObjects?)
    local velMagnitude = math.sqrt(math.pow(plr.xVel/plr.speed,2) + math.pow(plr.yVel/plr.speed,2))
    if velMagnitude > 0 then
        plr.x = plr.x + (plr.xVel / velMagnitude)
        plr.y = plr.y + (plr.yVel / velMagnitude)
    end

    -- update timers
    if plr.shotcooldown > 0 then
        plr.shotcooldown = plr.shotcooldown - (dt*1000)
    end
    if plr.invtime > 0 then
        plr.invtime = plr.invtime - (dt*1000)
    end

    -- shuut bullet
    if love.mouse.isDown(1) and plr.shotcooldown <= 0 then
        objB.spawnSimpleBullet(plr, 400, plr.angle, 500)
        plr.shotcooldown = 1000/plr.firerate
    end


    -- update objects and bullets
    for BID, bu in pairs(pBullets) do
        if bu.type == "simple" then objB.updateSimpleBullet(bu, BID, dt) end
    end


end

function love.draw()
    -- debug text
    gfx.setColor(0.5,0.5,0.5)
    gfx.print(plr.x..","..plr.y.." : "..plr.angle, 0,0)
    --gfx.print("BID "..nextBID.." OID "..nextOID, 0,32)
    --if love.mouse.isDown(1) then gfx.print(plr.shotcooldown.." : mouse good", 50, 50) end
    if H2hit then gfx.print("H2 bullet collision has happened", 70,70) end
    -- game UI
    gfx.setColor(plr.color)
    gfx.circle("line", 0, wHeight, 128)

    gfx.setColor(0.2,0.8,0.2)
    gfx.print(plr.hp, 0,16)

    -- player sprites
    gfx.setColor(plr.color)
    gfx.circle("fill", plr.x, plr.y, plr.hitbox)
    gfx.circle("line", plr.x, plr.y, plr.size)

    -- simple bullets
    for BID, bu in pairs(pBullets) do
        gfx.setColor(0.3,0.3,0.3) --draw trail underneath
        gfx.line(bu.x,bu.y, bu.x-(math.cos(bu.angle)*bu.vel/16),bu.y-(math.sin(bu.angle)*bu.vel/16))
        gfx.setColor(bu.color)
        gfx.circle("fill", bu.x,bu.y, bu.size)
    end

    -- player mini UI
    gfx.setColor(0.2,0.8,0.2)
    local hpEdge = ((radUp-math.pi/6) + (plr.hp/plr.maxhp)*math.pi/3)
    gfx.arc("line", "open", plr.x, plr.y, plr.size*1.5, radUp-math.pi/6, hpEdge, 8)
end

function love.keypressed(key)
    keys[key] = true
end

function love.keyreleased(key)
    keys[key] = false
end