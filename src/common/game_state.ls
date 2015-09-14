define [
    'structures/heap'
    'structures/linked_list'
    'actions/action'
    'controllers/single_action_controller'
    'util'
    'debug'
], (Heap, LinkedList, Action, SingleActionController, Util, Debug) ->

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
            @turnCount = 0
            @schedule = new Heap.Heap (a, b) -> a.time <= b.time

            @actionQueue = []

            @continuousEffects = new LinkedList.LinkedList()

        registerContinuousEffect: (effect, length) ->
            node = @continuousEffects.insert(effect)
            remover = new Action.RemoveContinuousEffect(node)
            remover_controller = new SingleActionController(remover)
            @scheduleActionSource(remover_controller, length)

        removeContinuousEffectNode: (node) ->
            @continuousEffects.removeNode(node)

        getTurnCount: ->
            return @turnCount

        getTime: ->
            return @absoluteTime

        scheduleActionSource: (as, relative_time) ->
            entry = new ScheduleEntry as, (relative_time + @absoluteTime)
            @schedule.insert(entry)

        getCurrentActionSource: ->
            top = @schedule.peak()
            if top?
                return top.actionSource
            else
                Debug.assert(false, 'No action sources remaining!')

        enqueueAction: (action) ->
            @actionQueue.push(action)

        applyAction: (action) ->
            ret = []
            @enqueueAction(action)
            while @actionQueue.length != 0
                current_action = @actionQueue.pop()
                current_action.apply(this)

            return ret

        progressSchedule: ->
            prev = @schedule.pop()
            nextTime = prev.time
            @timeDelta = nextTime - @absoluteTime
            @absoluteTime = nextTime
            ++@turnCount

        getCurrentTimeDelta: ->
            return @timeDelta

    {
        GameState
    }
