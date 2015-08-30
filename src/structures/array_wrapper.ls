define [
], ->
    class ArrayWrapper
        ->
            @array = new Array()

        push: (x) -> @array.push(x)
        pop: -> @array.pop()
        length: -> @array.length # note that this becomes a method
        first: -> @array[0]
        take: (n) -> @array.splice(@array.length - n)
        insert: (x) -> @push(x)
        extend: (s) ->
            s.forEach (x) ~>
                @insert(x)
