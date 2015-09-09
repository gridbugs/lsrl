define [
    'actions/effectable'
    'types'
], (Effectable, Types) ->

    class Character extends Effectable
        (@type, @position, @grid, @Controller) ->
            @controller = new @Controller(this, @position, @grid)
            @__playerCharacter = false
            super()

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
