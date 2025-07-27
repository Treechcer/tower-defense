defenseValues = {
    --[[
        "shooter",
        "generator",
        "tank"
    ]]

    -- temporary sprites are colors

    shooter = {
        sprite = {0,1,1},
        cost = 125,
        plantCoolDown = 12,

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

        print(percentage, "%")

        if percentage >= 90 then
            game.money = game.money + 25 + (5 * (math.random(0,1) * 2 -1))
            generator.cooldown = 0
        end
    end
end

return defenseValues