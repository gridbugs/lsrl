define [
    'system/continuous_effect'
    'assets/assets'
    'asset_system'
], (ContinuousEffect, Assets, AssetSystem) ->

    class Poisoned extends ContinuousEffect
        (@character, duration) ->
            super(@character, duration)

        _apply: (time_delta, game_state) ->
            game_state.enqueueAction(new Assets.Action.TakeDamage(@character, time_delta))

        toString: -> "Poisoned: #{@remainingTime}"

    AssetSystem.exposeAssets 'ContinuousEffect', {
        Poisoned
    }
