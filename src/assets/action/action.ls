define [
    'system/action'
    'assets/assets'
    'util'
    'asset_system'
    'types'
    'debug'
], (Action, Assets, Util, AssetSystem, Types, Debug) ->

    class Move extends Action implements Action.CharacterAction
        (@character, @direction) ->
            super()
            @fromCell = @character.getCell()
            @toCell = @fromCell.neighbours[@direction]

        Relationships: Util.enum [
            'SourceCell'
            'DestinationCell'
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @fromCell.notify(this, @Relationships.SourceCell, game_state)
            @toCell.notify(this, @Relationships.DestinationCell, game_state)

        commit: ->
            Debug.assert(@toCell.character == void)
            @character.position = @toCell.position
            @fromCell.character = void
            @toCell.character = @character

    class BumpIntoWall extends Action implements Action.CharacterAction
        (@character, @object) ->
            super()

        Relationships: Util.enum [
            'CollisionObject'
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @object.notify(this, @Relationships.CollisionObject, game_state)

        commit: ->

    class OpenDoor extends Action implements Action.CharacterAction
        (@character, @direction) ->
            super()
            @doorCell = @character.getCell().neighbours[@direction]

        Relationships: Util.enum [
            'DoorCell'
            'Character'
        ]

        prepare: (game_state) ->

            if @doorCell.feature.type != Types.Feature.Door
                @success = false
            else if @doorCell.feature.isOpen()
                @success = false

            @character.notify(this, @Relationships.Character, game_state)
            @doorCell.notify(this, @Relationships.DoorCell, game_state)

        commit: ->
            @doorCell.feature.open()

    class Wait extends Action implements Action.CharacterAction
        (@character, @time = 0) ->
            super()
            @time += 1

        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)

        commit: ->

    class Attack extends Action implements Action.CharacterAction
        (@character, @direction) ->
            super()
            @targetCell = @character.getCell().neighbours[@direction]
            @targetCharacter = @targetCell.character

        Relationships: Util.enum [
            'Attacker'
            'Target'
        ]

        prepare: (game_state) ->
            if @targetCharacter?
                @targetCharacter.notify(this, @Relationships.Target, game_state)
            else
                @success = false

            @character.notify(this, @Relationships.Attacker, game_state)

        commit: (game_state) ->
            game_state.enqueueAction(new AttackHit(@character, @targetCharacter))

    class AttackHit extends Action implements Action.CharacterAction
        (@character, @targetCharacter) ->
            super()
            @rescheduleRequired = false

        Relationships: Util.enum [
            'Attacker'
            'Target'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Attacker, game_state)
            @targetCharacter.notify(this, @Relationships.Target, game_state)

        commit: (game_state) ->
            damage = @character.getWeapon().getAttackDamage()
            game_state.enqueueAction(new TakeDamage(@targetCharacter, damage))

    class TakeDamage extends Action implements Action.CharacterAction
        (@character, @damage) ->
            super()
            @rescheduleRequired = false

        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)

        commit: (game_state) ->
            @character.takeDamage(@damage)
            if @character.hitPoints <= 0
                game_state.enqueueAction(new Die(@character))

    class Die extends Action implements Action.CharacterAction
        (@character) ->
            super()
            @rescheduleRequired = false

        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            if not @character.alive
                @success = false

        commit: (game_state) ->
            @character.die(game_state)

    class GetStuckInWeb extends Action implements Action.CharacterAction
        (@character, @cell) ->
            super()

        Relationships: Util.enum [
            'Character'
            'Cell'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @cell.notify(this, @Relationships.Cell, game_state)

        commit: ->

    class StruggleInWeb extends Action implements Action.CharacterAction
        (@character, @cell) ->
            super()
            @time = 10

        Relationships: Util.enum [
            'Character'
            'Cell'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @cell.notify(this, @Relationships.Cell, game_state)

        commit: ->
            @cell.feature.weaken()

    class BreakWeb extends Action implements Action.CharacterAction
        (@character, @cell) ->
            super()

        Relationships: Util.enum [
            'Character'
            'Cell'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @cell.notify(this, @Relationships.Cell, game_state)

        commit: ->
            @cell.feature.break()

    class BecomePoisoned extends Action implements Action.CharacterAction
        (@character) ->
            super()
            @rescheduleRequired = false

        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)

        commit: (game_state) ->
            game_state.registerContinuousEffect(new Assets.ContinuousEffect.Poisoned(@character, 5), @character)

    class Restore extends Action implements Action.CharacterAction
        (@character) ->
            super()

        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)

        commit: (game_state) ->
            @character.hitPoints = 100

    class Take extends Action implements Action.CharacterAction
        (@character, @slot) ->
            super()
            @item = @slot.item

        Relationships: Util.enum [
            'Character'
            'Item'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @item.notify(this, @Relationships.Item, game_state)

        commit: ->
            @slot.removeItem()
            @destinationKey = @character.getInventory().addItem(@item)

    class Drop extends Action implements Action.CharacterAction
        (@character, @slot) ->
            super()
            @item = @slot.item

        Relationships: Util.enum [
            'Character'
            'Item'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @item.notify(this, @Relationships.Item, game_state)

        commit: ->
            @slot.removeItem()
            @character.getCell().items.addItem(@item)

    class ChangeLevels extends Action implements Action.CharacterAction
        (@character, @cell) ->
            super()
            @stairs = @cell.feature

        shouldReschedule: false

        Relationships: Util.enum [
            'Character'
            'Stairs'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @stairs.notify(this, @Relationships.Stairs, game_state)

        commit: (game_state) ->
            game_state.switchCharacterLevel(@character, @stairs.destination)

    class Descend extends ChangeLevels
        (@character, @cell) ->
            super(@character, @cell)

    class Ascend extends ChangeLevels
        (@character, @cell) ->
            super(@character, @cell)

    class Equip extends Action implements Action.CharacterAction
        (@character, @equipmentSlot, @inventorySlot) ->
            super()
            @item = @inventorySlot.item

        Relationships: Util.enum [
            'Character'
            'Item'
        ]

        prepare: (game_state) ->
            if @item.isEquipped()
                # need to unequip the item first before equipping it in a different slot
                @success = false

                # in reverse order because the action queue is a stack
                game_state.enqueueAction(new Equip(@character, @equipmentSlot, @inventorySlot))
                game_state.enqueueAction(new Unequip(@character, @item.getSlot()))
                return

            if @equipmentSlot.containsItem()
                # need to clear the equipment slot before equipping a new item there
                @success = false

                # in reverse order because the action queue is a stack
                game_state.enqueueAction(new Equip(@character, @equipmentSlot, @inventorySlot))
                game_state.enqueueAction(new Unequip(@character, @equipmentSlot))
                return

            @character.notify(this, @Relationships.Character, game_state)
            @item.notify(this, @Relationships.Item, game_state)

        commit: ->
            @character.equipItem(@item, @equipmentSlot)


    class Unequip extends Action implements Action.CharacterAction
        (@character, @equipmentSlot) ->
            super()
            @item = @equipmentSlot.item

        Relationships: Util.enum [
            'Character'
            'Item'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @item.notify(this, @Relationships.Item, game_state)

        commit: ->
            @character.unequipItem(@equipmentSlot)

    class SwapWeapons extends Action implements Action.CharacterAction
        (@character) ->
            super()
            @toEquip = @character.equipmentSlots.preparedWeapon
            @toUnequip = @character.equipmentSlots.weapon
        
        Relationships: Util.enum [
            'Character'
            'UnequippedItem'
            'EquippedItem'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @toUnequip.item.notify(this, @Relationships.UnequippedItem, game_state)
            @toEquip.item.notify(this, @Relationships.EquippedItem, game_state)

        commit: ->
            if @toEquip.item.isEquipable()
                @toEquip.item.equip(@toUnequip)
            if @toUnequip.item.isEquipable()
                @toUnequip.item.equip(@toEquip)

            tmp = @toEquip.item
            @toEquip.item = @toUnequip.item
            @toUnequip.item = tmp

    class FireProjectile extends Action implements Action.CharacterAction
        (@character, @projectile, @trajectory) ->
            super()
        
        Relationships: Util.enum [
            'Character'
            'Projectile'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @projectile.notify(this, @Relationships.Projectile, game_state)

        commit: (game_state) ->
            @trajectory.cells[0].projectile = @projectile
            movement = new MoveProjectile(@projectile, @trajectory, 0)
            game_state.enqueueAction(movement)

    class MoveProjectile extends Action
        (@projectile, @trajectory, @index) ->
            super()
            @fromCell = @trajectory.cells[@index]
            @toCell = @trajectory.cells[@index + 1]

        Relationships: Util.enum [
            'SourceCell'
            'DestinationCell'
            'Projectile'
        ]

        prepare: (game_state) ->
            @projectile.notify(this, @Relationships.Projectile, game_state)
            @fromCell.notify(this, @Relationships.SourceCell, game_state)
            @toCell.notify(this, @Relationships.DestinationCell, game_state)

        commit: (game_state) ->
            if @toCell == @trajectory.end
                game_state.enqueueAction(new StopProjectile(@projectile, @toCell, @fromCell))
            else
                @fromCell.projectile = void
                @toCell.projectile = @projectile
                movement = new MoveProjectile(@projectile, @trajectory, @index + 1)
                game_state.enqueueAction(movement)

        getPosition: ->
            return @toCell.position

        getAnimationTime: ->
            if @toCell == @trajectory.end
                return 0
            else
                return 10

    class StopProjectile extends Action
        (@projectile, @toCell, @fromCell) ->
            super()

        Relationships: Util.enum [
            'Projectile'
            'ToCell'
            'FromCell'
        ]

        prepare: (game_state) ->
            @projectile.notify(this, @Relationships.Projectile, game_state)
            @fromCell.notify(this, @Relationships.SourceCell, game_state)
            @toCell.notify(this, @Relationships.DestinationCell, game_state)

        commit: (game_state) ->
            @fromCell.projectile = void
            @toCell.addItem(@projectile)

        getPosition: ->
            return @toCell.position

        getAnimationTime: ->
            return 10


    class Explode extends Action
        (@projectile, @cell) ->
            super()
            @cells = [@cell]
            for n in @cell.allNeighbours
                @cells.push(n)

        Relationships: Util.enum [
            'Projectile'
            'Cell'
        ]

        prepare: (game_state) ->
            @projectile.notify(this, @Relationships.Projectile, game_state)
            for c in @cells
                c.notify(this, @Relationships.Cell, game_state)

        commit: (game_state) ->
            for c in @cells
                c.projectile = @projectile
            game_state.enqueueAction(new PostExplode(@projectile, @cell, @cells))

        getPosition: ->
            return @cell.position

        getAnimationTime: ->
            return 100

    class PostExplode extends Action
        (@projectile, @cell, @cells) ->
            super()

        Relationships: Util.enum [
            'Projectile'
            'Cell'
        ]

        prepare: (game_state) ->
            @projectile.notify(this, @Relationships.Projectile, game_state)
            for c in @cells
                c.notify(this, @Relationships.Cell, game_state)

        commit: (game_state) ->
            for c in @cells
                c.projectile = void

        getPosition: ->
            return @cell.position

    class Null extends Action
        ->
            super()
            @rescheduleRequired = false



    AssetSystem.exposeAssets 'Action', {
        Move
        BumpIntoWall
        OpenDoor
        Wait
        Attack
        AttackHit
        TakeDamage
        Die
        GetStuckInWeb
        StruggleInWeb
        BreakWeb
        BecomePoisoned
        Restore
        Take
        Drop
        Descend
        Ascend
        Equip
        Unequip
        SwapWeapons
        FireProjectile
        StopProjectile
        Explode
        PostExplode
        Null
    }
