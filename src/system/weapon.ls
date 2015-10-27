define [
    'action/effectable'
], (Effectable) ->

    class Weapon implements Effectable
        ->
            @effects = []

        getAttackDamage: ->
            return 0
