enemyValues = require("enemy.enemyValues")
game = require("game")
map = require("map")

enemy = {
    enemyList = {} -- this object is table tables that are like : line 1-8 (1 == top line) X (int of pixel), type
}

function enemy.move(dt)
    local index = 1
    for key, value in pairs(enemy.enemyList) do
        local hit = false
        for key0, value0 in pairs(defenses.built) do
            print(value.lastAttack, value.cooldown)
            local posCheck = (game.width - value.x) >= (value0.x * map.blockSize)  and (game.width - value.x - 55) <= ((value0.x + 1) * map.blockSize) and value0.y == value.line -- I have no idea why '-55' works, I just tried '-50' and it worked well enough... I'll not investigate further eventho I have guesses
            if value.lastAttack >= value.attackCooldown and posCheck then
                defenses.damagePlant(key0, value.damage)
                hit = true
                value.lastAttack = 0
            elseif posCheck then
                hit = true
            end
        end

        if not hit then
            value.x = value.x + enemyValues[value.type].speed * dt
        end

        if value.x >= game.width - (-1 * map.blockSize + map.blockSize * 1.75 + map.blockSize/2) and map.lawnMowers[value.line] then
            value.health = 0

            enemy.die(index, value)

            map.lawnMowers[value.line] = false
        elseif value.x >= game.width - (-1 * map.blockSize + map.blockSize * 1.75 + map.blockSize/2) and not map.lawnMowers[value.line] then
            value.health = 0
            enemy.die(index, value)

            levelReader.reset()
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

function enemy.cooldownAdd(dt)
    for key, value in pairs(enemy.enemyList) do
        value.lastAttack = value.lastAttack + dt
    end
end

function enemy.Create(lineNum, xPos, enemyType)
    if not map.disabledLanes[lineNum] and (lineNum >= 1 and lineNum <= 8) then
        table.insert(enemy.enemyList, {line = lineNum, x = xPos, type = enemyType, health = enemyValues[enemyType].health, damage = enemyValues[enemyType].damage, attackCooldown = enemyValues[enemyType].attackCooldown, lastAttack = 0})
        map.enemyLanes[lineNum] = true

        enemy.sortEnemyByLine() 
    end
end

function enemy.sortEnemyByLine()
    table.sort(enemy.enemyList, function(a, b) return a.line < b.line end)
end

function enemy.kiullAll()
    enemy.enemyList = {}
end

--enemy.Create(1, 50, enemyValues.default.type)

return enemy