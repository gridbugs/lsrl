define [
    'util'
    'types'
], (Util, Types) ->
    class BaseGenerator
        getStartingPointHint: ->
            candidates = @grid.asArrayWhere (c) -> c.feature.type == Types.Feature.Null
            if candidates.length == 0
                Util.printDebug 'No suitable starting point'
                return @grid.get(0, 0)
            else
                return Util.getRandomElement(candidates)
