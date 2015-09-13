define [
    'types'
], (Types) ->

    class Damage
        (@type, @points) ->

        apply: (character) ->
            character.takeNetDamage(@points)

    class PhysicalDamage extends Damage
        (points) ->
            super(Types.Damage.Physical, points)

    class PoisonDamage extends Damage
        (points) ->
            super(Types.Damage.Poison, points)

    {
        Damage
        PhysicalDamage
        PoisonDamage
    }
