define [
], ->

    class TreeWrapper
        (@tree) ->

        insert: (key, value) -> @tree.insert(key, value)
        forEach: (f) -> @tree.forEach(f)
        findByKey: (key) -> @tree.findByKey(key)
        deleteByKey: (key) -> @tree.deleteByKey(key)
        empty: -> @tree.empty()
        top: -> @tree.top()
        containsKey: (key) -> @tree.containsKey(key)

    {
        TreeWrapper
    }
