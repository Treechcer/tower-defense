map = require("map")
projectile = require("projectile")

defenseValues = {
    --[[
        "shooter",
        "generator",
        "tank"
    ]]

    -- temporary sprites are colors

    shooter = {
        sprite = {0,1,1},
        ammoSprite = {1,1,1},
        cost = 125,
        plantCoolDown = 12,

        shootCoolDown = 0.5,

        count = 0, -- this is how many of there are spawned
    },

    generator = {
        sprite = {0,0,1},
        cost = 50,
        plantCoolDown = 7,

        count = 0,

        generatorCoolDownRange = {5,10},
        generatorCoolDown = 0
    },

    tank = {
        sprite = {1,0,1},
        cost = 25,
        plantCoolDown = 7,

        count = 0
    }
}

--here will be added behavior functions for the defensese

function defenseValues.generator.generate(generator)
    local r = defenseValues.generator.generatorCoolDownRange
    local gen = defenseValues.generator
    if generator.cooldown >= r[1] then
        local range = math.random(r[1], r[2])
        local percentage = math.floor(math.random() * 70) * (range / r[1]) + gen.generatorCoolDown

        if percentage >= 90 then
            game.money = game.money + 25 + (5 * (math.random(0,1) * 2 -1))
            generator.cooldown = 0
        end
    end
end

function defenseValues.shooter.shoot(shooter)
    if map.enemyLanes[shooter.y] and shooter.cooldown >= defenseValues[shooter.defense].shootCoolDown then
        projectile.create(shooter.x + (map.blockSize * 1.75 + map.blockSize / 3), shooter.y + (map.blockSize / 3), 100, {0,1,1}, 10, 25, 25, shooter.defense)
        shooter.cooldown = 0
    end
end

return defenseValues