require! './Heap.ls': {Heap}

class ScheduleEntry
    (action_source, time) ->
        @actionSource = action_source
        @time = time

export class GameState
    (grid, character) ->
        @playerCharacter = character
        @characters = [character]
        @grid = grid

        @absoluteTime = 0
        @schedule = new Heap (a, b) -> a.time <= b.time


    scheduleActionSource: (as, relative_time) ->
        @schedule.insert new ScheduleEntry as, (relative_time + @absoluteTime)
        

    getCurrentActionSource: -> @schedule.peak!.actionSource
    applyAction: ->
    progressSchedule: ->
    getCurrentTimeDelta: -> 100
