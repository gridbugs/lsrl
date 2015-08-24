/* A list of elements that can be in at most one list at a time.
 * Elements store the list they are currently in. When adding a
 * new element to the list, it is removed from the list which
 * currently contains it.
 */

define [
    \list_wrapper
], (ListWrapper) ->
    
    class UniqueList extends ListWrapper.ListWrapper
        (@list) ->
            super ...

        insert: (x) ->
            if x.list?
                x.list.removeElement(x)
            x.list = this
            super(x)

        removeElement: (x) ->
            x.list = void
            super(x)

    {
        UniqueList
    }
