define [
    'system/effectable'
], (Effectable) ->

    class Weapon implements Effectable
        ->
            @initEffectable()

        getAttackDamage: ->
            return 0
