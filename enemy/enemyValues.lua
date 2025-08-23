-- in this file are all enemy types and values associated with them

enemyValues = {
    default = {
        atcType = "melee",
        speed = 90,
        health = 120,
        color = {0.7, 0.2, 0.2},
        freezeColor = {0.4, 0.6, 1.0},
        fireColor = {1.0, 0.4, 0.1},
        obsidianColor = {0.2, 0.1, 0.3},
        type = "default",
        damage = 15,
        attackCooldown = 0.6,
    },

    tank = {
        atcType = "melee",
        speed = 70,
        health = 300,
        color = {0.3, 0.1, 0.3},
        freezeColor = {0.4, 0.6, 1.0},
        fireColor = {1.0, 0.3, 0.0},
        obsidianColor = {0.15, 0.15, 0.2},
        type = "tank",
        damage = 10,
        attackCooldown = 0.7,
    },

    shooter = {
        atcType = "range",
        speed = 70,
        health = 300,
        color = {0.3, 0.1, 0.3},
        freezeColor = {0.4, 0.6, 1.0},
        fireColor = {1.0, 0.3, 0.0},
        obsidianColor = {0.15, 0.15, 0.2},
        type = "shooter",
        damage = 10,
        attackCooldown = 0.7,
        range = 3,
        pierce = 2
    }
}


return enemyValues