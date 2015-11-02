define [
    'system/character'
    'assets/weapon/weapon'
    'asset_system'
], (Character, Weapons, AssetSystem) ->

    class Shrubbery extends Character
        (position, grid, Controller) ->
            super(position, grid, Controller)
            @hitPoints = 5
            @weapon = new Weapons.Null()

        getName: -> 'Shrubbery'

    class PoisonShrubbery extends Character
        (position, grid, Controller) ->
            super(position, grid, Controller)
            @hitPoints = 10
            @weapon = new Weapons.ShrubberyPoisonSpikes()

        getName: -> 'Poison Shrubbery'

    class CarnivorousShrubbery extends Character
        (position, grid, Controller) ->
            super(position, grid, Controller)
            @hitPoints = 20
            @weapon = new Weapons.ShrubberyTeeth()

        getName: -> 'Carnivorous Shrubbery'

    AssetSystem.exposeAssets 'Character', {
        Shrubbery
        PoisonShrubbery
        CarnivorousShrubbery
    }
