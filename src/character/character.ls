define [
    'interface/user_interface'
    'action/effectable'
    'action/effect'
    'action/damage'
    'character/recursive_shadowcast'
    'character/omniscient'
    'types'
    'config'
], (UserInterface, Effectable, Effect, Damage, RecursiveShadowcast, Omniscient, Types, Config) ->

    if Config.OMNISCIENT_CHARACTERS
        Observer = Omniscient
    else
        Observer = RecursiveShadowcast

    class Character extends Effectable
        (@type, @position, @grid, @Controller) ->
            super()

            @addEffect(new Effect.Solid())

            @controller = new @Controller(this, @position, @grid)

            @hitPoints = 10

            @poison = 0
            @poisonThreshold = 10

        getPosition: ->
            return @position

        getTurnCount: ->
            return @controller.getTurnCount()

        getName: -> 'Character'

        observe: (game_state) ->
            Observer.observe(@controller, game_state)
            @controller.turnCount = game_state.getTurnCount()

        getController: ->
            return @controller

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
            @controller.deactivate()
            if @observerNode?
                game_state.removeObserverNode(@observerNode)
            @getCell().character = void
