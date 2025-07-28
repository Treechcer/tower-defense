enemyValues = require("enemyValues")
game = require("game")

enemy = {
    enemyList = {} -- this object is table tables that are like : line 1-8 (1 == top line) X (int of pixel), type
}

table.insert(enemy.enemyList, {line = 1, x = 50, type = enemyValues.default.type})

function enemy.move(dt)
    for key, value in pairs(enemy.enemyList) do
        value.x = value.x + enemyValues[value.type].speed * dt
    end
end

function enemy.draw()
    for key, value in pairs(enemy.enemyList) do
        love.graphics.rectangle("fill", game.width - value.x, (value.line - 1) * 75, 75, 75)
    end
end

return enemy