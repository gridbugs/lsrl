define [
    'system/effectable'
    'system/equipable'
    'system/item'
], (Effectable, Equipable, Item) ->

    class Apparel implements Effectable, Item
        ->
            @initEffectable()

    class EquipableApparel extends Apparel implements Equipable
        ->
            super()
            @initEquipable()

    Apparel.EquipableApparel = EquipableApparel

    return Apparel
