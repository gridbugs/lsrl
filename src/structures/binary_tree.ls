define [
    'debug'
], (Debug) ->

    class BinaryTreeNode
        (@key, @value) ->
            @left = void
            @right = void

        leftInsert: (node) ->
            if @left?
                return @left.insert(node)
            else
                return node

        rightInsert: (node) ->
            if @right?
                return @right.insert(node)
            else
                return node

        insert: (node) ->
            if node.key < @key
                @left = @leftInsert(node)
            else
                @right = @rightInsert(node)

            return this

        update: ->

        swapLeftMostChild: (target) ->
            if @left?
                ret = @left.swapLeftMostChild(target)

                if ret == @left
                    @left = target.right

                @update()
                return ret

            tmp = @right

            # we are the leftmost child
            @left = target.left
            @right = target.right

            target.right = tmp
            target.left = void
            target.update()

            return this

        getSuccessor: ->
            if @right.left?
                return @right.swapLeftMostChild(this)
            else
                @right.left = @left
                return @right


        getDeletionReplacement: ->
            if @left?
                if @right?
                    return @getSuccessor()
                else
                    return @left
            else if @right?
                return @right
            else
                return void

        deleteByKey: (key, with_node) ->
            if key < @key
                @left = @left?.deleteByKey(key, with_node)
            else if key > @key
                @right = @right?.deleteByKey(key, with_node)
            else
                with_node?(this)
                return @getDeletionReplacement()

            return this

        forEachNode: (f) ->
            @left?.forEachNode(f)
            f(this)
            @right?.forEachNode(f)

        forEach: (f) -> @forEachNode (node) -> f(node.value)

        forEachPair: (f) -> @forEachNode (node) ->
            f(node.key, node.value)

        findNodeByKey: (key, f) ->
            if key < @key
                return @left?.findNodeByKey(key, f)
            else if key > @key
                return @right?.findNodeByKey(key,  f)
            else
                f(this)
                return this

        findByKey: (key, f) ->
            @findNodeByKey(key, (node) -> f?(node.value))?.value

    class BinaryTree
        ->
            @root = void
            @length = 0

        createNode: (key, value) ->
            return new BinaryTreeNode(key, value)

        tryInsert: (node) ->
            if @root?
                return @root.insert(node)
            else
                return node

        insert: (key, value) ->
            node = @createNode(key, value)
            @root = @tryInsert(node)
            ++@length

        forEachNode: (f) -> @root?.forEachNode(f)
        forEachPair: (f) -> @root?.forEachPair(f)
        forEachKey: (f) -> @root?.forEachKey(f)
        forEach: (f) -> @root?.forEach(f)

        deleteByKey: (key) ->
            ret = void
            @root = @root?.deleteByKey(key, (node) -> ret := node.value)
            if ret?
                --@length
            return ret

        findByKey: (key, f) -> @root?.findByKey(key, f)
        containsKey: (key) -> @findByKey(key)?

        empty: -> @root == void
        top: -> @root?.value
    {
        BinaryTree
        BinaryTreeNode
    }
