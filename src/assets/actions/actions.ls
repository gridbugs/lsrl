define [
    'action/action'
    'util'
    'type_system'
    'types'
], (Action, Util, TypeSystem, Types) ->

    class Move extends Action implements Action.CharacterAction
        (@character, @direction) ->
            super()
            @fromCell = @character.getCell()
            @toCell = @fromCell.neighbours[@direction]

        Relationships: Util.enum [
            'SourceCell'
            'DestinationCell'
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @fromCell.notify(this, @Relationships.SourceCell, game_state)
            @toCell.notify(this, @Relationships.DestinationCell, game_state)

        commit: ->
            @character.position = @toCell.position
            @fromCell.character = void
            @toCell.character = @character

    class BumpIntoWall extends Action implements Action.CharacterAction
        (@character, @cell) ->
            super()

        Relationships: Util.enum [
            'WallCell'
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @cell.notify(this, @Relationships.WallCell, game_state)

        commit: ->

    class OpenDoor extends Action implements Action.CharacterAction
        (@character, @direction) ->
            super()
            @doorCell = @character.getCell().neighbours[@direction]

        Relationships: Util.enum [
            'DoorCell'
            'Character'
        ]

        prepare: (game_state) ->

            if @doorCell.feature.type != Types.Feature.Door
                @success = false
            else if @doorCell.feature.isOpen()
                @success = false

            @character.notify(this, @Relationships.Character, game_state)
            @doorCell.notify(this, @Relationships.DoorCell, game_state)

        commit: ->
            @doorCell.feature.open()

    class Wait extends Action implements Action.CharacterAction
        (@character, @time = 1) ->
        
        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)

        commit: ->

    TypeSystem.makeType 'Action', {
        Move
        BumpIntoWall
        OpenDoor
        Wait
    }
