define [
    'system/controller'
    'assets/action/action'
], (Controller, Action) ->

    class NullController extends Controller
        (@character, @position, @grid) ->
            super()

        observe: (game_state) ->

        getAction: (game_state, callback) ->
            callback(new Action.Null())
