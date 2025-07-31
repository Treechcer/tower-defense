enemy = require("enemy.enemy")

levelReader = {
    time = 0,
    index = 1,
    flagNow = "wait",
    flagTime = 0.1
}

function levelReader.readLevel(level)
    levelReader.level = require("levels/" .. level)
end

function levelReader.spawn()
    if levelReader.level[levelReader.index] == nil then
        return
    end
    if levelReader.level[levelReader.index].time <= levelReader.time then
        for key, value in pairs(levelReader.level[levelReader.index].enemies) do
            enemy.Create(value.line, 0, value.type)
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