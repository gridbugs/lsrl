define [
    'assets/actions/actions'
    'types'
    'type_system'
], (Actions, Types, TypeSystem) ->

    class Solid
        notify: (action, relationship, game_state) ->
            if action.type == Types.Action.Move and relationship == action.Relationships.DestinationCell
                action.success = false

                game_state.enqueueAction(new Actions.BumpIntoWall(action.character, action.toCell))

    TypeSystem.makeType 'Effect', {
        Solid
    }
