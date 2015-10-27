define [
    'system/weapon'
    'assets/action/action'
    'type_system'
    'types'
], (Weapon, Actions, TypeSystem, Types) ->

    class BareHands extends Weapon
        ->
            super()

        getAttackDamage: ->
            return 4

    class ShrubberyTeeth extends Weapon
        ->
            super()

        getAttackDamage: ->
            return 2

    class ShrubberyPoisonSpikes extends Weapon
        ->
            super()

        getAttackDamage: ->
            return 1

        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.AttackHit and relationship == action.Relationships.Attacker
                game_state.enqueueAction(new Actions.BecomePoisoned(action.targetCharacter))

            @notifyRegisteredEffects()

    class Null extends Weapon
        ->
            super()

    TypeSystem.makeType 'Weapon', {
        BareHands
        ShrubberyTeeth
        ShrubberyPoisonSpikes
        Null
    }
