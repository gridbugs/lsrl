define [
    'actions/action'
    'types'
], (Action, Types) ->

    class Damage
        (@type, @points) ->

        apply: (character, game_state) ->
            character.takeNetDamage(@points)

    class PhysicalDamage extends Damage
        (points) ->
            super(Types.Damage.Physical, points)

    class PoisoningPhysicalDamage extends Damage
        (points, @buildup_rate, @damage_rate) ->
            super(Types.Damage.Physical, points)

        apply: (character, game_state) ->
            super(character, game_state)
            character.accumulatePoison(@buildup_rate)
            if character.isPoisoned()
                game_state.enqueueAction(new Action.BecomePoisoned(character, @damage_rate))

    class PoisonDamage extends Damage
        (points) ->
            super(Types.Damage.Poison, points)

    {
        Damage
        PhysicalDamage
        PoisonDamage
    }
