map = {
    width = 9,
    height = 8,
    blockSize = 75,

    enemyLanes = {
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
    },

    lawnMowers = {
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
    }
}

function map.reset()
    map.lawnMowers = {
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
    }

    enemyLanes = {
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
    }
end

function map.draw()
    for y = 1, map.height do
        for x = 1, map.width do

        color = ((x + y) % 2 == 0) and {0.2, 0.6, 0.2} or {0.25, 0.65, 0.25}

            love.graphics.setColor(color)

            love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize)
        end
    end
    
    x = 0
    for y = 1, map.height do
        if map.lawnMowers[y] then
            color = ((y + 1) % 2 == 0) and {0.4, 0.4, 0.4} or {0.2, 0.2, 0.2}

            love.graphics.setColor(color)

            love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize)
        end
    end
end

return map