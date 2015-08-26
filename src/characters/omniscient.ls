define [
], ->

    observe = (character, game_state) ->

        character.knowledge.grid.forEach (c) ->
            c.see game_state

    {
        observe
    }
