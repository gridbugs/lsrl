define [
], ->
    class ContinuousEffect
        (@subject, @remainingTime = 10) ->

        setNode: (@node) ->

        apply: (time_delta, game_state) ->
            if time_delta < @remainingTime
                @remainingTime -= time_delta
                @_apply(time_delta, game_state)
            else
                @_apply(@remainingTime, game_state)
                @finish(game_state)

        finish: (game_state) ->
            @_finish(game_state)
            @subject.continuousEffects.removeNode(@node)

        _apply: ->
        _finish: ->
