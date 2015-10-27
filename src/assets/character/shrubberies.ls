define [
    'character/character'
    'assets/weapon/weapon'
    'action/damage'
    'types'
], (Character, Weapons, Damage, Types) ->

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

        getCurrentAttackTime: ->
            return 40

        getCurrentAttackDamage: ->
            return new Damage.PoisoningPhysicalDamage(1, 100, 0.01, 50)

    class CarnivorousShrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.CarnivorousShrubbery, position, grid, Controller)
            @hitPoints = 20
            @weapon = new Weapons.ShrubberyTeeth()

        getName: -> 'Carnivorous Shrubbery'

        getCurrentAttackTime: ->
            return 40

    {
        Shrubbery
        PoisonShrubbery
        CarnivorousShrubbery
    }
