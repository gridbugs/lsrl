require! './Grid.ls': {Grid}
require! './Tiles.ls': {Tiles}

export class CellAutomataTestGenerator
    generate: (T, x, y) ->
        grid = new Grid T, x, y
        grid.forEach (c) -> c.type = Tiles.TREE
        return grid
