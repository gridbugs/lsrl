define [
    'structures/heap'
    'structures/linked_list'
    'structures/distributed_list'
    'system/action'
    'interface/user_interface'
    'util'
    'debug'
], (Heap, LinkedList, DistributedList, Action, UserInterface, Util, Debug) ->

    class ScheduleEntry
        (action_source, time) ->
            @actionSource = action_source
            @time = time

    class GameState
        ->
            @timeDelta = 0

            @absoluteTime = 0
            @turnCount = 0
            @schedule = new Heap (a, b) -> a.time <= b.time

            @actionQueue = []
            @continuousEffects = new DistributedList()
            @observers = new LinkedList()

        setDescriptionProfile: (@descriptionProfile) ->

        setPlayerCharacter: (@playerCharacter) ->

        processObservers: ->
            @observers.forEach (observer) ~>
                observer.observe(this)

        registerObserver: (observer) ->
            node = @observers.insert(observer)
            observer.setObserverNode(node)

        registerCharacter: (character) ->
            character.initGameState(this)

        removeObserverNode: (node) ->
            @observers.removeNode(node)

        processContinuousEffects: ->
            if @timeDelta > 0
                @continuousEffects.forEach (effect) ~>
                    effect.apply(@timeDelta, this)

                @processActions()

        registerContinuousEffect: (effect, character) ->
            node = character.continuousEffects.insert(effect)
            effect.setNode(node)

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

        applySingleAction: (action) ->
            ret = action.apply(this)
            if @descriptionProfile.accept(action) and action.describe?
                UserInterface.printDescriptionLine(action.describe())
            return ret

        applyAction: (action, source) ->
            @enqueueAction(action)
            @processFirstAction(source)
            @processActions()

        processFirstAction: (source) ->
            while @actionQueue.length != 0
                current_action = @actionQueue.pop()
                if @applySingleAction(current_action)
                    if source.active
                        @scheduleActionSource(source, current_action.time)
                    return

        processActions: ->
            while @actionQueue.length != 0
                current_action = @actionQueue.pop()
                @applySingleAction(current_action)

        progressTurnCount: ->
            ++@turnCount

        progressSchedule: ->
            prev = @schedule.pop()
            nextTime = prev.time
            @timeDelta = nextTime - @absoluteTime
            @absoluteTime = nextTime
            @progressTurnCount()

        getCurrentTimeDelta: ->
            return @timeDelta

