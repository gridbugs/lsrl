define [
], ->

    class CharacterCellEvent
        forEachEffect: (f) ->
            @character.effects.forEach f
            @cell.effects.forEach f

        forEachMatchingEffect: (f) ->
            @forEachEffect (e) ~>
                if e.match this
                    f e

    class MoveToCell extends CharacterCellEvent
        (@character, @cell) ->
        
    class MoveFromCell extends CharacterCellEvent
        (@character, @cell) ->

    {
        MoveToCell
        MoveFromCell
    }
