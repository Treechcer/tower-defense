local enemy = require("enemy.enemy")
local map = require("map")
local specialEffects = require("defenses.specialEffects")

projectile = {
    active = {}
}

function projectile.create(x, y, speed, sprite, damage, sizeX, sizeY, origin, isPlant, pierce)

    if defenseValues[origin].projSpeciality ~= nil then
        speciality = defenseValues[origin].projSpeciality
    else
        speciality = nil
    end

    table.insert(projectile.active, {x = x, y = y, speed = speed, sprite = sprite, damage = damage, sizeX = sizeX, sizeY = sizeY, origin = origin, speciality = speciality, isPlant = isPlant, pierce = pierce})
end

function projectile.move(dt)
    for index, value in ipairs(projectile.active) do
        local proj = projectile.active[index]
        proj.x = proj.x + (proj.speed * dt)
    end
end

function projectile.draw()
    for index, value in ipairs(projectile.active) do
        local proj = projectile.active[index]
        love.graphics.setColor(defenseValues[proj.origin].ammoSprite[1], defenseValues[proj.origin].ammoSprite[2], defenseValues[proj.origin].ammoSprite[3], game.levelTransition)
        love.graphics.rectangle("fill", proj.x, proj.y, proj.sizeX, proj.sizeY)
    end
end

function projectile.collisionCheck()
    for i = #projectile.active, 1, -1 do
        local proj = projectile.active[i]
        if proj.isPlant then
            for j = #enemy.enemyList, 1, -1 do
                local en = enemy.enemyList[j]
                local enX = game.width - en.x
                local enY = (en.line - 1) * map.blockSize
                local enWidth = map.blockSize
                local enHeight = map.blockSize
                if proj.x < enX + enWidth and proj.x + proj.sizeX > enX and proj.y < enY + enHeight and proj.y + proj.sizeY > enY then
                    
                    if proj.speciality ~= nil then
                        en = _G.projectile[proj.speciality.name](en, proj)
                    end

                    en.health = en.health - proj.damage
                    proj.pierce = proj.pierce - 1

                    if proj.pierce == 0 then
                        table.remove(projectile.active, i)
                    end

                    if en.health <= 0 then
                        enemy.die(j, en)
                    end
                end
            end
        else
            for j = #defenses.built, 1, -1 do
                local en = defenses.built[j]
                local canDo = true

                if proj.lastHit ~= nil then
                    if en.x == proj.lastHit.x and en.y == proj.lastHit.y then
                        canDo = false
                    end
                end

                local enX = (en.x + 0.4) * map.blockSize
                local enY = (en.y - 1) * map.blockSize
                local enWidth = map.blockSize
                local enHeight = map.blockSize
                if proj.x < enX + enWidth and proj.x + proj.sizeX > enX and proj.y < enY + enHeight and proj.y + proj.sizeY > enY and canDo then
                    en.hp = en.hp - proj.damage
                    proj.pierce = proj.pierce - 1

                    if proj.pierce == 0 then
                        table.remove(projectile.active, i)
                    else
                        projectile.active[i].lastHit = {x = en.x, y = en.y}
                    end

                    if en.hp <= 0 then
                        defenses.die(j)
                    end
                end
            end
        end
    end
end

function projectile.slow(en, proj)
    if en.onDot and not en.isObsidian then
        en = projectile.obsidian(en, proj)
        return en
    end


    if en.isObsidian then
        return en
    end

    if not en.isSlowed then
        en.speed = en.speed - (en.speed * (proj.speciality.effect / 100))
        en.timeToSlow = proj.speciality.effectTime
        en.isSlowed = true
        en.sprite = enemyValues[en.type].freezeColor
    end

    return en
end

function projectile.dot(en, proj)
    if en.isSlowed and not en.isObsidian then
        en = projectile.obsidian(en, proj)
        return en
    end

    if en.isObsidian then
        return en
    end

    if not en.onDot then
        en.timeToDot = proj.speciality.effectTime
        en.onDot = true
        en.dotDamage = proj.speciality.effect
        en.sprite = enemyValues[en.type][proj.speciality.type .. "Color"]
    end

    return en
end

function projectile.obsidian(en, proj)
    en.isSlowed = false
    en.timeToSlow = 0
    en.timeSlowed = 0
    en.onDot = false
    en.timeToDot = 0
    en.timeInDot = 0

    en.isObsidian = true
    en.timeToObsidian = specialEffects.obsidian.time
    en.dotDamage = specialEffects.obsidian.dotDamage
    en.speed = en.speed - (en.speed * (specialEffects.obsidian.speedDebuff / 100))
    en.sprite = enemyValues[en.type].obsidianColor

    return en
end

function projectile.reset()
    projectile.active = {}
end

return projectile