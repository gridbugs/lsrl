require! 'prelude-ls': {map, join, filter}
require! './PerlinTestGenerator.ls': {PerlinTestGenerator}
require! './CellAutomataTestGenerator.ls': {CellAutomataTestGenerator}
require! './Character.ls': {PlayerCharacter}
require! './Vec2.ls': {vec2}
require! './GameState.ls': {GameState}
require! './GameCommon.ls': {GameCommon}

class Cell
    (x, y) ->
        @x = x
        @y = y
    toString: -> "(#{@x} #{@y})"

export test = (drawer, input_source) ->
    c = new CellAutomataTestGenerator!
    grid = c.generateGrid Cell, 120, 40
    sp = c.getStartingPointHint!

    player = new PlayerCharacter (vec2 sp.x, sp.y), input_source

    game_state = new GameState grid, player
    return game_state
    #drawer.drawGameState game_state
    #drawer.print player.position
