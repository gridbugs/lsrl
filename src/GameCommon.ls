require! './GameState.ls'

export class TestAS
    (input_source, drawer) ->
        @inputSource = input_source
        @drawer = drawer

    getAction: (cb) ->
        @inputSource.getChar (c) ~>
            @drawer.log_window.addstr "char #{c}\n\r"
            @drawer.log_window.refresh!
            cb!

export class GameCommon
    (drawer, input_source) ->
        @gameDrawer = drawer
        @inputSource = input_source
        @gameState = new GameState.GameState (new TestAS input_source, drawer)
        @drawer = drawer

    start: -> @progressGameState!

    gameTimeToMs: (t) -> t

    progressGameState: ->

        @drawer.game_window.addstr "."
        @drawer.game_window.refresh!

        action_source = @gameState.getCurrentActionSource!

        action_source.getAction (action) ~>
            @drawer.game_window.addstr "x"
            @drawer.game_window.refresh!
            @gameState.applyAction action

            /* Progress the game state to the next action source */
            @gameState.progressSchedule!

            /* Get time until current action source (in game time) */
            time = @gameState.getCurrentTimeDelta!

            /* Process the next action after the time has passed */
            setTimeout (~>@progressGameState!), (@gameTimeToMs time)
