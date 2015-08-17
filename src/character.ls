define [
    \action
    \control
    \knowledge
    \recursive_shadowcast
    \omniscient
    \direction
    \ground
    \fixture
    \flood
    \search
    \types
    \util
    'prelude-ls'
    \config
], (Action, Control, Knowledge, Shadowcast, Omniscient, Direction, Ground, Fixture, Flood, Search, Types, Util, Prelude, Config) ->

    map = Prelude.map

    class AutoPath
        (@character, @directions) ->
            @index = 0

        isStopping: -> @index >= @directions.length
        getAction: (game_state) ->
            action = new Action.Move @character, Direction.AllDirections[@directions[@index]], \
                game_state
            ++@index
            return action


    class AutoMove
        (@direction) ->

    class AutoExplore
        (@character) ->
            if Config.AUTOEXPLORE_ALL
                @minSteps = 1000000000
            else
                @minSteps = 20

            @stepCount = 0
            @stopping = false
            @findDestination!

        isAtDestination: -> @character.getCell!position.equals @destination.position

        hasUnexploredAreas: -> @possible
        isStopping: -> @stopping
        minStepsPassed: -> @stepCount >= @minSteps

        findDestination: ->
            result = Search.findClosest @character.getKnowledgeCell!, \
                        ((c, d) -> c.game_cell.getMoveOutCost d), \
                        ((c) -> c.known and c.fixture.type == Types.Fixture.Null), \
                        ((c) -> c.hasUnknownNeighbour!)

            if result?
                @possible = true
                @directions = result.directions
                @nextIndex = 0
                @destination = result.cell.game_cell
            else
                @possible = false


        getAction: (game_state) ->
            d_idx = @directions[@nextIndex]
            direction =  Direction.AllDirections[d_idx]
            return new Action.Move @character, direction, game_state

        proceed: ->
            ++@nextIndex
            ++@stepCount

            /* Search for a new destination regardless of whether minStepsPassed! is true.
             * In the case where the last unexplored area is reached, but this object didn't
             * realize because it didn't search for new paths due to minStepsPassed! being true.
             */
            if @isAtDestination!
                @findDestination!
                if @minStepsPassed!
                    @stopping = true

    class Surroundings
        (@centre, @direction) ->
            @cells = Direction.Fronts[@direction.index] |> map (i) ~> @centre.neighbours[i]

        equals: (other) ->
            for i from 0 til @cells.length
                if @cells[i].fixture.type != other.cells[i].fixture.type
                    return false
            return true

    class PlayerCharacter
        (@position, @inputSource, @grid, @ui) ->
            @effects = []
            @knowledge = new Knowledge.Knowledge grid
            @viewDistance = 20

            if Config.OMNISCIENT_PLAYER
                @observe_fn = Omniscient.observe
            else
                @observe_fn = Shadowcast.observe

            @autoMode = null
            @autoExplore = null
            @path = null

        forEachEffect: (f) ->
            for e in @effects
                f e

        getAction: (game_state, cb) ->

            if not (@autoMode == null and @autoExplore == null and @path == null)
                if @inputSource.dirty
                    Util.printDrawer "Key pressed. Cancelling automatic move."
                    @autoMode = null
                    @autoExplore = null
                    @path = null

            if @autoMode? and @autoMode.constructor == AutoMove
                new_surroundings = new Surroundings @getCell!, @autoMode.direction
                if @surroundings.equals new_surroundings and @surroundings.centre.position.add(Direction.DirectionVectorsByIndex[@surroundings.direction.index]).equals(new_surroundings.centre.position)
                    @surroundings = new_surroundings
                    cb new Action.Move this, @autoMode.direction, game_state
                    return
                else
                    @autoMode = null

            if @path?
                if @path.isStopping!
                    @path = null
                    @getAction game_state, cb
                    return

                action = @path.getAction game_state
                cb action
                return

            if @autoExplore?
                @autoExplore.proceed!

                if not @autoExplore.hasUnexploredAreas!
                    Util.printDrawer "No further unexplored areas."
                    @autoExplore = null
                    @getAction game_state, cb
                    return

                if @autoExplore.isStopping!
                    @autoExplore = null
                    @getAction game_state, cb
                    return

                cb @autoExplore.getAction game_state
                return

            if @autoMode == null and @autoExplore == null and @path == null
                @inputSource.getControl (control) ~>
                    if not control?
                        @getAction game_state, cb
                        return

                    a = void
                    if control.type == Control.ControlTypes.Direction
                        a = new Action.Move this, control.direction, game_state
                        if not @canEnterCell a.toCell
                            @getAction game_state, cb
                            return

                    else if control.type == Control.ControlTypes.AutoDirection
                        a = new Action.Move this, control.direction, game_state
                        @autoMode = new AutoMove control.direction
                        @surroundings = new Surroundings @getCell!, @autoMode.direction
                    else if control.type == Control.ControlTypes.AutoExplore

                        if @getCell!fixture.type != Types.Fixture.Null
                            Util.printDrawer "Must be in open space."
                            @getAction game_state, cb
                            return

                        @autoExplore = new AutoExplore this
                        if not @autoExplore.hasUnexploredAreas!
                            Util.printDrawer "No unexplored areas!"
                            @autoExplore = null
                            @getAction game_state, cb
                            return

                        a = @autoExplore.getAction game_state
                    else if control.type == Control.ControlTypes.NavigateToCell
                        @navigateToCell @position, game_state, cb
                        return
                    else
                        @getAction game_state, cb
                        return

                    cb a

        navigateToCell: (start_coord, game_state, cb) ->
            @ui.selectCell start_coord, this, game_state, (coord) ~>
                if not coord?
                    @getAction game_state, cb
                    return
                dest_cell = @grid.getCart coord
                result = Search.findPath @getKnowledgeCell(), \
                    ((c, d) -> c.game_cell.getMoveOutCost d), \
                    ((c) -> c.known and c.fixture.type == Types.Fixture.Null), \
                    dest_cell
                
                if result?
                    @path = new AutoPath this, result.directions
                    @getAction game_state, cb
                else
                    Util.printDrawer "Can't reach selected cell."
                    @navigateToCell coord, game_state, cb



        canEnterCell: (c) -> not (c.fixture.type == Types.Fixture.Wall)
        getCell: -> @grid.getCart @position
        getKnowledgeCell: -> @knowledge.grid.getCart @position

        getName: -> "The player"

        canSeeThrough: (cell) ->
            cell.fixture.type != Types.Fixture.Wall

        observe: (game_state) ->
            @observe_fn this, game_state

    {
        PlayerCharacter
    }
