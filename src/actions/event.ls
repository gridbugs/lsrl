define [
    'types'
], (Types) ->

    class CharacterCellEvent
        forEachEffect: (f) ->
            @character.forEachEffect f
            @cell.forEachEffect f

        forEachMatchingEffect: (f) ->
            @forEachEffect (e) ~>
                if e.match this
                    f e

    class MoveToCell extends CharacterCellEvent
        (@character, @cell) ->
            @type = Types.Event.MoveToCell

    class MoveFromCell extends CharacterCellEvent
        (@character, @cell) ->
            @type = Types.Event.MoveFromCell

    {
        MoveToCell
        MoveFromCell
    }
