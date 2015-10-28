define [
    'system/effectable'
    'debug'
], (Effectable, Debug) ->

    class Feature implements Effectable
        ->
            @initEffectable()

        getOpacity: ->
            return 0

        isSolid: ->
            return true

        isBenign: ->
            return true

    # create debugging features for cells
    debugFeatureObj = {}
    for c in Debug.Chars
        debugFeatureObj[c] = class extends Feature

    Feature.DebugFeatures = debugFeatureObj

    Feature.NullFeature  = class extends Feature
        isSolid: ->
            return false

    return Feature
