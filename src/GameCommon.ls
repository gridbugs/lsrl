require! './KeyControl.ls'
require! './GameState.ls'
require! './Actor.ls'

export class GameCommon
    (drawer) ->
        @gameDrawer = drawer
        @keyControl = new KeyControl.KeyControl!
        @currentActor = new Actor.Actor '@'
        @gameState = new GameState.GameState @currentActor

    gameTimeToMs: (t) -> t

    processChar: (ch) ->
        if @acceptingKeyboardInput
            @acceptingKeyboardInput = false
            time_taken = @gameState.processAction (@keyControl.getAction ch, @gameState)
            @progressAfterDelay time_taken

    start: ->
        @progressGameState!

    progressAfterDelay: (game_time) ->
        @gameDrawer.draw @gameState
        setTimeout @progressGameState, (@gameTimeToMs game_time)

    progressGameState: ~>
        actor = @gameState.getCurrentActor!
        if actor is @currentActor
            @acceptingKeyboardInput = true
        else
            time_taken = @gameState.processAction actor.act!
            @progressAfterDelay time_taken
