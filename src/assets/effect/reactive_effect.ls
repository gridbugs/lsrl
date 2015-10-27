define [
    'assets/action/action'
    'types'
    'asset_system'
], (Actions, Types, AssetSystem) ->

    class Solid
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Move and relationship == action.Relationships.DestinationCell
                action.success = false

                game_state.enqueueAction(new Actions.BumpIntoWall(action.character, action.toCell))

    AssetSystem.exposeAssets 'ReactiveEffect', {
        Solid
    }
