define [
    'system/character'
    'assets/weapon/weapon'
    'assets/effect/reactive_effect'
    'asset_system'
], (Character, Weapons, ReactiveEffects, AssetSystem) ->

    class Spider extends Character
        (position, grid, level, Controller) ->
            super(position, grid, level, Controller)
            @weapon = new Weapons.SpiderFangs()
            @solid = new ReactiveEffects.SolidCharacter()

        notifyEffectable: (action, relationship, game_state) ->
            super(action, relationship, game_state)
            @solid.notify(action, relationship, game_state)

        getWeapon: -> @weapon

    AssetSystem.exposeAsset('Character', Spider)
