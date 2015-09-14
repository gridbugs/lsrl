define [
    'actions/effectable'
    'actions/effect'
    'actions/damage'
    'types'
], (Effectable, Effect, Damage, Types) ->

    class Character extends Effectable
        (@type, @position, @grid, @Controller) ->
            super()

            @addEffect(new Effect.Solid())

            @controller = new @Controller(this, @position, @grid)
            @__playerCharacter = false

            @hitPoints = 10

            @poison = 0
            @poisonThreshold = 10

        getName: -> 'Character'

        getController: ->
            return @controller

        isPlayerCharacter: ->
            return @__playerCharacter

        setAsPlayerCharacter: ->
            @__playerCharacter = true

        getPosition: ->
            return @position

        getCell: ->
            return @grid.getCart(@getPosition())

        getCurrentMoveTime: ->
            return 40

        getKnowledgeCell: ->
            @controller.getKnowledgeCell()

        setAutoMove: (auto_move) ->
            @controller.setAutoMove(auto_move)

        getAction: (game_state, callback) ->
            @controller.getAction(game_state, callback)

        getInventory: ->
            @controller.inventory

        getKnowledge: ->
            @controller.knowledge

        getCurrentAttackDamage: ->
            return new Damage.PhysicalDamage(3)

        getCurrentAttackTime: ->
            10

        getCurrentResistance: ->
            return 3

        getCurrentHitPoints: ->
            return @hitPoints

        takeNetDamage: (damage) ->
            @hitPoints = Math.max(0, @hitPoints - damage)

        isAlive: ->
            @hitPoints > 0

        die: ->
            @getCell().character = void

        accumulatePoison: (amount) ->
            @poison += amount

        isPoisoned: ->
            return @poison > @poisonThreshold

        clearPoison: ->
            @poison = 0

        becomePoisoned: (game_state, damage_rate) ->
            @clearPoison()
            game_state.registerContinuousEffect(new Effect.Poisoned(this, damage_rate))

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

    class CarnivorousShrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.CarnivorousShrubbery, position, grid, Controller)
            @hitPoints = 20

        getName: -> 'Carnivorous Shrubbery'

    class Human extends Character
        (position, grid, Controller) ->
            super(Types.Character.Human, position, grid, Controller)

        getName: -> 'Human'

    {
        Character
        Human
        Shrubbery
        PoisonShrubbery
        CarnivorousShrubbery
    }
