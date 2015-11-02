define [
    'system/controller'
    'assets/action/action'
    'asset_system'
], (Controller, Action, AssetSystem) ->

    class NullController extends Controller
        (@character, @position, @grid) ->
            super()

        observe: (game_state) ->

        getAction: (game_state, callback) ->
            callback(new Action.Null())

    AssetSystem.exposeAsset('Controller', NullController)
