define [
    'prelude-ls'
], (Prelude) ->

    filter = Prelude.filter
    each = Prelude.each

    class Trait
        forEachEffect: (f) ->
            for g in @effect_groups
                for e in g
                    if e.match this
                        f e

    class MoveToCell extends Trait
        (@character, @cell)~>
            @effect_groups =
                @character.effects
                @cell.effects


    class MoveFromCell extends Trait
        (@character, @cell)~>
            @effect_groups =
                @character.effects
                @cell.effects


    {
        MoveToCell
        MoveFromCell
    }
