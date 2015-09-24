define [
    'debug'
], (Debug) ->

    class BinaryTreeNode
        (@key, @value, @lt, @gt) ->
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
            if node.key `@lt` @key
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

        deleteNodeByKey: (key, callback) ->
            if key `@lt` @key
                @left = @left?.deleteNodeByKey(key, callback)
            else if key `@gt` @key
                @right = @right?.deleteNodeByKey(key, callback)
            else
                callback?(this)
                return @getDeletionReplacement()

            return this

        forEachNode: (f) ->
            @left?.forEachNode(f)
            f(this)
            @right?.forEachNode(f)

        forEach: (f) -> @forEachNode (node) -> f(node.value)

        forEachPair: (f) -> @forEachNode (node) ->
            f(node.key, node.value)

        findNodeByKey: (key, callback) ->
            if key `@lt` @key
                return @left?.findNodeByKey(key, callback)
            else if key `@gt` @key
                return @right?.findNodeByKey(key,  callback)
            else
                callback?(this)
                return this

        findByKey: (key, callback) ->
            @findNodeByKey(key, (node) -> callback?(node.value))?.value

        findAllByKey: (key, callback) ->
            n = @findNodeByKey(key)
            if n?
                callback(n.value)
                n.left?.findAllByKey(key, callback)
                n.right?.findAllByKey(key, callback)

    class BinaryTree
        (@lt = (<), @gt = (>))->
            @root = void
            @length = 0

        createNode: (key, value) ->
            return new BinaryTreeNode(key, value, @lt, @gt)

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

        deleteByKey: (key, callback) ->
            ret = void
            @root = @root?.deleteNodeByKey key, (node) ~>
                ret := node.value
                --@length
            if ret?
                callback?(ret)
            return ret

        findByKey: (key, callback) -> @root?.findByKey(key, callback)
        findAllByKey: (key, callback) -> @root?.findAllByKey(key, callback)
        containsKey: (key) -> @findByKey(key)?

        empty: -> @root == void
        top: -> @root?.value


    BinaryTree.Node = BinaryTreeNode


    return BinaryTree
