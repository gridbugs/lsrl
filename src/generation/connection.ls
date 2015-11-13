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
