define [\util, \grid, \tile, 'prelude-ls', \cell], (util, grid, tile, prelude, Cell) ->

    filter = prelude.filter
    map = prelude.map
    each = prelude.each

    const OPEN_SPACE_RATIO = 0.4

    class CACell
        (x, y) ->
            @x = x
            @y = y
            @alive = Math.random() < 0.5
            @alive_next = @alive

        step: ->
            @alive = @alive_next

        toString: -> if @alive then " " else @groupIdx

        countAliveNeighbours: -> @allNeighbours |> filter (.alive) |> (.length)

    class CellAutomataTestGenerator

        tryGenerateGrid: (x, y) ->
            @ca_grid = new grid.Grid CACell, x, y

            for i from 0 to 4
                @step 4, 8, 5, 5
            
            @clean!
            
            @classifySpaces!
     
        generateGrid: (T, x, y) ->
           
            while true
                @tryGenerateGrid x, y
                if @maxSpace.length >= (x*y*OPEN_SPACE_RATIO)
                    break

            game_grid = new grid.Grid T, x, y
            game_grid.forEach (c, i, j) ~>
                if @ca_grid.get(i, j).alive
                    c.become Cell.wallPrototype!
                else
                    c.become Cell.floorPrototype tile.Tiles.DIRT

            @maxGridSpace = @maxSpace |> map (x)~>game_grid.getCart x

            return game_grid

        getStartingPointHint: -> util.getRandomElement @maxGridSpace

        clean: ->
            @ca_grid.forEach (c) ->
                count = c.countAliveNeighbours!
                if count > 5
                    c.alive = true
                if count < 2
                    c.alive = false

        step: (live_min, live_max, res_min, res_max) ->
            @ca_grid.forEach (c) ->

                if c.distanceToEdge == 0
                    c.alive_next = true
                    return

                count = c.countAliveNeighbours!
                
                if c.alive and (count < live_min or count > live_max)
                    c.alive_next = false

                if not c.alive and count >= res_min and count <= res_max
                    c.alive_next = true

            @ca_grid.forEach (.step!)

        floodFillClassify: (c) ->
            @spaces[@currentGroupIdx].push c
            c.groupIdx = @currentGroupIdx
            for n in c.allNeighbours
                if not n.alive and not n.groupIdx?
                    @floodFillClassify n

        classifySpaces: ->
            @spaces = []
            @currentGroupIdx = 0
            
            @ca_grid.forEach (c) ~>
                if not c.alive and not c.groupIdx?
                    @spaces[@currentGroupIdx] = []
                    @floodFillClassify c
                    ++@currentGroupIdx
            
            max_space_length = 0
            max_space = void
            for s in @spaces
                if s.length > max_space_length
                    max_space_length = s.length
                    max_space = s
            @maxSpace = max_space

    { CellAutomataTestGenerator }
