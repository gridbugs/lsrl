define [
    'assets/action/action'
    'types'
    'asset_system'
], (Action, Types, AssetSystem) ->

    class Solid
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Move and relationship == action.Relationships.DestinationCell
                action.success = false
                game_state.enqueueAction(new Action.BumpIntoWall(action.character, action.toCell.feature))
            if action.type == Types.Action.MoveProjectile and relationship == action.Relationships.DestinationCell
                action.success = false
                game_state.enqueueAction(new Action.StopProjectile(action.projectile, action.fromCell, action.fromCell))

    class SolidCharacter
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Move and relationship == action.Relationships.DestinationCell
                action.success = false
                game_state.enqueueAction(new Action.BumpIntoWall(action.character, action.toCell.character))

    class ResurrectOnDeath
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Die
                action.success = false
                game_state.enqueueAction(new Action.Restore(action.character))

    class PoisonOnHit
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.AttackHit and relationship == action.Relationships.Attacker
                found = false
                action.targetCharacter.continuousEffects.forEach (effect) ->
                    if effect.type == Types.ContinuousEffect.Poisoned
                        effect.remainingTime += 5
                        found := true
                if not found
                    game_state.enqueueAction(new Action.BecomePoisoned(action.targetCharacter))

    AssetSystem.exposeAssets 'ReactiveEffect', {
        Solid
        SolidCharacter
        ResurrectOnDeath
        PoisonOnHit
    }
