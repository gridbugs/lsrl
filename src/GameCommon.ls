require! './GameState.ls'
require! './Test.ls'

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
        @gameState = @test!
        @drawer = drawer

    test: -> Test.test @gameDrawer, @inputSource
    start: ->
        @gameState.scheduleActionSource @gameState.playerCharacter, 10
        @drawer.drawGameState @gameState
        action_source = @gameState.getCurrentActionSource!
        action_source.getAction @gameState, (action) ~>
            action.commit!
            @drawer.drawGameState @gameState
    gameTimeToMs: (t) -> t

    progressGameState: ->

        action_source = @gameState.getCurrentActionSource!

        action_source.getAction @gameState, (action) ~>
            @drawer.game_window.addstr "x"
            @drawer.game_window.refresh!
            @gameState.applyAction action

            /* Progress the game state to the next action source */
            @gameState.progressSchedule!

            /* Get time until current action source (in game time) */
            time = @gameState.getCurrentTimeDelta!

            /* Process the next action after the time has passed */
            setTimeout (~>@progressGameState!), (@gameTimeToMs time)
