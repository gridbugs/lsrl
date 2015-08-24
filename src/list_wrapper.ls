define [

], ->

    class ListWrapper
        (@list) ->

        length: -> @list.length()
        empty: -> @list.empty()
        first: -> @list.first()
        insert: (x) -> @list.insert(x)
        forEach: (f) -> @list.forEach(f)
        forEachSatisfying: (f) -> @list.forEachSatisfying(f)
        getFirstSatisfying: (p) -> @list.getFirstSatisfying(p)
        getAllSatisfying: (p) -> @list.getAllSatisfying(p)
        removeAllSattisfying: (p) -> @list.removeAllSatisfying(p)
        removeElement: (e) -> @list.removeElement(e)
        toArray: -> @list.toArray()

    {
        ListWrapper
    }
