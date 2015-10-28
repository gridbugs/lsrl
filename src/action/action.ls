define [
    'interface/user_interface'
], (UserInterface) ->

    class Action
        ->
            @success = true
            @time = 1
            @rescheduleRequired = true

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


    /* An action which is clearly done by a single character. */
    Action.CharacterAction = {
        getSource: ->
            return @character.getController()
    }

    return Action
