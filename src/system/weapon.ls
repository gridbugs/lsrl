define [
    'system/effectable'
    'system/equipable'
    'system/item'
], (Effectable, Equipable, Item) ->

    class Weapon implements Effectable, Item
        ->
            @initEffectable()

        getAttackDamage: ->
            return 0

    class EquipableWeapon extends Weapon implements Equipable
        ->
            super()
            @initEquipable()

    Weapon.EquipableWeapon = EquipableWeapon

    return Weapon
