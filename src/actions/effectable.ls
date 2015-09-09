define [
    'structures/avl_tree'
], (AvlTree) ->
    class Effectable
        ->
            @effects = new AvlTree.AvlTree()

        forEachMatchingEffect: (event_type, callback) ->
            @effects.findAllByKey(event_type, callback)

        forEachEffect: (callback) ->
            console.debug(this)
            @effects.forEach(callback)

        addEffect: (effect) ->
            @effects.insert(effect.eventType, effect)
