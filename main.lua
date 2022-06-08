-- global tables
pObjects = {} --contains most things
plr = {} --player gameplay data (should usually be inside pObjects)
keys = {} --keyboard inputs table

-- constants
radUp = -math.pi/2

function love.load()
    -- setup window
    love.window.setTitle("C6H6")
    wWidth, wHeight = love.graphics.getDimensions()

    love.graphics.setNewFont(12)
    love.graphics.setColor(127,127,127)

    -- setup cursor
    cursorCanvas = love.graphics.newCanvas(32,32)
    love.graphics.setCanvas(cursorCanvas)
    love.graphics.clear()
    love.graphics.setColor(1,1,1)
    love.graphics.arc("line", "open", 16,16, 8, radUp,0, 8)
    love.graphics.arc("line", "open", 16,16, 8, -radUp,math.pi, 8)
    love.graphics.circle("fill", 16,16, 2)

    love.graphics.setCanvas() --disable canvas

    cursorImg = cursorCanvas:newImageData()
    crosshair = love.mouse.newCursor(cursorImg, 16,16)
    love.mouse.setCursor(crosshair)

    -- GAME STARTS --
    -- setup player
    spawnPlayer(wWidth*0.5, wHeight*0.5, 16, 4, 2.5)
    
end

function love.update(dt)
    if keys.w or keys.up then plr.yVel = -plr.speed
    elseif keys.s or keys.down then plr.yVel = plr.speed
    else plr.yVel = 0 end

    if keys.a or keys.left then plr.xVel = -plr.speed
    elseif keys.d or keys.right then plr.xVel = plr.speed
    else plr.xVel = 0 end 

    local velMagnitude = math.sqrt(math.pow(plr.xVel/plr.speed,2) + math.pow(plr.yVel/plr.speed,2))
    if velMagnitude > 0 then
        plr.x = plr.x + (plr.xVel / velMagnitude)
        plr.y = plr.y + (plr.yVel / velMagnitude)
    end
end

function love.draw()

    -- debug text
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.print(plr.x..","..plr.y, 0, 0)

    -- game UI
    love.graphics.setColor(plr.color)
    love.graphics.circle("line", 0, wHeight, 128)

    love.graphics.setColor(0.2,0.8,0.2)
    love.graphics.print(plr.hp, 0, 16)

    -- player sprites
    love.graphics.setColor(plr.color)
    love.graphics.circle("fill", plr.x, plr.y, plr.hitbox)
    love.graphics.circle("line", plr.x, plr.y, plr.size)

    -- player mini UI
    love.graphics.setColor(0.2,0.8,0.2)
    love.graphics.arc("line", "open", plr.x, plr.y, plr.size*1.5, radUp-math.pi/6, radUp+math.pi/6, 8)

end

function love.keypressed(key)
    keys[key] = true
end

function love.keyreleased(key)
    keys[key] = false
end

function spawnPlayer(x, y, size, hitbox, speed)
    -- X, Y, XVel, YVel, HP, SPD, ...?
    pObjects["player"] = plr
    plr["x"] = x
    plr["y"] = y
    plr["size"] = size
    plr["hitbox"] = hitbox
    plr["xVel"] = 0
    plr["yVel"] = 0
    plr["hp"] = 20.0
    plr["speed"] = speed
    plr["color"] = {1,1,1,1}
end