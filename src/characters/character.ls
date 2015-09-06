define [
    'types'
], (Types) ->
    
    class Character
        (@type, @position, @grid, @Controller) ->
            @controller = new @Controller(this, @position, @grid)

    class Shrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.Shrubbery, position, grid, Controller)

    class Human extends Character
        (position, grid, Controller) ->
            super(Types.Character.Human, position, grid, Controller)

    {
        Character
        Human
        Shrubbery
    }
