define [
    'character/character'
    'types'
], (Character, Types) ->
    
    class Human extends Character
        (position, grid, Controller) ->
            super(Types.Character.Human, position, grid, Controller)

        getName: -> 'Human'
