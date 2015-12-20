define [
], ->

    class Destination
        (@level, @feature) ->

        setCell: (@cell) ->

    class Connection
        (@fromLevel, @toLevel, @fromFeature, @toFeature) ->
            @fromDestination = new Destination(@fromLevel, @fromFeature)
            @toDestination = new Destination(@toLevel, @toFeature)

            @fromFeature.destination = @toDestination
            @toFeature.destination = @fromDestination

        connectFromCell: (@fromCell) ->
            @fromCell.feature = @fromFeature
            @fromDestination.setCell(@fromCell)

        connectToCell: (@toCell) ->
            @toCell.feature = @toFeature
            @toDestination.setCell(@toCell)

        connect: (cell, direction) ->
            switch direction
            |   Connection.TO => @connectToCell(cell)
            |   Connection.FROM => @connectFromCell(cell)

    Connection.TO = 'TO'
    Connection.FROM = 'FROM'

    return Connection
