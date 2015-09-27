define [
    'action/action'
    'structures/search'
    'structures/direction'
    'types'
    'util'
    'debug'
], (Action, Search, Direction, Types, Util, Debug) ->

    class SurroundingCells
        (centre, direction) ->
            cells = Direction.Fronts[direction].map (centre.neighbours.)
            @cellStates = cells.map (.isEmpty())

        matches: (other) ->
            for i from 0 til @cellStates.length
                if @cellStates[i] != other.cellStates[i]
                    return false
            return true

    class StraightLineMove
        (@character, @direction) ->
            @initialSurroundings =
                new SurroundingCells(@character.getCell(), @direction)

        hasAction: ->
            dest = @character.getCell().neighbours[@direction]
            if not dest.isEmpty()
                return false
            surroundings = new SurroundingCells(@character.getCell(), @direction)
            return surroundings.matches(@initialSurroundings)

        canStart: -> @character.getCell().fixture.type == Types.Fixture.Null

        getAction: (game_state, cb) ->
            cb(new Action.Move(@character, @direction, game_state))

    class AutoExploreOnce
        (@character) ->
            @atDestination = false
            @allExplored = false
            @findDestination()

        findDestination: ->
            result = Search.findClosest @character.getKnowledgeCell(), \
                        ((c, d) -> c.game_cell.getMoveOutCost d), \
                        ((c) ~> c.known and (c.game_cell.character == @character or c.game_cell.isEmpty() or c.fixture.type == Types.Fixture.Door)), \
                        ((c) -> c.hasUnknownNeighbour()), \
                        true
            if result?
                @directions = result.directions
                @path = result.path
                @nextIndex = 0
                @atDestination = false
            else
                @atDestination = true
                @allExplored = true

        canStart: -> not (@atDestination or @allExplored)

        hasAction: -> not (@atDestination or @allExplored)

        getAction: (game_state, cb) ->

            if @path[@nextIndex].fixture.type == Types.Fixture.Door and not @path[@nextIndex].fixture.isOpen()
                action = new Action.Move(@character, @directions[@nextIndex], game_state)
                @atDestination = true
                cb(action)
                return


            action = new Action.Move(@character, @directions[@nextIndex], game_state)
            ++@nextIndex
            if @nextIndex == @directions.length
                @atDestination = true

            cb(action)

    class AutoExplore extends AutoExploreOnce
        (@character) -> super ...

        hasAction: ->
            if @atDestination
                @findDestination()

            return super ...

    class FollowPath
        (@character, @directions) ->
            @index = 0

        canStart: -> @index < @directions.length
        hasAction: -> @index < @directions.length

        getAction: (game_state, cb) ->
            action = new Action.Move(@character, @directions[@index], game_state)
            ++@index
            cb action

    {
        StraightLineMove
        AutoExplore
        FollowPath
    }
