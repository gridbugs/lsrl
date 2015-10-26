define [
    'action/action_status'
    'interface/user_interface'
    'types'
], (ActionStatus, UserInterface, Types) ->

    class Action
        ->
            @success = true
            @time = 0
            @rescheduleRequired = true

        addTime: (time) ->
            @time += time

        apply: (game_state) ->
            @prepare(game_state)

            if @success
                @commit()

                if @rescheduleRequired
                    game_state.scheduleActionSource(@getSource(), @time)

        prepare: ->
        commit: ->


    /* An action which is clearly done by a single character. */
    Action.CharacterAction = {
        getSource: ->
            return @character.getController()
    }

    return Action
