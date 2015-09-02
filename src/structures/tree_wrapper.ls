define [
], ->

    class TreeWrapper
        (@tree) ->

        insert: (key, value) -> @tree.insert(key, value)
        forEach: (f) -> @tree.forEach(f)
        findByKey: (key, callback) -> @tree.findByKey(key, callback)
        deleteByKey: (key, callback) -> @tree.deleteByKey(key, callback)
        empty: -> @tree.empty()
        top: -> @tree.top()
        containsKey: (key) -> @tree.containsKey(key)

    {
        TreeWrapper
    }
