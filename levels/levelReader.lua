enemy = require("enemy.enemy")
map = require("map")
game = require("game")
projectile = require("defenses.projectile")
defenses = require("defenses.defenses")

levelReader = {
    time = 0,
    index = 1,
    flagNow = "wait",
    flagTime = 0.1,
    percent = 0,
    enSpawned = 0,
    alive = 0,

    bar = {
        width = 25,
        height = 150,
        x = 0,
        y = 0
    }
}

--these magic number are set because they look good not because of nay calculations

levelReader.bar.x = levelReader.bar.width / 1.52
levelReader.bar.y = (game.height / 2) + (levelReader.bar.height / 1.25)

function levelReader.readLevel(level)
    levelReader.level = require("levels/" .. level)

    levelReader.specialTiles()

    for key, value in pairs(levelReader.level.metadata.disabledLanes) do
        map.disableLane(value)
    end

    local enCount = 0
    for i = 1, #levelReader.level.wave do
        local enemyTable = levelReader.level.wave[i].enemies
        for j = 1, #enemyTable, 1 do
            if not map.disabledLanes[enemyTable[j].line] then
                enCount = enCount + 1
            end
        end
    end

    levelReader.enCount = enCount
    levelReader.percent = 0
    levelReader.enSpawned = 0
end

function levelReader.specialTiles()
    if levelReader.level.metadata.specialTiles ~= nil then
        for i = 1, #levelReader.level.metadata.specialTiles, 1 do
            map.makeSpecialTile(levelReader.level.metadata.specialTiles[i])
        end
    end
end

function levelReader.reset()
    enemy.kiullAll()
    projectile.reset()
    defenses.reset()

    game.money = game.defaults.startMoney
    levelReader.time = 0
    levelReader.index = 1
    levelReader.flagNow = "wait"
    levelReader.flagTime = 0.1
    levelReader.percent = 0
    levelReader.enSpawned = 0

    map.reset()
end

function levelReader.spawn()
    if levelReader.level.wave[levelReader.index] == nil then
        return
    end

    if levelReader.level.wave[levelReader.index].time <= levelReader.time then
        for key, value in pairs(levelReader.level.wave[levelReader.index].enemies) do
            --print(value.line, value.type)
            local tempBool = enemy.Create(value.line, 0, value.type)
            if tempBool then
                levelReader.enSpawned = levelReader.enSpawned + 1
                levelReader.alive = levelReader.alive + 1
            end
        end

        levelReader.percent = levelReader.enSpawned / levelReader.enCount

        local CS = levelReader.level.wave[levelReader.index].customScript

        if CS ~= nil then
            for i = 1, #CS do
                CS[i]()
            end
        end

        levelReader.index = levelReader.index + 1
    end
end

function levelReader.drawBar()
    love.graphics.rectangle("fill", levelReader.bar.x, levelReader.bar.y, levelReader.bar.width, levelReader.bar.height)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", levelReader.bar.x + levelReader.bar.width, levelReader.bar.y + levelReader.bar.height, - levelReader.bar.width, -(levelReader.bar.height * levelReader.percent))
end

function levelReader.logic(dt)
    flag = levelReader.flagNow

    if flag == "wait" then
        levelReader.flagTime = levelReader.flagTime - dt
        if levelReader.flagTime <= 0 then
            levelReader.flagNow = "attack"
        end
    elseif flag == "attack" then
        levelReader.time = levelReader.time + dt
        levelReader.spawn()
    end

    if levelReader.alive == 0 and levelReader.enSpawned == levelReader.enCount then
        love.event.quit()
    end
end

return levelReader
