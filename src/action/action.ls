define [
    'action/action_status'
    'interface/user_interface'
    'types'
    'type_system'
], (ActionStatus, UserInterface, Types, TypeSystem) ->

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

                if @rescheduleRequired
                    game_state.scheduleActionSource(@getSource(), @time)

        prepare: ->
        commit: ->


    /* An action which is clearly done by a single character. */
    Action.CharacterAction = {
        getSource: ->
            return @character.getController()
    }

    class RemoveContinuousEffect extends Action
        (@node, @effect) ->
            super()
            @rescheduleRequired = false

        commit: (game_state) ->
            @effect.finish()
            game_state.removeContinuousEffectNode(@node)

    TypeSystem.makeType 'Action', {
        RemoveContinuousEffect
    }

    Action.RemoveContinuousEffect = RemoveContinuousEffect

    return Action
