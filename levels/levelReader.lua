enemy = require("enemy.enemy")
map = require("map")
game = require("game")
projectile = require("defenses.projectile")
defenses = require("defenses.defenses")

levelReader = {
    time = 0,
    index = 1,
    flagNow = "wait",
    flagTime = 0.1
}

function levelReader.readLevel(level)
    levelReader.level = require("levels/" .. level)

    levelReader.specialTiles()

    for key, value in pairs(levelReader.level.metadata.disabledLanes) do
        map.disableLane(value)
    end
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
        end

        local CS = levelReader.level.wave[levelReader.index].customScript

        if CS ~= nil then
            for i = 1, #CS do
                CS[i]()
            end
        end

        levelReader.index = levelReader.index + 1
    end
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