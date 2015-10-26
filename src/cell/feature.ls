define [
    'action/effectable'
    'debug'
    'type_system'
], (Effectable, Debug, TypeSystem) ->

    class Feature implements Effectable
        ->
            @effects = []

        getOpacity: ->
            return 0

        isSolid: ->
            return true

    # create debugging features for cells
    debugFeatureObj = {}
    for c in Debug.Chars
        debugFeatureObj[c] = class extends Feature

    Feature.DebugFeatures = TypeSystem.makeType('Feature', debugFeatureObj)

    Feature.NullFeature  = class extends Feature
        isSolid: ->
            return false

    return Feature
