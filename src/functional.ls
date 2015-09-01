define [
], ->
    
    class Something
        (@value) ->
        ifSomething: (f, g) -> f(@value)

    class Nothing
        ifSomething: (f, g) -> g?()

    ifExists = (fn, ...args, onTrue, onFalse) ->
        done = false
        args.push (x) ->
            done := true
            onTrue(x)

        fn.apply(this, args)

        if not done
            onFalse?()
    
    maybe = (fn, ...args, callback) ->
        done = false
        args.push (x) ->
            done := true
            callback(new Something(x))

        fn.apply(this, args)

        if not done
            callback(new Nothing())

    unsafeCall = (fn, ...args) ->
        ret = void
        args.push (x) -> ret := x
        fn.apply(this, args)
        return ret

    {
        maybe
        unsafeCall
        ifExists
    }
