/* Groups elements of the same type (using their 'type' field)
 * into arrays keyed by type id.
 */

define [
    \list_wrapper
], (ListWrapper) ->
    
    class BucketList extends ListWrapper.ListWrapper
        (@list) ->
            super ...
            @types = []

        insert: (x) ->

            if not x.isGroupable()
                super([x])
                return
            
            # x is groupable
            type = x.type
            if not @types[type]?
                @types[type] = []
                super(@types[type])

            @types[type].push(x)

        removeElement: (x) ->
            if x.isGroupable()
                @types[x.type].pop()

    {
        BucketList
    }
