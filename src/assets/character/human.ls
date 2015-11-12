define [
    'system/character'
    'assets/action/action'
    'assets/weapon/weapon'
    'assets/effect/reactive_effect'
    'asset_system'
], (Character, Action, Weapons, ReactiveEffect, AssetSystem) ->

    class Human extends Character
        (position, grid, level, Controller) ->
            super(position, grid, level, Controller)
            @hitPoints = 100
            @weapon = new Weapons.BareHands()
            @resurrect = new ReactiveEffect.ResurrectOnDeath()

        notifyEffectable: (action, relationship, game_state) ->
            @resurrect.notify(action, relationship, game_state)

        getName: -> 'Human'

    AssetSystem.exposeAsset('Character', Human)
