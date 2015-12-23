define [
    'structures/heap'
    'structures/linked_list'
    'structures/distributed_list'
    'system/action'
    'interface/user_interface'
    'assets/assets'
    'util'
    'debug'
], (Heap, LinkedList, DistributedList, Action, UserInterface, Assets, Util, Debug) ->

    class ScheduleEntry
        (action_source, time) ->
            @actionSource = action_source
            @time = time
            @active = true

    class LevelState
        (@level, @gameState) ->

            @schedule = new Heap (a, b) -> a.time <= b.time

            @actionQueue = []
            @observers = new LinkedList()

        setDescriptionProfile: (@descriptionProfile) ->

        setPlayerCharacter: (@playerCharacter) ->
            @setDescriptionProfile(new Assets.DescriptionProfile.Default(@playerCharacter))

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

        purgeActionSource: (source) ->
            @schedule.forEach (entry) ->
                if entry.actionSource == source
                    entry.active = false

        getCurrentActionSource: ->
            while true
                top = @schedule.peak()
                Debug.assert(top?, 'No action sources remaining!')

                if top.active
                    return top.actionSource

                @schedule.pop()

        enqueueAction: (action) ->
            @actionQueue.push(action)

        applySingleAction: (action, callback) ->
            success = action.apply(@gameState)
            if success and @descriptionProfile.accept(action)
                UserInterface.printDescriptionLine(action.describe())
                time = action.time
            else
                time = 0

            UserInterface.drawCharacterKnowledge(@gameState.getPlayerCharacter(), @gameState)
            UserInterface.updateHud(@gameState.getPlayerCharacter())
            setTimeout(callback, time, success)

        applyAction: (action, source, callback) ->
            @enqueueAction(action)
            <~ @processFirstAction(source)
            <~ @processActions()
            callback()

        processFirstAction: (source, callback) ->
            if @actionQueue.length != 0
                current_action = @actionQueue.pop()
                success <~ @applySingleAction(current_action)
                if success
                    if source.active and current_action.shouldReschedule
                        @scheduleActionSource(source, current_action.time)

                    callback(true)
                else
                    @processFirstAction(source, callback)
            else
                callback(false)

        processActions: (callback) ->
            if @actionQueue.length == 0
                callback()
            else
                current_action = @actionQueue.pop()
                success <~ @applySingleAction(current_action)
                @processActions(callback)

