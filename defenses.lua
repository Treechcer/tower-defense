local map = require("map")
local defenseValues = require("defenseValues")

defenses = {
    pickedDefenses = {
        "shooter",
        "generator",
        "tank"
    },

    built = { -- it's table of tables, every table in it has X Y position

    },

    UIsize = 70,
    selected = 0,
}

function defenses.buyDraw()
    local offset = 5
    for i = 0, #defenses.pickedDefenses - 1 do
        if i + 1 == defenses.selected then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0.3,0.5,0.4)
        end
        love.graphics.rectangle("fill", 5, i * defenses.UIsize + offset, defenses.UIsize, defenses.UIsize)
        offset = offset + 5
    end
end

function defenses.draw()
    for key, value in pairs(defenses.built) do
        love.graphics.setColor(defenseValues[value.defense].sprite)
        love.graphics.rectangle("fill", (value.x - 1) * map.blockSize + map.blockSize * 1.75, (value.y - 1) * map.blockSize, map.blockSize, map.blockSize)
    end
end

return defenses