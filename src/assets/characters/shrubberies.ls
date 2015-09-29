define [
    'character/character'
    'action/damage'
    'types'
], (Character, Damage, Types) ->

    class Shrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.Shrubbery, position, grid, Controller)
            @hitPoints = 5

        getName: -> 'Shrubbery'

    class PoisonShrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.PoisonShrubbery, position, grid, Controller)
            @hitPoints = 10

        getName: -> 'Poison Shrubbery'

        getCurrentAttackTime: ->
            return 40

        getCurrentAttackDamage: ->
            return new Damage.PoisoningPhysicalDamage(1, 100, 0.01, 50)

    class CarnivorousShrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.CarnivorousShrubbery, position, grid, Controller)
            @hitPoints = 20

        getName: -> 'Carnivorous Shrubbery'

        getCurrentAttackTime: ->
            return 40

    {
        Shrubbery
        PoisonShrubbery
        CarnivorousShrubbery
    }
