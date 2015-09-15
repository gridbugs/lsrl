define [
    'structures/grid'
    'cell/fixture'
    'cell/ground'
    'structures/vec2'
    'util'
    'prelude-ls'
], (Grid, Fixture, Ground, Vec2, Util, Prelude) ->

    filter = Prelude.filter
    map = Prelude.map
    empty = Prelude.empty

    class Neighbour
        (@vertexCoord, @edgeCoord) ->
            @connected = false

        collapse: (vertex_grid) ->
            @vertex = (vertex_grid.getCart @vertexCoord).vertex

    class Vertex
        (@grid, @x, @y) ->
            @cell = @grid.get(@x, @y)
            @cell.setFixture Fixture.Tree
            @visited = false
            coord = new Vec2(@x, @y)
            neighbour_coords = [
                coord.add(new Vec2(0, 2))
                coord.add(new Vec2(0, -2))
                coord.add(new Vec2(2, 0))
                coord.add(new Vec2(-2, 0))
            ] |> filter (v) ~>
                v.x > 0 and v.y > 0 and \
                    v.x < @grid.width - 1 and v.y < @grid.height - 1

            edge_coords = neighbour_coords |> map (v) ~>
                coord.add(v.subtract(coord).divide(2))

            @neighbours = []
            for i from 0 til neighbour_coords.length
                @neighbours.push new Neighbour neighbour_coords[i], edge_coords[i]

            Util.shuffleArrayInPlace @neighbours

        collapse: (vertex_grid) ->
            for n in @neighbours
                n.collapse vertex_grid

        toString: -> @cell.position.toString()

    class VertexCell
        (@x, @y) ->

    class SearchNode
        (@vertex, @edge_cell) ->

    class MazeGenerator
        generateGrid: (T, width, height) ->
            grid = new Grid.Grid T, width, height
            vertex_grid = new Grid.Grid VertexCell, width, height
            vertices = []
            grid.forEach (c, i, j) ~>
                c.setGround Ground.Stone
                c.setFixture Fixture.Wall
                if i % 2 == 1 and j % 2 == 1 and i < width - 1 and j < height - 1
                    v = new Vertex grid, i, j
                    vertex_grid.get(i, j).vertex = v
                    vertices.push v

            for v in vertices
                v.collapse vertex_grid

            @createMazeDepthFirst (Util.getRandomElement vertices), grid

            @grid = grid
            return grid

        getStartingPointHint: ->
            while true
                c = @grid.getRandom!
                if c.fixture.getName! == 'Null'
                    return c

        createMazeDepthFirst: (start_vertex, grid) ->

            start_vertex.visited = true
            stack = [new SearchNode(start_vertex, null)]

            while not empty stack
                current = stack.pop!
                current.vertex.cell.setFixture Fixture.Null
                if current.edge_cell?
                    current.edge_cell.setFixture Fixture.Null

                for n in current.vertex.neighbours
                    if not n.vertex.visited
                        edge_cell = grid.getCart n.edgeCoord
                        n.vertex.visited = true
                        node = new SearchNode n.vertex, edge_cell
                        stack.push node


    {
        MazeGenerator
    }
