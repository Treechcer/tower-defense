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
    },

    disabledLanes = { -- this will be setuped in levelReader because you never know what level you play and the layout yk yk yk
        false, -- false ==> enabled, true ==> disabled
        false,
        false,
        false,
        false,
        false,
        false,
        false,
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
        local colSec
        if not map.disabledLanes[y] then
            colSec = level.color
        else
            colSec = level.disabledLaneColors
        end
        for x = 1, map.width do

            color = ((x + y) % 2 == 0) and colSec.main or colSec.second

            love.graphics.setColor(color)

            love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize)
        end
    end
    
    x = 0
    for y = 1, map.height do
        local colSec = {}

        if not map.disabledLanes[y] then
            colSec = level.lawnMowersColors
        else
            colSec.main = {0.75,0.75,0.75}
            colSec.second = {0.6,0.6,0.6}
        end

        if map.lawnMowers[y] then
            color = ((y + 1) % 2 == 0) and colSec.main or colSec.second

            love.graphics.setColor(color)

            love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize)
        end
    end
end

function map.disableLane(n) -- n ==> 1 - 8 ==> lane to diable
    map.disabledLanes[n] = true
end

return map