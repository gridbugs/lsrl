define [
    'system/action'
    'assets/assets'
    'util'
    'asset_system'
    'types'
    'debug'
], (Action, Assets, Util, AssetSystem, Types, Debug) ->

    class Move extends Action
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

    class BumpIntoWall extends Action
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

    class OpenDoor extends Action
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

    class Wait extends Action
        (@character, @time = 0) ->
            super()
            @time += 1

        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)

        commit: ->

    class Attack extends Action
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

    class AttackHit extends Action
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
            damage = @character.weapon.getAttackDamage()
            game_state.enqueueAction(new TakeDamage(@targetCharacter, damage))

    class TakeDamage extends Action
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

    class Die extends Action
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

    class GetStuckInWeb extends Action
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

    class StruggleInWeb extends Action
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

    class BreakWeb extends Action
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

    class BecomePoisoned extends Action
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

    class Restore extends Action
        (@character) ->
            super()

        Relationships: Util.enum [
            'Character'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)

        commit: (game_state) ->
            @character.hitPoints = 100

    class Take extends Action
        (@character, @groupId, @numItems) ->
            super()
            @items = @character.getCell().items.removeItemsByGroupId(@groupId, @numItems)

        Relationships: Util.enum [
            'Character'
            'Item'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @items.forEach (item) ~>
                item.notify(this, @Relationships.Item, game_state)

        commit: ->
            letter = @character.getInventory().insertItems(@items)

    class Drop extends Action
        (@character, @groupId, @numItems) ->
            super()
            @items = @character.getInventory().removeItemsByGroupId(@groupId, @numItems)

        Relationships: Util.enum [
            'Character'
            'Item'
        ]

        prepare: (game_state) ->
            @character.notify(this, @Relationships.Character, game_state)
            @items.forEach (item) ~>
                item.notify(this, @Relationships.Item, game_state)

        commit: ->
            @character.getCell().items.insertItems(@items)

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
        Null
    }
