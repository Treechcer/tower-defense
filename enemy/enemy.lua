enemyValues = require("enemy.enemyValues")
game = require("game")
map = require("map")

enemy = {
    enemyList = {} -- this object is table tables that are like : line 1-8 (1 == top line) X (int of pixel), type
}

function enemy.move(dt)
    local index = 1
    for key, value in pairs(enemy.enemyList) do
        value.x = value.x + enemyValues[value.type].speed * dt
        if value.x >= game.width - (-1 * map.blockSize + map.blockSize * 1.75 + map.blockSize/2) and map.lawnMowers[value.line] then
            value.health = 0

            enemy.die(index, value)

            map.lawnMowers[value.line] = false
        elseif value.x >= game.width - (-1 * map.blockSize + map.blockSize * 1.75 + map.blockSize/2) and not map.lawnMowers[value.line] then
        
        -- dying not implemented yet, so here we goo
        
        end

        index = index + 1
    end
end

function enemy.die(index, value)
    table.remove(enemy.enemyList, index)
    local line = value.line
    enemy.sortEnemyByLine()

    local found = false
    for x = 1, #enemy.enemyList do
        if line == enemy.enemyList[x].line then
            found = true
            break
        end
    end

    if not found then
        map.enemyLanes[line] = false
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

--enemy.Create(1, 50, enemyValues.default.type)

return enemy