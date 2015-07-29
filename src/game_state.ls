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

            @actionQueue = []

        scheduleActionSource: (as, relative_time) ->
            @schedule.insert new ScheduleEntry as, (relative_time + @absoluteTime)


        getCurrentActionSource: -> @schedule.peak!.actionSource
        pushAction: (action) ->
            @actionQueue.push action
            for t in action.traits
                t.process action

        applyActionQueue: ->
            while @actionQueue.length != 0
                action = @actionQueue.pop!
                if not action.cancelled?
                    action.commit!

        progressSchedule: ->
            prev = @schedule.pop!
            nextTime = prev.time
            @timeDelta = nextTime - @absoluteTime;
            @absoluteTime = nextTime
        getCurrentTimeDelta: -> @timeDelta

    { GameState }
