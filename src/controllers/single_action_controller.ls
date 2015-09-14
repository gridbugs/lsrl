define [
], ->
    class SingleActionController
        (@action) ->

        getAction: (game_state, callback) ->
            callback(action)
