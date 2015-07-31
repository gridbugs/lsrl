define [
    \heap
    \util
], (heap, Util) ->

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

        applyAction: (action) ->
            action_queue = [action]
            while action_queue.length != 0
                current_action = action_queue.pop!
                cancelled = false
                for event in current_action.events
                    event.forEachMatchingEffect (effect) ~>
                        cancelled := cancelled or effect.cancells event
                        actions = effect.getActions event, this
                        for new_action in actions
                            action_queue.push new_action

                    break if cancelled

                if not cancelled
                    current_action.commitAndReschedule!
            
        progressSchedule: ->
            prev = @schedule.pop!
            nextTime = prev.time
            @timeDelta = nextTime - @absoluteTime;
            @absoluteTime = nextTime
        getCurrentTimeDelta: -> @timeDelta

    { GameState }
