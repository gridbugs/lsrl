define [
    'character/character'
    'assets/action/action'
    'assets/weapon/weapon'
    'assets/effect/reactive_effect'
    'types'
], (Character, Action, Weapons, ReactiveEffect, Types) ->

    class Human extends Character
        (position, grid, Controller) ->
            super(Types.Character.Human, position, grid, Controller)
            @weapon = new Weapons.BareHands()
            @resurrect = new ReactiveEffect.ResurrectOnDeath()

        notifyEffectable: (action, relationship, game_state) ->
            @resurrect.notify(action, relationship, game_state)

        getName: -> 'Human'
