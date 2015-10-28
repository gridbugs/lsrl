define [
    'system/character'
    'assets/weapon/weapon'
    'types'
], (Character, Weapons, Types) ->

    class Shrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.Shrubbery, position, grid, Controller)
            @hitPoints = 5
            @weapon = new Weapons.Null()

        getName: -> 'Shrubbery'

    class PoisonShrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.PoisonShrubbery, position, grid, Controller)
            @hitPoints = 10
            @weapon = new Weapons.ShrubberyPoisonSpikes()

        getName: -> 'Poison Shrubbery'

    class CarnivorousShrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.CarnivorousShrubbery, position, grid, Controller)
            @hitPoints = 20
            @weapon = new Weapons.ShrubberyTeeth()

        getName: -> 'Carnivorous Shrubbery'

    {
        Shrubbery
        PoisonShrubbery
        CarnivorousShrubbery
    }
