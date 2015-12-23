define [
    'system/apparel'
    'assets/equipment_slot/equipment_slot'
    'asset_system'
], (Apparel, EquipmentSlot, AssetSystem) ->

    class EquipableAmulet extends Apparel.EquipableApparel
        ->
            super()

        compatibleSlots: new Set([
            EquipmentSlot.Neck
        ])

    class FlameAmulet extends EquipableAmulet
        ->
            super()


    AssetSystem.exposeAssets 'Apparel', {
        FlameAmulet
    }
