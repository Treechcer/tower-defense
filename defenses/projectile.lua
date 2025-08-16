local enemy = require("enemy.enemy")
local map = require("map")

projectile = {
    active = {}
}

function projectile.create(x, y, speed, sprite, damage, sizeX, sizeY, origin)

    if defenseValues[origin].projSpeciality ~= nil then
        speciality = defenseValues[origin].projSpeciality
    else
        speciality = nil
    end

    table.insert(projectile.active, {x = x, y = y, speed = speed, sprite = sprite, damage = damage, sizeX = sizeX, sizeY = sizeY, origin = origin, speciality = speciality})
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
                table.remove(projectile.active, i)

                if en.health <= 0 then
                    enemy.die(j, en)
                end
            end
        end
    end
end

function projectile.slow(en, proj)
    if not en.isSlowed then
        en.speed = en.speed - (en.speed * (proj.speciality.effect / 100))
        en.timeToSlow = proj.speciality.effectTime
        en.isSlowed = true
        en.sprite = enemyValues[en.type].freezeColor
    end

    return en
end

function projectile.reset()
    projectile.active = {}
end

return projectile