define [
    'controllers/controller'
], (Controller) ->
    class SingleActionController extends Controller
        (@action) ->
            super()

        getAction: (game_state, callback) ->
            @active = false
            callback(@action)
