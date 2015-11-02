define [
    'system/character'
    'assets/action/action'
    'assets/weapon/weapon'
    'assets/effect/reactive_effect'
    'asset_system'
], (Character, Action, Weapons, ReactiveEffect, AssetSystem) ->

    class Human extends Character
        (position, grid, Controller) ->
            super(position, grid, Controller)
            @weapon = new Weapons.BareHands()
            @resurrect = new ReactiveEffect.ResurrectOnDeath()

        notifyEffectable: (action, relationship, game_state) ->
            @resurrect.notify(action, relationship, game_state)

        getName: -> 'Human'

    AssetSystem.exposeAsset('Character', Human)
