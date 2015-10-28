define [
    'interface/user_interface'
    'system/effectable'
    'assets/observer/recursive_shadowcast'
    'assets/observer/omniscient'
    'types'
    'config'
], (UserInterface, Effectable, RecursiveShadowcast, Omniscient, Types, Config) ->

    if Config.OMNISCIENT_CHARACTERS
        Observer = new Omniscient()
    else
        Observer = new RecursiveShadowcast()

    class Character implements Effectable
        (@type, @position, @grid, @Controller) ->
            @initEffectable()
            @controller = new @Controller(this, @position, @grid)
            @hitPoints = 10
            @alive = true

        initGameState: (game_state) ->
            @continuousEffects = game_state.continuousEffects.createChild()

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

        getCell: ->
            return @grid.getCart(@getPosition())

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

        getCurrentHitPoints: ->
            return @hitPoints

        takeDamage: (damage) ->
            @hitPoints = Math.max(0, @hitPoints - damage)

        setObserverNode: (node) ->
            @observerNode = node

        die: (game_state) ->
            if @alive
                @alive = false
                @controller.deactivate()
                if @observerNode?
                    game_state.removeObserverNode(@observerNode)
                @getCell().character = void

        notifyEffectable: (action, relationship, game_state) ->
            @weapon.notify(action, relationship, game_state)
