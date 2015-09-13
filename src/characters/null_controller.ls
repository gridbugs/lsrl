define [
    'actions/action'
], (Action) ->

    class NullController
        (@character, @position, @grid) ->

        observe: (game_state) ->

        getAction: (game_state, callback) ->
            callback(new Action.Null())

    {
        NullController
    }
