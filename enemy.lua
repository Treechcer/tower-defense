enemyValues = require("enemyValues")
game = require("game")
map = require("map")

enemy = {
    enemyList = {} -- this object is table tables that are like : line 1-8 (1 == top line) X (int of pixel), type
}

function enemy.move(dt)
    for key, value in pairs(enemy.enemyList) do
        value.x = value.x + enemyValues[value.type].speed * dt
    end
end

function enemy.draw()
    love.graphics.setColor(0.4, 0.4, 0.4)
    for key, value in pairs(enemy.enemyList) do
        love.graphics.rectangle("fill", game.width - value.x, (value.line - 1) * 75, 75, 75)
    end
end

function enemy.Create(lineNum, xPos, enemyType)
    table.insert(enemy.enemyList, {line = lineNum, x = xPos, type = enemyType, health = enemyValues[enemyType].health})
    map.enemyLanes[lineNum] = true

    enemy.sortEnemyByLine()
end

function enemy.sortEnemyByLine()
    table.sort(enemy.enemyList, function(a, b) return a.line < b.line end)
end

enemy.Create(1, 50, enemyValues.default.type)

return enemy