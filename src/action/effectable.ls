define [
    'structures/avl_tree'
], (AvlTree) ->
    class Effectable
        ->
            @effects = new AvlTree()

        forEachMatchingEffect: (event_type, callback) ->
            @effects.findAllByKey(event_type, callback)

        forEachEffect: (callback) ->
            @effects.forEach(callback)

        addEffect: (effect) ->
            @effects.insert(effect.eventType, effect)
