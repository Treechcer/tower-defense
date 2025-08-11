game = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight(),
    world = 1,
    level = 1,
    defaults = {
        startMoney = 500
    },

    isRunning = true,
    levelTransition = 0,

    win = false,
}

game.money = game.defaults.startMoney

return game