define [
    'action/event'
    'action/action'
    'action/damage'
    'interface/user_interface'
    'types'
], (Event, Action, Damage, UserInterface, Types) ->

    class Poisoned
        (@character, @damage_rate) ->

        apply: (time_delta, game_state) ->
            damage = new Damage.PoisonDamage(@damage_rate * time_delta)
            game_state.enqueueAction(new Action.TakeDamage(@character, damage))

        onRemove: ->
            UserInterface.printLine("No longer poisoned.")

    class ReactiveEffect
        (@eventType) ->

    class WebEntry extends ReactiveEffect
        ->
            super(Types.Event.MoveToCell)

        apply: (status) ->
            status.gameState.enqueueAction(
                new Action.GetStuckInWeb(status.action.character)
            )

    class WebExit extends ReactiveEffect
        ->
            super(Types.Event.MoveFromCell)

        apply: (status) ->
            status.fail('stuck in web')
            status.gameState.enqueueAction(
                new Action.StruggleInWeb(status.action.character)
            )

    class ResurrectOnDeath extends ReactiveEffect
        ->
            super(Types.Event.Death)

        apply: (status) ->
            status.fail('resurrecting')
            status.gameState.enqueueAction(
                new Action.Resurrect(status.action.character)
            )

    class CellIsSticky
        (@cell, @fixture) ->

        match: (event) ->
            event.type == Types.Event.MoveFromCell and event.cell == @cell

        cancells: (event) -> true

        getActions: (event, game_state) ->
            if @fixture.strength > 0
                return [new Action.TryUnstick(event.character, @fixture, game_state)]
            else
                return [new Action.Unstick(event.character, @fixture, game_state)]


    {
        WebEntry
        WebExit
        Poisoned
        ResurrectOnDeath
    }

