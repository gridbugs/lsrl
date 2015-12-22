define [
], ->
    Equipable = {
        initEquipable: ->
            @equipped = false
            @equippedInSlot = void
        isEquipable: -> true
        isEquipped: -> @equipped
        equip: (slot) ->
            @equipped = true
            @equippedInSlot = slot
        unequip: ->
            @equipped = false
            @equippedInSlot = void
        getSlot: -> @equippedInSlot
    }

    return Equipable
