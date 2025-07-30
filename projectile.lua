projectile = {
    active = {}
}

function projectile.create(x, y, speed, sprite, damage, sizeX, sizeY)
    table.insert(projectile.active, {x = x, y = y, speed = speed, sprite = sprite, damage = damage, sizeX = sizeX, sizeY = sizeY})
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
        love.graphics.rectangle("fill", proj.x, proj.y, proj.sizeX, proj.sizeY)
    end
end

return projectile