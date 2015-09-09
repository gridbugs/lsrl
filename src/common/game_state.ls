define [
    'structures/heap'
    'util'
    'debug'
], (Heap, Util, Debug) ->

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
            @schedule = new Heap.Heap (a, b) -> a.time <= b.time

            @actionQueue = []

        scheduleActionSource: (as, relative_time) ->
            entry = new ScheduleEntry as, (relative_time + @absoluteTime)
            @schedule.insert entry

        getCurrentActionSource: ->
            top = @schedule.peak()
            if top?
                return top.actionSource
            else
                Debug.assert(false, 'No action sources remaining!')

        applyAction: (action) ->
            ret = []
            @actionQueue.push(action)
            while @actionQueue.length != 0
                current_action = @actionQueue.pop()
                current_action.apply(this)
                /*
                for event in current_action.events
                    event.forEachMatchingEffect (effect) ~>
                        cancelled := cancelled or effect.cancells event
                        actions = effect.getActions event, this
                        for new_action in actions
                            action_queue.push new_action

                    break if cancelled

                if not cancelled
                    descriptions = current_action.commitAndReschedule!
                    for desc in descriptions
                        ret.push desc
                */

            return ret

        progressSchedule: ->
            prev = @schedule.pop!
            nextTime = prev.time
            @timeDelta = nextTime - @absoluteTime
            @absoluteTime = nextTime
        getCurrentTimeDelta: -> @timeDelta

    {
        GameState
    }
