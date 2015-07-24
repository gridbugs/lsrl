export class GameState
    (grid, character) ->
        @characters = [character]
        @grid = grid
    getCurrentActionSource: -> @actionSource
    applyAction: ->
    progressSchedule: ->
    getCurrentTimeDelta: -> 100
