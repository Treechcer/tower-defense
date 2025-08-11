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
        },
        specialTiles = {
            {x = 3, y = 4, ability = "noPlace"}
        }
    },
    wave = {
        {
            time = 1,
            flag = "attack",
            enemies = {
                {line = 1, type = "default"},
                {line = 2, type = "default"},
                {line = 4, type = "default"}
            },

            customScript = {}
        },
        {
            time = 6,
            flag = "attack",
            enemies = {
                {line = 2, type = "default"},
                {line = 4, type = "default"}
            },

            customScript = {}
        }
    }

}

return level