define [
    'structures/linked_list'
], (LinkedList) ->

    class Node
        (@data) ->

    class ChildList
        (@_master) ->
            @_list = new LinkedList()

        insert: (x) ->
            node = new Node(x)
            list_node = @_list.insert(node)
            master_node = @_master._list.insert(node)

            node._child_node = list_node
            node._master_node = master_node
            node._child_list = this

            return node

        removeNode: (node) ->
            @_list.removeNode(node._child_node)
            @_master._list.removeNode(node._master_node)

    class DistributedList
        ->
            @_list = new LinkedList()

        createChild: ->
            return new ChildList(this)

        removeNode: (node) ->
            node._child_list._list.removeNode(node._child_node)
            @_list.removeNode(node._master_node)

        forEach: (f) ->
            @_list.forEach (node) ->
                f(node.data)
