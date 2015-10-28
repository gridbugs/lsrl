define [
], ->
    {

        initEffectable: ->
            @effects = []

        notifyEffectable: ->

        notify: (action, relationship, game_state) ->
            @notifyEffectable(action, relationship, game_state)
            for e in @effects
                e.notify(action, relationship, game_state)

        registerEffect: (effect) ->
            @effects.push(effect)
    }
