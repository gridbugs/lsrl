define [
    'interface/user_interface'
], (UserInterface) ->

    class Action
        ->
            @success = true
            @time = 1
            @rescheduleRequired = true

        shouldReschedule: true

        addTime: (time) ->
            @time += time

        apply: (game_state) ->
            @prepare(game_state)
            if @success
                @commit(game_state)
                return true
            return false

        prepare: ->
        commit: ->

        getAnimationTime: ->
            return @time

    Action.CharacterAction = {
        getPosition: -> @character.position
    }

    return Action
