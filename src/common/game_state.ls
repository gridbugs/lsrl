define [
    'structures/heap'
    'structures/linked_list'
    'structures/distributed_list'
    'system/action'
    'interface/user_interface'
    'util'
    'debug'
], (Heap, LinkedList, DistributedList, Action, UserInterface, Util, Debug) ->

    class GameState
        ->
            @timeDelta = 0

            @absoluteTime = 0
            @turnCount = 0
            @schedule = new Heap (a, b) -> a.time <= b.time

            @actionQueue = []
            @continuousEffects = new DistributedList()
            @observers = new LinkedList()

        setLevel: (@level) ->
            @levelState = @level.levelState

        switchCharacterLevel: (character, destination) ->
            level = destination.level
            level.beforeSwitchTo()

            cell = destination.cell

            console.debug character
            console.debug level
            console.debug cell
            character.switchToLevel(level)

        setDescriptionProfile: (@descriptionProfile) ->
            @levelState.setDescriptionProfile(@descriptionProfile)

        setPlayerCharacter: (@playerCharacter) ->

        getPlayerCharacter: ->
            return @levelState.playerCharacter

        processObservers: ->
            @levelState.processObservers()

        registerObserver: (observer) ->
            @levelState.registerObserver(observer)

        registerCharacter: (character) ->
            character.initGameState(this)

        removeObserverNode: (node) ->
            @levelState.removeObserverNode(node)

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

        scheduleActionSource: (source, relative_time) ->
            @levelState.scheduleActionSource(source, relative_time + @absoluteTime)

        getCurrentActionSource: ->
            return @levelState.getCurrentActionSource()

        enqueueAction: (action) ->
            @levelState.enqueueAction(action)

        applySingleAction: (action) ->
            return @levelState.applySingleAction(action)

        applyAction: (action, source) ->
            @levelState.applyAction(action, source)

        processFirstAction: (source) ->
            @levelState.processFirstAction(source)

        processActions: ->
            @levelState.processActions()

        progressTurnCount: ->
            ++@turnCount

        progressSchedule: ->
            prev = @levelState.schedule.pop()
            nextTime = prev.time
            @timeDelta = nextTime - @absoluteTime
            @absoluteTime = nextTime
            @progressTurnCount()

        getCurrentTimeDelta: ->
            return @timeDelta

