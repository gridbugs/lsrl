define [\heap], (heap) ->

    class ScheduleEntry
        (action_source, time) ->
            @actionSource = action_source
            @time = time

    class GameState
        (grid, character) ->
            @playerCharacter = character
            @characters = [character]
            @grid = grid
            @timeDelta = 0

            @absoluteTime = 0
            @schedule = new heap.Heap (a, b) -> a.time <= b.time


        scheduleActionSource: (as, relative_time) ->
            @schedule.insert new ScheduleEntry as, (relative_time + @absoluteTime)


        getCurrentActionSource: -> @schedule.peak!.actionSource
        applyAction: (action) -> action.commit! #XXX
        progressSchedule: ->
            prev = @schedule.pop!
            nextTime = prev.time
            @timeDelta = nextTime - @absoluteTime;
            @absoluteTime = nextTime
        getCurrentTimeDelta: -> @timeDelta

    { GameState }
