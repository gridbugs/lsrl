define [
    \action
    \search
    \direction
    \types
    \util
], (Action, Search, Direction, Types, Util) ->

    class StraightLineMove
        (@character, @direction) ->
            @initialSurroundings =
                new StraightLineMove.SurroundingCells(@character.getCell(), @direction)
        
        hasAction: ->
            surroundings = 
                new StraightLineMove.SurroundingCells(@character.getCell(), @direction)
            return surroundings.matches(@initialSurroundings)

        canStart: -> @character.getCell()fixture.type == Types.Fixture.Null

        getAction: (game_state, cb) ->
            cb(new Action.Move(@character, @direction, game_state))

    StraightLineMove.SurroundingCells = class
        (@centre, @direction) ->
            @cells = Direction.Fronts[@direction].map (i) ~> @centre.neighbours[i]

        matches: (other) ->
            for i from 0 til @cells.length
                if @cells[i].fixture.type != other.cells[i].fixture.type
                    return false
            return true
        

    class AutoExploreOnce
        (@character) ->
            @atDestination = false
            @allExplored = false
            @findDestination()

        findDestination: ->
            result = Search.findClosest @character.getKnowledgeCell(), \
                        ((c, d) -> c.game_cell.getMoveOutCost d), \
                        ((c) -> c.known and c.fixture.type == Types.Fixture.Null), \
                        ((c) -> c.hasUnknownNeighbour())
            if result?
                @directions = result.directions
                @nextIndex = 0
                @atDestination = false
            else
                @atDestination = true
                @allExplored = true

        canStart: -> not (@atDestination or @allExplored)

        hasAction: -> not (@atDestination or @allExplored)

        getAction: (game_state, cb) ->
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
        getAction: (game_state, cb) ->


    {
        StraightLineMove
        AutoExplore
        FollowPath
    }
