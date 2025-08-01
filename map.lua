--levelReader = require("levels.levelReader")

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
    local levelReader = require("levels.levelReader")
    local level = levelReader.level.metadata
    for y = 1, map.height do
        for x = 1, map.width do

        color = ((x + y) % 2 == 0) and level.color.main or level.color.second

            love.graphics.setColor(color)

            love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize)
        end
    end
    
    x = 0
    for y = 1, map.height do
        if map.lawnMowers[y] then
            color = ((y + 1) % 2 == 0) and level.lawnMowersColors.main or level.lawnMowersColors.second

            love.graphics.setColor(color)

            love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize)
        end
    end
end

return map