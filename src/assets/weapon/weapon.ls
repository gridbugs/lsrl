define [
    'system/weapon'
    'assets/action/action'
    'assets/effect/reactive_effect'
    'asset_system'
    'types'
], (Weapon, Actions, ReactiveEffect, AssetSystem, Types) ->

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
            @poisons = new ReactiveEffect.PoisonOnHit()

        getAttackDamage: ->
            return 1

        notifyEffectable: (action, relationship, game_state) ->
            @poisons.notify(action, relationship, game_state)

    class SpiderFangs extends Weapon
        ->
            super()
            @poisons = new ReactiveEffect.PoisonOnHit()

        getAttackDamage: ->
            return 1

        notifyEffectable: (action, relationship, game_state) ->
            if Math.random() < 0.5
                @poisons.notify(action, relationship, game_state)

    class Null extends Weapon
        ->
            super()

    AssetSystem.exposeAssets 'Weapon', {
        BareHands
        ShrubberyTeeth
        ShrubberyPoisonSpikes
        SpiderFangs
        Null
    }
