export class GameState
    (action_source) ->
        @actionSource = action_source
    getCurrentActionSource: -> @actionSource
    applyAction: ->
    progressSchedule: ->
    getCurrentTimeDelta: -> 100
