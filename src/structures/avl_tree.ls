define [
    'structures/binary_tree'
], (BinaryTree) ->

    class AvlTreeNode extends BinaryTree.Node
        (key, value, lt, gt) ->
            super(...)
            @height = 0

        leftHeight: ->
            if @left?
                return @left.height
            else
                return -1

        rightHeight: ->
            if @right?
                return @right.height
            else
                return -1

        update: ->
            left_height = @leftHeight()
            right_height = @rightHeight()

            @height = Math.max(left_height, right_height) + 1
            @balanceFactor = left_height - right_height

        rotateLeft: ->
            root = @right
            @right = root.left
            root.left = this

            @update()
            root.update()
            return root

        rotateRight: ->
            root = @left
            @left = root.right
            root.right = this

            @update()
            root.update()
            return root

        rebalance: ->
            if @balanceFactor == 2
                if @left.balanceFactor == -1
                    @left = @left.rotateLeft()
                return @rotateRight()
            else if @balanceFactor == -2
                if @right.balanceFactor == 1
                    @right = @right.rotateRight()
                return @rotateLeft()

            return this

        insert: (node) ->
            super(node)
            @update()
            return @rebalance()

        deleteByNodeKey: (key, callback) ->
            ret = super(key, callback)
            if ret?
                @update()
                return ret.rebalance()
            else
                return void

    class AvlTree extends BinaryTree
        (@lt = (<), @gt = (>)) ->
            super(@lt, @gt)

        createNode: (key, value) ->
            return new AvlTreeNode(key, value, @lt, @gt)
