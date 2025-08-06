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

    bar = {
        width = 150,
        height = 25,
        x = 0,
        y = 0
    }
}

function levelReader.readLevel(level)
    levelReader.level = require("levels/" .. level)

    levelReader.specialTiles()

    for key, value in pairs(levelReader.level.metadata.disabledLanes) do
        map.disableLane(value)
    end

    local enCount = 0
    for i = 1, #levelReader.level.wave do
        enCount = enCount + #levelReader.level.wave[i].enemies
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
            enemy.Create(value.line, 0, value.type)
            levelReader.enSpawned = levelReader.enSpawned + 1
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
    love.graphics.rectangle("fill", levelReader.bar.width - levelReader.bar.x, levelReader.bar.y, -(levelReader.bar.width * levelReader.percent), levelReader.bar.height)
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
end

return levelReader
