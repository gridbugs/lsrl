define [
    'actions/skill'
    'actions/action_status'
    'input/user_interface'
    'types'
], (Skill, ActionStatus, UserInterface, Types) ->

    class Action
        apply: (gameState) ->
            @status = new ActionStatus.ActionStatus(this, gameState)
        
            @prepare()

            if @status.isSuccessful()
                @commit()

                if @status.isRescheduleRequired()
                    gameState.scheduleActionSource(@getSource(), @status.getTime())

                return @status.getMessage()
            else
                return void

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

    {
        Move
        BumpIntoWall
    }
