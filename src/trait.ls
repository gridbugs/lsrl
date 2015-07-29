define [
], ->

    class Trait
        process: (action) ->
            for g in @effect_groups
                effect_list = g[@constructor.name]
                if effect_list?
                    for e in effect_list
                        if e.match this
                            e.apply action

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
