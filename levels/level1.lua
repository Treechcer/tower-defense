level = {
    metadata = {
        color = {
            main = {0.2, 0.6, 0.2},
            second = {0.25, 0.65, 0.25}
        },
        lawnMowersColors = {
            main = {0.4, 0.4, 0.4},
            second = {0.2, 0.2, 0.2}
        }
    },
    wave = {
        {
            time = 1,
            flag = "attack",
            enemies = {
                {line = 1, type = "default"},
                {line = 2, type = "default"},
            }
        },
        {
            time = 6,
            flag = "attack",
            enemies = {
                {line = 2, type = "default"},
                {line = 4, type = "default"}
            }
        }
    }

}

return level