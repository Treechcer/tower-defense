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

        count = 0, -- this is how many of there are spawned
    },

    generator = {
        sprite = {0,0,1},
        cost = 50,

        count = 0
    },

    tank = {
        sprite = {1,0,1},
        cost = 25,

        count = 0
    }
}

return defenseValues