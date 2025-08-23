map = require("map")
projectile = require("defenses.projectile")
enemy = require("enemy.enemy")
game = require("game")

defenseValues = {
    --[[
        "shooter",
        "generator",
        "tank"
    ]]

    -- temporary sprites are colors

    shooter = {
        type = "shooter",
        sprite = {0.2, 0.8, 0.2},
        ammoSprite = {0.9, 1.0, 0.9},
        cost = 100,
        plantCoolDown = 12,
        hp = 100,
        damage = 12.5,
        projSpeciality = nil,
        projectileSpeed = 325,

        shootCoolDown = 0.6,

        count = 0, -- this is how many of there are spawned
    },

    iceShooter = {
        type = "shooter",
        sprite = {0.3, 0.7, 1.0},
        ammoSprite = {0.7, 0.9, 1.0},
        cost = 175,
        plantCoolDown = 12,
        hp = 100,
        damage = 6.5,
        projSpeciality = {name = "slow", effect = 40, effectTime = 2.5, type = "watter"},
        projectileSpeed = 275,

        shootCoolDown = 0.8,

        count = 0,
    },

    fireShooter = {
        type = "shooter",
        sprite = {0.9, 0.3, 0.1},
        ammoSprite ={1.0, 0.7, 0.2},
        cost = 175,
        plantCoolDown = 12,
        hp = 100,
        damage = 5,
        projSpeciality = {name = "dot", effect = 15, effectTime = 1.5, type = "fire"},
        projectileSpeed = 250,

        shootCoolDown = 0.7,

        count = 0,
    },

    generator = {
        type = "generator",
        sprite = {1.0, 0.9, 0.2},
        cost = 85,
        plantCoolDown = 7,
        hp = 60,

        count = 0,

        generatorCoolDownRange = {5,8},
        generatorCoolDown = 0
    },

    tank = {
        type = "tank",
        sprite = {0.4, 0.2, 0.6},
        cost = 75,
        plantCoolDown = 9,
        hp = 250,

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
    --print(map.enemyLanes[shooter.y], shooter.y)
    local shoot = false
    for index, value in ipairs(enemy.enemyList) do
        --print(shooter.y, value.line, game.width - value.x, shooter.x * map.blockSize)
        if (game.width - value.x) > (shooter.x * map.blockSize) and shooter.y == value.line then
            shoot = true
        end
    end

    if map.enemyLanes[shooter.y] and shooter.cooldown >= defenseValues[shooter.defense].shootCoolDown and shoot then
        projectile.create(((shooter.x - 1) * map.blockSize) + (map.blockSize * 1.75 + map.blockSize / 3), ((shooter.y - 1) * map.blockSize) + (map.blockSize / 3), defenseValues[shooter.defense].projectileSpeed, {0,1,1}, defenseValues[shooter.defense].damage, 25, 25, shooter.defense)
        shooter.cooldown = 0

        --print(defenseValues[shooter.defense].damage)
    end
end

return defenseValues