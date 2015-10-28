define [
    'character/character'
    'assets/action/action'
    'assets/weapon/weapon'
    'types'
], (Character, Action, Weapons, Types) ->

    class Human extends Character
        (position, grid, Controller) ->
            super(Types.Character.Human, position, grid, Controller)

            @weapon = new Weapons.BareHands()

        notifyEffectable: (action, relationship, game_state) ->
            if action.type == Types.Action.Die
                action.success = false
                game_state.enqueueAction(new Action.Restore(action.character))

        getName: -> 'Human'
