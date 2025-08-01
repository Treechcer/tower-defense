local enemy = require("enemy.enemy")
local map = require("map")

projectile = {
    active = {}
}

function projectile.create(x, y, speed, sprite, damage, sizeX, sizeY, origin)
    table.insert(projectile.active, {x = x, y = y, speed = speed, sprite = sprite, damage = damage, sizeX = sizeX, sizeY = sizeY, origin = origin})
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
        love.graphics.setColor(defenseValues[proj.origin].ammoSprite)
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
                en.health = en.health - proj.damage
                table.remove(projectile.active, i)

                if en.health <= 0 then
                    enemy.die(j, en)
                end
            end
        end
    end
end

function projectile.reset()
    projectile.active = {}
end

return projectile