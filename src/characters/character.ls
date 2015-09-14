define [
    'input/user_interface'
    'actions/effectable'
    'actions/effect'
    'actions/damage'
    'types'
], (UserInterface, Effectable, Effect, Damage, Types) ->

    class Character extends Effectable
        (@type, @position, @grid, @Controller) ->
            super()

            @addEffect(new Effect.Solid())

            @controller = new @Controller(this, @position, @grid)
            @__playerCharacter = false

            @hitPoints = 10

            @poison = 0
            @poisonThreshold = 10

        getTurnCount: ->
            return @controller.getTurnCount()

        getName: -> 'Character'

        observe: (game_state) ->
            @controller.observe(game_state)

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
            return 10

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

        resurrect: ->
            @hitPoints = 10

        accumulatePoison: (amount) ->
            @poison += amount

        isPoisoned: ->
            return @poison > @poisonThreshold

        clearPoison: ->
            @poison = 0

        becomePoisoned: (game_state, damage_rate, duration) ->
            @clearPoison()
            UserInterface.printLine "Becomes poisoned."
            game_state.registerContinuousEffect(new Effect.Poisoned(this, damage_rate), duration)

        setObserverNode: (node) ->
            @observerNode = node

        die: (game_state) ->
            #if @observerNode?
            #    game_state.removeObserverNode(@observerNode)
            #@getCell().character = void

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
            return new Damage.PoisoningPhysicalDamage(1, 100, 0.1, 1000)

    class CarnivorousShrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.CarnivorousShrubbery, position, grid, Controller)
            @hitPoints = 20

        getName: -> 'Carnivorous Shrubbery'

        getCurrentAttackTime: ->
            return 40

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
