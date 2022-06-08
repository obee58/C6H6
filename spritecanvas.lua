-- small macro module for converting love.graphics results to ImageData --
-- primarily used for generative sprites, might extend to do background stuff --
local spritecanvas = {}

-- create new canvas with size w,h and begin drawing on it
-- between start() and finish(), calling love.graphics functions will draw to this canvas
function spritecanvas.start(w, h)
    canv = love.graphics.newCanvas(w,h)
    love.graphics.setCanvas(canv)
    love.graphics.clear()
    love.graphics.setColor(1,1,1)
end

-- call to return to regular drawing, returns ImageData of the created canvas
function spritecanvas.finish()
    love.graphics.setCanvas()
    return canv:newImageData()
end

return spritecanvas