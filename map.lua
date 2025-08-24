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
    },

    specialTiles = {}, -- these are the special tiles, ther will be all tiles but some will be false and others will be true, true are special false are normal - these tiles can be special in any shape or form
    specialTilesAbility = {} -- here will be store all of the special tile abilities, for example, if there is on x = 2 a y = 2 special tile that you can't place on, in specialTiles will be on index [2][2] true, and in this table will be store what it does (this sounded as the fastest and easiest way to implement this)
}

function map.generateSpecialTiles()
    for y = 1, map.height do
        local specialTileTable = {}
        local specialAbilityTable = {}
        for x = 1, map.width do
            specialTileTable[x] = false
            specialAbilityTable[x] = nil
        end

        map.specialTiles[y] = specialTileTable
        map.specialTilesAbility[y] = specialAbilityTable
    end
end

function map.makeSpecialTile(tileObj)

    --for index, value in ipairs(map.specialTiles) do
    --    print(index, " ", value)
    --end

    map.specialTiles[tileObj.y][tileObj.x] = true
    map.specialTilesAbility[tileObj.y][tileObj.x] = tileObj.ability

    --print(map.specialTilesAbility[tileObj.y][tileObj.x], tileObj.y, tileObj.x)
end

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

    map.disabledLanes = {
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
    }

    for key, value in pairs(levelReader.level.metadata.disabledLanes) do
        print(key, " : ", value)
    end

    for index, value in ipairs(levelReader.level.metadata.disabledLanes) do
        map.disabledLanes[value] = true
    end

    map.enemyLanes = {
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
    }

    map.specialTiles = {}
    map.specialTilesAbility = {}

    map.generateSpecialTiles()
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

            abilityDo = map.doAbilityOfTile("else")

            if map.specialTiles[y][x] then
                abilityDo = map.doAbilityOfTile(map.specialTilesAbility[y][x])
            end

            if abilityDo.draw then
                color = ((x + y) % 2 == 0) and colSec.main or colSec.second

                color = {color[1], color[2], color[3], game.levelTransition}

                love.graphics.setColor(color)

                love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize) 
            end
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

            color = {color[1], color[2], color[3], game.levelTransition}

            love.graphics.setColor(color)

            love.graphics.rectangle("fill", (x - 1) * map.blockSize + map.blockSize * 1.75, (y - 1) * map.blockSize, map.blockSize, map.blockSize)
        end
    end
end

function map.doAbilityOfTile(ability)
    obj = {
        draw = true,
        place = true
    }

    if ability == "noPlace" then
        obj = {
            draw = false,
            place = false
        }

        return obj
    else
        return obj
    end
end

function map.disableLane(n) -- n ==> 1 - 8 ==> lane to diable
    map.disabledLanes[n] = true
end

return map