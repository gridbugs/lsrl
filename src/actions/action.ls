define [
    'actions/action_status'
    'input/user_interface'
    'types'
], (ActionStatus, UserInterface, Types) ->

    class Action
        apply: (gameState) ->
            @status = new ActionStatus.ActionStatus(this, gameState)

            @prepare()

            if @status.isSuccessful()
                @commit()

                if @status.isRescheduleRequired()
                    gameState.scheduleActionSource(@getSource(), @status.getTime())

        prepare: ->
        commit: ->


    /* An action which is clearly done by a single character. */
    class CharacterAction extends Action
        (@character) ->

        getSource: ->
            return @character.getController()

    class Move extends CharacterAction
        (character, @direction) ->
            super(character)

            /* determine source and destination cells */
            @fromCell = @character.getCell()
            @toCell = @fromCell.neighbours[@direction]

        prepare: ->
            <~ @status.notify(@character, Types.Event.CharacterMove)
            <~ @status.notify(@fromCell, Types.Event.MoveFromCell)
            <~ @status.notify(@toCell, Types.Event.MoveToCell)

            @status.addTime(@character.getCurrentMoveTime(@direction))

        commit: ->
            @character.position = @toCell.position
            @fromCell.character = void
            @toCell.character = @character

    class BumpIntoWall extends CharacterAction
        (character) ->
            super(character)

        prepare: ->
            @status.addTime(5)

        commit: ->
            UserInterface.printLine("#{@character.getName()} bumps into a wall.")

    class GetStuckInWeb extends CharacterAction
        (character) ->
            super(character)

        prepare: ->

        commit: ->
            UserInterface.printLine("#{@character.getName()} gets stuck in a web.")

    class StruggleInWeb extends CharacterAction
        (character) ->
            super(character)
            @cell = @character.getCell()

        prepare: ->

        commit: ->
            --@cell.fixture.strength
            if @cell.fixture.strength == 0
                @cell.fixture.unstick()
                UserInterface.printLine("The web breaks.")
            else
                UserInterface.printLine("#{@character.getName()} struggles in the web.")

    class OpenDoor extends CharacterAction
        (character, @cell) ->
            super(character)

        prepare: ->
            @status.addTime(5)

        commit: ->
            @cell.fixture.open()
            UserInterface.printLine("Door opened.")

    class Take extends CharacterAction
        (character, @groupId, @numItems) ->
            super(character)

        prepare: ->
            @status.addTime(2)

        commit: ->
            items = @character.getCell().items.removeItemsByGroupId(@groupId, @numItems)
            char = @character.getInventory().insertItems(items)
            UserInterface.printLine("#{@character.getName()} takes #{@numItems} x #{items.first().getName()} (#{char}).")

    class Drop extends CharacterAction
        (character, @groupId, @numItems) ->
            super(character)

        prepare: ->
            @status.addTime(2)

        commit: ->
            items = @character.getInventory().removeItemsByGroupId(@groupId, @numItems)
            @character.getCell().items.insertItems(items)
            UserInterface.printLine("#{@character.getName()} drops #{@numItems} x #{items.first().getName()}.")

    class Attack extends CharacterAction
        (character, @direction) ->
            super(character)
            @targetCell = character.getCell().neighbours[@direction]

        prepare: ->
            @target = @targetCell.character

            if not @target?
                @status.fail('no target')
                return

            @status.addTime(@character.getCurrentAttackTime())
            @damage = @character.getCurrentAttackDamage()
            #@targetResistance = @target.getCurrentResistance()
            #@netDamage = Math.max(0, @grossDamage - @targetResistance)

        commit: ->
            @status.gameState.enqueueAction(new TakeDamage(@target, @damage))
            UserInterface.printLine("#{@character.getName()} attacks the #{@target.getName()}.")

    class TakeDamage extends CharacterAction
        (character, @damage) ->
            super(character)

        prepare: ->
            @status.setNoReschedule()

        commit: ->
            @status.setNoReschedule()
            @damage.apply(@character, @status.gameState)
            if not @character.isAlive()
                @status.gameState.enqueueAction(new Die(@character))

    class Die extends CharacterAction
        (character) ->
            super(character)

        prepare: ->
            @status.setNoReschedule()
            <~ @status.notify(@character, Types.Event.Death)

        commit: ->
            @character.die(@status.gameState)
            UserInterface.printLine("#{@character.getName()} dies.")

    class Resurrect extends CharacterAction
        (character) ->
            super(character)

        prepare: ->
            @status.setNoReschedule()

        commit: ->
            @character.resurrect()
            UserInterface.printLine("#{@character.getName()} is resurrected by some force.")

    class Null extends Action
        ->
            super()

        prepare: ->
            @status.setNoReschedule()

        commit: ->

    class Wait extends CharacterAction
        (character, @duration) ->
            super(character)

        prepare: ->
            @status.addTime(@duration)

        commit: ->

    class BecomePoisoned extends CharacterAction
        (character, @damage_rate, @duration) ->
            super(character)

        prepare: ->
            @status.setNoReschedule()

        commit: ->
            @character.becomePoisoned(@status.gameState, @damage_rate, @duration)

    class RemoveContinuousEffect extends Action
        (@node, @effect) ->
            super()

        prepare: ->
            @status.setNoReschedule()

        commit: ->
            @effect.onRemove()
            @status.gameState.removeContinuousEffectNode(@node)
    {
        Move
        BumpIntoWall
        GetStuckInWeb
        StruggleInWeb
        OpenDoor
        Take
        Drop
        Attack
        Null
        Wait
        TakeDamage
        BecomePoisoned
        RemoveContinuousEffect
        Resurrect
    }
