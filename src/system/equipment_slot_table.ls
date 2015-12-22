define [
    'util'
], (Util) ->

    class EquipmentSlot
        (@type, @key, @default) ->
            @item = @default

        containsItem: ->
            return @item != @default

    class EquipmentSlotTable
        (entries) ->
            @slots = entries.map (e) -> new EquipmentSlot(e[0], e[1], e[2])
            for s in @slots
                this[s.key] = s

            @letterMap = {}
            for i from 0 til @slots.length
                @letterMap[Util.getNthLetter(i)] = @slots[i]

        forEachMapping: (f) ->
            for k, v of @letterMap
                f(k, v)

        getSlotByLetter: (letter) ->
            return @letterMap[letter]

    EquipmentSlotTable.EquipmentSlot = EquipmentSlot
    return EquipmentSlotTable
