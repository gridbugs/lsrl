define [
], ->
    {
        notifyRegisteredEffects: (action, relationship, game_state) ->
            for e in @effects
                e.notify(action, relationship, game_state)

        notify: (action, relationship, game_state) ->
            @notifyRegisteredEffects(action, relationship, game_state)

        registerEffect: (effect) ->
            @effects.push(effect)

        addEffect: (effect) ->
    }
