define [
    \list_wrapper
    \util
    \debug
], (ListWrapper, Util, Debug) ->
    
    const DEFAULT_CHARS = "abcdefg"

    class AlphabeticList extends ListWrapper.ListWrapper
        (@list, @chars = DEFAULT_CHARS) ->
            @mapping  = Util.objectKeyedByArray(@chars)
            
            @list.forEach (x) ~>
                success = @fillFreeSlot(x)
                Debug.assert(success, "Out of slots.")
                

        insert: (x) ->
            success = @fillFreeSlot(x)
            Debug.assert(success, "Insert failed!")
            super(x)

        fillFreeSlot: (value) ->
            key = @getFreeKey()
            if key?
                @mapping[key] = value
                return true
            return false

        getFreeKey: ->
            for k, v of @mapping
                if not v?
                    return k
            return null

        forEachAlphabet: (f) ->
            for c in @chars
                if @mapping[c]?
                    f(c, @mapping[c])

        getByKey: (key) ->
            return @mapping[key]

    {
        AlphabeticList
    }
