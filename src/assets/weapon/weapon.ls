define [
    'system/weapon'
    'system/equipable'
    'assets/action/action'
    'assets/effect/reactive_effect'
    'assets/equipment_slot/equipment_slot'
    'system/item'
    'asset_system'
    'types'
], (Weapon, Equipable, Actions, ReactiveEffect, EquipmentSlot, Item, AssetSystem, Types) ->

    class EquipableWeapon extends Weapon.EquipableWeapon
        ->
            super()

        compatibleSlots: new Set([
            EquipmentSlot.Weapon,
            EquipmentSlot.PreparedWeapon
        ])

    class BareHands extends Weapon
        ->
            super()

        getAttackDamage: ->
            return 4

    class ShrubberyTeeth extends Weapon
        ->
            super()

        getAttackDamage: ->
            return 2

    class ShrubberyPoisonSpikes extends Weapon
        ->
            super()
            @poisons = new ReactiveEffect.PoisonOnHit()

        getAttackDamage: ->
            return 1

        notifyEffectable: (action, relationship, game_state) ->
            @poisons.notify(action, relationship, game_state)

    class SpiderFangs extends Weapon
        ->
            super()
            @poisons = new ReactiveEffect.PoisonOnHit()

        getAttackDamage: ->
            return 1

        notifyEffectable: (action, relationship, game_state) ->
            if Math.random() < 0.5
                @poisons.notify(action, relationship, game_state)

    class Null extends Weapon
        ->
            super()

    class RustySword extends EquipableWeapon
        ->
            super()

        getAttackDamage: ->
            return 1

    class BentSpear extends EquipableWeapon
        ->
            super()

        getAttackDamage: ->
            return 1

    AssetSystem.exposeAssets 'Weapon', {
        BareHands
        ShrubberyTeeth
        ShrubberyPoisonSpikes
        SpiderFangs
        RustySword
        BentSpear
        Null
    }
