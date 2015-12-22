define [
    'system/character'
    'assets/action/action'
    'assets/weapon/weapon'
    'assets/effect/reactive_effect'
    'assets/assets'
    'system/equipment_slot_table'
    'asset_system'
], (Character, Action, Weapons, ReactiveEffect, Assets, EquipmentSlotTable, AssetSystem) ->

    class Human extends Character
        (position, grid, level, Controller) ->
            super(position, grid, level, Controller)
            @hitPoints = 100
            @resurrect = new ReactiveEffect.ResurrectOnDeath()

        notifyEffectable: (action, relationship, game_state) ->
            @resurrect.notify(action, relationship, game_state)

        bare_hands = new Weapons.BareHands()
        equipmentSlots: new EquipmentSlotTable([
            [Assets.EquipmentSlot.Weapon, 'weapon', bare_hands]
            [Assets.EquipmentSlot.PreparedWeapon, 'preparedWeapon', bare_hands]
        ])

    AssetSystem.exposeAsset('Character', Human)
