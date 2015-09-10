define [
    'actions/effectable'
    'actions/effect'
    'types'
], (Effectable, Effect, Types) ->

    class Character extends Effectable
        (@type, @position, @grid, @Controller) ->
            super()

            @addEffect(new Effect.Solid())

            @controller = new @Controller(this, @position, @grid)
            @__playerCharacter = false

            @hitPoints = 10

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

        getCurrentAttackTime: ->
            return 10

        getCurrentAttackDamage: ->
            return 5


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

    class Shrubbery extends Character
        (position, grid, Controller) ->
            super(Types.Character.Shrubbery, position, grid, Controller)

        getName: -> 'Shrubbery'

    class Human extends Character
        (position, grid, Controller) ->
            super(Types.Character.Human, position, grid, Controller)

        getName: -> 'Human'

    {
        Character
        Human
        Shrubbery
    }
