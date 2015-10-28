define [
    'assets/action/action'
    'types'
    'asset_system'
], (Action, Types, AssetSystem) ->

    class Solid
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Move and relationship == action.Relationships.DestinationCell
                action.success = false

                game_state.enqueueAction(new Action.BumpIntoWall(action.character, action.toCell))

    class ResurrectOnDeath
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Die
                action.success = false
                game_state.enqueueAction(new Action.Restore(action.character))

    class PoisonOnHit
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.AttackHit and relationship == action.Relationships.Attacker
                game_state.enqueueAction(new Action.BecomePoisoned(action.targetCharacter))

    AssetSystem.exposeAssets 'ReactiveEffect', {
        Solid
        ResurrectOnDeath
        PoisonOnHit
    }
