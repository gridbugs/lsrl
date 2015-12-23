define [
    'assets/assets'
    'asset_system'
    'types'
], (Assets, AssetSystem, Types) ->

    class FireBall
        ->

        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.StopProjectile and relationship == action.Relationships.Projectile
                action.success = false
                game_state.enqueueAction(new Assets.Action.Explode(action.projectile, action.toCell))

    class ExplosionPart
        ->

    AssetSystem.exposeAssets 'Item', {
        FireBall
    }
