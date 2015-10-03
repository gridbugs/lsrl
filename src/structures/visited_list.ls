define [
    'structures/linked_list'
], (LinkedList) ->
    class VisitedList
        ->
            @list = new LinkedList()

        mark: (x) ->
            @list.push(x)

        unmarkAll: (extra_fields = [])->
            until @list.empty()
                x = @list.pop()
                for f in extra_fields
                    x[f] = void
                x.unvisit()
