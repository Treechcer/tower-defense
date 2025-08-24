scripts = require("levels.importantCustomScripts")

level = {
    metadata = {
        color = {
            main = {0.2, 0.6, 0.2},
            second = {0.25, 0.65, 0.25}
        },
        lawnMowersColors = {
            main = {0.4, 0.4, 0.4},
            second = {0.2, 0.2, 0.2}
        },
        disabledLaneColors = {
            main = {139 / 255, 69 / 255, 19 / 255},
            second = {160 / 255, 82 / 255, 45 / 255}
        },
        disabledLanes = {
            1,2,3,6,7,8
        },
        specialTiles = {
            --{x = 4, y = 4, ability = "noPlace"}
        },

        warmupTime = 1,
        delay = 0.1
    },
    wave = {
        {
            time = 1,
            flag = "attack",
            enemies = {
                {line = 5, type = "default"},
                {line = 5, type = "default"},
                {line = 4, type = "shooter"},
                --{line = 4, type = "default"},
                --{line = 2, type = "default"},
                --{line = 4, type = "default"}
            },

            customScript = {}
        },
        {
            time = 13,
            flag = "attack",
            enemies = {
                --{line = 2, type = "default"},
                {line = 4, type = "default"}
            },

            customScript = {}
        }
    }

}

return level