define [
    \debug
], (Debug) ->

    class LinkedListNode
        (@data) ->
            @next = void
            @prev = void

    class LinkedList
        ->
            @head = void
            @__length = 0

        length: -> @__length
        empty: -> @__length == 0

        firstNode: -> @head
        first: -> @head.data

        # Adds an element to the start of the list
        push: (x) -> @insert(x)

        # Removes and returns the element at the start of the list
        pop: ->
            if not @head?
                return void

            --@__length
            ret = @head.data
            @head = @head.next
            if @head?
                @head.prev = void

            return ret

        # Returns a new linked list containing the first n elements
        # from this list, removing them from this list. If n is greater
        # than the length of this list, all elements are removed from
        # this and returned in a new list. Order of elements is not
        # specified.
        take: (n) ->
            ret = new LinkedList()
            while n != 0 and @__length != 0
                --n
                ret.push(@pop())
            return ret

        insert: (x) ->
            # Insert x at the start of the list
            node = new LinkedListNode(x)
            @insertNode(node)
            return node

        extend: (s) ->
            s.forEach (x) ~>
                @insert(x)

        insertNode: (n) ->
            ++@__length

            n.next = @head

            if @head?
                @head.prev = n

            @head = n

        removeNode: (n) ->
            --@__length

            if n.next?
                n.next.prev = n.prev

            if n.prev?
                n.prev.next = n.next
            else
                # n is the head of the list
                Debug.assert(n == @head, "removeNode: n != @head")
                @head = n.next

        forEachNode: (f) ->
            tmp = @head
            while tmp?
                f(tmp)
                tmp = tmp.next

        forEach: (f) ->
            @forEachNode (node) -> f(node.data)

        forEachSatisfyingNode: (predicate, f) ->
            tmp = @head
            while tmp?
                if predicate(tmp.data)
                    f(tmp)
                tmp = tmp.next

        forEachSatisfying: (predicate,  f) ->
            @forEachSatisfyingNodes(predicate, (node) -> f(node.data))

        getFirstSatisfyingNode: (predicate) ->
            tmp = @head
            while tmp?
                if predicate(tmp.data)
                    return tmp
                tmp = tmp.next

            return void

        getFirstSatisfying: (predicate) ->
            @getFirstSatisfyingNode(predicate).data

        getAllSatisfyingNodes: (predicate) ->
            ret = []
            @forEachSatisfyingNode(predicate, (node) -> ret.push(node))
            return ret

        getAllSatisfying: (predicate) ->
            ret = []
            @forEachSatisfyingNode(predicate, (node) -> ret.push(node.data))
            return ret

        removeAllSatisfying: (predicate) ->
            @forEachSatisfyingNode(predicate, (node) ~> @removeNode(node))

        removeElement: (element) ->
            @removeAllSatisfying((x) -> x == element)

        toArray: ->
            @getAllSatisfying -> true
