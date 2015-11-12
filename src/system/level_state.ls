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

    class LevelState
        (@gameState) ->

            @schedule = new Heap (a, b) -> a.time <= b.time

            @actionQueue = []
            @observers = new LinkedList()

        setDescriptionProfile: (@descriptionProfile) ->

        setPlayerCharacter: (@playerCharacter) ->

        processObservers: ->
            @observers.forEach (observer) ~>
                observer.observe(@gameState)

        registerObserver: (observer) ->
            node = @observers.insert(observer)
            observer.setObserverNode(node)

        registerCharacter: (character) ->
            character.initGameState(@gameState)

        removeObserverNode: (node) ->
            @observers.removeNode(node)

        scheduleActionSource: (source, relatitve_time) ->
            entry = new ScheduleEntry(source, (@gameState.getTime() + relatitve_time))
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
            ret = action.apply(@gameState)
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

