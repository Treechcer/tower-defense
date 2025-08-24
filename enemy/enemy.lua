enemyValues = require("enemy.enemyValues")
game = require("game")
map = require("map")

enemy = {
    enemyList = {}, -- this object is table tables that are like : line 1-8 (1 == top line) X (int of pixel), type
    delaySpawn = 0.1,
    lastSpawn = 10,
    isSpawning = false,
    spawnEnemies = {}, -- this table is for future enemy spawns
}

function enemy.move(dt)
    local index = 1
    for key, value in pairs(enemy.enemyList) do
        local hit = false
        for key0, value0 in pairs(defenses.built) do
            local posCheck = (game.width - value.x) >= (value0.x * map.blockSize)  and (game.width - value.x - 55) <= ((value0.x + 1) * map.blockSize) and value0.y == value.line -- I have no idea why '-55' works, I just tried '-50' and it worked well enough... I'll not investigate further eventho I have guesses
            if value.lastAttack >= value.attackCooldown and posCheck and value.type ~= "shooter" then
                defenses.damagePlant(key0, value.damage)
                hit = true
                value.lastAttack = 0
            elseif enemyValues[value.type].atcType == "range" then
                local canShoot = (game.width - value.x) >= (value0.x * map.blockSize) and (game.width - value.x - 55) <= ((value0.x + enemyValues[value.type].range) * map.blockSize) and value0.y == value.line
                if value.lastAttack >= value.attackCooldown and canShoot then
                    projectile.create((game.width - value.x + (75 / 2)), value.line * 65, -200, {1,1,1}, value.damage, 10, 10, value.type, false, enemyValues[value.type].pierce)
                    hit = true
                    value.lastAttack = 0
                elseif canShoot then
                    hit = true
                end
            elseif posCheck then
                hit = true
            end
        end

        if not hit then
            --print(value.speed)
            value.x = value.x + value.speed * dt
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
    levelReader.alive = levelReader.alive - 1
    levelReader.percent = (levelReader.enSpawned - levelReader.alive) / levelReader.enCount
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
    for key, value in pairs(enemy.enemyList) do
        love.graphics.setColor(value.sprite[1], value.sprite[2], value.sprite[3], game.levelTransition)
        love.graphics.rectangle("fill", game.width - value.x, (value.line - 1) * 75, 75, 75)
    end
end

function enemy.cooldownAdd(dt)
    local index = 1
    for key, value in pairs(enemy.enemyList) do
        value.lastAttack = value.lastAttack + dt

        if value.isObsidian then
            if value.timeObsidian >= value.timeToObsidian then
                value.isObsidian = false
                value.timeToObsidian = 0
                value.timeObsidian = 0
                value.speed = enemyValues[value.type].speed
                value.sprite = enemyValues[value.type].color
            end

            value.health = value.health - (value.dotDamage * dt)

            value.timeObsidian = value.timeObsidian + dt
        elseif value.isSlowed then
            if value.timeSlowed >= value.timeToSlow then
                value.isSlowed = false
                value.timeToSlow = 0
                value.timeSlowed = 0
                value.speed = enemyValues[value.type].speed
                value.sprite = enemyValues[value.type].color
            end

            value.timeSlowed = value.timeSlowed + dt
        
        elseif value.onDot then
            if value.timeInDot >= value.timeToDot then
                value.onDot = false
                value.timeToDot = 0
                value.timeInDot = 0
                value.sprite = enemyValues[value.type].color
            end

            value.health = value.health - (value.dotDamage * dt)

            if value.health < 0 then
                enemy.die(index, value)
            end

            value.timeInDot = value.timeInDot + dt
        end

        index = index + 1
    end
end

function enemy.Create(lineNum, xPos, enemyType)
    if not map.disabledLanes[lineNum] and (lineNum >= 1 and lineNum <= 8) then
        table.insert(enemy.enemyList, {sprite = enemyValues[enemyType].color, line = lineNum, x = xPos, type = enemyType, health = enemyValues[enemyType].health, damage = enemyValues[enemyType].damage, attackCooldown = enemyValues[enemyType].attackCooldown, lastAttack = 0, speed = enemyValues[enemyType].speed, 
            isSlowed = false,   timeSlowed = 0,     timeToSlow = 0, -- This is for slowing
            onDot = false,      timeToDot = 0,      timeInDot = 0, dotDamage = 0, -- this is for DOT
            isObsidian = false, timeToObsidian = 0, timeObsidian = 0, -- this is for obsidian effect
            
        })
        
        map.enemyLanes[lineNum] = true

        enemy.sortEnemyByLine()

        return true
    end

    return false
end

function enemy.sortEnemyByLine()
    table.sort(enemy.enemyList, function(a, b) return a.line < b.line end)
end

function enemy.killAll()
    enemy.enemyList = {}
end

function enemy.delaySpawner(dt)
    if #enemy.spawnEnemies ~= 0 then
        if enemy.lastSpawn >= enemy.delaySpawn then
            enemy.Create(enemy.spawnEnemies[1].line, enemy.spawnEnemies[1].xPos, enemy.spawnEnemies[1].enemyType)
            enemy.lastSpawn = 0
            table.remove(enemy.spawnEnemies, 1)

            levelReader.enSpawned = levelReader.enSpawned + 1
            levelReader.alive = levelReader.alive + 1
        else
            enemy.lastSpawn = enemy.lastSpawn + dt
        end
    end
end

--enemy.Create(1, 50, enemyValues.default.type)

return enemy